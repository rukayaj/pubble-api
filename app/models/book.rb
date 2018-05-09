class Book < ApplicationRecord
  has_many :artworks, dependent: :destroy
end
