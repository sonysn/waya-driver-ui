///A Class Representing the Ride History of Drivers
class RideHistory {
  /// The date the ride was requested.
  final String requestDate;

  /// The pickup address for the ride.
  final String pickupAddress;

  /// The drop-off address for the ride.
  final String dropOffAddress;

  /// The fare for the ride.
  final int fare;

  /// The status of the ride.
  final String status;

  /// Creates a new instance of the [RideHistory] class.
  RideHistory({
    required this.requestDate,
    required this.pickupAddress,
    required this.dropOffAddress,
    required this.fare,
    required this.status,
  });

  /// Creates a new instance of the [RideHistory] class from a JSON map.
  ///
  /// The [json] parameter should contain the following keys:
  ///
  /// - `REQUEST_DATE`: A string representing the date the ride was requested.
  /// - `PICKUP_LOCATION`: A string representing the pickup address.
  /// - `DROPOFF_LOCATION`: A string representing the drop-off address.
  /// - `FARE`: An integer representing the fare for the ride.
  /// - `STATUS`: A string representing the status of the ride.

  factory RideHistory.fromJson(Map<String, dynamic> json) {
    return RideHistory(
      requestDate: json['REQUEST_DATE'],
      pickupAddress: json['PICKUP_LOCATION'],
      dropOffAddress: json['DROPOFF_LOCATION'],
      fare: json['FARE'],
      status: json['STATUS'],
    );
  }
}
