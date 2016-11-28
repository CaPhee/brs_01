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
end
