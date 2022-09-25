import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_with_location/view/addresses/widgets/address_item_view.dart';
import 'package:working_with_location/view/get_location/get_location_page.dart';
import 'package:working_with_location/view/google_map/google_map_page.dart';
import 'package:working_with_location/view_models/addresses_view_model.dart';
import 'package:working_with_location/view_models/location_view_model.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var addresses = context.watch<AddressesViewModel>().savedAddresses;
    Future.delayed(Duration.zero,(){
      Provider.of<LocationViewModel>(context,listen: false).fetchCurrentPosition();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Addresses Page"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GetLocationPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GoogleMapPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.location_on_sharp,
              color: Colors.white,
            ),),
        ],
      ),
      body: addresses.isEmpty
          ? Center(child: Image.asset("assets/images/map.png"))
          : ListView(
        padding:const EdgeInsets.symmetric(vertical: 20),
              physics: const BouncingScrollPhysics(),
              children: List.generate(addresses.length, (index) {
                var address = addresses[index];
                return AddressItemView(
                  cachedAddress: address,
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text("O'chirishni hohlaysizmi?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    context
                                        .read<AddressesViewModel>()
                                        .deleteAddress(address.id!);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Ha")),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Yo'q"))
                            ],
                          );
                        });
                  },
                );
              }),
            ),
    );
  }
}
