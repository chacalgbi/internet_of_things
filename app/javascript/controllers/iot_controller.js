import { Controller } from "@hotwired/stimulus"

window.client = null
window.client_id = document.getElementById('propeties') ? document.getElementById('propeties').dataset.client_id : null;
window.objCliente = {}
window.ArrayChannels = []
window.ArrayDevices = []
window.ArraySubscribles = []
window.ArrayAtivo = []
window.ArrayStateRele = []
window.ArrayStateSlide = []
window.ArrayEnter = []

export default class extends Controller {

  connect() {
    if (client_id) {
      console.log('Buscando dados do cliente..')
      this.others('objCliente', client_id)
    }
  }

  dados_grafico(id_channel, value){
    // dataGraph.forEach((ch, i)=>{
    //     if(ch.id == id_channel){
    //         valueGraph[i] = parseFloat(value)
    //     }
    // }) 
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

  restart_device(path, device) {
    ArrayAtivo.map((a) => {
      if (a.device === device) {
        if (a.online === 'sim') {
          //console.log(idInput, topic)
          client.publish(path, 'reiniciar')
        } else {
          $.notify(`${a.nome} OffLine`, "error")
        }
      }
    })
  }

  confirm_restart(event) {
    const element = event.target
    const path = element.getAttribute("data-path")
    const device = element.getAttribute("data-device")
    const title = element.getAttribute("data-title")
    const text = element.getAttribute("data-text")
    const icon = element.getAttribute("data-icon")
    const function_yes = () => { this.restart_device(path, device) }
    const function_no =  () => { this.msg_with_time('center', 'info', 'Cancelado!', false, 1000) }

    this.msg_confirm(title, text, icon, function_yes, function_no)
  }

  sms_test(event) {
    const element = event.target
    const path = element.getAttribute("data-path")
    const device = element.getAttribute("data-device")
    const id = element.getAttribute("data-id")

    ArrayAtivo.map((a) => {
      if (a.device === device) {
        if (a.online === 'sim') {
          const cel = document.getElementById(id).value

          if (cel.length < 11) {
            $.notify(`Inserir um número de celular válido e salvar!`, "error")
          } else {
            client.publish(path, `smsT:${cel}`)
            $.notify(`Enviando SMS para: ${cel}. Aguarde...`, "info")
          }
        } else {
          $.notify(`${a.nome} OffLine`, "error")
        }
      }
    })
  }

  preferences(event) {
    const element = event.target
    const path = element.getAttribute("data-path")
    const device = element.getAttribute("data-device")
    const id = element.getAttribute("data-id")

    ArrayAtivo.map((a) => {
      if (a.device === device) {
        if (a.online === 'sim') {
          const x = document.getElementById(id)
          let payload = ''
          let name = id.split('_')
          //console.log(`ID: ${id} - Type: ${x.type}`)

          if (x.type === 'text' || x.type === 'email' || x.type === 'number' || x.type === 'select-one') {
            if (name[0] === 'whatsapp') { // Formata se for celular para só enviar números
              payload = x.value.replace(/\D+/g, "")
            } else {
              payload = x.value
            }
          } else if (x.type === 'checkbox') {
            x.checked ? payload = 'sim' : payload = 'nao'
          }
          client.publish(path, `pref:${name[0]}:${payload}`)

        } else {
          $.notify(`${a.nome} OffLine`, "error")
        }
      }
    })
  }

  recuperar_preferencias(payload, device_id) {
    // Exemplo payload: email:teste@teste.com,whatsapp:77988188514,telegram:54544441215215,emailEnable:sim,telegramEnable:nao,dc2Max:12.7

    const arrayPayload = payload.split(',') // separa cada item do array

    if (arrayPayload[0] === 'info' || arrayPayload[0] === 'error' || arrayPayload[0] === 'success') { // Se tiver Salvo na 1° posição, indica que salvou um item. E deve mostrar a resposta para o cliente
      $.notify(arrayPayload[1], arrayPayload[0])
    }else if (arrayPayload[0] === 'btndc'){
      // Abre modal para calibrar tensão do Mini monitor
      document.getElementById(arrayPayload[1]).click()
    } else {
      arrayPayload.forEach(function (v) { // Senão, é um array com tudo para preencher todos os campos

        // Se na string tiver as palavras abaixo, trata de uma maneira diferente devido aos ":" Ex: rele2Liga:15:00
        if (v.match(/rele1Liga/) || v.match(/rele2Liga/) || v.match(/rele1Desl/) || v.match(/rele2Desl/)) {
          const array_timers = v.split(':')
          document.getElementById(`${array_timers[0]}_${device_id}`).value = `${array_timers[1]}:${array_timers[2]}`
        } else if (v.match(/rele1cmd/) || v.match(/rele2cmd/)) { // Uma String diferenciada com os valores dos campos de Acionar relé por evento
          let arr1 = v.split(':')
          let arr2 = arr1[1].split(' ')
          document.getElementById(`${arr1[0]}1_${device_id}`).value = `${arr2[0]}`
          document.getElementById(`${arr1[0]}2_${device_id}`).value = `${arr2[1]}`
          document.getElementById(`${arr1[0]}3_${device_id}`).value = `${arr2[2]}`
          document.getElementById(`${arr1[0]}4_${device_id}`).value = `${arr2[3]}`
          document.getElementById(`${arr1[0]}5_${device_id}`).value = `${arr2[4]}`
        } else {
          const campoEvalor = v.split(':') // Separa o ID do campo com o valor do mesmo => email:teste@teste.com
          const id = `${campoEvalor[0]}_${device_id}` // cria o id dinamicamente, EX: email_1

          if (campoEvalor[1] === 'sim' || campoEvalor[1] === 'nao') { //Se for um checkbox
            campoEvalor[1] === 'sim' ? document.getElementById(id).checked = true : document.getElementById(id).checked = false
          } else { // Campos em geral com values
            document.getElementById(id).value = campoEvalor[1]
          }
        }
      })
    }

  }

  get_values_configs(event) {
    const element = event.target
    const path = element.getAttribute("data-path")
    const device = element.getAttribute("data-device")

    ArrayAtivo.map((a) => {
      if (a.device === device) {
        if (a.online === 'sim') {
          client.publish(path, 'tudo')
        } else {
          $.notify(`${a.nome} OffLine`, "error")
        }
      }
    })
  }

  notice_dashboard_open() {
    const btnInitialize = document.getElementById('btn_initialize')
    btnInitialize && btnInitialize.click()
  }

  press_enter_terminal(){
    ArrayEnter.map((item, index, array) => {
      const a = item.split('_')
      window['press' + index] = document.getElementById(a[0]).addEventListener("keypress", function (event) {
        if (event.key === "Enter") {
          event.preventDefault()
          document.getElementById(a[1]).click()
        }
      })
    })
  }

  connect_mqtt() {
    let that = this; // Armazena uma referência ao controlador
    let arrayMqtt = objCliente.address_mqtt.split(":")
    const socket_host_prefix = window.location.protocol === 'https:' ? 'wss://' : 'ws://'
    const port = window.location.protocol === 'https:' ? 8883 : 8881

    const options = {
      port: port,
      clientId: `${objCliente.name}_${Math.floor(Math.random() * 900) + 100}`,
      username: arrayMqtt[0],
      password: arrayMqtt[1],
      clean: true,
      useSSL: false,
    }

    ArrayChannels.map((i) => {
      if(i.tipo == 'ativo'){
        let device = ArrayDevices.find((device)=>{ if (device.id == i.device_id) { return device } })
        ArrayAtivo.push({ canal: i.id, device: `acti${i.device_id}`, func: null, online: 'nao', nome: device.description })
      }

      if(i.tipo == 'button'){
        ArrayStateRele.push({ path: i.path, estado: i.previous_state })
      }

      if(i.tipo == 'slide'){
        ArrayStateSlide.push({ path: i.path, estado: i.previous_state })
      }

      if(i.tipo == 'terminal_insert'){
        ArrayEnter.push(`input${i.id}_inputButton${i.id}`)
      }

      if (i.category === 'subscrible') {
        ArraySubscribles.push(i.path)
      } else if (i.category === 'publish') {
        if (i.tipo === 'button' || i.tipo === 'slide') {
          ArraySubscribles.push(i.path)
        }
      }

    })

    client = mqtt.connect(`${socket_host_prefix}${arrayMqtt[2]}`, options)

    client.on('connect', function () {
      $.notify('Broker Conectado!', "success")
      client.subscribe(ArraySubscribles)
      // Avisa a placa  5 segundos depois do completo carregamento, que a página foi aberta.
      setTimeout(() => { that.notice_dashboard_open() }, 5000)
      //Seta os campos de input do terminal para aceitarem enter criando variaveis dinamicamente
      setTimeout(() => { that.press_enter_terminal() }, 1000)

      // Mantem o cliente atual conectado, enviando um publish a cada 5 segundos
      setInterval(() => { client.publish('/monitoramento/ativo', '1') }, 5000)
    })

    client.on('message', function (topic, message) {
      //console.log(topic + ': ' + message.toString());
      ArrayChannels.map((i) => {
        if (topic === i.path) {
          if (i.tipo === 'value')  { that.dados_grafico(i.id, message.toString()); document.getElementById(`${i.id}`).innerHTML = message.toString() }
          if (i.tipo === 'info')   { document.getElementById(`${i.id}`).innerHTML = message.toString() }
          if (i.tipo === 'button') { that.change_state_rele(topic, i.label, i.id, message.toString()) }
          if (i.tipo === 'slide')  { that.change_state_slide(topic, i.label, i.id, message.toString()) }
          if (i.tipo === 'led')    { that.change_led(`${i.id}`, message.toString()) }
          if (i.tipo === 'terminal_view') { that.terminal_view(message.toString(), `${i.id}`) }
          if (i.tipo === 'prefes_view') { that.recuperar_preferencias(message.toString(), `${i.device_id}`) }

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

  update_previous_state(id_channel, previous_state) {
    this.others('rele', { id_channel: id_channel, previous_state: previous_state })
  }

  change_state_rele(topic, label, id, message) {
    // Se algum outro cliente publicar no tópico do relé, 
    // aqui atualiza o status do botão e de seu array de controle de estado
    let newArray = ArrayStateRele.map((s) => {
      if (s.path === topic) {
        //console.log(s)
        if (message === '0') {
          document.getElementById(id).textContent = 'Ligar ' + label
          s.estado = '0'
        } else {
          document.getElementById(id).textContent = 'Desl ' + label
          s.estado = '1'
        }
        return s
      } else {
        return s
      }
    })
    ArrayStateRele = newArray
  }

  change_state_slide(topic, label, id, message) {
    let newArray = ArrayStateSlide.map((s) => {
      if (s.path === topic) {
        document.getElementById(`slideValue${id}`).innerHTML = message
        document.getElementById(`${id}`).value = message
        s.estado = message
        return s
      } else {
        return s
      }
    })
    ArrayStateSlide = newArray
  }

  rele(event) {
    const e = event.target
    const path = e.getAttribute("data-path")
    const label = e.getAttribute("data-label")
    const id = e.getAttribute("data-id")
    const array_info = e.getAttribute("data-array_info")
    const device = e.getAttribute("data-device")
    const color = e.getAttribute("data-color")

    ArrayAtivo.map((a) => {
        if (a.device === device) {
            if (a.online === 'sim') { // Só vai enviar caso a placa esteja OnLine
                if (array_info === 'switch') {
                    let newArray = ArrayStateRele.map((s) => {
                        if (s.path === path) {
                            if (s.estado === '0') {
                                document.getElementById(id).setAttribute("class", `btn btn-${color}`)
                                document.getElementById(id).textContent = 'Ligar ' + label
                                $.notify(`${label} Ligado(a)`, "success")
                                client.publish(path, '1')
                                this.update_previous_state(id, '1')
                                s.estado = '1'
                                return s
                            } else {
                                document.getElementById(id).setAttribute("class", `btn btn-outline-${color}`)
                                document.getElementById(id).textContent = 'Desl ' + label
                                $.notify(`${label} Desligado(a)`, "info")
                                client.publish(path, '0')
                                this.update_previous_state(id, '0')
                                s.estado = '0'
                                return s
                            }
                        } else {
                            return s
                        }
                    })
                    ArrayStateRele = newArray
                } else { // Caso o botão seja apenas um pulso, como o portão
                    client.publish(path, '1')
                    $.notify(`${label} Acionado`, "success")
                }
            } else {
                $.notify(`${a.nome} OffLine`, "error")
            }
        }
    })
  }

  slide(event) {
    const e = event.target
    const spanValue = e.getAttribute("data-span-value")
    const path = e.getAttribute("data-path")
    const id = e.getAttribute("data-id")
    const device = e.getAttribute("data-device")
    const value = document.getElementById(id).value

    ArrayAtivo.map((a) => {
      if (a.device === device) {
        if (a.online === 'sim') {
          client.publish(path, value.toString())
          this.update_previous_state(id, value.toString())
        } else {
          $.notify(`${a.nome} OffLine`, "error")
        }
      }
    })
  }

  change_led(id, message) {
    let classAtual = ''
    let name = ''
    const newLabel = document.getElementById(id).innerText.split(' - ')
    const oldArrayInfo = document.getElementById(id)
    const newArrayInfo = oldArrayInfo.getAttribute('name')
    const info = newArrayInfo.split('-')


    if (message === '0') {
        classAtual = 'danger'
        name = `${newLabel[0]} - ${info[0]}` // Ex: Sala - Aberta
    } else {
        classAtual = 'success'
        name = `${newLabel[0]} - ${info[1]}` // Ex: Sala - Fechada
    }

    document.getElementById(id).className = `badge rounded-pill bg-${classAtual}`;
    document.getElementById(id).innerText = name

    //update_previous_state(id, message)
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
      }else if (dt.error == false && param1 == 'change_name_device') {
        document.getElementById(`nomeDevice${dt.data.id}`).innerHTML = dt.data.description
        document.getElementById(`btn_set_new_name_${dt.data.id}`).setAttribute('data-description', dt.data.description)
        $.notify(dt.message, "success")
      }else if (dt.error == false && param1 == 'rele') {

      }else{
        $.notify(dt.message, "success")
      }

      if (dt.error == true) {
        console.log(dt)
        $.notify(dt.message, "error")
      }
    })
    .catch(error => console.error('Erro ao fazer fetch:', error))
  }

  terminal_view(message, id) {
    let textarea = document.getElementById(id)
    textarea.value += '\n'
    textarea.value += message
  }

  terminal_clear(event) {
    let button = event.target;
    let id = button.getAttribute("data-terminal-id");
    document.getElementById(id).value = ""
    this.others('clear_log', id)
  }

  terminal_send(event) {
    const element = event.target
    const idInput = element.getAttribute("data-input")
    const topic = element.getAttribute("data-path")
    const device = element.getAttribute("data-device")
    const logId = element.getAttribute("data-log")

    ArrayAtivo.map((a) => {
        if (a.device === device) {
            if (a.online === 'sim') {
                //console.log(idInput, topic)
                let cmd = document.getElementById(idInput).value.toLowerCase()
                client.publish(topic, cmd);
                document.getElementById(idInput).value = ""
                document.getElementById(idInput).focus()

                //Inserir os comandos enviados num log
                const node = document.createElement("li")
                node.appendChild(document.createTextNode(cmd))
                //document.getElementById(logId).appendChild(node)
                const list = document.getElementById(logId)
                list.insertBefore(node, list.children[0])

            } else {
                $.notify(`${a.nome} OffLine`, "error")
            }
        }
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

  set_modal_name(event) {
    let button = event.target;
    let description = button.getAttribute("data-description");
    let id = button.getAttribute("data-id");

    document.getElementById('novoNomeDevice').value = description
    document.getElementById('idDeviceModal').innerHTML = id
  }

  set_name_api() {
    const name = document.getElementById('novoNomeDevice').value
    const id = document.getElementById('idDeviceModal').innerHTML

    if (name.length < 4) {
        $.notify("Novo nome muito curto! Digite um nome com pelo menos 5 letras.", "error")
    } else if (id === "") {
        $.notify("Erro, id do device não encontrado!", "error")
    } else {
      this.others('change_name_device', { id: id, description: name })
    }
  }

  calibrate_voltage(){
    const tensao = document.getElementById('new_voltage').value
    const topico = document.getElementById('topic_calibrate').innerHTML
    const newTopico = topico.replace("info", "terminal_IN")

    if(tensao == ''){
        $.notify(`Informe a tensão da bateria!`, "error")
    }else{
        client.publish(newTopico, 'calibrar:'+tensao)
    }
  }

}