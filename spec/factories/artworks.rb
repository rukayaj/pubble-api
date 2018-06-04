FactoryBot.define do

  factory :artwork do
    copyright "Mirvy Meowface"
    notes "Checked"
    page 12
    source 1
    thumbnail_url 'http://mirvyface.com/cat.jpg'
    topic 1
    created_at DateTime.now
    updated_at DateTime.now
    source_id '12312486'
    book_id 1
  end

end
