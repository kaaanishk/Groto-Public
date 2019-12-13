import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/models/location_model.dart';
import 'package:groto/shared/strings.dart';
import 'package:groto/shared/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Figure out a better way
const kGoogleApiKey = "";

class PlacesAutoCompleteSearchDelegate extends SearchDelegate {
  String token = Uuid().generateV4();

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? Text('')
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        color: Colors.black,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<LocationModel>(
      builder: (context, locationModel, _) => FutureBuilder(
        initialData: null,
        future: _fetchAutoComplete(),
        builder: (context, snapshot) {
          if (query == '') {
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(poweredByGoogle),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      'Something went wrong. Check your internet or restart the app'),
                ],
              ),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CupertinoActivityIndicator(),
                    Text('Loading suggestions'),
                  ],
                ),
              );
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CupertinoActivityIndicator(),
                    Text('Loading suggestions'),
                  ],
                ),
              );
            case ConnectionState.active:
              return Column(
                children: <Widget>[
                  _placeSuggestions(context, snapshot, locationModel),
                  Image.asset(poweredByGoogle),
                ],
              );
            case ConnectionState.done:
              return Column(
                children: <Widget>[
                  _placeSuggestions(context, snapshot, locationModel),
                  Image.asset(poweredByGoogle),
                ],
              );
            default:
              return Center(
                child: Text('Something went wrong.'),
              );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchAutoComplete() async {
    if (query != '') {
//      String location = locationModel.currentLocation.latitude.toString() +
//          ',' +
//          locationModel.currentLocation.longitude.toString();
      final response = await http.get(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' +
              query +
              '&key=' +
              kGoogleApiKey +
              '&sessiontoken=' +
              token +
//              '&location=' +
//              location +
              '&components=country:in');
      if (response.statusCode == 200) {
        Map<String, dynamic> _place = json.decode(response.body);
        return _place['predictions'];
      } else {
        // Error
        return [];
      }
    }
    return [];
  }

  Widget _placeSuggestions(BuildContext context,
      AsyncSnapshot<dynamic> snapshot, LocationModel locationModel) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> _placeAutocomplete = snapshot.data[index];
        return ListTile(
          title:
              Text(_placeAutocomplete['description'].toString().split(', ')[0]),
          onTap: () async {
            locationModel.setPlace(placeId: _placeAutocomplete['place_id']);
            close(context, null);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: _fetchAutoComplete(),
      builder: (context, snapshot) {
        print(snapshot);
        if (query == '') {
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(poweredByGoogle),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Search failed please check your internet connection'),
          );
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CupertinoActivityIndicator(),
                    Text('Loading results'),
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              return Column(
                children: <Widget>[
                  _placeResult(context, snapshot),
                  Image.asset(poweredByGoogle),
                ],
              );
            default:
              return Center(
                child:
                    Text('Search failed please check your internet connection'),
              );
          }
        }
      },
    );
  }

  Widget _placeResult(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> _place = snapshot.data[index];
        return ListTile(
          title: Text(_place['description']),
          onTap: () {
            Provider.of<LocationModel>(context, listen: false)
                .setPlace(placeId: _place['place_id']);
            close(context, null);
          },
        );
      },
      shrinkWrap: true,
    );
  }
}
