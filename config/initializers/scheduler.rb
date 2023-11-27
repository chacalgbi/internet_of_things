# frozen_string_literal: true

require 'rufus-scheduler'

return if defined?(Rails::Console) || Rails.env.test? || File.split($PROGRAM_NAME).last == 'rake'

s = Rufus::Scheduler.singleton

s.every '40s' do
  MqttOffline.verify
end
