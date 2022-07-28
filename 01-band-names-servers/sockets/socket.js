const { io } = require('../index');

//Mensaje de Sockets
io.on('connection', client => {
    console.log('Cliente Conectado');

    client.on('disconnect', () => { 
        console.log('Cliente desconectado');
    });

    client.on('mensaje', (payload) => {
        console.log('Mensaje !!! ', payload);
        io.emit( 'mensaje', {admin: 'nuevo mensaje'});
    });
    
    client.on('emitir-mensaje', (payload) => {
        // io.emit('emitir-mensaje', payload); //emite a todos
        client.broadcast.emit('nuevo-mensaje', payload)
        console.log(payload);
    });

});

