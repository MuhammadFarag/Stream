require 'date'

module DateTimeOps
  refine DateTime do
    def to_date
      Date.jd(jd)
    end

    def within?(days)
      (to_date - DateTime.now.to_date).abs < days
    end
  end

end
