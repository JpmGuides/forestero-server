class DayTextsController < ApplicationController
  before_action :authorize_user

  def create
    valid_params = day_text_params

    @day_text = DayText.find_or_initialize_by(date: valid_params[:date])

    if @day_text.update(valid_params)
      head :created
    else
      render plain: @day_text.errors.full_messages[0], status: 400
    end
  end

  private

  def authorize_user
    head :unauthorized unless can? :manage, DayText
  end

  def day_text_params
    params.require(:day_text).permit(:text, :date, :bootsy_image_gallery_id)
  end
end
