require 'rspec'
require 'date'
require 'timecop'

class DateTime
  def to_date
    Date.jd(jd)
  end

  def within?(days)
    (to_date - DateTime.now.to_date).abs < days
  end
end

class Task
  def initialize(description)
    @completion_time = nil
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

class Stream
  def initialize(dormancy_days = 1)
    @task_list = []
    @dormancy_days = dormancy_days
  end

  def add(task)
    @task_list << task
  end

  def due
    last_completed_task = @task_list.select(&:complete?).last
    return nil if !last_completed_task.nil? && last_completed_task.completed_within?(@dormancy_days)
    @task_list.reject(&:complete?).first
  end
end

describe Stream do
  before(:each) do
    @task_1 = Task.new('My first task')
    @task_2 = Task.new('My second task')
    @stream = Stream.new
    @stream.add(@task_1)
    @stream.add(@task_2)
  end

  after(:each) do
    Timecop.return
  end

  context 'Due task' do
    it 'should be empty if no Tasks were added' do
      stream = Stream.new
      expect(stream.due).to eq nil
    end

    it 'should get the first entered task FIFO' do
      expect(@stream.due).to eq @task_1
    end

    it 'should get nothing, if the last completed task was completed within the default dormancy of 1 day' do
      @task_1.complete
      expect(@stream.due).to eq nil
    end

    it 'should get new task if the last completed task, was completed before the default dormancy days of 1 day' do
      Timecop.freeze(Date.today - 1)
      @task_1.complete
      Timecop.return
      expect(@stream.due).to eq @task_2
    end
  end
end
