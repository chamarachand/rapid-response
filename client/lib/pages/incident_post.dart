import './incidentPost/data_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Incident_post extends StatelessWidget {
  const Incident_post({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Incident Post"),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                  onPressed: () {
                    //button fuctionality
                    print("button pressed");
                  },
                  child: Text("Location"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 129, 198, 255)))),
            ),
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(8.0),
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  color: Color.fromARGB(255, 27, 189, 218),
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        //add photoes and video widgets
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 2,
                  color: Color.fromARGB(255, 245, 238, 35),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 10,
                        child: Text(
                          "text description",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            //add play voice funtionality
                            print("voice recorder pressed");
                          },
                          child: Text("voice Message")),
                      SizedBox(height: 16.0),
                      Container(
                        height: MediaQuery.of(context).size.height / 12,
                        color: Color.fromRGBO(194, 232, 242, 1),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 12,
                                color: Color.fromRGBO(128, 234, 255, 1),
                              ),
                              SizedBox(height: 5.0),
                            ],
                          );
                        },
                      ),
                    ],
                  ))
            ],
          )),
        ],
      ),
    );
  }
}
