class DayText < ApplicationRecord
  # validations
  validates :date, presence: true, uniqueness: true
end
