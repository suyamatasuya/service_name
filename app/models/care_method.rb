class CareMethod < ApplicationRecord
  has_and_belongs_to_many :symptoms
  has_many :user_care_histories


  validates :name, presence: true
  validates :description, presence: true
end