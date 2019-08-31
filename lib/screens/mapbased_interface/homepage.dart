import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tourguru/screens/ar_views/POI_List.dart';
import 'package:tourguru/screens/ar_views/ar3d_view.dart';
import 'package:tourguru/screens/ar_views/ar_location_poi_ui.dart';
import 'package:tourguru/screens/audio_guidance_ui/audio_tourpage.dart';
import 'package:tourguru/screens/mapbased_interface/place_details_page.dart';
import 'package:tourguru/models/place_model.dart';
import 'package:tourguru/services/google_maps_requests.dart';
import 'package:tourguru/services/google_place_service.dart';
import '../../radial_menu/flutter_radial_menu.dart';
//import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

Marker malabeMarker = Marker(
  markerId: MarkerId('malabe1'),
  position: LatLng(6.9356725, 79.9842310),
  infoWindow: InfoWindow(title: 'Kaduwela'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueMagenta,
  ),
);

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  String _destination = "(6.9356725,79.9842310)";
  String _source = "(6.9130779,79.9724734)";

//
//  var geolocator = Geolocator();
//  Position position;

  //
//  var geolocator = Geolocator();
//  Position position;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
//  final Set<Polyline> _polyLines = {};
//  Position position;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    if (_places == null) {
      LocationService.get().getNearbyPlaces().then((data) {
        this.setState(() {
          _places = data;
        });
      });
    }
  }

  double zoomVal = 5.0;
  String _currentPlaceId;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    onItemTapped = () => Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
        new PlaceDetailPage(_currentPlaceId)));
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("TourGuru"),
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.

            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.map)),
              Tab(icon: Icon(Icons.location_city)),
            ]),

            actions: <Widget>[
              IconButton(
                  icon: Icon(FontAwesomeIcons.searchLocation),
                  onPressed: () {
                    //Navigation Pane

                    Drawer drawer = new Drawer();

                    return drawer;
                  }),
            ],
          ),
          drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: new Text("username"),
                  accountEmail: new Text("useremail@mail.com"),
                  currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: new Text("T"),
                  ),
                ),
                new ListTile(
                    title: new Text(
                      "Travel Map",
                    ),
                    trailing: new Icon(FontAwesomeIcons.mapSigns),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }));
                    }),
                new Divider(),
                new ListTile(
                    title: new Text(
                      "AR 3D",
                    ),
                    trailing: new Icon(FontAwesomeIcons.objectGroup),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ARListView();
                          }));
                    }),
                new ListTile(
                    title: new Text(
                      "AR POI",
                    ),
                    trailing: new Icon(FontAwesomeIcons.accusoft),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ARPOIView();
                          }));
                    }),
                new ListTile(
                    title: new Text(
                      "Audio Tour",
                    ),
                    trailing: new Icon(FontAwesomeIcons.teamspeak),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return AudioTour();
                          }));
                    }),
                new Divider(),
                new ListTile(
                  title: new Text("Close"),
                  trailing: new Icon(Icons.close),
                  onTap: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartTop,
          floatingActionButton: new RadialMenu(
            items: <RadialMenuItem<int>>[
              const RadialMenuItem<int>(
                  value: 1, child: const Icon(Icons.map, size: 50)),
              const RadialMenuItem<int>(
                  value: 2, child: const Icon(Icons.camera_front, size: 50)),
              const RadialMenuItem<int>(
                  value: 3, child: const Icon(Icons.audiotrack, size: 50)),
              const RadialMenuItem<int>(
                  value: 4, child: const Icon(Icons.explore, size: 60)),
            ],
            radius: 100.0,
            onSelected: null,
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Stack(children: <Widget>[
                //Create Google Map Interface
                _googlemap(context),
                Positioned(
                  top: 50.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: locationController,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "pick up",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 105.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: destinationController,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
//                        sendRequest(value);
                      },
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.local_taxi,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "destination?",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),

//        Positioned(
//          top: 40,
//          right: 10,
//          child: FloatingActionButton(onPressed: _onAddMarkerPressed,
//          tooltip: "aadd marker",
//          backgroundColor: black,
//          child: Icon(Icons.add_location, color: white,),
//          ),
                _zoomminusfunction(),
                _zoomplusfunction(),
                _compassFunc(),
                _buildContainer(),
              ]),
              _createContent(),
            ],
          ),
        )
      //      Center(
//        // Center is a layout widget. It takes a single child and positions it
//        // in the middle of the parent.
//        child: Column(
//          // Column is also layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug painting" (press "p" in the console, choose the
//          // "Toggle Debug Paint" action from the Flutter Inspector in Android
//          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//          // to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add_alarm),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _compassFunc() {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 150.0,
          child: FloatingActionButton(
            onPressed: () => {_currentPosition},
            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: Colors.green,
            child: const Icon(Icons.add_location, size: 36.0),
          ),
        ));
  }

  void _currentPosition() {
    var markerIdVal = new DateTime.now().millisecondsSinceEpoch.toString();
    final MarkerId markerId = MarkerId(markerIdVal);

    StreamSubscription _getPositionSubscription;
//    var locationOptions = LocationOptions (accuracy: LocationAccuracy.high,timeInterval: 10);
//    _getPositionSubscription = geolocator.getPositionStream(locationOptions).listen(
//        (Position position){
//          this.position=position;
//          print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
//          _mapController.animateCamera(
//              CameraUpdate.newCameraPosition(
//                CameraPosition(
//                    target: LatLng(position.latitude,position.longitude), zoom: 20.0),
//              ),
//          );
//        });
  }

//    final Marker marker = Marker(
//        markerId: markerId,
//
//        position: LatLng(
////          center.latitude + sin(_markedIdCounter*pi/6.0)/20.0,
//          6.9356725,
//          79.9842310,
////          center.longitude + cos(_markedIdCounter*pi/6.0)/20.0,
//        ),
//    ),
//    infoWindow:InfoWindow(title:markedIdVal,snippet:'*'),
//    onTap:(){
//      _onMarker
//
//    }
//

//  }
//

  Widget _createContent() {
    if (_places == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new ListView(
        children: _places.map((f) {
          return new Card(
            child: new ListTile(
                title: new Text(
                  f.name,
                  style: _biggerFont,
                ),
                leading: new Image.network(f.icon),
                subtitle: new Text(f.vicinity),
                onTap: () {
                  _currentPlaceId = f.id;
                  // onItemTapped();
                  handleItemTap(f);
                }),
          );
        }).toList(),
      );
    }
  }

  List<PlaceDetail> _places;

  handleItemTap(PlaceDetail place) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new PlaceDetailPage(place.id)));
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment(1, -0.8),
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchMinus, color: Color(0xff6200ee)),
          onPressed: () {
            zoomVal--;
            _minus(zoomVal);
          }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchPlus, color: Color(0xff6200ee)),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: malabeMarker.position, zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: malabeMarker.position, zoom: zoomVal)));
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no",
                  6.9356725,
                  79.9842310,
                  "Kaduwela"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://lh5.googleusercontent.com/p/AF1QipMKRN-1zTYMUVPrH-CcKzfTo6Nai7wdL7D8PMkt=w340-h160-k-no",
                  6.9130779,
                  79.9724734,
                  "Blue Hill"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(
      String _image, double lat, double long, String destinationName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(destinationName),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(String destinationName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
                destinationName,
                style: TextStyle(
                    color: Color(0xff6200ee),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Text(
                      "4.1",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStarHalf,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                    child: Text(
                      "(946)",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
              ],
            )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
              "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
              "Closed \u00B7 Opens 17:00 Thu",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  Widget _googlemap(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(

          mapType: MapType.normal,
          initialCameraPosition:
          CameraPosition(target: LatLng(6.9356725, 79.9842310), zoom: 12),
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          rotateGesturesEnabled: true,
          myLocationEnabled: true,
          compassEnabled: true,
          zoomGesturesEnabled: true,

          onMapCreated: _onCreated,
          markers: _markers,
          onCameraMove: _onCameraMove,
          polylines: _polyLines,
//          markers: {malabeMarker, malabeMarker2},
        ));
  }

  void _onCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _controller.complete(controller);
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void _addMarker(LatLng location, String address) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastPosition.toString()),
          position: location,
          infoWindow: InfoWindow(title: address, snippet: "go here"),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  void createRoute(String encondedPoly) {
    setState(() {
      _polyLines.add(Polyline(
          polylineId: PolylineId(_lastPosition.toString()),
          width: 10,
          points: convertToLatLng(decodePoly(encondedPoly)),
          color: Colors.black));
    });
  }

/*
* [12.12, 312.2, 321.3, 231.4, 234.5, 2342.6, 2341.7, 1321.4]
* (0-------1-------2------3------4------5-------6-------7)
* */

//  this method will convert list of doubles into latlng
  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }
//
//  void _getUserLocation() async {
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    List<Placemark> placemark = await Geolocator()
//        .placemarkFromCoordinates(position.latitude, position.longitude);
//    setState(() {
//      _initialPosition = LatLng(position.latitude, position.longitude);
//      locationController.text = placemark[0].name;
//    });
//  }
////
//  void sendRequest(String intendedLocation) async {
//    List<Placemark> placemark =
//        await Geolocator().placemarkFromAddress(intendedLocation);
//    double latitude = placemark[0].position.latitude;
//    double longitude = placemark[0].position.longitude;
//    LatLng destination = LatLng(latitude, longitude);
//    _addMarker(destination, intendedLocation);
//    String route = await _googleMapsServices.getRouteCoordinates(
//        _initialPosition, destination);
//    createRoute(route);
//  }


  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

  VoidCallback onItemTapped;
}

Marker malabeMarker2 = Marker(
  markerId: MarkerId('malabe2'),
  position: LatLng(6.9130779, 79.9724734),
  infoWindow: InfoWindow(title: 'SLIIT'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueMagenta,
  ),
);

//  Marker malabeMarker = new Marker(
//      'Kaduwela1', 'Kaduwela', 6.9356725, 79.9842310,
//      draggable: true, color: Colors.teal);
//
//  Marker malabeMarker2 = Marker('malabe2', 'SLIIT', 6.9130779, 79.9724734,
//      draggable: true, color: Colors.teal);
