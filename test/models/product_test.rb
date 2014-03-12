require 'test_helper'
require 'pry'

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:name].any?
    # assert product.errors[:description].any?
    assert product.errors[:price].any?
    # assert product.errors[:image_url].any?
    assert product.errors[:quantity].any?
  end

  test "product price must be positive" do
    product = Product.first
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
    product.errors[:price]
    product.price = 1
    assert product.valid?
  end

  test "product is not valid without a unique name" do
    product = Product.new(name: products(:product_one).name,
      description: "yyy",
      price: 1,
      image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:name]
  end

  def new_product(imag_url)
    Product.new(name: "My Book Title",
      description: "yyy",
      price: 1,
      quantity: 20,
      image_url: imag_url)
  end
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end
end