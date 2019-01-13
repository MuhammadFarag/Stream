require 'rspec'

class Stream
  def tasks; end
end


describe Stream do
  context 'When retrieving tasks from a Stream' do

    it 'should get nothing when its first initialized' do
      stream = Stream.new
      expect(stream.tasks).to eq nil
    end
  end
end
