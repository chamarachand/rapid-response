import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

Position? previousLocation;
late bool _isLocationServiceRunning;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Check if previous location is available
    if (previousLocation != null) {
      // Calculate distance between previous and current locations
      double distanceInMeters = Geolocator.distanceBetween(
        previousLocation!.latitude,
        previousLocation!.longitude,
        position.latitude,
        position.longitude,
      );

      // Update previous location
      previousLocation = position;

      // Check if distance is greater than or equal to 100 meters
      if (distanceInMeters >= 100) {
        // Update location to the database
        // Here you should implement the code to update the location to your database
        print('Location updated: ${position.latitude}, ${position.longitude}');
      }
    } else {
      // Update previous location for the first time
      previousLocation = position;
    }

    return Future.value(true);
  });
}

void startLocationService() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager().registerPeriodicTask(
    '1',
    'backgroundTask',
    frequency: Duration(minutes: 15),
  );
  _isLocationServiceRunning = true;
}

void stopLocationService() {
  Workmanager().cancelAll(); // Cancels all background tasks
  _isLocationServiceRunning = false;
}

bool isLocationServiceRunning() {
  return _isLocationServiceRunning;
}
