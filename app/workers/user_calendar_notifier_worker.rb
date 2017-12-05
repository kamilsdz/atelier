class UserCalendarNotifierWorker
  include Sidekiq::Worker

  def perform(reservation_id)
    reservation = Reservation.find(reservation_id)
    notify_user_calendar(reservation)
  end

  def notify_user_calendar(reservation)
    UserCalendarNotifier.new(reservation.user).perform(reservation)
  end

end
