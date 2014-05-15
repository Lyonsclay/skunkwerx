require 'faker'

FactoryGirl.define do
  factory :admin do
    name "Spastic"
    email "chummy@lee.com"
    password "foobar"
    password_confirmation "foobar"
    password_reset_token "barfood"
  end

  factory :product do
    name Faker::Name.name
    description "The birdy must be free!"
    quantity 2
    unit_cost 23.56
  end
end

