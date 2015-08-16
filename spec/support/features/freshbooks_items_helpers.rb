include Admin::FreshbooksHelper

module Features
  module FreshbooksItemsHelpers
    def tune_destroy(item_id)
      freshbooks_call(item_delete_message(item_id))
    end
  end
end
