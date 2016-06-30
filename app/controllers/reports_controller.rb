class ReportsController < ApplicationController
  skip_before_action :authenticate_user!, only: :create
  protect_from_forgery except: :create
  load_and_authorize_resource except: [:create]

  def create
    @report = Report.new(report_params)

    if @report.save
      head :created
    else
      render plain: @report.errors.full_messages[0], status: 400
    end
  end

  def index
    @resumes = Report.resumes

    respond_to do |format|
      format.html
      format.csv { send_data Resume.to_csv(@resumes) }
    end
  end

  def raw
    if params[:date]
      @date = Date.parse(params[:date])
    else
      @date = Date.today
    end


    @reports = Report.where(created_at: (@date.beginning_of_day..@date.end_of_day))

    respond_to do |format|
      format.html
      format.csv { send_data Report.to_csv(@date) }
    end
  end

  private

  def report_params
    if request.raw_post
      post_params = Rack::Utils.parse_nested_query(request.raw_post)
      params = ActionController::Parameters.new(Report.transpose_params(post_params))
    end

    params.require(:report).permit([
      :taken_at, :site_reference, :site_id, :visit_id, :humidity, :canopy,
      :leaf, :maintenance, :flowers, :bp, :harvesting, :drying, :fertilizer, :wilt, :region,
      :site_active_gps, :site_latitude, :site_longitude, :site_accuracy, :site_age, :device_id,
      {:trees_attributes => [:tiny, :small, :large, :mature, :rife, :damaged, :blackpod]}
    ])
  end
end
