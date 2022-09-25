import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:working_with_location/data/repositories/location_repository.dart';

class LocationViewModel extends ChangeNotifier {
  LocationViewModel({required this.locationRepository});

  final LocationRepository locationRepository;

  String errorText = "";
  String yandexAddress = "";
  bool isLoading = false;
  Position? position;
  List<Placemark> placeMarks = [];
  List<Location> locationList = [];
  LatLng? latLng;

  fetchCurrentPosition() async {
    notify(true);
    try {
      position = await locationRepository.determinePosition();
      if (position != null) {
        notify(false);
      }
    } catch (error) {
      errorText = error.toString();
    }
    notify(false);
  }

  fetchAddressFromLatLong() async {
    notify(true);
    try {
      if (position != null) {
        placeMarks = await locationRepository.getAddressFromLatLong(
            lat: position!.latitude, long: position!.longitude);
      }
      notify(false);
    } catch (error) {
      errorText = error.toString();
      print(errorText);
    }
    notify(false);
  }

  fetchLocationFromText({required String addressText}) async {
    notify(true);
    locationList = [];
    try {
      locationList = await locationRepository.getAddressFromText(addressText: addressText);
     print("LOCATION LIST LENGTH:${locationList.length}");
      if (locationList.isNotEmpty) {
        latLng = LatLng(locationList[0].latitude, locationList[0].longitude);
      }
      notify(false);
    } catch (error) {
      errorText = error.toString();
      print(errorText);
    }
    notify(false);
  }

  fetchAddressFromAPI({required String geoCodeText}) async {
    notify(true);
    try {
      yandexAddress = await locationRepository.getLocationName(geoCodeText);
      notify(false);
    } catch (error) {
      errorText = error.toString();
    }
    notify(false);
  }

  notify(bool value) {
    isLoading = value;
    notifyListeners();
  }


}
