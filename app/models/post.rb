class Post < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :content, length: { minimum: 5, maximum: 500 }

end
