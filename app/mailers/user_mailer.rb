class UserMailer < ApplicationMailer
  def approved_request request
    @request = request
    mail to: request.user.email, subject: I18n.t(:request_has_processed)
  end

  def notification notifica, user
    @notifica = notifica
    @user = user
    title = notifica.is_a?(Review) ? notifica.book.title : notifica.review.title
    mail to: @user.email, subject: I18n.t(:notification,
      user: notifica.user.name, new_object: notifica.class.name,
      title: title)
  end
end
