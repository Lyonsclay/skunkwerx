require 'pry'

module Features
  module CallbackHelpers
    def callback_delete_message(callback_id)
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <request method=\"callback.delete\">
          <callback_id>20</callback_id>
        </request>"
    end

    def callback_list_message(callback)
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <request method=\"callback.list\">
          <event>#{callback}</event>
          <uri>http://example.com/webhooks/ready</uri>
        </request>"
    end

    def callback_delete(callback)
      callback_list = self.controller.freshbooks_call(callback_list_message(callback))
    end
  end
end