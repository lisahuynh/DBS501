const oracledb = require('oracledb');
const { json } = require('stream/consumers');

var rslt = new Object();

oracledb.getConnection(
  {
    user          : 'COMP214_F22_er_45',
    password      : 'password',
    connectString : '(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = 199.212.26.208)(PORT = 1521))(CONNECT_DATA =(SID= SQLD)))'
    //connectString : "(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))(CONNECT_DATA =(SID= ORCL)))"
  },
  function(err, connection) {
    console.log('Starting to establish a connection. . . . . ');
    if (err) {
      console.error(err.message);
      return;
    }
    console.log('Connection was successful!');

    connection.execute("SELECT * FROM HR_employees where first_name = 'bill'", function(err, result){
      if(err){
        console.error(err.message);
        return;
      }
      rslt = JSON.stringify(result);
      console.log(JSON.parse(rslt));

    })

    connection.close(
      function(err) {
        if (err) {
          console.error(err.message);
          return;
        }
      });
  });