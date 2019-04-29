require 'csv'

class Resume
  attr_accessor :reports, :date, :region

  def initialize(date, region, reports)
    self.date = date
    self.region = region
    self.reports = reports
  end

  def country
    reports.first.country
  end

  def report_date
    Date.today.strftime('%d.%m.%Y')
  end

  def creation_date
    (date + 1.day).strftime('%d.%m.%Y')
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
    @tiny ||= trees.sum { |t| t.tiny.to_i }  / nb_trees.to_f
  end

  def small
    @small ||= trees.sum { |t| t.small.to_i }  / nb_trees.to_f
  end

  def small2
    @small2 ||= trees.sum { |t| t.small2.to_i }  / nb_trees.to_f
  end

  def large
    @large ||= trees.sum { |t| t.large.to_i } / nb_trees.to_f
  end

  def mature
    @mature ||= trees.sum { |t| t.mature.to_i } / nb_trees.to_f
  end

  def ripe
    @ripe ||= trees.sum { |t| t.rife.to_i } / nb_trees.to_f
  end

  def infest
    @infest ||= trees.sum { |t| t.infest.to_i }  / nb_trees.to_f
  end

  def force_r
    @force_r ||= trees.sum { |t| t.force_r.to_i } / nb_trees.to_f
  end

  def damaged
    @damaged ||= trees.sum { |t| t.damaged.to_i } / nb_trees.to_f
  end

  def blackpod
    @blackpod ||= trees.sum { |t| t.blackpod.to_i }/ nb_trees.to_f
  end

  def total_pods
    @total_pods ||= tiny + small + large + mature + ripe + infest + force_r + blackpod
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

  def to_csv
    method = [:region, :report_date] + self.class.headers.keys

    method.map { |m| self.send(m) }
  end

  def self.headers
    {
      country: 'Country',
      creation_date: 'Visit date',
      nb_sites: 'Nb sites',
      humidity: 'Humidity',
      canopy: 'Canopy',
      leaf: 'Leaf',
      maintenance: 'Maintenance',
      flowers: 'Flowers',
      tiny: 'Tiny',
      small: 'Small',
      small2: 'Small 2',
      large: 'Large',
      mature: 'Mature',
      ripe: 'Ripe',
      infest: 'Infest',
      force_r: 'Force R',
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
        csv << resume.to_csv
      end
    end
  end
end
