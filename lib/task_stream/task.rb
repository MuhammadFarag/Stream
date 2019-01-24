require 'date'

module TaskStream
  class Task
    attr_accessor :description, :completion_time

    def initialize(description, completion_time = nil)
      @description = description
      @completion_time = completion_time
    end

    def complete
      @completion_time = Time.now
    end

    def complete?
      !@completion_time.nil?
    end

    def completed_within?(days)
      (Time.now - @completion_time ) < (days * 24 * 3600)
    end
  end
end
