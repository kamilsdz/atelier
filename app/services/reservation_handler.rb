class ReservationHandler
  def initialize(user)
      @user = user
  end

  def take(book)
    return "not available" unless book.
    can_be_taken?(user)
    if book.available_reservation.present?
        perform_expiration_worker(book.available_reservation)
      book.available_reservation.update_attributes(status: 'TAKEN')
    else
      perform_expiration_worker(book.reservations.create(user: user, status: 'TAKEN'))
    end
  end

  def give_back
    ActiveRecord::Base.transaction do
      book.reservations.find_by(status: 'TAKEN').update_attributes(status: 'RETURNED')
      book.next_in_queue.update_attributes(status: 'AVAILABLE') if next_in_queue(book).present?
    end
  end

  def reserve(book)
    return unless book.can_reserve?(user)

    book.reservations.create(user: user, status: 'RESERVED')
  end

  def cancel_reservation(user)
    book.reservations.where(user: user, status: 'RESERVED').order(created_at: :asc).first.update_attributes(status: 'CANCELED')
  end

private
attr_reader :user

def perform_expiration_worker(res)
  ::BookReservationExpireWorker.perform_at(res.expires_at-1.day, res.book_id)
end

def next_in_queue(book)
  book.reservations.where(status: 'RESERVED').order(created_at: :asc).first
end

end
