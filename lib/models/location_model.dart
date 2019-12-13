import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groto/enums/view_state.dart';
import 'package:groto/models/base_model.dart';
import 'package:groto/shared/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationModel extends BaseModel {
  LatLng _currentLocation;
  Map<String, dynamic> _place;
  bool _permission;
  String _token;
  SharedPreferences _preferences;
  String gkey = 'AIzaSyDSEWLXainnmT2YYnhdg35z410IfB8tuOo';

  LatLng get currentLocation => _currentLocation;

  Map<String, dynamic> get place => _place;

  bool get permission => _permission;

  String get token => _token;

  LocationModel() {
    _token = Uuid().generateV4();
    getLastKnownLocation();
  }

  setToken(String token) {
    _token = token;
  }

  setPlace({@required String placeId}) async {
    setState(ViewState.BUSY);
    try {
      final _response = await http.get(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=' +
              placeId +
              '&fields=name,geometry' +
              '&sessiontoken=' +
              _token +
              '&key=' +
              gkey);
      if (_response.statusCode == 200) {
        Map<String, dynamic> placeInfo = json.decode(_response.body);
        _place = placeInfo['result'];
        _preferences = await SharedPreferences.getInstance();
        _preferences.setString('PlaceID', placeId);
      }
    } catch (e) {
      throw e;
    } finally {
      setState(ViewState.IDLE);
    }
  }

  setCurrentLocation({@required LatLng currentLocation}) {
    _currentLocation = currentLocation;
    notifyListeners();
  }

  Future<String> getLastKnownLocation() async {
    setState(ViewState.BUSY);
    _preferences = await SharedPreferences.getInstance();
    String placeId = _preferences.getString('PlaceID');
    if (placeId != null) {
      await setPlace(placeId: placeId);
    }
    setState(ViewState.IDLE);
    return placeId;
  }
}
