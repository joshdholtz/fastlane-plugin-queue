module Fastlane
  module Actions
    class QueueStopAction < Action
      def self.run(params)
        UI.message("Stopping the queue!")
        
        # I feel bad about this
        require 'resque'
        begin
          Resque::Worker.all.each do |worker|
            Process.kill("KILL", worker.pid) rescue true
            worker.shutdown!
            worker.prune_dead_workers
          end
        rescue
          UI.warning("Nothing to stop")
        end

        begin
          require 'vegas'
          require 'resque/server'
          Vegas::Runner.new(Resque::Server, 'fastlane-plugin-queue-resque-web', {}, ["--kill"])
        rescue
          UI.warning("Nothing to stop")
        end
      end

      def self.description
        "Queue up fastlane jobs"
      end

      def self.authors
        ["Josh Holtz"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Queue up fastlane jobs with resque with a nice web interface"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "QUEUE_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
