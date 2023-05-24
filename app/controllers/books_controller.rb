class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit]

  def index
    @books = Book.all
  end

  def new
    set_new_book
  end

  def create
    @book = Book.add_book(book_params[:title], book_params[:descr], book_params[:count_pages], book_params[:status], book_params[:genre_id], book_params[:user_id])
    author_ids = params[:book][:author_ids]
    if @book
      author_ids.each do |author_id|
        Book.add_book_author(@book.id, author_id)
      end
      redirect_to @book
    else
      flash.now[:alert] = 'All fields must be filled!'
      set_new_book
      render :new
    end
  end

  def show
    @genres = @book.genre
    @authors = @book.authors
  end

  def edit
    @genres = @book.genre
  end

  def update
    @book = Book.update_book(params[:id], book_params[:title], book_params[:descr], book_params[:count_pages], book_params[:status], book_params[:genre_id], book_params[:user_id])
    if @book
      redirect_to @book
    else
      flash.now[:alert] = 'All fields must be filled!'
      set_book
      render :edit
    end
  end

  def destroy
    Book.delete_book_id(params[:id])
    redirect_to books_path
  end

  private

  def set_new_book
    @book = Book.new
    @genres = Genre.all
    @authors = Author.all
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :descr, :count_pages, :status, :genre_id, :user_id, author_ids: [])
  end
end
