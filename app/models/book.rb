class Book < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_one :request, dependent: :destroy
  has_many :marks

  validates :title, presence: true,
    length: {maximum: Settings.max_lenght_title}
  validates :publish_date, presence: true
  validates :author, presence: true
  validates :number_of_pages, presence: true
  validates :introduce, presence: true,
    length: {maximum: Settings.max_lenght_book_introduce}

  accepts_nested_attributes_for :request, allow_destroy: true

  default_scope {where deleted: false, bought: true}
  scope :delete_commentators_of_review, ->review_id do
    where(review_id: review_id).update_all(deleted: true)
  end

  mount_uploader :cover, PictureUploader

  delegate :name, to: :category, allow_nil: true

  def delete
    self.update_attributes deleted: true
  end

  scope :search, ->keyword {where "title LIKE ?", "%#{keyword}%" if keyword.present?}
  scope :of_category, ->category_id {where category_id: category_id if category_id.present?}
  scope :read, ->{joins(:marks).where "marks.read = ?", true}
  scope :reading, ->{joins(:marks).where "marks.read = ?", false}
end
