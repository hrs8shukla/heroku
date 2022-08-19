import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<String> _data = [];

  var url = Uri.parse("https://botiphi.herokuapp.com/predict");

  //static const String BOT_URL = "https://botiphi.herokuapp.com/predict";
  TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey [300],

      appBar: AppBar(

        backgroundColor: Colors.blue,

        centerTitle: true,

        title: Text("ChatBot"),

      ),
      body: Stack(

          children: <Widget>[
            AnimatedList(

              key: _listKey,
              initialItemCount: _data.length,

              itemBuilder: (BuildContext context, int index, Animation<double> animation) {
                return buildItem(_data[index], animation, index);
              },
            ),
             Align(alignment: Alignment.bottomCenter,
              child: ColorFiltered(
                colorFilter: ColorFilter.linearToSrgbGamma(),
                child: Container(
                  color:Colors.white,
                  child:  Padding(
                    padding: EdgeInsets.only(left: 20,right: 20),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon :Icon(
                        Icons.message,
                        color: Colors.blue,

                      ),
                     hintText: "Hello",
                        fillColor: Colors.white,
                      ),
                      controller: queryController,
                      textInputAction: TextInputAction.send,
                      onSubmitted:(msg) {
                        this.getResponse();
                      },


                    ),
                  ),

                ),
              ),
            )

          ]
      ),
    );
  }


  void getResponse()
  {
    if (queryController.text.length>0)
      {
        this.insertSingleItem(queryController.text);
        var client = getClient();
        try{
          client.post(
            url,
            body: {"query" : queryController.text},
          ). then((response)
              {
                print(response.body);
                Map<String, dynamic> data
                = jsonDecode(response.body);
                insertSingleItem(data["response"] + "<bot>");

              });
        }
        finally
            {
              client.close();
              queryController.clear();
            }
      }
  }

  void insertSingleItem(String message)
  {
    _data.add(message);
    _listKey.currentState?.insertItem(_data.length-1);
  }
}
  http.Client getClient()
  {
    return http.Client();
  }
    Widget buildItem(String item, Animation<double> animation , int index)
    {
       bool mine = item.endsWith("<bot>");
       return SizeTransition(sizeFactor: animation,
         child: Padding(
         padding: EdgeInsets.only(top: 10),
           child: Container(
             alignment: mine? Alignment.topLeft: Alignment.topRight,
              child: Bubble(
                child: Text(
                  item.replaceAll("<bot>", ""),
                      style: TextStyle(
                    color: mine? Colors.white:Colors.black,
                ),

                ),
                color: mine ? Colors.blue:Colors.grey[200],
                padding: BubbleEdges.all(10),
              ),
           ),

       ),

       );
    }