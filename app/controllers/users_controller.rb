class UsersController < ApplicationController
  def index
    # all users
  end

  def show
    # profil usera
  end

  def is_adult?
        (DateTime.now - :birth_date).to_i >= 6570
  end
  
end
