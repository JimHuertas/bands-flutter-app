const { io } = require('../index');
const Band = require('../models/band');
const Bands = require('../models/bands');

const bands = new Bands();
bands.addBand(new Band('Queen'));
bands.addBand(new Band('Bon jovi'));
bands.addBand(new Band('$uicideboy$'));
bands.addBand(new Band('Ghostemane'));

//Mensaje de Sockets
io.on('connection', client => {
    console.log('Cliente Conectado');

    client.emit('bandas-activas', bands.getBands());

    client.on('disconnect', () => { 
        console.log('Cliente desconectado');
    });

    client.on('add-votes', (payload) => {
        
        bands.voteBand(payload.id);
        io.emit('bandas-activas', bands.getBands());
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

    client.on('add-band', (payload) => {
        bands.addBand(new Band(payload.name))
        io.emit('bandas-activas', bands.getBands());
    });

    client.on('delete-band', (payload) => {
        bands.deleteBand(payload.id)
        io.emit('bandas-activas', bands.getBands());
    });

});

