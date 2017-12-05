class Book < ApplicationRecord
  has_many :reservations
  has_many :borrowers, through: :reservations, source: :user
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  scope :not_for_adult, -> {where('category_id IN (?)', Category.not_for_adults.map(&:id))}

  validates :title, :isbn, :category_name, presence: true
  # statuses: AVAILABLE, TAKEN, RESERVED, EXPIRED, CANCELED, RETURNED


  def category_name
    category.try(:name)
  end

  def category_name=(name)
    self.category = Category.where(name: name).first_or_initialize
  end

  def can_take?(user)
    not_taken? && ( available_for_user?(user) || reservations.empty? )
  end

  def take(user)
    return unless can_take?(user)

    if available_reservation.present?
      available_reservation.update_attributes(status: 'TAKEN')
      perform_expiration_worker(available_reservation)
    else
      #perform_expiration_worker(reservations.create(user: user, status: 'TAKEN'))
      reservation = reservations.create(user: user, status: 'TAKEN')
      #::UserCalendarNotifierWorker.perform_at(DateTime.now, reservation.id)
      perform_notifier_worker(reservation)
    end
    # .tap {|reservation|
    #   perform_notifier_worker(reservation)
    #   #::UserCalendarNotifierWorker.perform_at(DateTime.now, reservation.id)
    # }
  end

  def give_back
    ActiveRecord::Base.transaction do
      reservations.find_by(status: 'TAKEN').tap { |reservation|
        reservation.update_attributes(status: 'RETURNED')
        perform_notifier_worker(reservation)
      }
      next_in_queue.update_attributes(status: 'AVAILABLE') if next_in_queue.present?
    end
  end

  def can_reserve?(user)
    reservations.find_by(user: user, status: 'RESERVED').nil?
  end

  def reserve(user)
    return unless can_reserve?(user)

    reservations.create(user: user, status: 'RESERVED')
  end

  def cancel_reservation(user)
    reservations.where(user: user, status: 'RESERVED').order(created_at: :asc).first.update_attributes(status: 'CANCELED')
  end

  private
  def perform_notifier_worker(reservation)
    ::UserCalendarNotifierWorker.perform_at(DateTime.now, reservation.id)
  end

  def perform_expiration_worker(res)
    ::BookReservationExpireWorker.perform_at(DateTime.now+13.days, res.book_id)
  end


  # def kill_worker(res)
  #   TODO
  # end

  def not_taken?
    reservations.find_by(status: 'TAKEN').nil?
  end

  def available_for_user?(user)
    if available_reservation.present?
      available_reservation.user == user
    else
      pending_reservations.nil?
    end
  end

  def pending_reservations
    reservations.find_by(status: 'PENDING')
  end

  def available_reservation
    reservations.find_by(status: 'AVAILABLE')
  end

  def next_in_queue
    reservations.where(status: 'RESERVED').order(created_at: :asc).first
  end
end
