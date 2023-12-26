module IotHelper
  def object_of_channels(channels)
    count = 0
    types = {}
    channels.each do |channel|
      if channel.tipo == 'led'
        count += 1
        types["#{channel.tipo}#{count}"] = channel
      else
        types[channel.tipo] = channel
      end
    end
    types
  end

  def led_atrributes(led)
    array_info = led.array_info.split('-')
    last_label = led.previous_state == '0' ? array_info[0] : array_info[1]
    actual_class = led.previous_state == '0' ? 'danger' : 'success'

    [array_info, last_label, actual_class]
  end

  def button_atrributes(btn)
    last_value = btn.previous_state
    last_label = btn.previous_state == '0' ? 'Ligar ' : 'Desli '
    last_class = btn.previous_state == '0' ? 'outline-' : ''

    [last_value, last_label, last_class]
  end

  def find_channel_for_type(channels, type)
    channels.find { |channel| channel.tipo == type }
  end
end
