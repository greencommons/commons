class StaticPagesController < ApplicationController
  layout false, only: :home

  def home
    @counts = Resource.group(:resource_type).count
    @networks = Network.includes(:users).sample(10)
  end

  def policy; end

  def about; end
end
