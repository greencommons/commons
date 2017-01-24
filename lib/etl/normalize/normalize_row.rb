class NormalizeRow
  def initialize(normalizer_klass, source_klass, *args)
    @normalizer = normalizer_klass.new
    @source = source_klass.new(*args)
  end

  def each
    @source.each do |input|
      @normalizer.process(input) do |array|
        array.each do |record|
          yield record
        end
      end
    end
  end
end
