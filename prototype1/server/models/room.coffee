module.exports = (sequelize, DataTypes) ->
    Room = sequelize.define "Room", { roomname: DataTypes.STRING }, {}