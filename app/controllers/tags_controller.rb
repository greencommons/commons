class TagsController < ApplicationController
  TAGGABLE_MODELS = %w(Group Resource).freeze

  def create
    if TAGGABLE_MODELS.include?(params[:model_name])
      entity = params[:model_name].constantize.find(params[params[:model_name].foreign_key])
      entity.tag_list.add(tag_params[:name])
      entity.save

      render json: entity.cached_tags
    else
      render json: { error: 'Unsupported Model Name.' }
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
