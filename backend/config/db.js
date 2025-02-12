const { Sequelize } = require('sequelize');

// ตั้งค่าตัวแปรการเชื่อมต่อฐานข้อมูลโดยตรง
const DB_HOST = '202.29.22.52';
const DB_USER = 'root';
const DB_PASSWORD = 'A8035725q6q7FSSLbfGdkfqT72fcwGD69eQO5KmeO8Sakr3PFHll9asHkWkzpq0R';
const DB_NAME = 'db_laws';
const DB_PORT = 8485;

const sequelize = new Sequelize(DB_NAME, DB_USER, DB_PASSWORD, {
  host: DB_HOST,
  port: DB_PORT,
  dialect: 'mysql',
  dialectModule: require('mysql2'),
});

// การเชื่อมต่อฐานข้อมูล
sequelize.authenticate()
  .then(() => {
    console.log('Connection has been established successfully.');
  })
  .catch(err => {
    console.error('Unable to connect to the database:', err);
  });

module.exports = sequelize;