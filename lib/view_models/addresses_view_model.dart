import 'package:flutter/foundation.dart';
import 'package:working_with_location/data/local/cached_address.dart';
import 'package:working_with_location/data/repositories/cache_repository.dart';
import 'package:working_with_location/utils/my_utils.dart';

class AddressesViewModel extends ChangeNotifier {
  AddressesViewModel({required CacheRepository cacheRepository})
      : _cacheRepository = cacheRepository{
   getSavedAddresses();
  }

  final CacheRepository _cacheRepository;

  String errorText = "";
  bool isLoading = false;
  List<CachedAddress> savedAddresses = [];

  void getSavedAddresses() async {
    notify(true);
    savedAddresses = await _cacheRepository.getAllCachedAddresses();
    notify(false);
  }

  void saveAddress(CachedAddress cachedAddress) async {
    notify(true);
    var savedAddress = await _cacheRepository.insertCachedAddress(
        cachedAddress: cachedAddress);
    if (savedAddress.id != null) {
      savedAddresses = await _cacheRepository.getAllCachedAddresses();
    }
    notify(false);
  }

  void deleteAddress(int addressId) async {
    notify(true);
    await _cacheRepository.deleteCachedAddressById(id: addressId);
    savedAddresses = await _cacheRepository.getAllCachedAddresses();
    MyUtils.getMyToast(message: "Manzil o'chirildi!");
    notify(false);
  }

  void deleteAllAddresses() async {
    notify(true);
    await _cacheRepository.clearAllCachedAddresses();
    savedAddresses = [];
    notify(false);
  }

  notify(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
