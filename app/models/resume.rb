require 'csv'

class Resume
  attr_accessor :reports, :date, :region

  def initialize(date, region, reports)
    self.date = date
    self.region = region
    self.reports = reports
  end

  def report_date
    Date.today.strftime('%d.%m.%Y')
  end

  def creation_date
    date.to_date.strftime('%d.%m.%Y')
  end

  def nb_reports
    reports.count
  end

  def nb_sites
    nb_reports
  end

  def humidity
    reports.sum(&:humidity) / nb_reports.to_f
  end

  def canopy
    reports.sum(&:canopy) / nb_reports.to_f
  end

  def leaf
    reports.sum(&:leaf) / nb_reports.to_f
  end

  def maintenance
    reports.sum(&:maintenance) / nb_reports.to_f
  end

  def flowers
    reports.sum(&:flowers) / nb_reports.to_f
  end

  def trees
    @trees ||= reports.map(&:trees).flatten
  end

  def nb_trees
    @nb_trees ||= trees.count
  end

  def tiny
    @tiny ||= trees.sum(&:tiny) / nb_trees.to_f
  end

  def small
    @small ||= trees.sum(&:small) / nb_trees.to_f
  end

  def large
    @large ||= trees.sum(&:large) / nb_trees.to_f
  end

  def mature
    @mature ||= trees.sum(&:mature) / nb_trees.to_f
  end

  def ripe
    @ripe ||= trees.sum(&:rife) / nb_trees.to_f
  end

  def damaged
    @damaged ||= trees.sum(&:damaged) / nb_trees.to_f
  end

  def blackpod
    @blackpod ||= trees.sum(&:blackpod) / nb_trees.to_f
  end

  def total_pods
    @total_pods ||= tiny + small + large + mature + ripe + damaged + blackpod
  end

  def bp
    @bp ||= Percentage.new(reports.sum { |r| r.bp ? 1 : 0 } / nb_reports.to_f)
  end

  def wilt
    @wilt ||= Percentage.new(reports.sum { |r| r.wilt ? 1 : 0 } / nb_reports.to_f)
  end

  def harvesting
    @harvesting ||= Percentage.new(reports.sum { |r| r.harvesting ? 1 : 0 } / nb_reports.to_f)
  end

  def drying
    @drying ||= Percentage.new(reports.sum { |r| r.drying ? 1 : 0 } / nb_reports.to_f)
  end

  def fertilizer
    @fertilizer ||= Percentage.new(reports.sum { |r| r.fertilizer ? 1 : 0 } / nb_reports.to_f)
  end

  def to_csv(csv)
    method = [:region, :report_date] + self.class.headers.keys

    values = method.map { |m| self.send(m) }

    csv << values
  end

  def self.headers
    {
      creation_date: 'Visit date',
      nb_sites: 'Nb sites',
      humidity: 'Humidity',
      canopy: 'Canopy',
      leaf: 'Leaf',
      maintenance: 'Maintenance',
      flowers: 'Flowers',
      tiny: 'Tiny',
      small: 'Small',
      large: 'Large',
      mature: 'Mature',
      ripe: 'Ripe',
      damaged: 'Damaged',
      blackpod: 'Blackpod',
      total_pods: 'Total Pods',
      bp: 'Black pod infestations',
      wilt: 'Wilt',
      harvesting: 'Harvesting',
      drying: 'Drying',
      fertilizer: 'Fertilizer'
    }
  end


  def self.to_csv(resumes)
    header_names =  ['Region', 'Report Date'] + headers.values

    CSV.generate do |csv|
      csv << header_names

      resumes.each do |resume|
        resume.to_csv(csv)
      end
    end
  end
end
