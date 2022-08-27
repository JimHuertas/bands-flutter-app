import 'package:flutter/material.dart';
import 'package:flutter_advance/services/socket_service.dart';
import 'package:provider/provider.dart';


class StatusPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    // socketService.socket.emit(event)

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: <Widget>[ 
            Text('ServerStatus: ${socketService.serverStatus}')
          ]
        ),
     ),
     floatingActionButton: FloatingActionButton(
      onPressed: () {
        socketService.socket.emit('emitir-mensaje',{
          'nombre': 'Flutter', 
          'mensaje':'Momento Maincra'});
      },
      child: Icon(Icons.message),
    ),
   );
  }



}