# frozen_string_literal: true
class ProcessAllFilesInLocalFolders
  def initialize(folders)
    @folders = folders
  end

  def each
    [*folders].each do |folder|
      Dir.glob(folder) do |file|
        ap "Processing #{file}..."
        yield file
      end
    end
  end

  private

  attr_reader :folders
end
