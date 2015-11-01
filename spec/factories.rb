FactoryGirl.define do
  factory :user do
    password "password"
    location "90210"
    phone ENV['KNOWN_REAL_CELL_NUMBER']
  end
end
