require 'date'

class DateTime
  def to_date
    Date.jd(jd)
  end

  def within?(days)
    (to_date - DateTime.now.to_date).abs < days
  end
end

module TaskStream
  class Task
    attr_accessor :description

    def initialize(description)
      @description = description
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
