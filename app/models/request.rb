class Request < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :description, presence: true,
    length: {maximum: Settings.max_lenght_request_description}

  scope :have_processed, -> do
    joins_book.where("processed = ? OR books.bought = ?", true, true)
  end
  scope :of_user, ->keyword do
    joins(:user).where("users.name LIKE ?", "%#{keyword}%")
  end
  scope :of_category, ->category_id do
    joins_book
    .where("books.category_id = ? ", category_id) if category_id.present?
  end
  scope :search_titile, ->keyword do
    joins_book.where("books.title LIKE ?", "%#{keyword}%")
  end
  scope :joins_book, ->do
    joins("LEFT JOIN books ON book_id = books.id")
  end

  delegate :title, to: :book, allow_nil: true
  delegate :name, to: :user, allow_nil: true

  default_scope {where deleted: false}

  after_update :send_mail_approved_request

  def delete
    self.update_attributes deleted: true
  end

  def book
    Book.unscoped{super}
  end

  private
  def send_mail_approved_request
    if deleted
      MailerWorker.perform_async MailerWorker::MAIL_DELETE_REQUEST, id, Request.name
    end
  end
end
