import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:working_with_location/data/services/api_provider.dart';

class LocationRepository {
  LocationRepository({required this.apiProvider});

  final ApiProvider apiProvider;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {})
        .catchError((e) {});

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<String> getLocationName(String geoCodeText) async =>
      apiProvider.getLocationName(geoCodeText);

  Future<List<Placemark>> getAddressFromLatLong({
    required double lat,
    required double long,
  }) async =>
      placemarkFromCoordinates(lat, long);

  Future<List<Location>> getAddressFromText(
          {required String addressText}) async =>
      locationFromAddress(addressText);
}
