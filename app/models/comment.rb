class Comment < ApplicationRecord
  belongs_to :commentator

  validates :commentator, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.max_lenght_content_comment}

  default_scope {where deleted: false}

  delegate :name, to: :commentator, allow_nil: true
  delegate :user, to: :commentator, allow_nil: true
  delegate :title, to: :commentator, allow_nil: true
  delegate :review, to: :commentator, allow_nil: true
  delegate :review_id, to: :commentator, allow_nil: true

  after_create :create_activity

  private
  def create_activity
    Activity.create user_id: user.id, target_id: id, target_type: Comment.name,
      action_type: Activity.activity_types[:created]
  end
end
