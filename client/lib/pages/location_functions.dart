import 'package:client/storage/user_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Variable to keep track of the number of connected Flutter engines
int connectedFlutterEngines = 0;

Position? previousLocation;
late bool _isLocationServiceRunning;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Increment the connectedFlutterEngines count when a new Flutter engine connects
    connectedFlutterEngines++;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Retrieve previous latitude and longitude from the database
    double? previousLatitude;
    double? previousLongitude;

    final accessToken = await UserSecureStorage.getAccessToken();

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/first-responder/get-latitude-longitude'),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'x-auth-token': accessToken,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        previousLatitude = data['latitude'];
        previousLongitude = data['longitude'];
      }
    } catch (e) {
      // Handle error
      print('Error fetching previous location: $e');
    }

    // Check if previous latitude and longitude are available
    if (previousLatitude != null && previousLongitude != null) {
      // Calculate distance between previous and current locations
      double distanceInMeters = Geolocator.distanceBetween(
        previousLatitude,
        previousLongitude,
        position.latitude,
        position.longitude,
      );

      // Check if distance is greater than or equal to 100 meters
      if (distanceInMeters >= 100) {
        // Update location to the database
        updateLocationToDatabase(position.latitude, position.longitude);
        print('Location updated: ${position.latitude}, ${position.longitude}');
      }
    } else {
      // Update previous location for the first time
      updateLocationToDatabase(position.latitude, position.longitude);
      print('First location recorded: ${position.latitude}, ${position.longitude}');
    }

    return Future.value(true);
  });
}

// Function to update location to the database
Future<void> updateLocationToDatabase(double latitude, double longitude) async {
  // Implement database update logic here
  // Use HTTP requests or any database library to update the location
  final accessToken = await UserSecureStorage.getAccessToken();

  try {
    final response = await http.patch(
      Uri.parse('http://10.0.2.2:3000/api/first-responder/set-latitude-longitude?latitude=$latitude&longitude=$longitude'),
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'x-auth-token': accessToken,
      },
    );
    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
      print('Failed to update location: ${response.statusCode}');
    }
  } catch (e) {
    // Handle error
    print('Error updating location: $e');
  }
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
  // Decrement the connectedFlutterEngines count when a Flutter engine disconnects
  connectedFlutterEngines--;
  
  // Check if there are no active Flutter engines before stopping the service
  if (connectedFlutterEngines <= 0) {
    Workmanager().cancelAll(); // Cancels all background tasks
    _isLocationServiceRunning = false;
  }
}

bool isLocationServiceRunning() {
  return _isLocationServiceRunning;
}