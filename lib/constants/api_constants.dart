class ApiConstants {
  //static String baseUrl = 'http://192.168.100.43:3000';
  static String baseUrl = 'https://waya-api.onrender.com';
  static const port = 3000;
  static String signInEndpoint = '/driversignin';
  static String signUpEndpoint = '/driversignup';
  static String logoutEndpoint = '/logout';
  static String updateAvailabilityEndpoint = '/availability';
  static String getDriverCars = '/getdrivercars';
  static String getBalanceEndpoint = '/getbalancedriver';
  static String transferToOtherDrivers = '/tranfertodriver';
  static String chargeEndpoint = '/chargeDriver';
  static String driverAcceptRideEndpoint = '/driverAcceptRide';
  static String locationUpdatePingEndpoint = '/currentLocationPing';
  static String getUserTransfersEndpoint = '/getUserTransfers';
  static String getDepositsEndpoint = '/getDeposits';
  static String driverGetCurrentRidesEndpoint = '/driverGetCurrentRides';
  static String driverCancelRideEndpoint = '/onDriverCancelledRide';
  static String driverOnRideCompleteEndpoint = '/driverOnRideComplete';
}
