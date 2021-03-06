import 'package:http/http.dart' as http;
import 'package:tourguru/models/place_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'package:flutter/services.dart' show PlatformException;


class LocationService {
  static final _locationService = new LocationService();



  static LocationService get() {
    return _locationService;
  }

  final String detailUrl =
      "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyBLcIpermU2uTd2ny81zbPVoWXNwQ8_6JU&placeid=";
  final String url =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=6.9130779,79.9724734&radius=1500&key=AIzaSyBLcIpermU2uTd2ny81zbPVoWXNwQ8_6JU";

  Future<List<PlaceDetail>> getNearbyPlaces() async {
    var reponse = await http.get(url, headers: {"Accept": "application/json"});

    List data = json.decode(reponse.body)["results"];
    print(data);
    var places = <PlaceDetail>[];
    data.forEach((f) => places.add(new PlaceDetail(f["place_id"], f["name"],
        f["icon"], f["rating"].toString(), f["vicinity"])));

    return places;
  }

  Future getPlace(String place_id) async {
    var response = await http
        .get(detailUrl + place_id, headers: {"Accept": "application/json"});
    var result = json.decode(response.body)["result"];


    List<String> weekdays = [];
    if (result["opening_hours"] != null)
      weekdays = result["opening_hours"]["weekday_text"];
    return new PlaceDetail(
        result["place_id"],
        result["name"],
        result["icon"],
        result["rating"].toString(),
        result["vicinity"],
        result["formatted_address"],
        result["international_phone_number"],
        weekdays);
  }
//reviews.map((f)=> new Review.fromMap(f)).toList()
}
