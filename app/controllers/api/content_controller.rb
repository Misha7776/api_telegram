class Api::ContentController < ApplicationController
  def index
    @content = ContentService.new.build_content
    render json: @content, status: :ok
  end
end
