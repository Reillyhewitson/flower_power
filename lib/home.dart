import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'global.dart' as global;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState(){
    super.initState();
    this.getData();
  }

  List data;

  Future<String> getData() async{
    var getResponse = await http.get("https://flower-power-4dbf7.firebaseio.com/flowers.json");
    setState(() {
          var resbody = json.decode(getResponse.body);
          data = resbody;
        });
    return "finished";
  }

  @override
  Widget build(BuildContext context) {
    if(this.data == null){
          return Scaffold(
            appBar: AppBar(title: Text("Flower Power")),
            body: Text("loading", textAlign: TextAlign.center,));
        }
    else{
      return Scaffold(
        appBar: AppBar(title: Text("Flower Power")),
        body: ListView.builder(
          itemCount: this.data.length,
          itemBuilder: (BuildContext context, int index) => PlantItem(plant: this.data[index], index: index, )
        )
      );
    }
  }
}


class PlantItem extends StatefulWidget{
  PlantItem({this.plant, this.index});
  final Map plant;
  final int index;
  
  @override
  State<StatefulWidget> createState() => PlantItemState();
}

class PlantItemState extends State<PlantItem>{
  
  Widget build(BuildContext context){
    return ListTile(
      leading: Image.network(widget.plant["img"], height: 50.0, width: 50.0,),
      title: Text(widget.plant["name"]),
      trailing: global.status[widget.index] == true ? FlatButton(child: Text("Watered", style: TextStyle(color: Colors.green)), onPressed: () => global.status[widget.index] = true) : FlatButton(child: Text("Not Watered", style: TextStyle(color: Colors.red)), onPressed: () => global.status[widget.index] = true,));
  }
}