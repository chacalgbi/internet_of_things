window.client = null
window.client_id = document.getElementById('propeties').dataset.client_id
window.objCliente = {}
window.ArrayChannels = []
window.ArrayDevices = []
window.ArraySubscribles = []
window.ArrayConfigsChannels = []
window.ArrayAtivo = []

window.others = function(param1 = null, param2 = null) {
  const dados = { param1, param2 }
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content

  fetch('/others', { method: 'POST', headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': csrfToken }, body: JSON.stringify(dados) })
  .then(response => response.json())
  .then(dt => {
      if (dt.error == false && param1 == 'objCliente') {
        objCliente = dt.data.client
        ArrayChannels = dt.data.channels
        ArrayDevices = dt.data.devices

        ConectaMqtt()
      }
  })
  .catch(error => console.error('Erro ao fazer fetch:', error))
}

window.comando_generico = function(path, device, command) {
  console.log(path, device, command)
}

window.ConectaMqtt = function() {
  let arrayMqtt = objCliente.address_mqtt.split(":")

  const options = {
    port: 8883,
    clientId: objCliente.name,
    username: arrayMqtt[0],
    password: arrayMqtt[1],
    clean: true,
  }

  
  ArrayDevices.map((item, index, array) => {
    ArrayChannels.map((i) => {
      if(i.tipo == 'ativo'){
        ArrayAtivo.push({ canal: i.id, device: `acti${item.id}`, func: null, online: 'nao', nome: item.description })
      }
    })
  })
  
  ArrayChannels.map((i) => {
    if (i.category === 'subscrible') {
      ArraySubscribles.push(i.path)
    } else if (i.category === 'publish') {
      if (i.type === 'button' || i.type === 'slide') {
        ArraySubscribles.push(i.path)
      }
    }
  })

    client = mqtt.connect(`ws://${arrayMqtt[2]}`, options)

    client.on('connect', function () {
      console.log('Broker Conectado!')
      client.subscribe(ArraySubscribles)
  })

  client.on('message', function (topic, message) {
    //console.log(topic + ': ' + message.toString());
    ArrayChannels.map((i) => {
      if (topic === i.path) {
        // if (i.tipo === 'value') { dadosGrafico(i.id, message.toString()); document.getElementById(`${i.id}`).innerHTML = message.toString() }
        // if (i.tipo === 'info') { document.getElementById(`${i.id}`).innerHTML = message.toString() }
        // if (i.tipo === 'button') { alteraStateRele(topic, i.label, i.id, message.toString()) }
        // if (i.tipo === 'slide') { alteraStateSlide(topic, i.label, i.id, message.toString()) }
        // if (i.tipo === 'led') { alterarLed(`${i.id}`, message.toString()) }
        // if (i.tipo === 'terminal_view') { TerminalView(message.toString(), `${i.id}`) }
        // if (i.tipo === 'prefes_view') { recuperarPreferencias(message.toString(), `${i.device_id}`) }


        // Led indicador de conexão com a placa (Lógica um pouco complexa)
        if (i.tipo === 'ativo') {
          //console.log('ativo', i)
            ArrayAtivo.map((a) => {
                if (a.canal === i.id) {

                  if (message.toString() === '1') {
                    a.online = 'sim'
                    document.getElementById(`${a.device}`).innerHTML = 'Online'
                    document.getElementById(`${a.device}`).style.backgroundColor = '#00FF7F'
                    clearTimeout(a.func)
                  } else {
                    a.online = 'sim'
                    document.getElementById(`${a.device}`).innerHTML = 'Online'
                    document.getElementById(`${a.device}`).style.backgroundColor = '#D3D3D3'
                    clearTimeout(a.func)
                  }

                  // Após mudar a cor, seta de novo o TimeOut, caso a placa fique Offline, essa função dentro vai executar
                  a.func = setTimeout(() => {
                    a.online = 'nao'
                    document.getElementById(`${a.device}`).innerHTML = 'Offline'
                    document.getElementById(`${a.device}`).style.backgroundColor = '#FA8072'
                    //console.log("Device OffLine")
                  }, 10000)

                }
            })
        }
      }
    })
})

}

document.addEventListener('DOMContentLoaded', (event) => {
  others('objCliente', client_id)
})