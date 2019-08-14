import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String localZone;
var resBody;
var resBodyZones;
List zonas;

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
    localZone = "America/Maceio";
  }

  Future<Map> _getDataZoneTime() async{
    http.Response resposta = await http.get("http://api.timezonedb.com/v2.1/get-time-zone?key=2OAR4HS329MU&format=json&by=zone&zone=$localZone");

    resBody = json.decode(resposta.body);

    return resBody;
  }

  Future<Map> _getDataZones() async{
    http.Response resposta = await http.get("http://api.timezonedb.com/v2.1/list-time-zone?key=2OAR4HS329MU&format=json");

    resBodyZones = json.decode(resposta.body);

    print(resBodyZones);

    return resBodyZones;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("No seu Tempo"),
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
                                  color: Colors.white,
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: "Roboto"),
                            ),

                            padding: const EdgeInsets.all(0.0),
                            alignment: Alignment.bottomCenter,
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
            builder: (BuildContext context, AsyncSnapshot snapshot){

              if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none){
                return Container(
                  child: Center(
                    child: Text("Carredando..."),
                    )
                  );
              }
              return Expanded(
                child: ListView.builder(
                    itemCount: 425,
                    itemBuilder: (BuildContext context, int index){
                      if(resBodyZones["zones"][index]["zoneName"] != null){
                        return ListTile(
                          title: Text(resBodyZones["zones"][index]["zoneName"]),
                          onLongPress: (){
                            setState(() {
                              localZone = resBodyZones["zones"][index]["zoneName"];
                            });
                            print(localZone);
                          },
                        );
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
