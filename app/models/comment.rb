# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, length: { minimum: 3, message: 'コメントは3文字以上で入力してください。' }
end
