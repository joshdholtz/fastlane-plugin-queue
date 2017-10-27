class Job
  @queue = :fastlane

  def self.perform(params)
    platform = params['platform']
    lane = params['lane']
    lane_parameters = params['lane_parameters']
    
    FileUtils::rm_rf '../_autobuilds'
    
    if platform.to_s.size == 0
      platform = nil
    end
    
    lane_parameters = lane_parameters.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    
    dot_env = nil
    Fastlane::LaneManager.cruise_lane(platform, lane, lane_parameters, dot_env)
  end
end
