import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_advance/models/band.dart';
import 'package:flutter_advance/services/socket_service.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id:'1', name: 'Metallica', votes: 1),
    Band(id:'2', name: 'Bullet for my valentine', votes: 3),
    Band(id:'3', name: 'My Chemical Romance', votes: 4),
    Band(id:'4', name: 'System of a Down', votes: 7),
    Band(id:'5', name: 'Nirvana', votes: 2),
  ];

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    final Icon _icon_status = (socketService.serverStatus == ServerStatus.Online) 
            ? Icon(Icons.check_circle, color: Colors.blue[300],)
            : Icon(Icons.offline_bolt, color: Colors.red,);
    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),

            child: _icon_status
            
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _BandTile(bands[index])
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewButton
      ),
    );
  }

  Widget _BandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        print('direction: $direction');
        print('id: ${band.id}');
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white),),
        ),

      ),
      child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0,2)),
            backgroundColor: Colors.blue[100],
          ),
          title: Text(band.name),
          trailing: Text('${band.votes}', style: TextStyle( fontSize: 20),),
          onTap: (){
            print(band.name);
          },
        ),
    );
  }

  addNewButton(){
    final textController = new TextEditingController();

    if(Platform.isAndroid){
      return showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('add'),
                elevation: 5,
                onPressed: () => addBandToList(textController.text)
              ),
            ],
          );
        }
      );
    }
    showCupertinoDialog(
      context: context, 
      builder: ( _ ){
        return CupertinoAlertDialog(
          title: Text('New band Name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Exit'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      }
    );

  }

  addBandToList(String name){
    print(name);
    if(name.length > 1){
      this.bands.add(new Band(
        id: DateTime.now().toString(), name: name,));
        setState(() {});
    }

    Navigator.pop(context);
  }

}