module Fastlane
  module Actions
    class QueueStartAction < Action
      def self.run(params)
        UI.message("Starting the queue!")
        
        # Gotta do the fork thing
        pid = Process.fork do
          require 'vegas'
          require 'resque/server'
          Vegas::Runner.new(Resque::Server, 'fastlane-plugin-queue-resque-web')
        end
        
        # pid = Process.fork do
          require 'resque'
          worker = Resque::Worker.new("fastlane")
          worker.prepare
          worker.log "Starting worker #{self}"
          worker.work(5) # interval, will block
        # end
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
