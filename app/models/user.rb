# frozen_string_literal: true

class User < ApplicationRecord
  has_many :symptoms
  has_many :posts
  has_many :comments
  has_many :user_care_histories
  has_many :favourites
  has_many :favourited_posts, through: :favourites, source: :post
  has_many :care_records
  has_many :authentications, dependent: :destroy

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :email, presence: true

  validates :name, presence: true, length: { maximum: 255 }

  def favourite(post)
    favourites.create(post:)
  end

  def unfavourite(post)
    favourites.find_by(post:)&.destroy
  end

  def self.create_with_auth_and_hash(authentication, auth_hash)
    user = create!(
      name: auth_hash['info']['name'],
      email: auth_hash['info']['email'],
      password: SecureRandom.hex(3)
    )
    user.authentications << authentication
    user
  end

  def self.find_by_auth_hash(provider, uid)
    authentication = Authentication.find_by(provider:, uid:)
    return nil unless authentication

    authentication.user
  end
end
