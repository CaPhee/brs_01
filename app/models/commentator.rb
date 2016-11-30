class Commentator < ApplicationRecord
  belongs_to :user
  belongs_to :review
  has_many :comments

  accepts_nested_attributes_for :comments,
    reject_if: proc {|attributes| attributes[:content].blank?}

  default_scope {where deleted: false}
  scope :delete_commentators_of_review, ->review_id do
    where(review_id: review_id).update_all(deleted: true)
  end

  delegate :name, to: :user, allow_nil: true
  delegate :title, to: :review, allow_nil: true
end
