import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ARPOIView extends StatefulWidget {
  ARPOIView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ARPOIViewState createState() => _ARPOIViewState();
}

class _ARPOIViewState extends State<ARPOIView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("TourGuru AR POI View"),
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.

            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.map)),
              Tab(icon: Icon(Icons.location_city)),
            ]),
          ),
          body: TabBarView(children: <Widget>[
            new Text("AR page"),
            new Text("Q&A")
          ]),
        ));
  }
}
