require "test_helper"

class BooksTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:programming_c)
    @first_author = authors(:first_author)
    @second_author = authors(:second_author)
  end

  test 'シンプルに項目を更新する場合' do
    params = {
      book: {
        title: 'プログラミング言語X',
        authors_attributes: {
          @first_author.id => { id: @first_author.id, name: 'カーニハン', _destroy: '0' },
          @second_author.id => { id: @second_author.id, name: 'リッチー', _destroy: '0' },
        }
      }
    }
    put book_path(@book), params: params
    assert_response :success
    assert_equal 'プログラミング言語X', @book.reload.title
    assert_equal 'カーニハン', @first_author.reload.name
    assert_equal 'リッチー', @second_author.reload.name
  end

  test '著者の名前を入れ替える場合' do
    params = {
      book: {
        title: 'プログラミング言語C',
        authors_attributes: {
          @first_author.id => { id: @first_author.id, name: 'りっちー', _destroy: '0' },
          @second_author.id => { id: @second_author.id, name: 'かーにはん', _destroy: '0' },
        }
      }
    }
    put book_path(@book), params: params
    assert_response :success
    assert_equal 'りっちー', @first_author.reload.name
    assert_equal 'かーにはん', @second_author.reload.name
  end

  def assert_records_not_changed
    assert_equal 'プログラミング言語C', @book.reload.title
    assert_equal 'かーにはん', @first_author.reload.name
    assert_equal 'りっちー', @second_author.reload.name
  end

  test 'バリデーションエラーが発生する場合' do
    params = {
      book: {
        title: '',
        authors_attributes: {
          @first_author.id => { id: @first_author.id, name: 'かーにはん', _destroy: '0' },
          @second_author.id => { id: @second_author.id, name: 'りっちー', _destroy: '0' },
        }
      }
    }
    put book_path(@book), params: params
    assert_response :bad_request
    assert_records_not_changed
  end

  test 'DBのユニーク制約違反が発生する場合' do
    params = {
      book: {
        title: 'プログラミング言語C',
        authors_attributes: {
          @first_author.id => { id: @first_author.id, name: 'りっちー', _destroy: '0' },
          @second_author.id => { id: @second_author.id, name: 'りっちー', _destroy: '0' },
        }
      }
    }
    put book_path(@book), params: params
    assert_response :bad_request
    assert_records_not_changed
  end
end
