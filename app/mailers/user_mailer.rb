class UserMailer < ApplicationMailer
  def confirm_email(user, email)
   @user = user

   mail(to: email, subject: "Potwierdź adres email")
 end
end
