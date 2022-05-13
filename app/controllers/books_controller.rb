class BooksController < ApplicationController
  def update
    @book = Book.find(params[:id])
    if @book.update_with_avoiding_uniqueness_error(book_params)
      head :ok
    else
      head :bad_request
    end
  end

  private

  def book_params
    params.require(:book).permit(
      :title,
      authors_attributes: %i[id _destroy name],
    )
  end
end
