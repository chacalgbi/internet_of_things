# frozen_string_literal: true

class MonitoringController < AdminController
  def index
    @client = Client.find_by(email: current_user.email)
    @channels = Channel.joins('INNER JOIN clients ON channels.client_id = clients.id INNER JOIN devices ON channels.device_id = devices.id')
                       .where(tipo: 'ativo')
                       .select('channels.*, clients.name as client_name, devices.description as device_description',
                               '( SELECT obs
                                  FROM channels AS c2
                                  WHERE c2.tipo = "terminal_view"
                                  AND c2.client_id = channels.client_id
                                  AND c2.device_id = channels.device_id) as terminal_view_obs')
  end
end
