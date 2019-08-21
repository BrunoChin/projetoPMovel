import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var resBody;

void main() =>
    runApp(MaterialApp(
      theme: new ThemeData(
        brightness: Brightness.light,
      ),
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String localZone = "America/Maceio";

  var resBodyZones;

  TextEditingController _localControler = TextEditingController();

  void _setZone(String text){
    setState(() {
      localZone = _localControler.text;
    });
    print(_localControler.toString());
  }

  Future<Map> _getDataZoneTime() async {
    http.Response resposta = await http.get(
        "http://api.timezonedb.com/v2.1/get-time-zone?key=2OAR4HS329MU&format=json&by=zone&zone=$localZone");

    resBody = json.decode(resposta.body);

    return resBody;
  }

  Future<Map> _getDataZones() async {
    http.Response resposta = await http.get(
        "http://api.timezonedb.com/v2.1/list-time-zone?key=2OAR4HS329MU&format=json");

    resBodyZones = json.decode(resposta.body);

    print(resBodyZones);

    return resBodyZones;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("No Seu Tempo"),
      ),
      body: FutureBuilder<Map>(
        future: _getDataZoneTime(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: Text(
                  "Carragando os Dados....",
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
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
                          child: Center(
                            child: Text(
                              "$localZone",
                              style: new TextStyle(fontSize: 37.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: "Roboto"),
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(
                              0.0, 0.0, 1.0, 50.0),
                          alignment: Alignment.topLeft,
                        ),

                        new Container(
                          child:
                          texto(),
                          padding: const EdgeInsets.all(0.0),
                          alignment: Alignment.bottomCenter,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                          child: TextField(
                            decoration: InputDecoration(labelText: "Buscar Local", border: OutlineInputBorder()),
                            controller: _localControler,
                            onSubmitted: _setZone,
                          ),
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        ),
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
          FutureBuilder<Map>(
            future: _getDataZones(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Container(
                    child: Center(
                      child: Text("Carredando..."),
                    )
                );
              }
              return Expanded(
                child: ListView.builder(
                    itemCount: 425,
                    itemBuilder: (BuildContext context, int index) {
                      if (resBodyZones["zones"][index]["zoneName"] != null) {
                        return ListTile(
                          title: Text(resBodyZones["zones"][index]["zoneName"]),
                          onLongPress: () {
                            setState(() {
                              localZone =
                              resBodyZones["zones"][index]["zoneName"];
                            });
                          },
                        );
                      }
                      else {
                        return Text("Erro ao carrecar :(");
                      }
                    }),
              );
            },
          ),
        ],),
      ),
    );
  }
}

Widget texto(){
  if(resBody["formatted"].toString() == "" || resBody["formatted"] == null){
    return Text(
        "Local não encontrado",
        style: new TextStyle(fontSize: 35.0,
        color: Colors.black,
        fontWeight: FontWeight.w200,
        fontFamily: "Roboto"),
    );
  }
  else{
    return new Text(
      resBody["formatted"],
      style: new TextStyle(
          fontSize: 35.0,
          color: Colors.black,
          fontWeight: FontWeight.w200,
          fontFamily: "Roboto"),
    );
  }
}