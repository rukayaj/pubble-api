FactoryBot.define do

  factory :user do
    email 'test@test.com'
    name 'Billy Bob'
    password 'test' 
    updated_at DateTime.now
  end

end
