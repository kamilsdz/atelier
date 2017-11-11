class ReservationsMailer < ApplicationMailer
  def take_email(user, book)
    @user = user
    @book = book
    @reservation = @book.reservations.where(book_id: book.id, user_id: user.id, status: "TAKEN").first
   mail(to: user.email, subject: "Wypożyczono książkę: " + book.title)
 end
end
