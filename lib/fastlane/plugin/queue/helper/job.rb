class MockOptions
  attr_accessor :env
end

class Job
  @queue = :fastlane

  def self.perform(params)
    run = params['run']

    platform = params['platform']
    lane = params['lane']
    lane_parameters = params['lane_parameters']

    if run
      args = run.split(' ')
      
      if args.first == "fastlane"
        args.shift
      end
      
      Fastlane::CommandLineHandler.handle(args, MockOptions.new)
    else
      platform = nil if platform.to_s.size == 0
      lane_parameters = lane_parameters.each_with_object({}) { |(k, v), memo| memo[k.to_sym] = v; }

      dot_env = nil
      Fastlane::LaneManager.cruise_lane(platform, lane, lane_parameters, dot_env)
    end
  end
end
