class StaticPagesController < ApplicationController
  layout false, only: :home

  def home; end

  def policy; end
end
