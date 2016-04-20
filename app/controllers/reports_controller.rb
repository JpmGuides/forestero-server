class ReportsController < ApplicationController
  skip_before_filter :authenticate_user!, only: :create
  protect_from_forgery except: :create

  def create
    @report = Report.new(report_params)

    if @report.save
      head :created
    else
      render plain: @report.errors.full_messages[0], status: 400
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
      :leaf, :maintenance, :flowers, :bp, :harvesting, :drying, :fertilizer, :wilt,
      {:trees_attributes => [:tiny, :small, :large, :mature, :rife, :damaged, :blackpod]}
    ])
  end
end
