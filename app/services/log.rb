# frozen_string_literal: true

class Log
  def self.error(log)
    puts "#{Time.now} --- ERROR: #{log} --- \n".colorize(:red)
    Rails.logger.error "\n --- ERROR: #{log} --- \n" if Rails.env.production?
  end

  def self.info(log)
    puts "#{Time.now} --- INFO: #{log} --- \n".colorize(:green)
    Rails.logger.info "\n --- INFO: #{log} --- \n" if Rails.env.production?
  end

  def self.alert(log)
    puts "#{Time.now} --- ALERTA: #{log} --- \n".colorize(:yellow)
    Rails.logger.warn "\n --- ALERTA: #{log} --- \n" if Rails.env.production?
  end
end
