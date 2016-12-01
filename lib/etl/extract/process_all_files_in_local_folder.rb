class ProcessAllFilesInLocalFolder
  def initialize(glob)
    @glob = glob
  end

  def each
    Dir.glob(glob) do |file|
      yield file
    end
  end

  private

  attr_reader :glob
end
