class UserHandler
def User.from_omniauth(access_token)
  data = User.access_token.info
  user = User.where(email: data['email']).first

  unless user
    user = User.create(
     email: data['email'],
     password: Devise.friendly_token[0,20]
    )
  end
  user
end

def is_adult?
  User.where(DateTime.now - :birth_date).to_i >= 6570
end

end
