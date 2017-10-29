module Fastlane
  module Actions
    class QueueStartAction < Action
      def self.run(params)
        UI.message("Starting the queue's web server and worker!")

        # Gotta do the fork thing
        # Otherwise this process will block the worker from starting
        # This can get called  multiple times and only one server will be run
        pid = Process.fork do
          require 'vegas'
          require 'resque/server'
          Vegas::Runner.new(Resque::Server, 'fastlane-plugin-queue-resque-web')
        end

        # Starts a blocking worker
        require 'resque'
        worker = Resque::Worker.new("fastlane")
        worker.prepare
        worker.log "Starting worker #{self}"
        worker.work(5) # interval, will block

        # Stops the queue and webserver
        other_action.queue_stop
      end

      def self.description
        "Starts web server and worker for queueing fastlane jobs"
      end

      def self.authors
        ["Josh Holtz"]
      end

      def self.return_value
        # This action will NEVER return because the worker is blocking
      end

      def self.details
        "Starts a Resque web server and worker for queueing fastlane jobs"
      end

      def self.available_options
        # No options right now but probably allow Resque options to be set
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
