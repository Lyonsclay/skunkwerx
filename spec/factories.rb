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

  factory :malone_tuning do
    name Faker::Name.name
    make 
  end
 
  factory :malone_tune do
    name "Malone::" + Faker::Name.name
    description "The juice that gives goose!"
    unit_cost 250.00
  end

  factory :option do
    name "Option::" + Faker::Name.name
    description "Gives juice the go!"
    unit_cost 78.00
  end
end

