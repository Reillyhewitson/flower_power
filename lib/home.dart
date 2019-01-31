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

enum WaterState{
  watered,
  not
}

class PlantItemState extends State<PlantItem>{
  @override
  void initState(){
    super.initState();
    
    this.setWater(global.status[widget.index]);
  }

  WaterState _waterState = WaterState.not;

  setWater(status){
    if(status == false){
      _waterState = WaterState.not;
    }
    else{
      _waterState = WaterState.watered;
    }
    

  }
  

  void water(){
    global.status[widget.index] = true;
    setState(() {
      _waterState = WaterState.watered;
    });

  }

  void not(){
    global.status[widget.index] = false;
    setState(() {
          _waterState = WaterState.not;
        });
  }
  
  Widget build(BuildContext context){
    return InkWell( 
      onTap: (){
        Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (BuildContext context) => PlantDetail(plant: widget.plant, status: global.status[widget.index], index: widget.index,)
            )
          );
      },
      child: ListTile(
      leading: Image.network(widget.plant["img"], height: 50.0, width: 50.0,),
      title: Text(widget.plant["name"]),
      trailing: _waterState == WaterState.watered ? FlatButton(child: Text("Watered", style: TextStyle(color: Colors.green)), onPressed: () => not()) : FlatButton(child: Text("Not Watered", style: TextStyle(color: Colors.red)), onPressed: () => water(),)
      )
    );
  }
}

class PlantDetail extends StatefulWidget{
  PlantDetail({this.plant, this.status, this.index});
  final Map plant;
  final bool status;
  final int index;
  
  @override
  State<StatefulWidget> createState() => PlantDetailState();
}

class PlantDetailState extends State<PlantDetail>{
  @override
  void initState(){
    super.initState();
    
    this.setWater(global.status[widget.index]);
  }

  WaterState _waterState = WaterState.not;

  setWater(status){
    if(status == false){
      _waterState = WaterState.not;
    }
    else{
      _waterState = WaterState.watered;
    }
    

  }

  void water(){
    global.status[widget.index] = true;
    setState(() {
      _waterState = WaterState.watered;
    });

  }

  void not(){
    global.status[widget.index] = false;
    setState(() {
          _waterState = WaterState.not;
        });
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(widget.plant["name"]), automaticallyImplyLeading: true, ),
      body: ListView(
          children: <Widget>[ 
                  Container(child: Image.network(widget.plant["img"])),
            Container( 
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 0), 
              child:ListTile( 
                title: Text(widget.plant["name"], style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                trailing: _waterState == WaterState.watered ? FlatButton(child: Text("Watered", style: TextStyle(color: Colors.green)), onPressed: () => not()) : FlatButton(child: Text("Not Watered", style: TextStyle(color: Colors.red)), onPressed: () => water(),) ,
              )
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Description", style: TextStyle(fontSize: 20.0)),
                  Text(widget.plant["desc"], textAlign: TextAlign.center,),
                  Divider(),
                  Text("How to care for", style: TextStyle(fontSize: 20.0)),
                  Text(widget.plant["howTo"], textAlign: TextAlign.center,)
                ]
              )
            )
          ]
        )
      );
  }
}
      