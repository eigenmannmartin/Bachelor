define ['flux'], (flux) ->

	class Logic


		sync:
			Function_init: (Logic, args) ->
				Logic._DB_clear "Contact"

				contacts = [
					{"first_name": "Riley", "last_name": "Burt", "middle_name": "J.", "street": "Ap #478-849 Accumsan St.", "country": "Bouvet Island", "city": "Badajoz", "state": "Extremadura", "email": "nibh@vitaealiquetnec.edu", "phone": "(033220) 937671"},
					{"first_name": "Tanya", "last_name": "Reynolds", "middle_name": "N.", "street": "536-3821 Erat Street", "country": "Togo", "city": "New Haven", "state": "Connecticut", "email": "tempus.risus@telluseuaugue.co.uk", "phone": "(03805) 9925691"},
					{"first_name": "Sylvester", "last_name": "Mendez", "middle_name": "V.", "street": "996-5460 Sed Rd.", "country": "Panama", "city": "Évreux", "state": "Haute-Normandie", "email": "ipsum@Sedeu.edu", "phone": "(02068) 5325262"},
					{"first_name": "Lillian", "last_name": "Cooley", "middle_name": "K.", "street": "Ap #580-3670 Vivamus Rd.", "country": "El Salvador", "city": "Belfast", "state": "Ulster", "email": "Nulla.tincidunt@penatibuset.ca", "phone": "(0169) 97042500"},
					{"first_name": "Alika", "last_name": "Calhoun", "middle_name": "W.", "street": "P.O. Box 379, 1680 Tortor. St.", "country": "Virgin Islands, British", "city": "San José de Alajuela", "state": "Alajuela", "email": "metus@Integer.edu", "phone": "(0243) 11894722"},
					{"first_name": "Yoko", "last_name": "Richmond", "middle_name": "J.", "street": "858-8271 Egestas. Street", "country": "Singapore", "city": "Nazilli", "state": "Aydın", "email": "urna@malesuadaaugueut.net", "phone": "(0034) 12467098"},
					{"first_name": "Arden", "last_name": "Barrera", "middle_name": "C.", "street": "8540 Vitae St.", "country": "Korea, North", "city": "Gliwice", "state": "SL", "email": "Duis@massaVestibulum.org", "phone": "(038860) 212005"},
					{"first_name": "Hannah", "last_name": "Hanson", "middle_name": "P.", "street": "6601 Malesuada Rd.", "country": "Colombia", "city": "Milwaukee", "state": "WI", "email": "nec.orci@ametrisusDonec.ca", "phone": "(0268) 15945673"},
					{"first_name": "Colby", "last_name": "Daniel", "middle_name": "Y.", "street": "9441 Sit Road", "country": "Saint Kitts and Nevis", "city": "Funtua", "state": "KT", "email": "cursus@CrasinterdumNunc.com", "phone": "(0931) 26317437"},
					{"first_name": "Alden", "last_name": "Hines", "middle_name": "T.", "street": "1031 Rutrum Rd.", "country": "Vanuatu", "city": "Thorembais-les-B�guines", "state": "WB", "email": "metus@luctusut.ca", "phone": "(0366) 11659405"},
					{"first_name": "Macaulay", "last_name": "Fisher", "middle_name": "W.", "street": "P.O. Box 546, 4904 Cubilia St.", "country": "Armenia", "city": "Cartagena", "state": "Murcia", "email": "lacinia.mattis@netusetmalesuada.ca", "phone": "(032794) 138499"},
					{"first_name": "Knox", "last_name": "Webb", "middle_name": "K.", "street": "272-2978 Vulputate, St.", "country": "Guatemala", "city": "Berlin", "state": "Berlin", "email": "elit.sed.consequat@temporloremeget.edu", "phone": "(033872) 966374"},
					{"first_name": "Tyrone", "last_name": "Carney", "middle_name": "G.", "street": "P.O. Box 570, 6414 Tristique Road", "country": "Iran", "city": "Katsina", "state": "Katsina", "email": "lobortis.quis@In.org", "phone": "(02744) 6422698"},
					{"first_name": "Jillian", "last_name": "Mcbride", "middle_name": "M.", "street": "P.O. Box 959, 4823 Mauris Av.", "country": "Albania", "city": "Lincoln", "state": "NE", "email": "aliquet@dignissimlacusAliquam.com", "phone": "(047) 72805611"},
				]

				for contact in contacts
					model = Logic._DB_insert { meta:{model: "Contact"}, data: contact }
					model.then (model) ->
						Logic._send_message 'S_API_WEB_send', { meta:{ model:"Contact" }, data: model }



			Contact: (Logic, new_obj, prev_obj) ->
				model = "Contact"
				@obj = new_obj
				@prev = prev_obj

				me = @  #bind @ to me
				promise = Logic._DB_select meta:{ model:model, id: new_obj.id }  #get current db item
				### istanbul ignore next ###
				promise.then ( db_objs ) ->  #return updated item
					data = id: me.obj.id  #new object

					#traditional transaction
					me._traditional data, db_objs, me.obj, me.prev, 'first_name'
					me._traditional data, db_objs, me.obj, me.prev, 'last_name'
					me._traditional data, db_objs, me.obj, me.prev, 'middle_name'

					#combining
					me._combining data, db_objs, me.obj, me.prev, 'title'


					#contextual 
					me._contextual data, db_objs, me.obj, me.prev, 'street', 'last_name'
					me._contextual data, db_objs, me.obj, me.prev, 'city', 'last_name'
					me._contextual data, db_objs, me.obj, me.prev, 'country', 'last_name'
					me._contextual data, db_objs, me.obj, me.prev, 'state', 'last_name'
					me._contextual data, db_objs, me.obj, me.prev, 'email', 'last_name'
					me._contextual data, db_objs, me.obj, me.prev, 'phone', 'last_name'

					return data  #returning data

			_repeatable: (data, db_obj, new_obj, prev_obj, attr) ->
				### istanbul ignore else ###
				if new_obj[attr]? and new_obj[attr] isnt prev_obj[attr]
					data[attr] = db_obj[attr] + (new_obj[attr] - prev_obj[attr])

				return data

			_combining: (data, db_obj, new_obj, prev_obj, attr) ->
				### istanbul ignore else ###
				if new_obj[attr]?
					if new_obj[attr] is prev_obj[attr] 
						data[attr] = db_obj[attr]
					else if new_obj[attr] isnt prev_obj[attr] and prev_obj[attr] isnt db_obj[attr] and db_obj[attr] isnt null
						data[attr] = db_obj[attr]
						data['conflict'] = true
					else
						data[attr] = new_obj[attr]

				return data

			_traditional: (data, db_obj, new_obj, prev_obj, attr) ->
				### istanbul ignore else ###
				if new_obj[attr]? and new_obj[attr] isnt prev_obj[attr]
					if new_obj[attr] is prev_obj[attr] 
						data[attr] = db_obj[attr]
					else if prev_obj[attr] is db_obj[attr]
						data[attr] = new_obj[attr] 
					else 
						data[attr] = db_obj[attr]
						data['conflict'] = true 

				return data

			_contextual: (data, db_obj, new_obj, prev_obj, attr, context) ->
				### istanbul ignore else ###
				if new_obj[attr]? and prev_obj[attr] isnt new_obj[attr]
					if prev_obj[context] is db_obj[context]
						data[attr] = new_obj[attr]
					else 
						data[attr] = db_obj[attr]
						data['conflict'] = true

				return data


		constructor: (sequelize=false) ->
			if sequelize 
				@Sequelize = sequelize
			else
				throw new Error "you need to pass a sequelize instance"

			me = @
			flux.dispatcher.register (messageName, message) ->
				me.dispatch messageName, message

		dispatch: (messageName, message) ->
			if messageName is 'S_LOGIC_SM_get'
				@_get message

			if messageName is 'S_LOGIC_SM_create'
				@_create message

			if messageName is 'S_LOGIC_SM_update'
				@_update message

			if messageName is 'S_LOGIC_SM_delete'
				@_delete message

			if messageName is 'S_LOGIC_SM_execute'
				@_execute message

			
		_execute: (message) ->
			if 'socket' not of message.meta
				throw new Error "not implemented yet!"

			@sync["Function_"+message.meta.function](@, message.data.args)

		###
		# @message: meta:{ model:[model_name], socket:[socket], [id:[element_id]] } 
		###
		_get: (message) ->
			if 'socket' not of message.meta
				throw new Error "not implemented yet!"
				#@_send_message 'S_API_WEB_send', { meta:{ model:message.meta.model }, data: model }

			models = @_DB_select message

			me = @
			models.then (models) ->
				if models.constructor is Array
					for model in models
						me._send_message 'S_API_WEB_send', { meta:{ model:message.meta.model, socket:message.meta.socket }, data: model }
				else
					me._send_message 'S_API_WEB_send', { meta:{ model:message.meta.model, socket:message.meta.socket }, data: models }

		###
		# @message: meta:{ model:[model_name] }, data:{ obj:{} } 
		###
		_create: (message) ->
			model = @_DB_insert meta:{ model:message.meta.model }, data: message.data.obj
			me = @
			model.then (model) ->
				me._send_message 'S_API_WEB_send', { meta:{ model:message.meta.model }, data: model }

		###
		# @message: meta:{ model:[model_name] }, data:{ obj:{}, prev:{} } 
		###
		_update: (message) ->
			@message = message  #bind message to @
			me = @  #bind @ to me
			socket = message.meta.socket
			promise = @sync[message.meta.model]( @, message.data.obj, message.data.prev )  #call corresponding sync method
			promise.then (data) ->  #apply object do db
				if data['conflict']? is true
					me._send_message 'S_API_WEB_send', { meta:{ model:me.message.meta.model, socket:me.message.meta.socket, conflict:true }, prev:me.message.data.prev, try:me.message.data.obj, data:data }


				me._DB_update( meta:{ model:me.message.meta.model }, data: data ).then (model) ->
					me._send_message 'S_API_WEB_send', { meta:{ model:me.message.meta.model }, data: model }  #send message, so clients know
				

		###
		# @message: meta:{ model:[model_name] }, data:{ obj:{} } 
		###
		_delete: (message) ->
			@_send_message 'S_API_WEB_send', { meta:{ model:message.meta.model }, data: { id: message.data.obj.id, deleted: 1 } }
			@_DB_delete meta:{ model:message.meta.model }, data: message.data.obj


		_send_message: (messageName, message) ->
			flux.doAction messageName, message



		_DB_select: (message) ->
			if 'id' of message.meta
				r = @Sequelize[message.meta.model].find(message.meta.id)
			else
				r = @Sequelize[message.meta.model].findAll()

			return r

		_DB_insert: (message) ->
			r = @Sequelize[message.meta.model].create( message.data )

		_DB_update: (message) ->
			r = @Sequelize[message.meta.model].find( message.data.id )
			r.then (el) ->
				el.updateAttributes( message.data )
				el.save()

		_DB_delete: (message) ->
			@Sequelize[message.meta.model].find(message.data.id).then (el) ->
				el.destroy()

		_DB_clear: (model) ->
			me = @
			@Sequelize[model].findAll().then (els) ->
				for el in els
					me._send_message 'S_API_WEB_send', { meta:{ model:model }, data: { id: el.id, deleted: 1 } }
					el.destroy()


	Logic