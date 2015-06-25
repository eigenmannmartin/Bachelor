(function() {
  define(['flux'], function(flux) {
    var Logic;
    Logic = (function() {
      Logic.prototype.sync = {
        Function_init: function(Logic, args) {
          var contact, contacts, model, _i, _len, _results;
          Logic._DB_clear("Contact");
          contacts = [
            {
              "first_name": "Riley",
              "last_name": "Burt",
              "middle_name": "J.",
              "street": "Ap #478-849 Accumsan St.",
              "country": "Bouvet Island",
              "city": "Badajoz",
              "state": "Extremadura",
              "email": "nibh@vitaealiquetnec.edu",
              "phone": "(033220) 937671"
            }, {
              "first_name": "Tanya",
              "last_name": "Reynolds",
              "middle_name": "N.",
              "street": "536-3821 Erat Street",
              "country": "Togo",
              "city": "New Haven",
              "state": "Connecticut",
              "email": "tempus.risus@telluseuaugue.co.uk",
              "phone": "(03805) 9925691"
            }, {
              "first_name": "Sylvester",
              "last_name": "Mendez",
              "middle_name": "V.",
              "street": "996-5460 Sed Rd.",
              "country": "Panama",
              "city": "Évreux",
              "state": "Haute-Normandie",
              "email": "ipsum@Sedeu.edu",
              "phone": "(02068) 5325262"
            }, {
              "first_name": "Lillian",
              "last_name": "Cooley",
              "middle_name": "K.",
              "street": "Ap #580-3670 Vivamus Rd.",
              "country": "El Salvador",
              "city": "Belfast",
              "state": "Ulster",
              "email": "Nulla.tincidunt@penatibuset.ca",
              "phone": "(0169) 97042500"
            }, {
              "first_name": "Alika",
              "last_name": "Calhoun",
              "middle_name": "W.",
              "street": "P.O. Box 379, 1680 Tortor. St.",
              "country": "Virgin Islands, British",
              "city": "San José de Alajuela",
              "state": "Alajuela",
              "email": "metus@Integer.edu",
              "phone": "(0243) 11894722"
            }, {
              "first_name": "Yoko",
              "last_name": "Richmond",
              "middle_name": "J.",
              "street": "858-8271 Egestas. Street",
              "country": "Singapore",
              "city": "Nazilli",
              "state": "Aydın",
              "email": "urna@malesuadaaugueut.net",
              "phone": "(0034) 12467098"
            }, {
              "first_name": "Arden",
              "last_name": "Barrera",
              "middle_name": "C.",
              "street": "8540 Vitae St.",
              "country": "Korea, North",
              "city": "Gliwice",
              "state": "SL",
              "email": "Duis@massaVestibulum.org",
              "phone": "(038860) 212005"
            }, {
              "first_name": "Hannah",
              "last_name": "Hanson",
              "middle_name": "P.",
              "street": "6601 Malesuada Rd.",
              "country": "Colombia",
              "city": "Milwaukee",
              "state": "WI",
              "email": "nec.orci@ametrisusDonec.ca",
              "phone": "(0268) 15945673"
            }, {
              "first_name": "Colby",
              "last_name": "Daniel",
              "middle_name": "Y.",
              "street": "9441 Sit Road",
              "country": "Saint Kitts and Nevis",
              "city": "Funtua",
              "state": "KT",
              "email": "cursus@CrasinterdumNunc.com",
              "phone": "(0931) 26317437"
            }, {
              "first_name": "Alden",
              "last_name": "Hines",
              "middle_name": "T.",
              "street": "1031 Rutrum Rd.",
              "country": "Vanuatu",
              "city": "Thorembais-les-B�guines",
              "state": "WB",
              "email": "metus@luctusut.ca",
              "phone": "(0366) 11659405"
            }, {
              "first_name": "Macaulay",
              "last_name": "Fisher",
              "middle_name": "W.",
              "street": "P.O. Box 546, 4904 Cubilia St.",
              "country": "Armenia",
              "city": "Cartagena",
              "state": "Murcia",
              "email": "lacinia.mattis@netusetmalesuada.ca",
              "phone": "(032794) 138499"
            }, {
              "first_name": "Knox",
              "last_name": "Webb",
              "middle_name": "K.",
              "street": "272-2978 Vulputate, St.",
              "country": "Guatemala",
              "city": "Berlin",
              "state": "Berlin",
              "email": "elit.sed.consequat@temporloremeget.edu",
              "phone": "(033872) 966374"
            }, {
              "first_name": "Tyrone",
              "last_name": "Carney",
              "middle_name": "G.",
              "street": "P.O. Box 570, 6414 Tristique Road",
              "country": "Iran",
              "city": "Katsina",
              "state": "Katsina",
              "email": "lobortis.quis@In.org",
              "phone": "(02744) 6422698"
            }, {
              "first_name": "Jillian",
              "last_name": "Mcbride",
              "middle_name": "M.",
              "street": "P.O. Box 959, 4823 Mauris Av.",
              "country": "Albania",
              "city": "Lincoln",
              "state": "NE",
              "email": "aliquet@dignissimlacusAliquam.com",
              "phone": "(047) 72805611"
            }
          ];
          _results = [];
          for (_i = 0, _len = contacts.length; _i < _len; _i++) {
            contact = contacts[_i];
            model = Logic._DB_insert({
              meta: {
                model: "Contact"
              },
              data: contact
            });
            _results.push(model.then(function(model) {
              return Logic._send_message('S_API_WEB_send', {
                meta: {
                  model: "Contact"
                },
                data: model
              });
            }));
          }
          return _results;
        },
        Contact: function(Logic, new_obj, prev_obj) {
          var me, model, promise;
          model = "Contact";
          this.obj = new_obj;
          this.prev = prev_obj;
          me = this;
          promise = Logic._DB_select({
            meta: {
              model: model,
              id: new_obj.id
            }
          });

          /* istanbul ignore next */
          return promise.then(function(db_objs) {
            var data;
            data = {
              id: me.obj.id
            };
            me._traditional(data, db_objs, me.obj, me.prev, 'first_name');
            me._traditional(data, db_objs, me.obj, me.prev, 'last_name');
            me._traditional(data, db_objs, me.obj, me.prev, 'middle_name');
            me._combining(data, db_objs, me.obj, me.prev, 'title');
            me._contextual(data, db_objs, me.obj, me.prev, 'street', 'last_name');
            me._contextual(data, db_objs, me.obj, me.prev, 'city', 'last_name');
            me._contextual(data, db_objs, me.obj, me.prev, 'country', 'last_name');
            me._contextual(data, db_objs, me.obj, me.prev, 'state', 'last_name');
            me._contextual(data, db_objs, me.obj, me.prev, 'email', 'last_name');
            me._contextual(data, db_objs, me.obj, me.prev, 'phone', 'last_name');
            return data;
          });
        },
        _repeatable: function(data, db_obj, new_obj, prev_obj, attr) {

          /* istanbul ignore else */
          if ((new_obj[attr] != null) && new_obj[attr] !== prev_obj[attr]) {
            data[attr] = db_obj[attr] + (new_obj[attr] - prev_obj[attr]);
          }
          return data;
        },
        _combining: function(data, db_obj, new_obj, prev_obj, attr) {

          /* istanbul ignore else */
          if (new_obj[attr] != null) {
            if (new_obj[attr] === prev_obj[attr]) {
              data[attr] = db_obj[attr];
            } else if (new_obj[attr] !== prev_obj[attr] && prev_obj[attr] !== db_obj[attr] && db_obj[attr] !== null) {
              data[attr] = db_obj[attr];
              data['conflict'] = true;
            } else {
              data[attr] = new_obj[attr];
            }
          }
          return data;
        },
        _traditional: function(data, db_obj, new_obj, prev_obj, attr) {

          /* istanbul ignore else */
          if ((new_obj[attr] != null) && new_obj[attr] !== prev_obj[attr]) {
            if (new_obj[attr] === prev_obj[attr]) {
              data[attr] = db_obj[attr];
            } else if (prev_obj[attr] === db_obj[attr]) {
              data[attr] = new_obj[attr];
            } else {
              data[attr] = db_obj[attr];
              data['conflict'] = true;
            }
          }
          return data;
        },
        _contextual: function(data, db_obj, new_obj, prev_obj, attr, context) {

          /* istanbul ignore else */
          if ((new_obj[attr] != null) && prev_obj[attr] !== new_obj[attr]) {
            if (prev_obj[context] === db_obj[context]) {
              data[attr] = new_obj[attr];
            } else {
              data[attr] = db_obj[attr];
              data['conflict'] = true;
            }
          }
          return data;
        }
      };

      function Logic(sequelize) {
        var me;
        if (sequelize == null) {
          sequelize = false;
        }
        if (sequelize) {
          this.Sequelize = sequelize;
        } else {
          throw new Error("you need to pass a sequelize instance");
        }
        me = this;
        flux.dispatcher.register(function(messageName, message) {
          return me.dispatch(messageName, message);
        });
      }

      Logic.prototype.dispatch = function(messageName, message) {
        if (messageName === 'S_LOGIC_SM_get') {
          this._get(message);
        }
        if (messageName === 'S_LOGIC_SM_create') {
          this._create(message);
        }
        if (messageName === 'S_LOGIC_SM_update') {
          this._update(message);
        }
        if (messageName === 'S_LOGIC_SM_delete') {
          this._delete(message);
        }
        if (messageName === 'S_LOGIC_SM_execute') {
          return this._execute(message);
        }
      };

      Logic.prototype._execute = function(message) {
        if (!('socket' in message.meta)) {
          throw new Error("not implemented yet!");
        }
        return this.sync["Function_" + message.meta["function"]](this, message.data.args);
      };


      /*
      		 * @message: meta:{ model:[model_name], socket:[socket], [id:[element_id]] }
       */

      Logic.prototype._get = function(message) {
        var me, models;
        if (!('socket' in message.meta)) {
          throw new Error("not implemented yet!");
        }
        models = this._DB_select(message);
        me = this;
        return models.then(function(models) {
          var model, _i, _len, _results;
          if (models.constructor === Array) {
            _results = [];
            for (_i = 0, _len = models.length; _i < _len; _i++) {
              model = models[_i];
              _results.push(me._send_message('S_API_WEB_send', {
                meta: {
                  model: message.meta.model,
                  socket: message.meta.socket
                },
                data: model
              }));
            }
            return _results;
          } else {
            return me._send_message('S_API_WEB_send', {
              meta: {
                model: message.meta.model,
                socket: message.meta.socket
              },
              data: models
            });
          }
        });
      };


      /*
      		 * @message: meta:{ model:[model_name] }, data:{ obj:{} }
       */

      Logic.prototype._create = function(message) {
        var me, model;
        model = this._DB_insert({
          meta: {
            model: message.meta.model
          },
          data: message.data.obj
        });
        me = this;
        return model.then(function(model) {
          return me._send_message('S_API_WEB_send', {
            meta: {
              model: message.meta.model
            },
            data: model
          });
        });
      };


      /*
      		 * @message: meta:{ model:[model_name] }, data:{ obj:{}, prev:{} }
       */

      Logic.prototype._update = function(message) {
        var me, promise, socket;
        this.message = message;
        me = this;
        socket = message.meta.socket;
        promise = this.sync[message.meta.model](this, message.data.obj, message.data.prev);
        return promise.then(function(data) {
          if ((data['conflict'] != null) === true) {
            me._send_message('S_API_WEB_send', {
              meta: {
                model: me.message.meta.model,
                socket: me.message.meta.socket,
                conflict: true
              },
              prev: me.message.data.prev,
              "try": me.message.data.obj,
              data: data
            });
          }
          return me._DB_update({
            meta: {
              model: me.message.meta.model
            },
            data: data
          }).then(function(model) {
            return me._send_message('S_API_WEB_send', {
              meta: {
                model: me.message.meta.model
              },
              data: model
            });
          });
        });
      };


      /*
      		 * @message: meta:{ model:[model_name] }, data:{ obj:{} }
       */

      Logic.prototype._delete = function(message) {
        this._send_message('S_API_WEB_send', {
          meta: {
            model: message.meta.model
          },
          data: {
            id: message.data.obj.id,
            deleted: 1
          }
        });
        return this._DB_delete({
          meta: {
            model: message.meta.model
          },
          data: message.data.obj
        });
      };

      Logic.prototype._send_message = function(messageName, message) {
        return flux.doAction(messageName, message);
      };

      Logic.prototype._DB_select = function(message) {
        var r;
        if ('id' in message.meta) {
          r = this.Sequelize[message.meta.model].find(message.meta.id);
        } else {
          r = this.Sequelize[message.meta.model].findAll();
        }
        return r;
      };

      Logic.prototype._DB_insert = function(message) {
        var r;
        return r = this.Sequelize[message.meta.model].create(message.data);
      };

      Logic.prototype._DB_update = function(message) {
        var r;
        r = this.Sequelize[message.meta.model].find(message.data.id);
        return r.then(function(el) {
          el.updateAttributes(message.data);
          return el.save();
        });
      };

      Logic.prototype._DB_delete = function(message) {
        return this.Sequelize[message.meta.model].find(message.data.id).then(function(el) {
          return el.destroy();
        });
      };

      Logic.prototype._DB_clear = function(model) {
        var me;
        me = this;
        return this.Sequelize[model].findAll().then(function(els) {
          var el, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = els.length; _i < _len; _i++) {
            el = els[_i];
            me._send_message('S_API_WEB_send', {
              meta: {
                model: model
              },
              data: {
                id: el.id,
                deleted: 1
              }
            });
            _results.push(el.destroy());
          }
          return _results;
        });
      };

      return Logic;

    })();
    return Logic;
  });

}).call(this);
