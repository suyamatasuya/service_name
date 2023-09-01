# frozen_string_literal: true

class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :user_id, uniqueness: { scope: :post_id } # これにより、ユーザーは一つの投稿を一度だけお気に入りにできる。
end
