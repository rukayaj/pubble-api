class Artwork < ApplicationRecord
  belongs_to :book
  enum source: [:shutterstock, :dreamstime, :other]
end
