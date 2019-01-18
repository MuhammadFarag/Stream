class TaskStream
  def initialize(*streams)
    @streams = streams
  end

  def tasks
    @streams.map(&:due) unless @streams.nil? || @streams.empty?
  end
end
