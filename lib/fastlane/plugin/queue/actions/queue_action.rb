require 'resque'

module Fastlane
  module Actions
    
    class QueueAction < Action
      def self.run(params)
        run = params[:run]
        
        platform = params[:platform]
        lane = params[:lane]
        lane_parameters = params[:lane_parameters]
        
        if run
          lane_parameters = {} # the parameters we'll pass to the lane
          platform_lane_info = [] # the part that's responsible for the lane/platform definition
          args.each do |current|
            if current.include? ":" # that's a key/value which we want to pass to the lane
              key, value = current.split(":", 2)
              value = Fastlane::CommandLineHandler.convert_value(value)
              lane_parameters[key.to_sym] = value
            else
              platform_lane_info << current
            end
          end

          platform = nil
          lane = platform_lane_info[1]
          if lane
            platform = platform_lane_info[0]
          else
            lane = platform_lane_info[0]
          end
        end
        
        lane_parameters['queue'] = nil
        lane_parameters[:queue] = nil
        
        Resque.enqueue(Job, {
          'platform' => platform,
          'lane' => lane,
          'lane_parameters' => lane_parameters
          })
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
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :lane_parameters,
                               description: "Run that stuff",
                                  optional: false,
                                      type: Hash)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
