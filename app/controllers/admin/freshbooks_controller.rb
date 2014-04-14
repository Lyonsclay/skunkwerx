require 'pry'

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
    @callbacks = callbacks_display("item.create")
  end

  def items_sync
    # Make sure admin is logged in!
    if current_admin
      items = get_items
      # malone_tunes_items = []
      product_items = []
      # Track newly created items for sync descrepancy assesment.
      new_products = []
      # Split items into malone_tunes and products and save to database.
      items.each do |item|
        if item["name"].match("Malone")
          # malone_tunes_items += item
          MaloneTune.create(item)
        else
          product_items << item
          p = Product.create(item)
          if p.save
            new_products << p
          end
        end
        flash[:sync_discrepancy] = check_items_against_products(product_items, new_products)
      end

      if flash[:sync_discrepancy].empty?
        flash[:notice] = "Products are up to date"
      end
      redirect_to '/admin'
    # Redirect to HOME if an admin not logged in.
    else
      redirect_to root_path
    end
  end

  def webhook_create
    if current_admin
      callback_create(params[:method])
    end
    redirect_to '/admin'
  end

  def webhooks
    puts "************ Freshbooks Callbacks params[] **************"
    puts params
    puts "*********************************************************"
    # Check to insure valid freshbooks api request.
    if params[:system] == "https://skunkwerxperformanceautomotivellc.freshbooks.com"
      puts "**************** inside params[:system] ***************"
      key = find_key("name")
      # Callback Verify action for all webhook methods;
      if params[key] == "callback.verify"
        callback_verify(params[:verifier])
      end
      # Item Create Callback method creates new product.
      if params[key] == "item.create"
        item_create(params[:object_id])
      end
      # Send response status ok.
      head 200
    end
  end
end

