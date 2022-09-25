import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:working_with_location/custom_packages/top_snackbar/custom_snackbar.dart';
import 'package:working_with_location/custom_packages/top_snackbar/show_top_snackbar.dart';
import 'package:working_with_location/utils/my_utils.dart';
import 'package:working_with_location/view_models/location_view_model.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late final GoogleMapController googleMapController;
  final Set<Marker> markers = {};
  CameraPosition currentCameraPosition = const CameraPosition(
      target: LatLng(41.286393176986685, 69.20411702245474), zoom: 14);
  MapType mapType = MapType.normal;
  Color color = Colors.black;

  //Text
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var yandexAddress = context.watch<LocationViewModel>().yandexAddress;
    var position = context.watch<LocationViewModel>().position;
    var latLng = context.watch<LocationViewModel>().latLng;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google MAps"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => googleMapController = controller,
            initialCameraPosition: currentCameraPosition,
            onCameraMove: (CameraPosition position) {
              currentCameraPosition = position;
            },
            mapType: mapType,
            onCameraIdle: () {
              print("IDLE");
              print("LONGITUDE:${currentCameraPosition.target.longitude}");
              print("LATITUDE:${currentCameraPosition.target.latitude}");
              context.read<LocationViewModel>().fetchAddressFromAPI(
                  geoCodeText:
                      "${currentCameraPosition.target.longitude},${currentCameraPosition.target.latitude}");
            },
            markers: markers,
          ),
          Positioned(
            top: 24,
            right: 12,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    if (position == null) {
                      showTopSnackBar(
                          context,
                          const CustomSnackBar.info(
                              message: "Position olinmadi"));
                    } else {
                      googleMapController
                          .animateCamera(CameraUpdate.newLatLngZoom(
                        LatLng(position.latitude, position.longitude),
                        14,
                      ));
                    }
                  },
                  child: const Icon(
                    Icons.gps_fixed,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  onPressed: _changeMapType,
                  child: const Icon(
                    Icons.map,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  onPressed: _addMarker,
                  child: const Icon(
                    Icons.location_on_rounded,
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.location_on_sharp,
              color: Colors.red,
              size: 35,
            ),
          ),
          Positioned(
            top: 100,
            left: 50,
            right: 50,
            child: Text(
              yandexAddress,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
              right: 50,
              left: 0,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                height: 50,
                child: TextField(
                  controller: searchController,
                  onSubmitted: (value) async {
                    if (value.length > 3) {
                      await context
                          .read<LocationViewModel>()
                          .fetchLocationFromText(addressText: value);
                     Future.delayed(const Duration(milliseconds: 500),(){
                       if (latLng != null) {
                         googleMapController.animateCamera(
                             CameraUpdate.newLatLngZoom(latLng, 14));
                       }
                     });
                    }
                  },
                  decoration: InputDecoration(
                      // suffixIcon: IconButton(
                      //   onPressed: () ,
                      //   icon: const Icon(Icons.search),
                      // ),
                      // suffixIcon: ,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
              ))
        ],
      ),
    );
  }

  void _changeMapType() {
    setState(() {
      if (mapType == MapType.normal) {
        color = Colors.white;
        mapType = MapType.hybrid;
      } else {
        color = Colors.black;
        mapType = MapType.normal;
      }
    });
  }

  Future<Uint8List> getImageIcon() async {
    return await MyUtils.getBytesFromAsset("assets/images/taxi.png", 70);
  }

  Future<void> _addMarker() async {
    print("MARKERS LENGTH:${markers.length}");
    Uint8List markerImage = await getImageIcon();
    LatLng latLng = LatLng(
      currentCameraPosition.target.latitude,
      currentCameraPosition.target.longitude,
    );
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          infoWindow: const InfoWindow(
              title: "Mening uyim", snippet: "Chustdan 13 km uzoqlikda"),
          position: latLng,
          icon: BitmapDescriptor.fromBytes(markerImage),
        ),
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    googleMapController.dispose();
    super.dispose();
  }
}
