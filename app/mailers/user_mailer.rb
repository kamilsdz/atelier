class UserMailer < ApplicationMailer
  def confirm_email(email)

   mail(to: email, subject: "Potwierdź adres email")
 end
end
