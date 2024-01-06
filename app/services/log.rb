# frozen_string_literal: true

class Log
  def self.error(log)
    puts "#{time_now} ERROR: #{log}".colorize(:red) if Rails.env.development?
    Rails.logger.error log.to_s if Rails.env.production?
  end

  def self.info(log)
    puts "#{time_now} INFO: #{log}".colorize(:green) if Rails.env.development?
    Rails.logger.info log.to_s if Rails.env.production?
  end

  def self.alert(log)
    puts "#{time_now} ALERTA: #{log}".colorize(:yellow) if Rails.env.development?
    Rails.logger.warn log.to_s if Rails.env.production?
  end

  def self.time_now
    Time.now.strftime('%d\%m\%Y %H:%M:%S')
  end
end
