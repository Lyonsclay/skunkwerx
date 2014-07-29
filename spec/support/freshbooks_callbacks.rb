module FreshbooksCallbacks

    def callback_delete_message(callback_id)
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <request method=\"callback.delete\">
          <callback_id>#{callback_id}</callback_id>
        </request>"
    end

    def delete_all_webhooks
      callback_list = freshbooks_call(callback_list_message)
      doc = Document.new callback_list.to_xml
      callback_list.each do |callback|
        callback_ids = REXML::XPath.match( doc, '//callback-id')
        callback_ids.map { |e| e.text.to_i }.each do |id|
          response_hash = freshbooks_call(callback_delete_message(id))
        end
      end
    end

    def get_callback_verify(method)
      callback_verify = "0"
      num = 0
      # This until loop provides small delay for app at
      # skunkwerx-performance.com to receive verify callback,
      # and authenticate verify callback with Freshbooks API.
      until callback_verify == "1" || num == 10 do
        num += 1
        doc = Document.new callbacks_display.to_xml
        callbacks = REXML::XPath.match(doc, '//callback/event')
        callback = callbacks.keep_if { |c| c.text == method }
        callback_verify = callback.first.next_element.text
      end
      callback_verify
    end
  end

  def get_callbacks_list
    freshbooks_call(callback_list_message)["response"]["callbacks"]["callback"]
  end

  def delete_unverified_callbacks
    # get ids for unverified callbacks
    unverified_ids = get_callbacks_list.map { |c| c["callback_id"] if c["verified"] == "0" }.compact

    # send callback delete message for every unverified callback
    unverified_ids.each do |id|
      response_hash = freshbooks_call(callback_delete_message(id))
      puts response_hash
    end
  end
end