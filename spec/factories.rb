FactoryGirl.define do
  factory :admin do
    name "Spastic"
    email "chummy@lee.com"
    password "foobar"
    password_confirmation "foobar"
    password_reset_token "barfood"
  end
end

