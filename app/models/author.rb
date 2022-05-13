class Author < ApplicationRecord
  belongs_to :book
  validates :name, uniqueness: { scope: :book_id }
end
