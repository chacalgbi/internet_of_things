# frozen_string_literal: true

ActiveAdmin.register Client do
  permit_params :name, :email, :cel, :address_mqtt, :obs

  batch_action :Importar_Clientes_do_Sistema_antigo, form: { array_clients: :text } do |_ids, inputs|
    array_clients = inputs['array_clients']
    data = JSON.parse(array_clients)
    alert = "#{data.count} Clientes: "

    begin
      Client.transaction do
        data.each do |client_data|
          alert += "#{client_data['name']}, "
          Client.create!(client_data)
        end
        alert += 'criados com sucesso.'
      end
    rescue StandardError => e
      alert = "Rollback realizado devido ao erro: #{e.class} | #{e.message}"
    end

    redirect_to collection_path, alert:
  end
end
