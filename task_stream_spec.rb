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

describe Stream do
  before(:each) do
    @task_1 = Task.new('My first task')
    @task_2 = Task.new('My second task')
    @stream = Stream.new(5, DateTime.now)
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

    it 'should get nothing, if the last completed task was completed within dormancy value' do
      Timecop.freeze(Date.today - 4)
      @task_1.complete
      Timecop.return
      expect(@stream.due).to eq nil
    end

    it 'should get new task if the last completed task, was completed before dormancy value' do
      Timecop.freeze(Date.today - 5)
      @task_1.complete
      Timecop.return
      expect(@stream.due).to eq @task_2
    end

    it 'should not get tasks for streams that are going to start in the future' do
      Timecop.freeze(Date.today - 5)
      expect(@stream.due).to eq nil
      Timecop.return
    end
  end
end

class River
  def initialize(*streams)
    @streams = streams
  end

  def tasks
    @streams.map(&:due) unless @streams.nil? || @streams.empty?
  end
end

describe River do
  before(:each) do
    @task_1 = Task.new('My first task')
    @task_2 = Task.new('My second task')
    @stream = Stream.new(5, DateTime.now)
    @stream.add(@task_1)
    @stream.add(@task_2)
  end

  context 'tasks' do
    it 'should return nothing if the river is empty' do
      river = River.new
      expect(river.tasks).to eq nil
    end

    it 'should return due task from one stream' do
      river = River.new(@stream)
      expect(river.tasks).to eq [@task_1]
    end

    it 'should return due tasks from all streams' do
      river = River.new(@stream, @stream)
      expect(river.tasks).to eq [@task_1, @task_1]
    end
  end
end
