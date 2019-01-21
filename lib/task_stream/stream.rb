module TaskStream
  class Stream
    attr_accessor :name

    def initialize(dormancy_days = 1, start_date = nil, name = "") # TODO: Remove the empty default value
      @task_list = []
      @dormancy_days = dormancy_days
      @start_date = start_date
      @name = name
    end

    def add(task)
      @task_list << task
    end

    def due
      return unless @start_date.nil? || @start_date && @start_date <= DateTime.now

      last_completed_task = @task_list.select(&:complete?).last
      @task_list.reject(&:complete?).first unless last_completed_task && last_completed_task.completed_within?(@dormancy_days)
    end
  end
end
