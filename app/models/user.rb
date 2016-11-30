class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :protected_token
  has_many :activities, dependent: :destroy
  has_many :active_relationships,
    class_name: Relationship.name,
    foreign_key: :follower_id,
    dependent: :destroy
  has_many :following, through: :active_relationships,
    source: :followed
  has_many :passive_relationships,
    class_name: Relationship.name,
    foreign_key: :followed_id,
    dependent: :destroy
  has_many :followers, through: :passive_relationships,
    source: :follower
  has_many :reviews
  has_many :commentators, dependent: :destroy
  has_many :comments, through: :commentators
  has_many :marks, dependent: :destroy
  has_many :books, through: :marks
  has_many :favorites, dependent: :destroy
  has_many :favorite_books, class_name: Book.name, through: :favorites, source: :book
  has_many :likes
  has_many :requests

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.max_lenght_name}
  validates :email, presence: true, length: {maximum: Settings.max_lenght_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  validates :password, presence: true,
    length: {minimum: Settings.min_lenght_password,
    maximum: Settings.max_length_password}, allow_nil: true

  mount_uploader :avatar, PictureUploader

  scope :search, ->keyword {where "name LIKE ?", "%#{keyword}%"}
  scope :reviewers_of_book, ->book_id do
    joins(:reviews).where("reviews.book_id = ?", book_id).group("users.id")
  end

  def follow other_user
    active_relationships.create followed_id: other_user.id
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include? other_user
  end
end
