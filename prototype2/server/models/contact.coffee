### istanbul ignore next: sequelize is not testable in the browser ###
module.exports = (sequelize, DataTypes) ->
	Contact = sequelize.define "Contact", { 
		first_name: DataTypes.STRING
		last_name: DataTypes.STRING
		middle_name: DataTypes.STRING
		title: DataTypes.STRING

		street: DataTypes.STRING
		country: DataTypes.STRING
		state: DataTypes.STRING
		city: DataTypes.STRING

		email: DataTypes.STRING

		phone: DataTypes.STRING
	}, {}


