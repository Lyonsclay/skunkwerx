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
      freshbooks_sync
      redirect_to '/admin'
    # Redirect to HOME if an admin not logged in.
    else
      redirect_to root_path
    end
  end

  def webhook_create
    puts "********************* inside webhook_create *************"
    if current_admin
      puts "********************** inside current_admin ************"
      callback_create(params[:method])
    end
    puts "**************** right before redirect_to '/admin' ********"
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

