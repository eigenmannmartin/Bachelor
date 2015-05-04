require
paths:
    jquery:'Libs/jquery/jquery-1.8.0.min'

shim:
    'jquery':
        exports : '$'

require ["src/app"], (App)->
  app = new App()