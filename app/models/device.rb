class Device < ApplicationRecord
  validates :uuid, presence: true
end
