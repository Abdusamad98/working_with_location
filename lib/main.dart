import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_with_location/data/repositories/cache_repository.dart';
import 'package:working_with_location/data/repositories/location_repository.dart';
import 'package:working_with_location/data/services/api_client.dart';
import 'package:working_with_location/data/services/api_provider.dart';
import 'package:working_with_location/view/addresses/addresses_page.dart';
import 'package:working_with_location/view_models/addresses_view_model.dart';
import 'package:working_with_location/view_models/location_view_model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => LocationViewModel(
          locationRepository: LocationRepository(
            apiProvider: ApiProvider(
              apiClient: ApiClient(),
            ),
          ),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => AddressesViewModel(
          cacheRepository: CacheRepository(),
        ),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddressesPage(),
    );
  }
}
