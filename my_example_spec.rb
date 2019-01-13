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
  context 'When retrieving tasks from a Stream' do

    it 'should be empty if no Tasks were added' do
      stream = Stream.new
      expect(stream.tasks.first).to eq nil
    end

    it 'should get the first entered task FIFO' do
      stream = Stream.new
      stream.add('My first task')
      stream.add('My second task')
      expect(stream.tasks.first).to eq 'My first task'
    end

  end
end
