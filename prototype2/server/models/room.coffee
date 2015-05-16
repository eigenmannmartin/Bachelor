module.exports = (sequelize, DataTypes) ->
	Room = sequelize.define "Room", { 
		name: DataTypes.STRING
		description: DataTypes.TEXT

		free: DataTypes.BOOLEAN
		beamer: DataTypes.BOOLEAN
		ac: DataTypes.BOOLEAN
		seats: DataTypes.INTEGER

		image: DataTypes.STRING
	}, {}




