# == Schema Information
#
# Table name: books
#
#  id         :bigint(8)        not null, primary key
#  country    :string
#  grade      :string
#  notes      :string
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Book < ApplicationRecord
  has_many :artworks, dependent: :destroy
end
