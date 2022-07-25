const express = require('express')
const path = require('path')


const app = express()

const publicPath = path.resolve(__dirname)



app.listen(3000, (err) =>{
    if( err ) throw new Error(err);

    console.log('Servidor Corriendo en puerto ', 3000);
});