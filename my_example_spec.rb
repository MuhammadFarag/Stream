require 'rspec'


class Stream
  def tasks
    []
  end
end


describe Stream do
  context 'When retrieving tasks from a Stream' do

    it 'should be empty if no Tasks were added' do
      stream = Stream.new
      expect(stream.tasks.first).to eq nil
    end
  end
end
