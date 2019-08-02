import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourguru/screens/audio_guidance_ui/proximity_poi_ui.dart';
import 'package:tourguru/screens/audio_guidance_ui/speech_config_ui.dart';

class AudioTour extends StatefulWidget {
  AudioTour({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AudioTourState createState() => _AudioTourState();
}

class _AudioTourState extends State<AudioTour> {
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
            title: Text("TourGuru AudioTour"),
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.

            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.map)),
              Tab(icon: Icon(Icons.location_city)),
            ]),
          ),
          body: TabBarView(children: <Widget>[
            PPOIConfigUI(currentLocation : "Configuration of Proximity POI detection"),
            SpeechConfig(),
          ]),
        ));
  }
}
