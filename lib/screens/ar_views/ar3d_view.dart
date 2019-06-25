import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AR3DView extends StatefulWidget {
  AR3DView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AR3DViewState createState() => _AR3DViewState();
}

class _AR3DViewState extends State<AR3DView> {
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
            title: Text("TourGuru AR 3D View"),
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.

            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.map)),
              Tab(icon: Icon(Icons.location_city)),
            ]),
          ),
          body: TabBarView(children: <Widget>[
            new Text("AR paage"),
            new Text("AR tab page")
          ]),
        ));
  }
}
