### istanbul ignore next: sequelize is not testable in the browser ###
module.exports = (sequelize, DataTypes) ->
	Name = sequelize.define "Name", {
		first_name: DataTypes.STRING
		last_name: DataTypes.STRING
		middle_name: DataTypes.STRING
		title: DataTypes.STRING
	}, {}

	Address = sequelize.define "Address", {
		street: DataTypes.STRING
		country: DataTypes.STRING
		state: DataTypes.STRING
	}, {}

	Email = sequelize.define "Email", {
		email: DataTypes.STRING
		active: DataTypes.BOOLEAN
		primary: DataTypes.BOOLEAN
	}, {}

	Phone = sequelize.define "Phone", {
		phone: DataTypes.STRING
		active: DataTypes.BOOLEAN
		primary: DataTypes.BOOLEAN
	}, {}

	Contact = sequelize.define "Contact", { 
		first_name: DataTypes.STRING
		last_name: DataTypes.STRING
		middle_name: DataTypes.STRING
		title: DataTypes.STRING

		street: DataTypes.STRING
		country: DataTypes.STRING
		state: DataTypes.STRING

		email: DataTypes.STRING

		phone: DataTypes.STRING
	}, {}


