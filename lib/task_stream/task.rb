require 'date'

module TaskStream
  class Task
    attr_accessor :description

    def initialize(description, completion_time = nil)
      @description = description
      @completion_time = completion_time
    end

    def complete
      @completion_time = DateTime.now
    end

    def complete?
      !@completion_time.nil?
    end

    def completed_within?(days)
      (Date.jd(@completion_time.jd) - DateTime.now.to_date).abs < days
    end
  end
end
