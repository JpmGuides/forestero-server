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
      small2:   numbers[2],
      large:    numbers[3],
      mature:   numbers[4],
      rife:     numbers[5],
      infest:   numbers[6],
      force_r:  numbers[7],
      blackpod: numbers[8]
    }
  rescue
    {}
  end

  #-----------------------#
  #   instance methods    #
  #-----------------------#

  def to_csv
    column_names = ['tiny', 'small', 'small2', 'large', 'mature', 'rife', 'infest', 'force_r', 'blackpod']

    attributes.values_at(*column_names)
  end
end
