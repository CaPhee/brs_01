class Request < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :description, presence: true,
    length: {maximum: Settings.max_lenght_request_description}

  scope :have_processed, -> do
    joins(:book).where "processed = ? OR books.bought = ?", true, true
  end

  def book
    Book.unscoped{super}
  end
end
