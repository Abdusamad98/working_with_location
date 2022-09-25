import 'package:working_with_location/data/local/cached_address.dart';
import 'package:working_with_location/data/local/local_database.dart';

class CacheRepository {
  Future<CachedAddress> insertCachedAddress(
      {required CachedAddress cachedAddress}) async {
    return await LocalDatabase.insertCachedAddress(cachedAddress);
  }

  Future<CachedAddress> getSingleAddressById({required int id}) async {
    return await LocalDatabase.getSingleAddressById(id);
  }

  Future<List<CachedAddress>> getAllCachedAddresses() async {
    return await LocalDatabase.getAllCachedAddresses();
  }

  Future<int> deleteCachedAddressById({required int id}) async {
    return await LocalDatabase.deleteCachedAddressById(id);
  }

  Future<int> updateCachedAddress(
      {required int id, required CachedAddress cachedAddress}) async {
    return await LocalDatabase.updateCachedAddress(cachedAddress);
  }

  Future<int> clearAllCachedAddresses() async {
    return await LocalDatabase.deleteAllCachedAddresses();
  }
}
