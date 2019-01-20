require 'rspec'
require 'date'
require 'timecop'
require './lib/task_stream.rb'


describe TaskStream::Stream do
  before(:each) do
    @task_1 = TaskStream.new_task('My first task')
    @task_2 = TaskStream.new_task('My second task')
    @stream = TaskStream.new_stream(5, DateTime.now)
    @stream.add(@task_1)
    @stream.add(@task_2)
  end

  after(:each) do
    Timecop.return
  end

  context 'Due task' do
    it 'should be empty if no Tasks were added' do
      stream = TaskStream.new_stream
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
