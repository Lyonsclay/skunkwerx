require 'pry'
require 'net/https'
require 'uri'
# For parsing XML
require 'rexml/document'
# Import into the top level namespace for convenience
include REXML

class Admin::FreshbooksController < ApplicationController
  layout 'admin'
  # skip_before_action :verify_authenticity_token, only: :webhooks
  # before_action :verify_authenticity_token, only: Proc.new { |c| c.request.original_url == 'http://www.freshbooks.com/api/' }
  # skip_before_action :verify_authenticity_token, only: Proc.new { |c| c.request.format == 'application/json' }
  protect_from_forgery except: :webhooks

  def index
    if !current_admin
      redirect_to root_path
    end
  end

  def items_sync
    # Make sure admin is logged in!
    if current_admin
      # Make initial call to determine number( num ) of pages
      xml_hash = Hash.from_xml freshbooks_call(initial_message(1)).body
      num = xml_hash["response"]["items"]["pages"].to_i
      items = []
      # Make a call for each page and add results to items array.
      (1..num).each do |page|
        response = freshbooks_call(initial_message(page))
        xml_hash = Hash.from_xml response.body
        items += xml_hash["response"]["items"]["item"]
      end
      #Save items that have been flagged with a value in tax2_id
      items.each do |item|
        item.delete_if {|k,v| k == "item_id" }
        unless item["tax2_id"].nil?
          if item["name"].match("Malone")
            MaloneTune.create(item)
          else
            Product.create(item)
          end
        end
      end
    # Redirect to HOME if an admin not logged in.
    else
      redirect_to root_path
    end
    flash[:notice] = "Products have been successfully synced"
    redirect_to '/admin'
  end

  def callback_item_create
    if current_admin
      event = "item.create"
      response = freshbooks_call(callback_create_message(event))
      xml_hash = Hash.from_xml response.body
      callback_id = xml_hash['response']['callback_id']
      session[:callback_id] = callback_id
      flash[:notice] = display_response(response)
      Rails.cache.write 'callback_id', callback_id
    end
    render 'admin/index'
  end

  def webhooks
    puts "************ Freshbooks Callbacks params[] **************"
    puts params
    puts "*********************************************************"
    # Check to insure valid freshbooks api request.
    if params[:system] == "https://skunkwerxperformanceautomotivellc.freshbooks.com"
      puts "**************** inside params[:system] ************"
      # Callback Verify action for all webhook methods;
      if params["name "] == "callback.verify"
        puts "**************** inside callback.verify *************"
        verifier = params[:verifier]
        callback_id = Rails.cache.read "callback_id"
        puts "**************** callback_id ********************"
        puts callback_id
        puts "****************************************************"
        response = freshbooks_call(callback_verify_message(callback_id, verifier))
        flash[:notice] = display_response(response)
      end
      # Item Create Callback method creates new product.
      if params["name "] == "item.create"
        puts "**************** inside item.create ****************"
        puts "******************* params *************************"
        puts params
        puts "****************************************************"
        item_id = params[:object_id]
        response = freshbooks_call(item_get_message(item_id))
        xml_hash = Hash.from_xml response.body
        puts "*************** xml_hash **********************"
        puts xml_hash
        puts "***********************************************"
        Product.create(xml_hash['response']['item'])
      end
      head 200
    end
  end
end

