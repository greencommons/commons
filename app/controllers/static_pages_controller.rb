class StaticPagesController < ApplicationController
  layout false, only: :home

  def home
    @counts = Resource.group(:resource_type).count
  end

  def policy; end

  def about; end
end
