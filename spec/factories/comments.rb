FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.sentence(3, true) }
    user
    movie
  end
end
