class MailerWorker
  include Sidekiq::Worker

  MAIL_DELETE_REQUEST = 0
  MAIL_APPROVED_REQUEST = 1
  MAIL_NOTIFICATION = 2

  def perform action, object_notifica_id, object_notifica_type
    case action
    when MAIL_DELETE_REQUEST
      send_mail_approved_request Request.unscoped.find_by id: object_notifica_id
    when MAIL_APPROVED_REQUEST
      Request.have_processed.each do |request|
        send_mail_approved_request request
      end
    when MAIL_NOTIFICATION
      case object_notifica_type
      when Review.name
        notifica_new_review Review.find_by id: object_notifica_id
      when Comment.name
        notifica_new_comment Comment.find_by id: object_notifica_id
      end
    end
  end

  private
  def notifica_new_comment comment
    comment.review.commentators.each do |commentator|
      UserMailer.notification(comment, commentator.user).deliver_now
    end
  end
  def notifica_new_review review
    User.reviewers_of_book(review.book_id).each do |user|
      UserMailer.notification(review, user).deliver_now
    end
  end
  def send_mail_approved_request request
    UserMailer.approved_request(request).deliver_now
  end
end
