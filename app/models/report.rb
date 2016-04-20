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
      bp: params['p10'],
      harvesting: params['p11'],
      drying: params['p12'],
      fertilizer: params['p13'],
      wilt: params['p14'],
    }}

    report_params[:report][:trees_attributes] = transpose_trees_params(params)

    return report_params
  rescue
    return {}
  end

  def self.transpose_trees_params(params)
    trees_index = 1
    trees_param = []

    while params["t#{trees_index}"].present?
      trees_param << Tree.transpose_params(params["t#{trees_index}"])
      trees_index += 1
    end

    return params
  end
end
