(function() {
  define('src/app', ['src/client'], function(client) {
    var App;
    App = (function() {
      function App() {}

      return App;

    })();
    return App;
  });

}).call(this);

(function() {
  define('src/client', [], function() {
    var Client;
    Client = (function() {
      function Client() {}

      return Client;

    })();
    return Client;
  });

}).call(this);

(function() {
  var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define('src/datastoreInMemory', [], function() {
    var inMemoryDatastore;
    inMemoryDatastore = (function() {
      inMemoryDatastore.prototype.datastore = [];

      inMemoryDatastore.prototype.schema = {};

      function inMemoryDatastore(opts) {
        if (opts) {
          this.init(opts);
        }
      }

      inMemoryDatastore.prototype.init = function(opts) {
        var i, len, name, ref, results, table, tables;
        this.datastore = [];
        this.schema = [];
        ref = opts['tables'];
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          tables = ref[i];
          results.push((function() {
            var results1;
            results1 = [];
            for (name in tables) {
              table = tables[name];
              this.schema[name] = table;
              results1.push(this.datastore[name] = []);
            }
            return results1;
          }).call(this));
        }
        return results;
      };

      inMemoryDatastore.prototype.insert = function(data) {
        var _tblname, _tblrows, i, key, len, newrow, ref, results, row, val;
        _tblname = data['table'];
        _tblrows = data['data'];
        results = [];
        for (i = 0, len = _tblrows.length; i < len; i++) {
          row = _tblrows[i];
          newrow = [];
          ref = row[0];
          for (key in ref) {
            val = ref[key];
            if (indexOf.call(this.schema[_tblname], key) < 0) {
              throw new Error(key + " is not defined in schema");
            } else {
              newrow[key] = val;
            }
          }
          newrow['pk'] = this.datastore[_tblname].length;
          results.push(this.datastore[_tblname].push(newrow));
        }
        return results;
      };

      inMemoryDatastore.prototype.get = function(data) {
        var _match, _query, _tblname, index, key, result, val;
        _tblname = data['table'];
        _query = data['query'];
        result = [];
        for (key in _query) {
          val = _query[key];
          for (index in this.datastore[_tblname]) {
            _match = this.datastore[_tblname][index][key].toString().match(val);
            if (_match && _match[0] === this.datastore[_tblname][index][key].toString()) {
              result.push(this.datastore[_tblname][index]);
            }
          }
        }
        return result;
      };

      return inMemoryDatastore;

    })();
    return inMemoryDatastore;
  });

}).call(this);

(function() {
  require;
  ({
    paths: {
      jquery: 'Libs/jquery/jquery-1.8.0.min'
    },
    shim: {
      'jquery': {
        exports: '$'
      }
    }
  });

  require(["src/app"], function(App) {
    var app;
    return app = new App();
  });

}).call(this);

(function() {
  define('src/server', [], function() {
    var Server;
    Server = (function() {
      function Server() {}

      return Server;

    })();
    return Server;
  });

}).call(this);
