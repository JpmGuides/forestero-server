require 'csv'

class Report < ApplicationRecord
  # associations
  has_many :trees, inverse_of: :report, dependent: :destroy
  belongs_to :device, inverse_of: :reports

  # validations
  validates :site_reference, :site_id, :visit_id, :taken_at, presence: true

  # accept nested parameters
  accepts_nested_attributes_for :trees

  #scopes
  scope :demo, -> { where(demo: true) }
  scope :real, -> { where("demo IS NULL or demo = false") }

  #-----------------------#
  #     class methods     #
  #-----------------------#

  def self.transpose_params(params)
    return {} unless params.is_a?(Hash)

    device = Device.find_or_create_by(uuid: params['d1'])

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
      region: params['p15'],
      site_active_gps: params['s1'],
      site_latitude: params['s2'],
      site_longitude: params['s3'],
      site_accuracy: params['s4'],
      site_age: params['s5'],
      device_id: device.id,
      demo: (params['d2'].to_s == '1')
    }}

    if device.uuid == '71739E5944834FAC8EF9CA534CE20240'
      report_params[:report][:demo] = false
    end


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

  def self.to_csv(date = DateTime.yesterday, options = {})
    header_names = [
      'date', 'site_reference', 'country', 'site_longitude', 'site_latitude', 'site_age', 'device', 'humidity', 'canopy', 'leaf', 'maintenance', 'flowers', 'bp', 'wilt', 'harvesting', 'drying', 'fertilizer',
      'tree1_tiny', 'tree1_small', 'tree1_large', 'tree1_mature', 'tree1_rife', 'tree1_damaged', 'tree1_blackpod',
      'tree2_tiny', 'tree2_small', 'tree2_large', 'tree2_mature', 'tree2_rife', 'tree2_damaged', 'tree2_blackpod',
      'tree3_tiny', 'tree3_small', 'tree3_large', 'tree3_mature', 'tree3_rife', 'tree3_damaged', 'tree3_blackpod',
      'tree4_tiny', 'tree4_small', 'tree4_large', 'tree4_mature', 'tree4_rife', 'tree4_damaged', 'tree4_blackpod',
      'tree5_tiny', 'tree5_small', 'tree5_large', 'tree5_mature', 'tree5_rife', 'tree5_damaged', 'tree5_blackpod'
    ]

    CSV.generate(options) do |csv|
      csv << header_names
      Report.where(created_at: (date.beginning_of_day..date.end_of_day)).real.each do |report|
        csv << report.to_csv
      end
    end
  end

  def self.resumes(date = DateTime.yesterday)
    resumes = []
    date = date - 1.day

    Report.where(taken_at: (date.beginning_of_day..date.end_of_day)).real.group_by(&:region).each do |region, reports|
      resumes << Resume.new(date, region, reports)
    end

    resumes
  end

  #-----------------------#
  #   instance methods    #
  #-----------------------#

  def country
    if ['AS', 'BAR', 'CR', 'ER', 'WN', 'WS'].include?(region)
      return 'Ghana'
    else
      return 'Ivory Coast'
    end
  end

  def to_csv
    column_names = [
      'taken_at', 'site_reference', 'country', 'site_longitude', 'site_latitude', 'site_age', 'device', 'humidity', 'canopy', 'leaf', 'maintenance', 'flowers', 'bp', 'wilt', 'harvesting', 'drying', 'fertilizer'
    ]

    values = []

    column_names.each do |attributes|
      value = send(attributes)

      if value.is_a?(Device)
        values << value.to_s
      elsif value.is_a?(TrueClass) || value.is_a?(FalseClass)
        values << (value ? 1 : 0)
      else
        values << value
      end
    end

    trees.limit(5).each do |tree|
      values += tree.to_csv
    end

    values
  end
end
