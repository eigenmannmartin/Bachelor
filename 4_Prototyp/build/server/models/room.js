
/* istanbul ignore next: sequelize is not testable in the browser */

(function() {
  module.exports = function(sequelize, DataTypes) {
    var Room;
    return Room = sequelize.define("Room", {
      name: DataTypes.STRING,
      description: DataTypes.TEXT,
      free: DataTypes.BOOLEAN,
      beamer: DataTypes.BOOLEAN,
      ac: DataTypes.BOOLEAN,
      seats: DataTypes.INTEGER,
      image: DataTypes.STRING
    }, {});
  };

}).call(this);
