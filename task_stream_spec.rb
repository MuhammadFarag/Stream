require 'rspec'
require 'date'
require 'timecop'

class DateTime
  def to_date
    Date.jd(DateTime.now.jd)
  end

  def same_day_as?(other)
    Date.jd(jd) == Date.jd(other.jd)
  end

  def today?
    same_day_as?(DateTime.now)
  end
end

class Task
  attr_accessor :description, :completion_time

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

  def completed_today?
    @completion_time.today?
  end

end

class Stream
  def initialize
    @task_list = []
  end

  def add(task)
    @task_list << task
  end

  def due
    last_completed_task = @task_list.select(&:complete?).last
    return nil if !last_completed_task.nil? && last_completed_task.completed_today?
    @task_list.reject(&:complete?).first
  end
end

describe Stream do
  before(:each) do
    @task_1 = Task.new('M@y first task')
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

    it 'should get nothing, if the last completed task was completed today' do
      @task_1.complete
      expect(@stream.due).to eq nil
    end

    it 'should get new task if the last completed task, was completed before today' do
      Timecop.freeze(Date.today - 1)
      @task_1.complete
      Timecop.return
      expect(@stream.due).to eq @task_2
    end
  end
end
