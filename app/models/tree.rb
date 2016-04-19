class Tree < ApplicationRecord
  # assications
  belongs_to :report

  # validations
  validates :report, presence: true
end
