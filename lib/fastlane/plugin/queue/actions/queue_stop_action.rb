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
        Process.fork do
          begin
            require 'vegas'
            require 'resque/server'
            Vegas::Runner.new(Resque::Server, 'fastlane-plugin-queue-resque-web', {}, ["--kill"])
            puts "killed resque"
          rescue StandardError
            UI.warning("Nothing to stop")
          end
        end
        
        Process.fork do
          begin
            require 'vegas'
            require 'resque/server'
            Vegas::Runner.new(App, 'fastlane-plugin-queue-app', {}, ["--kill"])
            puts "killed app"
          rescue StandardError
            UI.warning("Nothing to stop")
          end
        end
        
        # Sleeping because we need time to kill these proceses ^ :-|
        sleep 5
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
