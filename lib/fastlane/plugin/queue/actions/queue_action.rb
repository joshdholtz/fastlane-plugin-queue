require 'resque'

module Fastlane
  module Actions
    class QueueAction < Action
      def self.run(params)
        # Should be value like "<platform> <lane> <parameters...>"
        # Ex: "ios build environment:production"
        # Usage: fastlane run queue run:"ios build environment:production"
        run = params[:run]

        # These values come in from running the queue action in a Fastfile
        platform = params[:platform]
        lane = params[:lane]
        lane_parameters = params[:lane_parameters]

        if lane_parameters
          lane_parameters['queue'] = nil
          lane_parameters[:queue] = nil
        end

        Resque.enqueue(Job, {
          'run' => run,
          'platform' => platform,
          'lane' => lane,
          'lane_parameters' => lane_parameters
          })
      end

      def self.description
        "Adds fastlane jobs to a queue"
      end

      def self.authors
        ["Josh Holtz"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Adds fastlane jobs to a Resque queue"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :run,
                               description: "Run that stuff",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :platform,
                               description: "Run that stuff",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :lane,
                               description: "Run that stuff",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :lane_parameters,
                               description: "Run that stuff",
                                  optional: true,
                                      type: Hash)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
