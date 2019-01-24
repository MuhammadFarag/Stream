require_relative 'due_task_extension'
module TaskStream
  class Stream
    attr_accessor :name

    def initialize(dormancy_days = 1, start_date = nil, name = nil)
      @task_list = []
      @dormancy_days = dormancy_days
      @start_date = start_date
      @name = name
    end

    def add(task)
      @task_list << task
    end

    def due
      return unless @start_date.nil? || @start_date && @start_date <= Time.now

      last_completed_task = @task_list.select(&:complete?).last
      due_task = @task_list.reject(&:complete?).first unless @dormancy_days && last_completed_task && last_completed_task.completed_within?(@dormancy_days)
      unless due_task.nil?
        due_task.extend TaskStream::DueTask
        unless last_completed_task.nil?
          due_task.overdue = time_sub(Time.now, last_completed_task.completion_time) - 1
        else
          due_task.overdue = @start_date.nil? ? 0 : time_sub(Time.now, @start_date) - 1
        end
      end
      due_task
    end

    private

    def time_sub(t1, t2)
      years = t1.year - t2.year
      months = t1.month - t2.month
      days = t1.day - t2.day
      years * 365 + months * 30 + days
    end
  end
end
# That is (today - last_task_completion_date) - dormancy days - 1 # We subtract one because if it is the first
