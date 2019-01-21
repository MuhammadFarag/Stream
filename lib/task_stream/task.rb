require 'date'
require_relative 'refinement'
module TaskStream
  class Task

    using DateTimeOps
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
      @completion_time.within?(days)
    end
  end
end
