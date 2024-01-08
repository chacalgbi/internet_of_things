import { Controller } from "@hotwired/stimulus"

window.client_mqtt = document.getElementById('propeties') ? document.getElementById('propeties').dataset.client_id : null;
window.ArraySubscribles = []
window.ArrayMonitoramento = []

export default class extends Controller {

  connect() {
    this.connect_mqtt()
  }

  loading(small, position, confirm, timer, icon, text) {
    // EXEMPLO: loading(true, 'center', false, 2000, 'info', 'Aguarde carregar...');

    //warning, error, success, info, question
    //'top', 'top-start', 'top-end', 'center', 'center-start', 'center-end', 'bottom', 'bottom-start', 'bottom-end'.
    Swal.fire({
      toast: small,
      position: position,
      showConfirmButton: confirm,
      timer: timer,
      timerProgressBar: true,
      icon: icon,
      title: text
    })
  }

  msg_with_time(position, icon, title, button, timer) {
    // EXEMPLO: msgWithTime('center', 'success', 'Apagado!', true, 1000);
    //warning, error, success, info, question
    //'top', 'top-start', 'top-end', 'center', 'center-start', 'center-end', 'bottom', 'bottom-start', 'bottom-end'.
    Swal.fire({
      position: position,
      icon: icon,
      title: title,
      showConfirmButton: button,
      timer: timer
    });
  }

  msg_confirm(title, text, icon, function_yes, function_no) {
    Swal.fire({
      title: title,
      text: text,
      icon: icon,
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Sim, Desejo!',
      cancelButtonText: 'Cancelar'
    })
    .then((result) => {
      if (result.isConfirmed) {
        function_yes();
      } else {
        function_no();
      }
    })
  }

  restart_device(path) {
    client.publish(path, 'reiniciar')
  }

  enviar_update(path){
    client.publish(path, "atualizar")
  }

  atualizar_em_massa_mini_v1(){
    // Este comando abaixo irá atualizar todos os MINI Monitoramentos com a versão V1
    // Em todos os dispositivos deverá está subscrito nesse tópico
    // E para atualizar, deverá existir o arquivo bin no endereço: thomelucas.com.br/img/atualizar_em_massa_mini_v1.bin
    client.publish('/monitoramento/atualizar_em_massa_mini_v1','atualizar_em_massa_mini_v1')
    $.notify('Comando de atualizar em massa a Versão MINI 1 enviado! Aguarde o processo...', "info")
  }

  confirm_restart(event) {
    const element = event.target
    const path = element.getAttribute("data-path")
    const title = element.getAttribute("data-title")
    const text = element.getAttribute("data-text")
    const icon = element.getAttribute("data-icon")
    const function_yes = () => { this.restart_device(path) }
    const function_no =  () => { this.msg_with_time('center', 'info', 'Cancelado!', false, 1000) }

    this.msg_confirm(title, text, icon, function_yes, function_no)
  }

  confirm_update(event) {
    const element = event.target
    const path = element.getAttribute("data-path")
    const title = element.getAttribute("data-title")
    const text = element.getAttribute("data-text")
    const icon = element.getAttribute("data-icon")
    const function_yes = () => { this.enviar_update(path) }
    const function_no =  () => { this.msg_with_time('center', 'info', 'Cancelado!', false, 1000) }

    this.msg_confirm(title, text, icon, function_yes, function_no)
  }

  confirm_update_massa_mini_v1(event) {
    const element = event.target
    const title = element.getAttribute("data-title")
    const text = element.getAttribute("data-text")
    const icon = element.getAttribute("data-icon")
    const function_yes = () => { this.atualizar_em_massa_mini_v1() }
    const function_no =  () => { this.msg_with_time('center', 'info', 'Cancelado!', false, 1000) }

    this.msg_confirm(title, text, icon, function_yes, function_no)
  }

  connect_mqtt() {
    let arrayMqtt = client_mqtt.split(":")
    const socket_host_prefix = window.location.protocol === 'https:' ? 'wss://' : 'ws://'
    const port = window.location.protocol === 'https:' ? 8883 : 8881

    const options = {
      port: port,
      clientId: `monitoring_${Math.floor(Math.random() * 900) + 100}`,
      username: arrayMqtt[0],
      password: arrayMqtt[1],
      clean: true,
      useSSL: false,
    }

    channels.map((i) => {
      let obj = {
        id: i.id,
        cliente: i.client_name,
        device: i.device_description,
        ativo: `monitAtivo${i.id}`,
        info: `monitInfo${i.id}`,
        update: i.path.replace("ativo", "update"),
        reiniciar: i.path.replace("ativo", "reiniciar"),
        pathAtivo: i.path,
        pathInfo: i.path.replace("ativo", "info"),
        func: null,
        obs: i.terminal_view_obs
      }

      ArrayMonitoramento.push(obj)
      ArraySubscribles.push(i.path)
      ArraySubscribles.push(obj.pathInfo)
    })

    client = mqtt.connect(`${socket_host_prefix}${arrayMqtt[2]}`, options)

    client.on('connect', function () {
      console.log('Broker Conectado!')
      client.subscribe(ArraySubscribles)
    })

    client.on('message', function (topic, message) {
      ArrayMonitoramento.map((i) => {
        if (topic === i.pathAtivo) {
          if (message.toString() === '1') {
            document.getElementById(`monitAtivo${i.id}`).innerHTML = 'Online'
            document.getElementById(`monitAtivo${i.id}`).style.backgroundColor = '#00FFAF'
            clearTimeout(i.func)
          } else {
            document.getElementById(`monitAtivo${i.id}`).innerHTML = 'Online'
            document.getElementById(`monitAtivo${i.id}`).style.backgroundColor = '#00FF40'
            clearTimeout(i.func)
          }

          // Após mudar a cor, seta de novo o TimeOut, caso a placa fique Offline, essa função dentro vai executar
          i.func = setTimeout(() => {
            document.getElementById(`monitAtivo${i.id}`).innerHTML = 'Offline'
            document.getElementById(`monitAtivo${i.id}`).style.backgroundColor = '#FA8072'
            document.getElementById(`monitInfo${i.id}`).innerHTML = '<p style="color:blue;font-size:12px"></p>'
          }, 20000)
        }else if (topic === i.pathInfo) {
          document.getElementById(`monitInfo${i.id}`).innerHTML = `<p style="color:blue;font-size:12px">${message.toString()}</p>`
        }
      })
    })
  }

  generic_comand(event) {
    let button = event.target;
    let path = button.getAttribute("data-path");
    let device = button.getAttribute("data-device-id");
    let command = button.getAttribute("data-type");

    ArrayAtivo.map((a) => {
      if (a.device === device) {
        if (a.online === 'sim') {
          client.publish(path, command)
        } else {
          $.notify(`${a.nome} OffLine`, "error")
        }
      }
    })
  }

}