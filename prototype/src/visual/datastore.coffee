define 'visual/datastore',
[
	'text!templates/test.tpl'
],(
	tpl
) ->
	class datastore

		constructor: ( opts ) ->
			if opts
				this.init opts 

		init: ( opts ) ->
			this.datastore = opts[ 'datastore' ]

		render: () ->


	datastore