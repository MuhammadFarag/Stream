class Stream
  def initialize(dormancy_days = 1, start_date = nil)
    @task_list = []
    @dormancy_days = dormancy_days
    @start_date = start_date
  end

  def add(task)
    @task_list << task
  end

  def due
    return unless @start_date && @start_date <= DateTime.now

    last_completed_task = @task_list.select(&:complete?).last
    @task_list.reject(&:complete?).first unless last_completed_task && last_completed_task.completed_within?(@dormancy_days)
  end
end
