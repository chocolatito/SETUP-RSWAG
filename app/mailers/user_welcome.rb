class UserWelcome < ApplicationMailer
def send_user_welcome
    @user = params[:user]
    mail(to: @user.email, subject: '¡Bienvenido a Somos Más!')
end
end
