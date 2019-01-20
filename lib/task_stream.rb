require_relative 'task_stream/stream'
require_relative 'task_stream/task'

module TaskStream
  def initialize(*streams)
    @streams = streams
  end

  def tasks
    @streams.map(&:due) unless @streams.nil? || @streams.empty?
  end

  def self.new_stream(dormancy_days = 1, start_date = nil)
    Stream.new(dormancy_days, start_date)
  end

  def self.new_task(description)
    Task.new(description)
  end
end
