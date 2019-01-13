require 'rspec'


class Stream
  def initialize
    @task_list = []
  end

  def add(task)
    @task_list << task
  end

  def tasks
    @task_list
  end
end


describe Stream do
  before(:all) do
    @task_1 = 'My first task'
    @task_2 = 'My second task'
  end

  context 'When retrieving tasks from a Stream' do

    it 'should be empty if no Tasks were added' do
      stream = Stream.new
      expect(stream.tasks.first).to eq nil
    end

    it 'should get the first entered task FIFO' do
      stream = Stream.new
      stream.add(@task_1)
      stream.add(@task_2)
      expect(stream.tasks.first).to eq @task_1
    end

  end
end
