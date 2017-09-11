class StaticPagesController < ApplicationController
  layout false, only: :home

  def home
    @counts = Resource.group(:resource_type).count
    @networks = Network.includes(:users).sample(10)
    @books = Resource.books.sample(6)
    @articles = Resource.articles.sample(6)
    @reports = Resource.reports.sample(6)
    @audios = Resource.audios.sample(6)
    @courses = Resource.courses.sample(6)
    @datasets = Resource.datasets.sample(6)
    @syllabuses = Resource.syllabuses.sample(6)
    @videos = Resource.videos.sample(6)
  end

  def policy; end

  def about; end
end
