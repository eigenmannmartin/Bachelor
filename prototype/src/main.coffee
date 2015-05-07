###

TODO:
API-Design dependend on Domain

###

require
paths:
    jquery:'bower_components/jquery/dist/jquery'

shim:
    'jquery':
        exports : '$'

require ["app"], (App)->
  window.app = new App