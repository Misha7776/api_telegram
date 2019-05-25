class Api::ContentController < ApplicationController
  def index
    @content = ContentService.new.fetch
    render json: @content, status: :ok
  end
end
