require 'rspec'
require 'date'
require 'timecop'
require './lib/task_stream.rb'

describe TaskStream do
  before(:each) do
    @task_1 = TaskStream::Task.new('My first task')
    @task_2 = TaskStream::Task.new('My second task')
    @stream = TaskStream::Stream.new(5, DateTime.now)
    @stream.add(@task_1)
    @stream.add(@task_2)
  end

  context 'tasks' do
    it 'should return nothing if the task_stream is empty' do
      streams = TaskStream::Streams.new
      expect(streams.tasks).to eq nil
    end

    it 'should return due task from one stream' do
      streams = TaskStream::Streams.new(@stream)
      expect(streams.tasks).to eq [@task_1]
    end

    it 'should return due tasks from all streams' do
      streams = TaskStream::Streams.new(@stream, @stream)
      expect(streams.tasks).to eq [@task_1, @task_1]
    end
  end
end
