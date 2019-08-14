import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final localZone = "America/Maceio";
String dateHour;

void main() => runApp(MaterialApp(home: Home(),));

  Future<Map> getData() async{
    http.Response resposta = await http.get("http://api.timezonedb.com/v2.1/get-time-zone?key=YOUR_API_KEY&format=json&by=zone&zone=$localZone");

    return json.decode(resposta.body);
  }

  String getHora(Map context){
    String hora = context["formatted"];
    return hora;
  }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("World's times zones"),
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, estado){
         switch (estado.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(
                  child: Text(
                    "Carragando os Dados....",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  ),
                );
              default:
                if (estado.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carragando os Dados :(",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                      Container(
                        child: Text("$localZone", style: TextStyle(fontSize: 20.0),),
                      ),
                      String hora = getData();
                      Container(
                          child: Text("$context[formatted]", style: TextStyle(fontSize: 20.0),),
                        )
                    ],),
                  );
                }
            }
        },
      ),
    );
  }
}