require 'calabash-android/management/app_installation'

AfterConfiguration do |config|
	FeatureNameMemory.feature_name = nil
end

Before do |scenario|
  @scenario_is_outline = (scenario.class == Cucumber::Ast::OutlineTable::ExampleRow)
  if @scenario_is_outline
    scenario = scenario.scenario_outline
  end

  feature_name = scenario.feature.title
  if ((FeatureNameMemory.feature_name != feature_name \
      && ENV["RESET_BETWEEN_FEATURES"] == "1") \
      || ENV["RESET_BETWEEN_SCENARIOS"] == "1")

    log "Installing the app from the hook...."
    log "Feature name: #{feature_name}"
    log "Saved feature name: #{FeatureNameMemory.feature_name}"
    log "RESET_BETWEEN_FEATURES: #{ENV['RESET_BETWEEN_FEATURES']}"
    log "RESET_BETWEEN_SCENARIOS: #{ENV['RESET_BETWEEN_SCENARIOS']}"

    if ENV["RESET_BETWEEN_SCENARIOS"] == "1"
      log "New scenario - reinstalling apps"
    else
      log "First scenario in feature - reinstalling apps"
    end

    uninstall_apps
    install_app(ENV["TEST_APP_PATH"])
    install_app(ENV["APP_PATH"])
    FeatureNameMemory.feature_name = feature_name
	FeatureNameMemory.invocation = 1
  else
    FeatureNameMemory.invocation += 1
  end
end

FeatureNameMemory = Class.new
class << FeatureNameMemory
  @feature_name = nil
  attr_accessor :feature_name, :invocation
end
