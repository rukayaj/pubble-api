# == Schema Information
#
# Table name: artworks
#
#  id            :bigint(8)        not null, primary key
#  copyright     :string
#  notes         :string
#  page          :integer
#  source        :integer
#  thumbnail_url :string
#  topic         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  book_id       :bigint(8)
#  source_id     :string
#
# Indexes
#
#  index_artworks_on_book_id  (book_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#

class Artwork < ApplicationRecord
  belongs_to :book
  enum source: [:shutterstock, :dreamstime, :other]
end
