class Category < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.max_lenght_name_of_book}

  default_scope {where deleted: false}
  scope :search, ->keyword {where "name LIKE ?", "%#{keyword}%"}

  def delete
    Book.delete_books_of_category id
    self.update_attributes deleted: true
  end
end
