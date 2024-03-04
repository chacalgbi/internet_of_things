# frozen_string_literal: true

class Notify
  def self.notification_log(identity = nil, channel = nil, recipient = nil, message = nil, result = nil) # rubocop:disable Metrics/ParameterLists
    Notification.create!(
      identity: identity || '',
      channel: channel || '',
      recipient: recipient || '',
      message: message || '',
      result: result || ''
    )
  end
end
