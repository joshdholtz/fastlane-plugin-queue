describe Fastlane::Actions::QueueAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The queue plugin is working!")

      Fastlane::Actions::QueueAction.run(nil)
    end
  end
end
