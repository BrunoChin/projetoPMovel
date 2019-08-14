import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final localZone = "America/Maceio";
var resBody;
var resBodyZones;

void main() => runApp(MaterialApp(
  theme: new ThemeData(
    brightness:Brightness.dark,
  ),
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    _getDataZones();
  }

  Future<Map> _getDataZoneTime() async{
    http.Response resposta = await http.get("http://api.timezonedb.com/v2.1/get-time-zone?key=2OAR4HS329MU&format=json&by=zone&zone=$localZone");

    resBody = json.decode(resposta.body);

    return resBody;
  }

  Future<List<String>> _getDataZones() async{
    http.Response resposta = await http.get("http://api.timezonedb.com/v2.1/list-time-zone?key=2OAR4HS329MU&format=json");

    resBodyZones = json.decode(resposta.body)["zones"];

    List<String> timesZones;

    for(var temp in resBodyZones){
      print(temp);
      timesZones.add(temp.toString());
    }

    return timesZones;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("World's times zones"),
      ),
      body: FutureBuilder<Map>(
        future: _getDataZoneTime(),
        builder: (context, snapshot){
         switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(
                  child: Text(
                    "Carragando os Dados....",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carragando os Dados",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(0.0),
                    child:
                    new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Container(
                            child:
                            new Text(
                              "$localZone",
                              style: new TextStyle(fontSize:37.0,
                                  color: const Color(0xFF000000),
                                  fontWeight: FontWeight.w200,
                                  fontFamily: "Roboto"),
                            ),

                            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 1.0, 50.0),
                            alignment: Alignment.topLeft,
                          ),

                          new Container(
                            child:
                            new Text(
                              resBody["formatted"],
                              style: new TextStyle(fontSize:35.0,
                                  //color: const Color(Colors.green),
                                  fontWeight: FontWeight.w200,
                                  fontFamily: "Roboto"),
                            ),

                            padding: const EdgeInsets.all(0.0),
                            alignment: Alignment.bottomCenter,
                          )
                        ]

                    ),

                  );
                }
            }
        },
      ),
      drawer: Drawer(
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
            child: Text("Local Zones", style: TextStyle(fontSize: 30.0),)
          ),
          FutureBuilder<List<String>>(
            future: _getDataZones(),
            builder: (BuildContext context, AsyncSnapshot snapshot){

              var data = json.decode(snapshot.data);

              if(snapshot.data == null){
                return Container(
                  child: Text("Carredando..."),
                );
              }
              return ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text(data[index]["zoneName"]),
                  );
                });
            },
          ),
        ],),
      ),
    );
  }
}
