class S3SignaturesController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    direct_upload_signature = S3.new.generate_signature(
      ResourcePathBuilder.generate(params[:filename])
    )
    render json: { s3_signature: direct_upload_signature }
  end
end
