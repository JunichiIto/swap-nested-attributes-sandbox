class Book < ApplicationRecord
  has_many :authors, dependent: :destroy
  accepts_nested_attributes_for :authors, reject_if: :all_blank, allow_destroy: true

  def update_with_avoiding_uniqueness_error(book_params)
    success = false
    ActiveRecord::Base.transaction do
      # HACK: 著者名をスワップするような更新が走ると、どうしてもユニークバリデーションに引っかかってしまう
      # そこで事前に著者名をデタラメに更新しておき、ユニークバリデーションエラーの発生を回避する、というハック
      authors.each do |author|
        author.update_columns(name: SecureRandom.uuid)
      end
      success = update(book_params)

      raise ActiveRecord::Rollback unless success
    end
    success
  end
end
