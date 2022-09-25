import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_with_location/custom_packages/top_snackbar/custom_snackbar.dart';
import 'package:working_with_location/custom_packages/top_snackbar/show_top_snackbar.dart';
import 'package:working_with_location/data/local/cached_address.dart';
import 'package:working_with_location/view/get_location/widgets/my_custom_expension.dart';
import 'package:working_with_location/view_models/addresses_view_model.dart';
import 'package:working_with_location/view_models/location_view_model.dart';

class GetLocationPage extends StatefulWidget {
  const GetLocationPage({Key? key}) : super(key: key);

  @override
  State<GetLocationPage> createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {
  final TextEditingController controller = TextEditingController();
  String typeText = "";

  @override
  Widget build(BuildContext context) {
    bool loader = context.watch<LocationViewModel>().isLoading;
    var placeMarks = context.watch<LocationViewModel>().placeMarks;
    var locations = context.watch<LocationViewModel>().locationList;
    var yandexAddress = context.watch<LocationViewModel>().yandexAddress;
    var position = context.watch<LocationViewModel>().position;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lakatsiya va Manzilni olish"),
      ),
      body: loader
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(32),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('''
                        ${position.toString()},
                        speed: ${position?.speed},
                        accuracy: ${position?.accuracy},
                        altitude: ${position?.altitude},
                        floor: ${position?.floor},
                        timestamp: ${position?.timestamp},
                     '''),
                    TextButton(
                      onPressed: () {
                        context
                            .read<LocationViewModel>()
                            .fetchCurrentPosition();
                      },
                      child: const Text("Get Location from Geolocator"),
                    ),
                    Visibility(
                      visible: position != null,
                      child: TextButton(
                        onPressed: () {
                          if (position != null) {
                            context.read<LocationViewModel>().fetchAddressFromAPI(
                                geoCodeText:
                                    "${position.longitude},${position.latitude}");
                          }
                        },
                        child: const Text("Get Address from  Yandex API"),
                      ),
                    ),
                    Text("Yandex API Address:$yandexAddress"),
                    Visibility(
                        visible:
                            ((position != null) && yandexAddress.isNotEmpty),
                        child: Column(
                          children: [
                            TextButton(
                                onPressed: () {
                                  if (typeText.isNotEmpty) {
                                    CachedAddress cachedAddress = CachedAddress(
                                      addressName: yandexAddress,
                                      longitude: position!.longitude,
                                      addressType: getAddressType(typeText),
                                      latitude: position.latitude,
                                      createdAt: DateTime.now().toString(),
                                    );
                                    context
                                        .read<AddressesViewModel>()
                                        .saveAddress(cachedAddress);
                                    showTopSnackBar(
                                      context,
                                      CustomSnackBar.success(
                                        message: "Manzil qo'shildi!",
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                  }
                                },
                                child: const Text("SAVE")),
                            MyCustomExpansion(
                              types: const ["Home", "Work", "Study", "Other"],
                              typeText: typeText,
                              onPresses: (value) {
                                setState(() {
                                  typeText = value;
                                });
                              },
                            ),
                          ],
                        )),
                    // TextButton(
                    //   onPressed: () {
                    //     context
                    //         .read<LocationViewModel>()
                    //         .fetchAddressFromLatLong();
                    //   },
                    //   child: const Text("Get Address with Geocoding package"),
                    // ),
                    // TextField(controller: controller),
                    // TextButton(
                    //     onPressed: () {
                    //       if (controller.text.isNotEmpty) {
                    //         context
                    //             .read<LocationViewModel>()
                    //             .fetchLocationFromText(
                    //                 addressText: controller.text);
                    //       }
                    //     },
                    //     child: const Text("Get Location from Input Address")),
                  ],
                ),
              ),
            ),
    );
  }

  int getAddressType(String typeText) {
    switch (typeText) {
      case "Home":
        return 1;
      case "Work":
        return 2;
      case "Study":
        return 3;
      default:
        return 4;
    }
  }
}
