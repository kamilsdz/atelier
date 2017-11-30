class UsersController < ApplicationController
  def index
    # all users
  end

  def show
    # profil usera
  end

  def adult?
      (Date.today - current_user.age).to_i >= 6570
    end
  end

end
