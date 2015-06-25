(function() {
  define(['react', 'reactrouter', 'flux'], function(React, Router, flux) {
    var ContactEdit, Contacts;
    this.RouteHandler = Router.RouteHandler;
    this.Route = Router.Route;
    this.NotFoundRoute = Router.NotFoundRoute;
    this.Link = Router.Link;
    Contacts = React.createClass({
      getInitialState: function() {
        return {
          contacts: flux.stores.prototype_contacts.getState().contacts
        };
      },
      componentDidMount: function() {
        var me;
        me = this;
        return flux.stores.prototype_contacts.on('change', function(state) {
          return me.setState({
            contacts: state.contacts
          });
        });
      },
      get_contact: function(id) {
        var contact, _i, _len, _ref;
        _ref = this.state.contacts;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          contact = _ref[_i];
          if (contact.id === id) {
            return contact;
          }
        }
      },
      manual_command: function(event) {
        var object, prev;
        if (event.key === 'Enter') {
          event.preventDefault();
          object = JSON.parse(event.target.value);
          prev = object.id != null ? JSON.parse(JSON.stringify(this.get_contact(object.id))) : {};
          if (object["delete"] != null) {
            return flux.doAction('C_PRES_STORE_delete', {
              meta: {
                model: "Contact"
              },
              data: object
            });
          } else {
            return flux.doAction('C_PRES_STORE_update', {
              meta: {
                model: "Contact"
              },
              data: object,
              prev: prev
            });
          }
        }
      },
      render: function() {
        return React.createElement("div", {
          "className": "container"
        }, React.createElement("div", {
          "className": "row"
        }, React.createElement("p", {
          "className": "hidden"
        }, React.createElement("textarea", {
          "onKeyDown": this.manual_command,
          "defaultValue": '{"id":1,"last_name":"Eigenmann"}'
        })), React.createElement("table", {
          "className": "hoverable"
        }, React.createElement("thead", null, React.createElement("tr", null, React.createElement("th", null, "Name"), React.createElement("th", null, "Phone"), React.createElement("th", null, "Email"), React.createElement("th", null, "Country"))), React.createElement("tbody", null, this.state.contacts.map(function(contact) {
          return React.createElement("tr", {
            "className": "nowrap"
          }, React.createElement("td", null, contact.title, " ", contact.first_name, " ", contact.last_name), React.createElement("td", null, contact.phone), React.createElement("td", null, contact.email), React.createElement("td", null, contact.country), React.createElement("td", null, React.createElement(Link, {
            "to": "Contact/Edit",
            "params": {
              Id: contact.id
            }
          }, "Edit")));
        })))));
      }
    });
    flux.dispatcher.register(function(messageName, message) {
      if (messageName === 'C_PRES_STORE_conflict') {
        return console.log("you got an sync-error!!!");
      }
    });
    ContactEdit = React.createClass({
      mixins: [Router.Navigation],
      getInitialState: function() {
        return {
          contact: this.getContact(this.props.params.Id)
        };
      },
      componentDidMount: function() {
        var me;
        me = this;
        return flux.stores.prototype_contacts.on('change', function(state) {
          return me.setState({
            contact: me.getContact(me.props.params.Id)
          });
        });
      },
      getContact: function(id) {
        var contact, result, _i, _len, _ref;
        result = false;
        _ref = flux.stores.prototype_contacts.getState().contacts;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          contact = _ref[_i];
          if (contact.id === parseInt(id)) {
            result = contact;
          }
        }
        return JSON.parse(JSON.stringify(result));
      },
      change_title: function(event) {
        var contact;
        contact = this.state.contact;
        contact.title = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      change_first_name: function(event) {
        var contact;
        contact = this.state.contact;
        contact.first_name = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      change_last_name: function(event) {
        var contact;
        contact = this.state.contact;
        contact.last_name = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      change_middle_name: function(event) {
        var contact;
        contact = this.state.contact;
        contact.middle_name = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      change_street: function(event) {
        var contact;
        contact = this.state.contact;
        contact.street = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      change_country: function(event) {
        var contact;
        contact = this.state.contact;
        contact.country = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      change_state: function(event) {
        var contact;
        contact = this.state.contact;
        contact.state = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      change_city: function(event) {
        var contact;
        contact = this.state.contact;
        contact.city = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      change_email: function(event) {
        var contact;
        contact = this.state.contact;
        contact.email = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      change_phone: function(event) {
        var contact;
        contact = this.state.contact;
        contact.phone = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      change_pnotes: function(event) {
        var contact;
        contact = this.state.contact;
        contact.pnotes = event.target.value;
        return this.setState({
          contact: contact
        });
      },
      click_save: function(event) {
        var object, prev;
        object = JSON.parse(JSON.stringify(this.state.contact));
        prev = this.getContact(object.id);
        flux.doAction('C_PRES_STORE_update', {
          meta: {
            model: "Contact"
          },
          data: object,
          prev: prev
        });
        return this.transitionTo('Contacts');
      },
      click_delete: function(event) {
        var object;
        object = JSON.parse(JSON.stringify(this.state.contact));
        flux.doAction('C_PRES_STORE_delete', {
          meta: {
            model: "Contact"
          },
          data: object
        });
        return this.transitionTo('Contacts');
      },
      render: function() {
        var contact;
        contact = this.state.contact;
        if (contact) {
          return React.createElement("div", {
            "className": "container"
          }, React.createElement("div", {
            "className": "row"
          }, React.createElement("div", {
            "className": "col s12 l10 offset-l1"
          }, React.createElement("div", {
            "className": "card-panel green lighten-1"
          }, React.createElement("div", {
            "className": "card-panel"
          }, React.createElement("a", {
            "className": "btn-floating btn-large waves-effect waves-light red right planner-save-btn",
            "onClick": this.click_save
          }, React.createElement("i", {
            "className": "mdi-content-save"
          })), React.createElement("div", {
            "className": "row"
          }, React.createElement("form", {
            "className": "col s12"
          }, React.createElement("div", {
            "className": "row"
          }, React.createElement("div", {
            "className": "input-field col s2"
          }, React.createElement("input", {
            "id": "title",
            "type": "text",
            "value": contact.title,
            "onChange": this.change_title,
            "className": "validate"
          }), React.createElement("label", {
            "htmlFor": "title",
            "className": (contact.title ? "active" : void 0)
          }, "Title")), React.createElement("div", {
            "className": "input-field col s3"
          }, React.createElement("input", {
            "id": "first_name",
            "type": "text",
            "value": contact.first_name,
            "onChange": this.change_first_name,
            "className": "validate"
          }), React.createElement("label", {
            "htmlFor": "first_name",
            "className": (contact.first_name ? "active" : void 0)
          }, "Firstname")), React.createElement("div", {
            "className": "input-field col s2"
          }, React.createElement("input", {
            "id": "middle_name",
            "type": "text",
            "value": contact.middle_name,
            "onChange": this.change_middle_name,
            "className": "validate"
          }), React.createElement("label", {
            "htmlFor": "middle_name",
            "className": (contact.middle_name ? "active" : void 0)
          }, "Middlename")), React.createElement("div", {
            "className": "input-field col s5"
          }, React.createElement("input", {
            "id": "last_name",
            "type": "text",
            "value": contact.last_name,
            "onChange": this.change_last_name,
            "className": "validate"
          }), React.createElement("label", {
            "htmlFor": "last_name",
            "className": (contact.last_name ? "active" : void 0)
          }, "Lastname"))), React.createElement("div", {
            "className": "row"
          }, React.createElement("div", {
            "className": "input-field col s4"
          }, React.createElement("input", {
            "id": "country",
            "type": "text",
            "value": contact.country,
            "onChange": this.change_country,
            "className": "validate"
          }), React.createElement("label", {
            "htmlFor": "country",
            "className": (contact.country ? "active" : void 0)
          }, "Country")), React.createElement("div", {
            "className": "input-field col s3"
          }, React.createElement("input", {
            "id": "state",
            "type": "text",
            "value": contact.state,
            "onChange": this.change_state,
            "className": "validate"
          }), React.createElement("label", {
            "htmlFor": "state",
            "className": (contact.state ? "active" : void 0)
          }, "State")), React.createElement("div", {
            "className": "input-field col s5"
          }, React.createElement("input", {
            "id": "city",
            "type": "text",
            "value": contact.city,
            "onChange": this.change_city,
            "className": "validate"
          }), React.createElement("label", {
            "htmlFor": "city",
            "className": (contact.city ? "active" : void 0)
          }, "City"))), React.createElement("div", {
            "className": "row"
          }, React.createElement("div", {
            "className": "input-field col s12"
          }, React.createElement("input", {
            "id": "street",
            "type": "text",
            "value": contact.street,
            "onChange": this.change_street,
            "className": "validate"
          }), React.createElement("label", {
            "htmlFor": "street",
            "className": (contact.street ? "active" : void 0)
          }, "Street"))), React.createElement("div", {
            "className": "row"
          }, React.createElement("div", {
            "className": "input-field col s6"
          }, React.createElement("input", {
            "id": "email",
            "type": "text",
            "value": contact.email,
            "onChange": this.change_email,
            "className": "validate"
          }), React.createElement("label", {
            "htmlFor": "email",
            "className": (contact.email ? "active" : void 0)
          }, "E-mail")), React.createElement("div", {
            "className": "input-field col s6"
          }, React.createElement("input", {
            "id": "phone",
            "type": "text",
            "value": contact.phone,
            "onChange": this.change_phone,
            "className": "validate"
          }), React.createElement("label", {
            "htmlFor": "phone",
            "className": (contact.phone ? "active" : void 0)
          }, "Phone"))), React.createElement("div", {
            "className": "row"
          }, React.createElement("div", {
            "className": "input-field col s12"
          }, React.createElement("textarea", {
            "id": "pnotes",
            "className": "materialize-textarea",
            "onChange": this.change_pnotes
          }), React.createElement("label", {
            "for": "pnotes"
          }, "Notes"))), React.createElement("div", {
            "className": "row"
          }, React.createElement("div", {
            "className": "col s12"
          }, React.createElement("a", {
            "className": "waves-effect waves-light btn right grey",
            "onClick": this.click_delete
          }, React.createElement("i", {
            "className": "mdi-action-delete"
          })))))))))));
        } else {
          return React.createElement("div", null, "\t\t\t\t\tContact not found yet!");
        }
      }
    });
    return [Contacts, ContactEdit];
  });

}).call(this);

//# sourceMappingURL=plannerPages.js.map
