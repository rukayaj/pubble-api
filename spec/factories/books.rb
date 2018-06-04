FactoryBot.define do

  factory :book do
    # sequence(:id) { |number| number }
    country "Namibia"
    grade "9"
    notes "Top priority"
    subject "Mathematics"
    created_at DateTime.now
    updated_at DateTime.now
  end

end
