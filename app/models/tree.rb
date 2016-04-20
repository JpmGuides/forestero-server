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

    {
      tiny:     numbers[0],
      small:    numbers[1],
      large:    numbers[2],
      mature:   numbers[3],
      rife:     numbers[4],
      damaged:  numbers[5],
      blackpod: numbers[6]
    }
  rescue
    {}
  end

  #-----------------------#
  #   instance methods    #
  #-----------------------#

  def to_csv
    column_names = ['tiny', 'small', 'large', 'mature', 'rife', 'damaged', 'blackpod']

    attributes.values_at(*column_names)
  end
end
