require 'rspec'
require 'date'
require 'timecop'
require './lib/task.rb'
require './lib/stream.rb'
require './lib/river.rb'

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
