// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require popper
//= require bootstrap

require('packs/answers')
require('packs/questions')
require('packs/gist_loader')
require('packs/comments')

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "@oddcamp/cocoon-vanilla-js"
import 'jquery'
import consumer from "../channels/consumer";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

export const cable = cable || consumer