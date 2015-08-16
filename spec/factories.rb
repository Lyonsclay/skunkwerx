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

  factory :malone_tuning_builder do
    name Faker::Name.name 
    unit_cost 22.40
  end
  
  factory :malone_tuning do
    name "Malone - " + Faker::Name.name
    description "The juice that gives goose!"
    unit_cost 250.00
  end

  factory :option do
    name "Option - " + Faker::Name.name
    description "Gives juice the go!"
    unit_cost 78.00
  end

  factory :vehicle_params, class:Hash do
    vehicle = {
      make: "Super",
      model: "Duper",
      engine: "2.0l",
      year: { start: "1998", finish: "2003" }
    }
    
    factory :build_vehicle, class:Hash do 
      initialize_with { { build_vehicle: vehicle, select_vehicle: "" } }
    end

    factory :select_vehicle, class:Hash do
      initialize_with { { select_vehicle: vehicle.update(year: { range: "1998-2003" }), build_vehicle: "" } }
    end 
  end
end

