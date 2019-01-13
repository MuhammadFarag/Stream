require 'rspec'


class Task
  attr_accessor :completed, :description

  def initialize(description)
    @completed = false
    @description = description
  end

  def complete
    @completed = true
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
    @task_list.select { |task| !task.completed }.first
  end
end


describe Stream do
  before(:all) do
    @task_1 = Task.new('My first task')
    @task_2 = Task.new('My second task')
  end

  context 'Due task' do

    it 'should be empty if no Tasks were added' do
      stream = Stream.new
      expect(stream.due).to eq nil
    end

    it 'should get the first entered task FIFO' do
      stream = Stream.new
      stream.add(@task_1)
      stream.add(@task_2)
      expect(stream.due).to eq @task_1
    end

    it 'should get the first uncompleted task' do
      stream = Stream.new
      stream.add(@task_1)
      stream.add(@task_2)
      @task_1.complete
      expect(stream.due).to eq @task_2
    end

  end
end
