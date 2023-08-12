class Authentication < ApplicationRecord
    belongs_to :user
  
    validates :provider, :uid, presence: true
  end
  