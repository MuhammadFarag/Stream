require 'rspec'
require 'date'
require 'timecop'
require './lib/task_stream.rb'


describe TaskStream::Stream do
  before(:each) do
    @task_1 = TaskStream::Task.new('My first task')
    @task_2 = TaskStream::Task.new('My second task')
    @stream = TaskStream::Stream.new(5, Time.now, "Stream name")
    @stream.add(@task_1)
    @stream.add(@task_2)
  end

  after(:each) do
    Timecop.return
  end

  context 'Due task' do
    it 'should be empty if no Tasks were added' do
      stream = TaskStream::Stream.new(nil, nil, "Stream name")
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

    it 'should return due task if initialized with nils' do
      stream = TaskStream::Stream.new(nil, nil, "Stream name")
      stream.add(@task_1)
      expect(stream.due).to eq @task_1
    end

    it 'should return due task if dormancy days set to nil' do
      stream = TaskStream::Stream.new(nil, Time.now, "Stream name")
      stream.add(@task_1)
      stream.add(@task_2)
      expect(stream.due).to eq @task_1
      @task_1.complete
      expect(stream.due).to eq @task_2
    end
  end

  context 'number of overdue days' do

    it 'Should be zero for the first task if the stream has no start date' do
      stream = TaskStream::Stream.new(nil, nil, "Stream name")
      stream.add(@task_1)
      expect(stream.due.overdue).to  eq 0
    end

    it 'Should one day less than time since the start of the stream for the first task' do
      Timecop.freeze(Date.today + 2 )
      expect(@stream.due.overdue).to  eq 1
    end

    it 'Should one day less than time since last task was completed if dormancy days is nil' do
      stream = TaskStream::Stream.new(nil, Time.now, "Stream name")
      stream.add(@task_1)
      stream.add(@task_2)
      Timecop.freeze(Date.today + 1 )
      @task_1.complete
      Timecop.freeze(Date.today + 3 )
      expect(stream.due.overdue).to  eq 2
    end

    it 'Should one day less than time since last task was completed - dormancy days if dormancy days is set' do
      stream = TaskStream::Stream.new(1, Time.now, "Stream name")
      stream.add(@task_1)
      stream.add(@task_2)
      Timecop.freeze(Date.today + 1 )
      @task_1.complete
      Timecop.freeze(Date.today + 3 )
      expect(stream.due.overdue).to  eq 1
    end

  end
end
