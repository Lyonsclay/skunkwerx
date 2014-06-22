require 'spec_helper'
require 'nokogiri'
require 'open-uri'

module Features
  module WebhooksTestHelpers
    def skunkwerx_get_products
      doc = Nokogiri::HTML(open(ENV['SKUNKWERX_URL'] + '/products/index'))
      product_names = doc.xpath("//tr//p").map { |p| p.content }
    end

    def skunkwerx_create_product(name)
      product = Product.new
      product.name = @name
      product.description = "It happens to be so great!"
      product.unit_cost = "21.99"
      freshbooks_call(item_create_message(product))
    end

    def item_update_message(description)
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><request method=\"item.update\"><item><item_id>#{item_id}</item_id><description>#{description}</description></item></request>"
    end

    def skunkwerx_update_product(description)
      freshbooks_call(item_update_message(description))
    end

    def skunkwerx_destroy_product
      freshbooks_call(item_delete_message(item_id))
    end

    def skunkwerx_get_item_id
      items = get_items
      items.select { |item| item["name"] == @name }
      items.first["item_id"]
    end

    def skunkwerx_get_item_description
      doc = Nokogiri::HTML(open(ENV['SKUNKWERX_URL'] + '/products/index'))
      elem = doc.search("//dt[contains(text(), \"#{@name}\")]")
      elem.first.next_element.next_element.content.strip
    end
  end
end
