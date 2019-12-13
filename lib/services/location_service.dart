//import 'dart:async';
//
//import 'package:geolocator/geolocator.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:groto/enums/location_service_state.dart';
//import 'package:location_permissions/location_permissions.dart';
//
//class LocationService {
//  final Geolocator _geolocator = Geolocator();
//  final LocationPermissions _locationPermission = LocationPermissions();
//  StreamController<LocationServiceState> locationStreamController =
//      StreamController<LocationServiceState>();
//
//  LocationService() {
//    _locationPermission.serviceStatus.listen((ServiceStatus status) {
//      locationStreamController.add(_getLocationServiceState(status));
//    });
//  }
//
//  LocationServiceState _getLocationServiceState(ServiceStatus status) {
//    switch (status) {
//      case ServiceStatus.enabled:
//        return LocationServiceState.ON;
//      case ServiceStatus.unknown:
//        return LocationServiceState.OFF;
//      case ServiceStatus.disabled:
//        return LocationServiceState.OFF;
//      case ServiceStatus.notApplicable:
//        return LocationServiceState.OFF;
//      default:
//        return LocationServiceState.OFF;
//    }
//  }
//
//  Future<bool> checkPermission() async {
//    PermissionStatus permission =
//        await LocationPermissions().checkPermissionStatus();
//    if (PermissionStatus.granted != permission)
//      permission = await LocationPermissions().requestPermissions();
//    return permission == PermissionStatus.granted ||
//        permission == PermissionStatus.restricted;
//  }
//
//  Future<LatLng> getLocation() async {
//    Position position = await _geolocator.getCurrentPosition(
//        desiredAccuracy: LocationAccuracy.high);
//    return LatLng(position.latitude, position.longitude);
//  }
//}
