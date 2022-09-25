import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:working_with_location/data/local/cached_address.dart';

class AddressItemView extends StatelessWidget {
  const AddressItemView(
      {Key? key, required this.cachedAddress, required this.onLongPress})
      : super(key: key);
  final CachedAddress cachedAddress;
  final GestureLongPressCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.grey.shade300,
                spreadRadius: 4,
                offset: const Offset(2, 3),
              ),
            ]),
        child: Row(
          children: [
            getAddressIcon(cachedAddress.addressType),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cachedAddress.addressName,
                    style: const TextStyle(color: Colors.blue, fontSize: 16),
                    maxLines: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "(${cachedAddress.longitude}, ${cachedAddress.latitude})",
                      ),
                      Text(
                        DateFormat.yMMMd()
                            .format(DateTime.parse(cachedAddress.createdAt)),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getAddressIcon(int type) {
    if (type == 1) {
      return const Icon(
        Icons.home,
        size: 35,
        color: Colors.green,
      );
    } else if (type == 2) {
      return const Icon(
        Icons.work,
        size: 35,
        color: Colors.teal,
      );
    }else if (type == 3) {
      return const Icon(
        Icons.school,
        size: 35,
        color: Colors.red,
      );
    } else {
      return const Icon(
        Icons.location_city,
        size: 35,
        color: Colors.brown,
      );
    }
  }
}
