class Device < ApplicationRecord
  # associations
  has_many :reports, inverse_of: :device

  # validations
  validates :uuid, presence: true
  validates :uuid, uniqueness: true
end
