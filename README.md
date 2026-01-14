# DESCRIÇÃO
Depois de alguns anos utilizando softwares de terceiros para gerenciar minhas automações IOT (Internet of Things), resolvi criar o sistema completo para gerenciar meus dispositivos. Ele abrange desde o cadastro de dispositivos, até a criação de automações, com a possibilidade de criar automações complexas, com múltiplos dispositivos para cada cliente. Este software escrito em Ruby on Rails e se comunica com os dispositivos IOT via requisiçõe HTTP e MQTT.

# Versões utilizadas
- Ruby 3.2.2
- Rails 7.1.2

# Como rodar em desenvolvimento

Este projeto usa `cssbundling-rails` (Bootstrap via Sass). Se o arquivo compilado `app/assets/builds/application.css` não existir, o Rails vai levantar erro ao renderizar as páginas.

## Setup

```bash
bundle install
yarn install
```

## Rodando

Opção recomendada (sobe Rails + watch do CSS):

```bash
bin/dev
```

Ou, se preferir rodar só o Rails:

```bash
yarn build:css
bin/rails server
```