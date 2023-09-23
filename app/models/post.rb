# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :favourites, dependent: :destroy
  has_many :favourited_users, through: :favourites, source: :user
  has_many :comments, dependent: :destroy

  validates :content, presence: true
  validates :content, length: { minimum: 5, maximum: 500 }
end
