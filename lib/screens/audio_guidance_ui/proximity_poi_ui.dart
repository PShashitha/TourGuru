import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'package:flutter/services.dart' show PlatformException;


class PPOIConfigUI extends StatefulWidget{
  PPOIConfigUI({Key loc, this.currentLocation }) : super(key:loc);

  final String currentLocation;

  @override
  _PPOIConfigUIState createState() => _PPOIConfigUIState();

  }

final LatLngBounds mlbBounds= LatLngBounds(
  southwest: const LatLng(6.8880244, 79.9494517),
  northeast: const LatLng(6.9418313, 80.0212095),
);


class _PPOIConfigUIState extends State<PPOIConfigUI>{

  _PPOIConfigUIState();

  Map<String, double>   _currentLocation = new Map();
  StreamSubscription<Map<String,double>> locationSubscription;


  Location location = new Location();
  String error;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState(){
    super.initState();

    //Default variable initialized to 0
    _currentLocation['latitude'] = 0.0;
    _currentLocation['longitude'] = 0.0;

    initPlatformState();

    locationSubscription = location.onLocationChanged().listen((Map<String,double> result){

      setState(() {
        _currentLocation = result;
      });
    });

  }


  void initPlatformState () async{

    Map<String,double> my_location;
    try{
      my_location = await location.getLocation();
      error = "";
    }on PlatformException catch(e){
        if(e.code == 'PERMISSION_DENIED')
          error = "Permission Denied";
        else if(e.code == 'PERMISSION_DENIED_NEVER_ASK')
          error = "Permission Denied - Give the needed permission to get current location.";
        my_location = null;
    }

    setState(() {
      _currentLocation = my_location;
    });
  }




  static final CameraPosition _kInitialPosition = const CameraPosition(
      target: LatLng(6.9145910,79.9726142 ),
    zoom:11.0
  );
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
  GoogleMapController _controller;
  bool _nightMode = false;



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
        setState(() {
          _cameraTargetBounds = _cameraTargetBounds.bounds == null
              ? CameraTargetBounds(mlbBounds)
              : CameraTargetBounds.unbounded;
        });
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
          '${_myLocationButtonEnabled ? 'disable' : 'enable'} my location button'),
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
      _controller.setMapStyle(mapStyle);
    });
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
            _controller.setMapStyle(null);
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
      initialCameraPosition: _kInitialPosition,
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
      onCameraMove: _updateCameraPos,
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

    if (_isMapCreated){
      columnChildren.add(
        Expanded(
          child: ListView(
            children: <Widget>[
              Text('Curreent location: ${_currentLocation['latitude']} , ${_currentLocation['longitude']}',style: TextStyle(fontSize: 20.0,color: Colors.blueAccent)),
              Text('Camaera bearing:  ${_position.bearing}'),
              Text(
                'Camera Target: ${_position.target.latitude.toStringAsFixed(4)},'
                    '${_position.target.longitude.toStringAsFixed(4)}'),
              Text('camera zoom: ${_position.zoom}'),
              Text('camera tilt: ${_position.tilt}'),
              Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
              _compassToggler(),
              _latLngBoundsToggler(),
              _mapTypeCycler(),
              _zoomBoundsToggler(),
              _rotateToggler(),
              _scrollToggler(),
              _tiltToggler(),
              _zoomToggler(),
              _indoorViewToggler(),
              _myLocationToggler(),
              _myLocationButtonToggler(),
              _nightModeToggler(),

            ]
          ),
        )
      );
    }

   return Column(
     mainAxisAlignment: MainAxisAlignment.start,
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: columnChildren,
   );
  }

  Widget _buildConfigColumn(){
    return Column(

    );
  }

  void  _updateCameraPos(CameraPosition pos){
    setState(() {
      _position = pos;
    });
  }

  void onMapCreated(GoogleMapController gMapController){
    setState(() {
      _controller = gMapController;
      _isMapCreated = true;
    });
  }
}