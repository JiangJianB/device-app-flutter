import 'package:dianjian/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Continuespotcheck extends StatefulWidget {
  @override
  _ContinuespotcheckState createState() => _ContinuespotcheckState();
}

class _ContinuespotcheckState extends State<Continuespotcheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 40,
                    child: RaisedButton(
                      child: Text("继续点检"),
                      color: Colors.pink,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => App(),
                            ));
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
