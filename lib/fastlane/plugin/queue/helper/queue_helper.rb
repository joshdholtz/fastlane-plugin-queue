module Fastlane
  module Helper
    class QueueHelper
      # class methods that you define here become available in your action
      # as `Helper::QueueHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the queue plugin helper!")
      end
    end
  end
end
