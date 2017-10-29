module Fastlane
  module Actions
    class QueueStopAction < Action
      def self.run(params)
        UI.message("Stopping the queue's web server and worker!")

        # I feel bad about this but need to kill the process of the worker
        # and shutdown the worker and prunce dead workers from showing
        # in the Resque web interface
        require 'resque'
        begin
          Resque::Worker.all.each do |worker|
            begin
              Process.kill("KILL", worker.pid)
            rescue StandardError
              true
            end
            worker.shutdown!
            worker.prune_dead_workers
          end
        rescue StandardError
          UI.warning("Nothing to stop")
        end

        # Shut down our web server
        begin
          require 'vegas'
          require 'resque/server'
          Vegas::Runner.new(Resque::Server, 'fastlane-plugin-queue-resque-web', {}, ["--kill"])
        rescue StandardError
          UI.warning("Nothing to stop")
        end
      end

      def self.description
        "Stops web server and worker for queueing fastlane jobs"
      end

      def self.authors
        ["Josh Holtz"]
      end

      def self.return_value
        # No return value right now
      end

      def self.details
        "Stops a Resque web server and worker for queueing fastlane jobs"
      end

      def self.available_options
        # No options right now
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
