import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'package:flutter/services.dart' show PlatformException;

class PPOIConfigUI extends StatefulWidget {
  PPOIConfigUI({Key loc, this.currentLocation}) : super(key: loc);

  final String currentLocation;

  @override
  _PPOIConfigUIState createState() => _PPOIConfigUIState();
}

/**
 * Set a variable as props from HomePage that sent as geo location of device
 */
//  final LatLngBounds mlbBounds= LatLngBounds(
//    southwest:  LatLng(southwestlat, southwestlon),
//    northeast:  LatLng(northeastlat, northeastlon),
//  );

class _PPOIConfigUIState extends State<PPOIConfigUI> {
  _PPOIConfigUIState();

  LocationData _startLocation;
  //To map the location latitude, longitude
  LocationData _currentLocation;
  //An listener to get all events based on location change
  StreamSubscription<LocationData> _locationSubscription;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;


  List<LatLng> _mapLongPressedPos = new List<LatLng>();

  //To map circle on the map with an id to identify selected circle(tapped)
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  Circle createdCircle;
  CircleId circleID;

  //Defines circle color
  int filColorIndex = 0;
  int strokeColorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.transparent,
    Colors.yellowAccent,
  ];

  int _circleIDCounter = 1;
  CircleId selectedCircle;

  Location _locationService = new Location();
  bool _permission = false;


  String error;

  bool currentWidget = true;

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(0,0),
    zoom: 4,
  );

  CameraPosition _currentCameraPosition;
  GoogleMap googleMap;

  double _radius = 7000;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();


    initPlatformState();

  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _addLongPressedMarker(LatLng pos) {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        pos.latitude,
        pos.longitude,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _onCircleTapped(CircleId circleId) {
    setState(() {
      selectedCircle = circleId;
    });
  }


  void _changeRadius(){
//    final Circle circle = circles[createdCircle];

    setState(() {
      circles[circleID] = createdCircle.copyWith(
        radiusParam: _radius,
      );
    });
  }

  //Add a radius Circle
  void _addCircle() {
    final int circleCount = circles.length;
    if (circleCount == 2) return;

    final String circleIDValue = 'circle_id_$_circleIDCounter';
    final CircleId circleId = CircleId(circleIDValue);
    circleID = circleId;

    final Circle circle = Circle(
        circleId: circleId,
        consumeTapEvents: true,
        strokeColor: Color.fromRGBO(255, 255, 64, 0.2),
        fillColor: Color.fromRGBO(0, 0, 205, 0.2),
        strokeWidth: 100,
        center : LatLng(_currentLocation.longitude,_currentLocation.longitude),
        radius: 7000,
        onTap: () {
          _onCircleTapped(circleId);
        });

    createdCircle = circle;
    setState(() {
      createdCircle = circle;
      circles[circleId] = circle;
    });
  }

  void initPlatformState() async {

    await _locationService.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService.onLocationChanged().listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude),
                zoom: 16
            );

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));

            if(mounted){
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if(serviceStatusResult){
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });

  }

  slowRefresh()async{
    _locationSubscription.cancel();
    await _locationService.changeSettings(accuracy: LocationAccuracy.BALANCED, interval: 10000);
    _locationSubscription = _locationService.onLocationChanged().listen((LocationData result) {
      if(mounted){
        setState(() {
          _currentLocation = result;
        });
      }
    });
  }

  static final CameraPosition _kInitialPosition =
       CameraPosition(target: LatLng(6.9146469, 79.9731601), zoom: 11.0);
  CameraPosition _position = _kInitialPosition;
  bool _isMapCreated = false;
  bool _isMoving = false;
  bool _compassEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  MapType _mapType = MapType.normal;
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _indoorViewEnabled = true;
  bool _myLocationEnabled = true;
  bool _myLocationButtonEnabled = true;
  GoogleMapController _gmapControler;
  bool _nightMode = false;
  bool _isWalking = false;
  bool _isDriving = false;

  Widget _compassToggler() {
    return MaterialButton(
      child: Text('${_compassEnabled ? 'disable' : 'enable'} compass'),
      onPressed: () {
        setState(() {
          _compassEnabled = !_compassEnabled;
        });
      },
    );
  }

  Widget _latLngBoundsToggler() {
    return FlatButton(
      child: Text(
        _cameraTargetBounds.bounds == null
            ? 'bound camera target'
            : 'release camera target',
      ),
      onPressed: () {
//        setState(() {
//          _cameraTargetBounds = _cameraTargetBounds.bounds == null
//              ? CameraTargetBounds(mlbBounds)
//              : CameraTargetBounds.unbounded;
//        });
      },
    );
  }

  Widget _zoomBoundsToggler() {
    return FlatButton(
      child: Text(_minMaxZoomPreference.minZoom == null
          ? 'bound zoom'
          : 'release zoom'),
      onPressed: () {
        setState(() {
          _minMaxZoomPreference = _minMaxZoomPreference.minZoom == null
              ? const MinMaxZoomPreference(12.0, 16.0)
              : MinMaxZoomPreference.unbounded;
        });
      },
    );
  }

  Widget _mapTypeCycler() {
    final MapType nextType =
        MapType.values[(_mapType.index + 1) % MapType.values.length];
    return FlatButton(
      child: Text('change map type to $nextType'),
      onPressed: () {
        setState(() {
          _mapType = nextType;
        });
      },
    );
  }

  Widget _rotateToggler() {
    return FlatButton(
      child: Text('${_rotateGesturesEnabled ? 'disable' : 'enable'} rotate'),
      onPressed: () {
        setState(() {
          _rotateGesturesEnabled = !_rotateGesturesEnabled;
        });
      },
    );
  }

  Widget _scrollToggler() {
    return FlatButton(
      child: Text('${_scrollGesturesEnabled ? 'disable' : 'enable'} scroll'),
      onPressed: () {
        setState(() {
          _scrollGesturesEnabled = !_scrollGesturesEnabled;
        });
      },
    );
  }

  Widget _tiltToggler() {
    return FlatButton(
      child: Text('${_tiltGesturesEnabled ? 'disable' : 'enable'} tilt'),
      onPressed: () {
        setState(() {
          _tiltGesturesEnabled = !_tiltGesturesEnabled;
        });
      },
    );
  }

  Widget _zoomToggler() {
    return FlatButton(
      child: Text('${_zoomGesturesEnabled ? 'disable' : 'enable'} zoom'),
      onPressed: () {
        setState(() {
          _zoomGesturesEnabled = !_zoomGesturesEnabled;
        });
      },
    );
  }

  Widget _indoorViewToggler() {
    return FlatButton(
      child: Text('${_indoorViewEnabled ? 'disable' : 'enable'} indoor'),
      onPressed: () {
        setState(() {
          _indoorViewEnabled = !_indoorViewEnabled;
        });
      },
    );
  }

  Widget _myLocationToggler() {
    return FlatButton(
      child: Text(
          '${_myLocationButtonEnabled ? 'disable' : 'enable'} my location button'),
      onPressed: () {
        setState(() {
          _myLocationEnabled = !_myLocationEnabled;
        });
      },
    );
  }

  Widget _myLocationButtonToggler() {
    return FlatButton(
      child: Text(
          '${_myLocationButtonEnabled ? 'disable' : 'enable'} Enable Nararted Guidance'),
      onPressed: () {
        setState(() {
          _myLocationButtonEnabled = !_myLocationButtonEnabled;
        });
      },
    );
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      _nightMode = true;
      if(_controller.isCompleted)
        _gmapControler.setMapStyle(mapStyle);
    });
  }

  Widget _travelTypeConfig(){

    if(!_isMapCreated){
      return null;
    }
    return Center(
      child: Card(
        color: Colors.lightGreen,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.card_travel),
              title: Text('Preffered Travel Options'),
              subtitle: Text('Configure the tavel method'),
            ),
            ListTile(
              title: Text('Walking'),
              trailing: Switch(
                  value: _isWalking,
                  onChanged: (bool value){
                    setState(() {
                      _isWalking = value;
                      _isDriving = !value;
                    });
                  }),
              onTap: (){
                setState(() {
                  _isDriving = _isWalking;
                  _isWalking = !_isWalking;
                });
              },

            ),
            ListTile(
              title: Text('Driving'),
              trailing: Switch(
                  value: _isDriving,
                  onChanged: (bool value){
                    setState(() {
                      _isDriving = value;
                      _isWalking = !value;
                    });
                  }),
              onTap: (){
                setState(() {
                  _isWalking = _isDriving;
                  _isDriving = !_isDriving;
                });
              },

            ),
          ],
        ),

      ),


    );
  }

  Widget _radiusOfPOIDetection(){
    if(!_isMapCreated){
      return null;
    }
    return Slider(
      label: "Set Proximity Radius",
      activeColor: Colors.orangeAccent,
      min: 1000,
      max: 50000,
      divisions: 5,
      value: _radius,
      onChanged: (double val){
        setState(() {
          _radius = val;

        });
        _changeRadius();
      },
    );
  }
  Widget _nightModeToggler() {
    if (!_isMapCreated) {
      return null;
    }
    return FlatButton(
      child: Text('${_nightMode ? 'disable' : 'enable'} night mode'),
      onPressed: () {
        if (_nightMode) {
          setState(() {
            _nightMode = false;
            _gmapControler.setMapStyle(null);
          });
        } else {
          _getFileData('assets/night_mode.json').then(_setMapStyle);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GoogleMap gMap = GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _initialCamera,
      circles: Set<Circle>.of(circles.values),
      compassEnabled: _compassEnabled,
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      mapType: _mapType,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      indoorViewEnabled: _indoorViewEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationButtonEnabled: _myLocationButtonEnabled,
      gestureRecognizers:
          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
          // https://github.com/flutter/flutter/issues/28312
          // ignore: prefer_collection_literals
          <Factory<OneSequenceGestureRecognizer>>[
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      ].toSet(),
      onCameraMove: _updateCameraPos,
      onLongPress: (LatLng pos) {
        _addLongPressedMarker(pos);
        setState(() {
          _mapLongPressedPos.add(pos);
        });
      },
      markers: Set<Marker>.of(markers.values),
    );

    final List<Widget> columnChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300.0,
            child: gMap,
          ),
        ),
      )
    ];

    if (_isMapCreated) {
      columnChildren.add(Expanded(
        child: ListView(children: <Widget>[
          Text(
              'Curreent location: ${_currentLocation.latitude} , ${_currentLocation.longitude}',
              style: TextStyle(fontSize: 18.0, color: Colors.blueAccent), textAlign: TextAlign.center),
          Text('Camaera bearing:  ${_position.bearing}'),
          Text('Camera Target: ${_position.target.latitude.toStringAsFixed(4)},'
              '${_position.target.longitude.toStringAsFixed(4)}'),
          Text('camera zoom: ${_position.zoom}'),
          Text('camera tilt: ${_position.tilt}'),
          Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
//              _compassToggler(),
//               button to get the cmera bounds to certain area
//              _latLngBoundsToggler(),
          _travelTypeConfig(),
          _radiusOfPOIDetection(),
          _mapTypeCycler(),
          _myLocationToggler(),
          _myLocationButtonToggler(),
          _nightModeToggler(),
        ]),
      ));
    }

    return _buildConfigColumn(columnChildren);
  }

  Widget _buildConfigColumn(List<Widget> widgets) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }


  void _updateCameraPos(CameraPosition pos) {
    setState(() {
      _position = pos;
    });
  }

  void onMapCreated(GoogleMapController gMapController) {
    _addCircle();
    _controller.complete(gMapController);
    setState(() {

      _isMapCreated = true;
    });
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

//  LatLng _createCenter() {
//    final double offset = _circleIDCounter.ceilToDouble();
//    if (_currentLocation == null) {
//       6.4444;
//      _currentLocation.longitude = 79.22;
//    }
//    return _createLatLng(
//        _currentLocation.latitude, _currentLocation.longitude);
////    print("Current Location<><><>Latitude:"+_currentLocation['latitude'].toString()+"longitude"+_currentLocation['longitude'].toString());
//    return _createLatLng(6.9146, 79.9726);
//  }
}
