module TaskStream
  class Streams
    def initialize(*streams)
      @streams = streams
    end

    def tasks
      @streams.map(&:due) unless @streams.nil? || @streams.empty?
    end
  end
end
