// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "./iots"
import "./terminal"
import * as bootstrap from "bootstrap"
import Rails from "@rails/ujs"
Rails.start()