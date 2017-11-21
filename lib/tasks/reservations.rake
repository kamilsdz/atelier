namespace :reservations do
  desc "expires reminder"
  task "reminder": :environment do
    res = Reservation.where("status" => "TAKEN", "expires_at" => Date.tomorrow.all_day)
    res.each{|i| BookNotifierMailer.book_return_remind(Book.find(i.book_id)).deliver}
  end
end
