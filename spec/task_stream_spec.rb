require 'rspec'
require 'date'
require 'timecop'
require './lib/task_stream.rb'

describe TaskStream do
  before(:each) do
    @task_1 = TaskStream.new_task('My first task')
    @task_2 = TaskStream.new_task('My second task')
    @stream = TaskStream.new_stream(5, DateTime.now)
    @stream.add(@task_1)
    @stream.add(@task_2)
  end

  context 'tasks' do
    it 'should return nothing if the task_stream is empty' do
      river = TaskStream.new
      expect(river.tasks).to eq nil
    end

    it 'should return due task from one stream' do
      river = TaskStream.new(@stream)
      expect(river.tasks).to eq [@task_1]
    end

    it 'should return due tasks from all streams' do
      river = TaskStream.new(@stream, @stream)
      expect(river.tasks).to eq [@task_1, @task_1]
    end
  end
end
