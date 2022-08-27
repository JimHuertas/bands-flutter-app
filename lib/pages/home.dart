import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_advance/models/band.dart';
import 'package:flutter_advance/services/socket_service.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';


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
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('bandas-activas', _handleActiveBand);

    super.initState();
  }

  _handleActiveBand(dynamic payload){
    bands = (payload as List)
      .map((band)=>Band.fromMap(band))
      .toList();
      
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('bandas-activas');
    super.dispose();
  }

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
      body: Column(
        children: <Widget>[
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) => _BandTile(bands[index])
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewButton
      ),
    );
  }

  Widget _BandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ){
        socketService.socket.emit("delete-band", {
          "id" : band.id
        });
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
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
          onTap: () => socketService.socket.emit('add-votes', {'id'  :band.id}),
        ),
    );
  }

  addNewButton(){
    final textController = new TextEditingController();

    if(Platform.isAndroid){
      return showDialog(
        context: context, 
        builder: ( _ ) => AlertDialog(
          title: Text('New band name:'), 
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Add'),
              elevation: 5,
              onPressed: () => addBandToList(textController.text)
            ),
            MaterialButton(
              child: Text('Cancel'),
              elevation: 5,
              onPressed: () => Navigator.pop(context)
            ),
          ],
        )
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    if(name.length > 1){
      socketService.socket.emit("add-band",{
        "name": name,
      });
    }

    Navigator.pop(context);
  }

  _showGraph(){
    Map<String, double> dataMap = {};
    bands.forEach((band){
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble() );
    });

    final List<Color> colorList = [
      Colors.blue[50]!,
      Colors.blue[200]!,
      Colors.pink[50]!,
      Colors.pink[200]!,
      Colors.yellow[50]!,
      Colors.yellow[200]!,
    ];

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartType: ChartType.ring,
        //chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          //showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      )
    );
  }

}