// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// for Bootstrap
import "popper"
import "bootstrap"
import jquery from "jquery"

window.$ = jquery
