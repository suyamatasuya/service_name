class CareMethod < ApplicationRecord
  has_and_belongs_to_many :symptoms


  validates :name, presence: true
  validates :description, presence: true
end