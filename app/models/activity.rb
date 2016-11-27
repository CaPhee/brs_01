class Activity < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  enum activity_types: [:created, :updated, :removed]

  validates :target_id, presence: true
  validates :target_type, presence: true
  validates :action_type, presence: true

  scope :users_activities, ->user_id do
    where("user_id = :user_id OR user_id IN (SELECT followed_id
      FROM relationships WHERE follower_id = :user_id)", user_id: user_id)
    .order created_at: :desc
  end

  def review
    Review.unscoped.find_by id: target_id
  end

  def comment
    Comment.unscoped.find_by id: target_id
  end

  def followed
    User.find_by id: target_id
  end

  def book
    Book.unscoped.find_by id: target_id
  end
end
