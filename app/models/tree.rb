class Tree < ApplicationRecord
  # assications
  belongs_to :report, inverse_of: :trees

  # validations
  validates :report, presence: true

  #-----------------------#
  #     class methods     #
  #-----------------------#

  def self.transpose_params(params)
    numbers = params.gsub(/[()]/, '').split(',')

    return {
      tiny:     numbers[0],
      small:    numbers[1],
      large:    numbers[2],
      mature:   numbers[3],
      ripe:     numbers[4],
      damaged:  numbers[5],
      blackpod: numbers[6]
    }
  rescue
    return {}
  end
end
