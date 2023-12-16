import { Controller } from "@hotwired/stimulus"

let client = null
let client_id = document.getElementById('propeties').dataset.client_id
let objCliente = {}
let ArrayChannels = []
let ArrayDevices = []
let ArraySubscribles = []
let ArrayConfigsChannels = []
let ArrayAtivo = []

export default class extends Controller {

  connect() {
    console.log('Buscando dados do cliente..')
    this.others('objCliente', client_id)
  }

  dadosGrafico(id_channel, value){
    // dataGraph.forEach((ch, i)=>{
    //     if(ch.id == id_channel){
    //         valueGraph[i] = parseFloat(value)
    //     }
    // }) 
  }

  connect_mqtt() {
    let that = this; // Armazena uma referência ao controlador
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
          if (i.tipo === 'value') { that.dadosGrafico(i.id, message.toString()); document.getElementById(`${i.id}`).innerHTML = message.toString() }
          // if (i.tipo === 'info') { document.getElementById(`${i.id}`).innerHTML = message.toString() }
          // if (i.tipo === 'button') { alteraStateRele(topic, i.label, i.id, message.toString()) }
          // if (i.tipo === 'slide') { alteraStateSlide(topic, i.label, i.id, message.toString()) }
          // if (i.tipo === 'led') { alterarLed(`${i.id}`, message.toString()) }
          if (i.tipo === 'terminal_view') { that.TerminalView(message.toString(), `${i.id}`) }
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

  others(param1 = null, param2 = null) {
    const dados = { param1, param2 }
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    fetch('/others', { method: 'POST', headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': csrfToken }, body: JSON.stringify(dados) })
    .then(response => response.json())
    .then(dt => {
        if (dt.error == false && param1 == 'objCliente') {
          objCliente = dt.data.client
          ArrayChannels = dt.data.channels
          ArrayDevices = dt.data.devices
          this.connect_mqtt()
        }else if(dt.error == false && param1 == 'clear_log'){
          $.notify("Log limpo com sucesso!", "success")
        }

        if (dt.error == true) { $.notify(dt.message, "error") }
    })
    .catch(error => console.error('Erro ao fazer fetch:', error))
  }

  TerminalView(message, id) {
    let textarea = document.getElementById(id)
    textarea.value += message
    textarea.value += '\n'
    textarea.focus()
    textarea.setSelectionRange(textarea.value.length, textarea.value.length)
  }

  terminalClear(event) {
    let button = event.target;
    let id = button.getAttribute("data-terminal-id");
    document.getElementById(id).value = ""
    this.others('clear_log', id)
  }

  comandoGenerico(event) {
    let button = event.target;
    let path = button.getAttribute("data-path");
    let device = button.getAttribute("data-device-id");
    let command = button.getAttribute("data-type");

    ArrayAtivo.map((a) => {
      if (a.device === device) {
        if (a.online === 'sim') { // Só vai enviar caso a placa esteja OnLine
          client.publish(path, command)
        } else {
          $.notify(`${a.nome} OffLine`, "error")
        }
      }
    })
  }

}


