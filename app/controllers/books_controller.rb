class BooksController < ApplicationController
  before_action :load_books, only: :index
  before_action :load_book, only: :show
  before_action :new_book, only: :create


  def new
  end


  def create
    if new_book.save
      redirect_to books_path
    else
      redirect_to new_book_path
    end
  end

  def filter
     render template: 'books/filter', locals: { books: filter_books }
  end


  def by_category
    @category = ::Category.find_by(name: params[:name])
  end


  private

  def filter_params
    permitted_params
      .slice(:title, :isbn)
      .merge(category.present? ? { category_id: category.id } : {})
      .reject{ |k, v| v.to_s.empty? }
  end

  def filter_books
    Book.where(filter_params)
  end

  def category
    Category.find_by(name: permitted_params[:category_name])
  end

  def load_books
    if current_user.age.present?
         if (Date.today - current_user.age).to_i >= 6570
           @books = Book.all
         else
           @books = Book.not_for_adult
        end
    else
       @books = Book.all
    end
  end

  def load_book
    @book = Book.find(params[:id])
  end

  def new_book
    @book = Book.new(title: params[:title], isbn: params[:isbn], category_id: params[:category])
  end
end

def permitted_params
     params.permit(:title, :isbn, :category_id, :category_name)
   end
