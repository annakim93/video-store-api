class VideosController < ApplicationController
  def index
    videos = Video.all.as_json(
      only: [:id, :title, :release_date, :available_inventory]
    )
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id]).as_json(
      only: [:overview, :title, :release_date, :available_inventory, :total_inventory]
    )

    if video.nil?
      render json: {
        errors: ['Not Found']
      }, status: :not_found

      return
    end

    render json: video, status: :ok
  end

  def create
    video = Video.new(video_params)

    if video.save
      render json: video.as_json(only: [:id]), status: :created
      return
    else
      render json: {
        errors: video.errors.messages
      }, status: :bad_request
      return
    end
  end

  private

  def video_params
    return params.permit(
      :id,
      :title,
      :overview,
      :release_date,
      :total_inventory,
      :available_inventory
    )
  end
end
