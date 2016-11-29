class Mark < ApplicationRecord
  belongs_to :user
  belongs_to :book

  after_save :create_rark_activity

  private
  def create_rark_activity
    action_type = if read
        Activity.activity_types[:removed]
      else
        Activity.activity_types[:updated]
      end
    Activity.create user_id: user_id, target_id: book_id, target_type: Book.name,
      action_type: action_type
  end
end
