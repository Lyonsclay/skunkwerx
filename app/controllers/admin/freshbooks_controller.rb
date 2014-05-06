require 'pry'

class Admin::FreshbooksController < ApplicationController
  layout 'admin/application'
  # skip_before_action :verify_authenticity_token, only: :webhooks
  # before_action :verify_authenticity_token, only: Proc.new { |c| c.request.original_url == 'http://www.freshbooks.com/api/' }
  # skip_before_action :verify_authenticity_token, only: Proc.new { |c| c.request.format == 'application/json' }
  protect_from_forgery except: :webhooks
  before_filter :authorize, except: :webhooks

  def index
    @callbacks = callbacks_display
  end

  def items_sync
    freshbooks_sync
    redirect_to '/admin'
  end

  def webhook_create
    puts "********************* inside webhook_create *************"
    callback_create(params[:method])
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

