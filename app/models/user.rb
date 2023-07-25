class User < ApplicationRecord
  has_many :symptoms
  has_many :posts
  has_many :comments
  has_many :user_care_histories
  has_many :favourites
  has_many :favourited_posts, through: :favourites, source: :post
  has_many :care_records
  
  authenticates_with_sorcery!
  
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :email, presence: true

  validates :name, presence: true, length: { maximum: 255 }

  def favourite(post)
    favourites.create(post: post)
  end

  def unfavourite(post)
    favourites.find_by(post: post)&.destroy
  end
end
