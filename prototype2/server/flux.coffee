define ['es6-promise', 'fluxify'], (promise, flux) ->

	###
	# node does not support promises out of the box, so we promisify
	###
	flux.promisify( Promise );
	flux

