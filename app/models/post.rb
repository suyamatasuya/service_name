class Post < ApplicationRecord
  belongs_to :user
  has_many :favourites, dependent: :destroy
  has_many :favourited_by, through: :favourites, source: :user
  

  validates :content, presence: true
  validates :content, length: { minimum: 5, maximum: 500 }

end
