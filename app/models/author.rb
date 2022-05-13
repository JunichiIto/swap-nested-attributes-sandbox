class Author < ApplicationRecord
  belongs_to :book

  validates :name, presence: true, uniqueness: { scope: :book_id }
end
