class Book < ApplicationRecord
  has_many :authors, dependent: :destroy
end
