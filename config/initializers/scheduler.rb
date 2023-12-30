# frozen_string_literal: true

require 'rufus-scheduler'

return if Rails.env.test? || File.split($PROGRAM_NAME).last == 'rake'

s = Rufus::Scheduler.singleton

s.every '1m' do
  MqttOffline.verify
end
