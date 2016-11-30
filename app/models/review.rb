class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :commentators
  has_many :comments, through: :commentators

  validates :book, presence: true
  validates :user, presence: true
  validates_numericality_of :rate,
    greater_than_or_equal_to: Settings.min_rate.to_i,
    less_than_or_equal_to: Settings.max_rate.to_i
  validates :title, presence: true, length: {maximum: Settings.max_length_review_title}
  validates :content, presence: true, length: {maximum: Settings.max_length_review_content}

  default_scope {where deleted: false}
  scope :of_book, ->book_id {where book_id: book_id if book_id.present?}

  after_save :update_rate_of_book
  after_create :mail_notifica_other_reviewer

  def book
    Book.unscoped{super}
  end

  def delete
    Commentator.delete_commentators_of_review id
    self.update_attributes deleted: true
  end

  private
  def update_rate_of_book
    book.rate = get_new_rate
    unless book.save
      errors.add :book, I18n.t(:failed_update_rate)
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  def get_new_rate
    reviews = Review.where book_id: book_id
    new_rate = reviews.sum(:rate) / reviews.count
  end

  def mail_notifica_other_reviewer
    MailerWorker.perform_async MailerWorker::MAIL_NOTIFICATION, id, Review.name
  end
end
