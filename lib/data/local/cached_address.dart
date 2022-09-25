const String addressTable = "cached_address";

class CachedAddressFields {
  static final List<String> values = [
    /// Add all fields
    id, addressName, addressType, createdAt, latitude,longitude
  ];
  static const String id = "_id";
  static const String addressName = "address_name";
  static const String addressType = "address_type";
  static const String createdAt = "created_at";
  static const String latitude = "latitude";
  static const String longitude = "longitude";
}

class CachedAddress {
  final int? id;
  final String addressName;
  final int addressType;
  final String createdAt;
  final double longitude;
  final double latitude;

  CachedAddress({
    this.id,
    required this.addressName,
    required this.longitude,
    required this.addressType,
    required this.latitude,
    required this.createdAt,
  });

  CachedAddress copyWith({
    int? id,
    int? addressType,
    String? addressName,
    String? createdAt,
    double? longitude,
    double? latitude,
  }) =>
      CachedAddress(
        id: id ?? this.id,
        addressType: addressType ?? this.addressType,
        addressName: addressName ?? this.addressName,
        createdAt: createdAt ?? this.createdAt,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
      );

  static CachedAddress fromJson(Map<String, Object?> json) => CachedAddress(
        id: json[CachedAddressFields.id] as int?,
        addressType: json[CachedAddressFields.addressType] as int,
        addressName: json[CachedAddressFields.addressName] as String,
        createdAt: json[CachedAddressFields.createdAt] as String,
        longitude: json[CachedAddressFields.longitude] as double,
        latitude: json[CachedAddressFields.latitude] as double,
      );

  Map<String, Object?> toJson() => {
        CachedAddressFields.id: id,
        CachedAddressFields.addressType: addressType,
        CachedAddressFields.addressName: addressName,
        CachedAddressFields.createdAt: createdAt,
        CachedAddressFields.longitude: longitude,
        CachedAddressFields.latitude: latitude,
      };

  @override
  String toString() => '''
        ID: $id 
        ADDRESS NAME $addressName
        ADDRESS TYPE $addressType
        CREATED AT $createdAt
        LONGITUDE $longitude
        LATITUDE $latitude
      ''';
}
