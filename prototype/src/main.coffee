require
paths:
    jquery:'Libs/jquery/jquery-1.8.0.min'

shim:
    'underscore':
        exports : '_'

require ["src/app"], (App)->
  app = new App()