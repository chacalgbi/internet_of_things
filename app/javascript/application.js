// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "./jquery"
import "./notify"
import "./sweetalert2"
import * as bootstrap from "bootstrap"
import Rails from "@rails/ujs"
Rails.start()