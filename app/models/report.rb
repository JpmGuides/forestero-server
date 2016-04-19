class Report < ApplicationRecord
  # associations
  has_many :trees

  # validations
  validates :site_reference, :site_id, :visit_id, presence: true
end
