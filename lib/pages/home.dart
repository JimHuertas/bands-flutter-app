import 'package:flutter/material.dart';

import 'package:flutter_advance/models/band.dart';


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
    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _BandTile(bands[index])
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: (){}
      ),
    );
  }

  ListTile _BandTile(Band band) {
    return ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: TextStyle( fontSize: 20),),
        onTap: (){
          print(band.name);
        },
      );
  }
}