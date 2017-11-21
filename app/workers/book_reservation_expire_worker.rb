class BookReservationExpireWorker
  include Sidekiq::Worker

  def perform(book_id)
    @book = Book.find(book_id)
    BookNotifierMailer.book_return_remind(@book).deliver
    BookNotifierMailer.book_reserved_return(@book).deliver if any_waiting_reservation?
  end

  def any_waiting_reservation?
     @book.reservations.where(status: 'RESERVED').any?
  end

end
