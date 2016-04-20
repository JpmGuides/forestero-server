require 'csv'

class Report < ApplicationRecord
  # associations
  has_many :trees, inverse_of: :report, dependent: :destroy

  # validations
  validates :site_reference, :site_id, :visit_id, :taken_at, presence: true

  # accept nested parameters
  accepts_nested_attributes_for :trees

  #-----------------------#
  #     class methods     #
  #-----------------------#

  def self.transpose_params(params)
    return {} unless params.is_a?(Hash)
    report_params = { report: {
      taken_at: (params['p1'] ? Date.parse(params['p1']).to_datetime : nil),
      site_reference: params['p2'],
      site_id: params['p3'],
      visit_id: params['p4'],
      humidity: params['p5'],
      canopy: params['p6'],
      leaf: params['p7'],
      maintenance: params['p8'],
      flowers: params['p9'],
      bp: !!(params['p10'].to_s =~ /yes/i),
      harvesting: !!(params['p11'].to_s =~ /yes/i),
      drying: !!(params['p12'].to_s =~ /yes/i),
      fertilizer: !!(params['p13'].to_s =~ /yes/i),
      wilt: !!(params['p14'].to_s =~ /yes/i),
    }}

    report_params[:report][:trees_attributes] = transpose_trees_params(params)

    report_params
  rescue
    {}
  end

  def self.transpose_trees_params(params)
    trees_index = 1
    trees_params = []

    while params["t#{trees_index}"].present?
      trees_params << Tree.transpose_params(params["t#{trees_index}"])
      trees_index += 1
    end

    trees_params
  end

  def self.to_csv(date = DateTime.now, options = {})
    header_names = [
      'date', 'site_reference', 'humidity', 'canopy', 'leaf', 'maintenance', 'flowers', 'bp', 'harvesting', 'drying', 'fertilizer', 'wilt',
      'tree1_tiny', 'tree1_small', 'tree1_large', 'tree1_mature', 'tree1_rife', 'tree1_damaged', 'tree1_blackpod',
      'tree2_tiny', 'tree2_small', 'tree2_large', 'tree2_mature', 'tree2_rife', 'tree2_damaged', 'tree2_blackpod',
      'tree3_tiny', 'tree3_small', 'tree3_large', 'tree3_mature', 'tree3_rife', 'tree3_damaged', 'tree3_blackpod',
      'tree4_tiny', 'tree4_small', 'tree4_large', 'tree4_mature', 'tree4_rife', 'tree4_damaged', 'tree4_blackpod',
      'tree5_tiny', 'tree5_small', 'tree5_large', 'tree5_mature', 'tree5_rife', 'tree5_damaged', 'tree5_blackpod'
    ]

    CSV.generate(options) do |csv|
      csv << header_names
      Report.where(created_at: (date.beginning_of_day..date.end_of_day)).each do |report|
        csv << report.to_csv
      end
    end
  end

  #-----------------------#
  #   instance methods    #
  #-----------------------#

  def to_csv
    column_names = [
      'taken_at', 'site_reference', 'humidity', 'canopy', 'leaf', 'maintenance', 'flowers', 'bp', 'harvesting', 'drying', 'fertilizer', 'wilt'
    ]

    values = attributes.values_at(*column_names)
    trees.limit(5).each do |tree|
      values += tree.to_csv
    end

    values
  end
end
