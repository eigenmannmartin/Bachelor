### istanbul ignore next ###
define ['es6-promise', 'fluxify'], (promise, flux) ->

	###
	# node does not support promises out of the box, so we promisify
	###
	### istanbul ignore next: not possible to test in the browser ###
	flux.promisify( Promise );
	### istanbul ignore next ###
	flux

