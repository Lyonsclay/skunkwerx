class Admin::FreshbooksController < ApplicationController
  layout 'admin/application'
  # skip_before_action :verify_authenticity_token, only: :webhooks
  # before_action :verify_authenticity_token, only: Proc.new { |c| c.request.original_url == 'http://www.freshbooks.com/api/' }
  # skip_before_action :verify_authenticity_token, only: Proc.new { |c| c.request.format == 'application/json' }
  protect_from_forgery except: :webhooks
  before_filter :authorize, except: [:webhooks, :tunes_create]

  def tunes_create
    unless params["tune_ids"].nil?
      params["tune_ids"].each { |id| tune_item_create(id.to_i) }
    end
    redirect_to '/admin'
  end

  def index
    session[:sync_discrepancy] = ""
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

  def webhooks_delete
    delete_all_webhooks
    redirect_to '/admin'
  end

  # !!!Post webhooks is the only Skunkwerx url Freshbooks API will call.
  # This method must handle callback verify on callback creation and any callbacks
  # that Freshbooks will make.
  def webhooks
    puts "*************** inside webhooks ************************"
    puts "***params: " + params.inspect
    puts "*********************************************************"
    # Check to insure valid freshbooks api request.
    if params[:system] == "https://skunkwerxperformanceautomotivellc.freshbooks.com"
      puts "**************** inside params[:system] ***************"
      puts "***params: " + " - " + params.inspect + " - "
      # Callback Verify action for all webhook methods;
      if params["name"] == "callback.verify"
        puts "****************** inside callback.verify **************"
        puts "***params[:verifier]: " + params[:verifier]
        puts "********************************************************"
        callback_verify(params[:verifier])
      end
      # Freshbooks sends notification on item create, update and destroy.
      if params["key"] == "item.create"
        puts "********************* inside item.create **************"
        puts "***params[:object_id] : " + params[:object_id]
        item_create(params[:object_id])
        puts "******************************************************"
      end

      if params["key"] == "item.update"
        puts "********************* inside item.update **************"
        puts "***params[:object_id] : " + params[:object_id]
        item_update(params[:object_id])
        puts "******************************************************"
      end

      if params["key"] == "item.delete"
        puts "********************* inside item.delete ***************"
        puts "***params[:object_id] : " + params[:object_id]
        item_delete(params[:object_id])
        puts "******************************************************"
      end
      # Send response status ok.
      head 200
    end
  end
end

