class UserCareHistory < ApplicationRecord
  belongs_to :user
  belongs_to :care_method
  belongs_to :symptom

  validates :care_received_date, presence: true
end
