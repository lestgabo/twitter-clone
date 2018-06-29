class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Twitter Sample Application - Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Twitter Sample Application - Password reset"
  end
end
