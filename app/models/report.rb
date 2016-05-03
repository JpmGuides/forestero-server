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
      region: params['p15']
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

  def self.to_csv(date = DateTime.yesterday, options = {})
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

  def self.report_to_csv(date = DateTime.yesterday)
    report = Report.report(date)
    header_names = [:region, :report_date] + report[report.keys.first].keys
    header_names = header_names.map { |h| h.to_s.humanize }

    CSV.generate do |csv|
      csv << header_names
      report.each do |region, values|
        csv << [region, Date.today.strftime('%d.%m.%Y')] + values.values
      end
    end
  end

  def self.report(date = DateTime.yesterday)
    report = {}

    Report.where(taken_at: (date.beginning_of_day..date.end_of_day)).group_by(&:region).each do |region, reports|
      nb_report = reports.count.to_f

      report[region] = {}
      report[region][:creation_date] = date.to_date.strftime('%d.%m.%Y')
      report[region][:nb_sites]      = nb_report.to_i
      report[region][:humidity]      = reports.sum(&:humidity) / nb_report
      report[region][:canopy]        = reports.sum(&:canopy) / nb_report
      report[region][:leaf]          = reports.sum(&:leaf) / nb_report
      report[region][:maintenance]   = reports.sum(&:maintenance) / nb_report
      report[region][:flowers]       = reports.sum(&:flowers) / nb_report

      trees = reports.map(&:trees).flatten
      nb_trees = trees.count.to_f

      report[region][:tiny]       = trees.sum(&:tiny) / nb_trees
      report[region][:small]      = trees.sum(&:small) / nb_trees
      report[region][:large]      = trees.sum(&:large) / nb_trees
      report[region][:mature]     = trees.sum(&:mature) / nb_trees
      report[region][:ripe]       = trees.sum(&:rife) / nb_trees
      report[region][:damaged]    = trees.sum(&:damaged) / nb_trees
      report[region][:blackpod]   = trees.sum(&:blackpod) / nb_trees
      report[region][:total_pods] = report[region][:tiny] + report[region][:small] + report[region][:large] + report[region][:mature] + report[region][:ripe] + report[region][:damaged] + report[region][:blackpod]

      report[region][:black_pod_infestation] = Percentage.new(reports.sum { |r| r.bp ? 1 : 0 } / nb_report)
      report[region][:wilt] = Percentage.new(reports.sum { |r| r.wilt ? 1 : 0 } / nb_report)
      report[region][:harvesting] = Percentage.new(reports.sum { |r| r.harvesting ? 1 : 0 } / nb_report)
      report[region][:drying] = Percentage.new(reports.sum { |r| r.drying ? 1 : 0 } / nb_report)
      report[region][:fertilizer] = Percentage.new(reports.sum { |r| r.fertilizer ? 1 : 0 } / nb_report)
    end

    report
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
