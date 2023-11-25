# frozen_string_literal: true

class Log
  def self.error(log)
    puts " --- ERROR: #{log} --- \n".colorize(:red)
  end

  def self.info(log)
    puts " --- INFO: #{log} --- \n".colorize(:green)
  end

  def self.alert(log)
    puts " --- ALERTA: #{log} --- \n".colorize(:yellow)
  end
end
