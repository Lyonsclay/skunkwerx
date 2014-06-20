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
      product.name = name
      product.description = "It happens to be so great!"
      product.unit_cost = "21.99"
      freshbooks_call(item_create_message(product))
    end

    def skunkwerx_destroy_product(item_id)
      freshbooks_call(item_delete_message(item_id))
    end

    def skunkwerx_get_item_id(name)
      items = get_items
      items.select { |item| item["name"] == name }
      items.first["item_id"]
    end
  end
end
