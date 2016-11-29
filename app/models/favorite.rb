class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :book

  after_create :create_favorite_activity

  private
  def create_favorite_activity
    Activity.create user_id: user_id, target_id: book_id,
      target_type: Book.name, action_type: Activity.activity_types[:created]
  end
end
