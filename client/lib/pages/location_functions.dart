import 'package:client/storage/user_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// variable to keep track of the number of connected Flutter engines
int connectedFlutterEngines = 0;
// variable to store previous location
Position? previousLocation;
// variable to represent running of location services
late bool _isLocationServiceRunning;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // increasing the connectedFlutterEngines count when a new Flutter engine is connected
    connectedFlutterEngines++;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // variables to store previous lat and long in database
    double? previousLatitude;
    double? previousLongitude;

    final accessToken = await UserSecureStorage.getAccessToken();
    // retrieve previous latitude and longitude from the database
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
      print('Error fetching previous location: $e');
    }

    // checking whether previous latitude and longitude is available
    if (previousLatitude != null && previousLongitude != null) {
      // calculating the distance between previous and current locations
      double distanceInMeters = Geolocator.distanceBetween(
        previousLatitude,
        previousLongitude,
        position.latitude,
        position.longitude,
      );

      // checking whether the distance is greater 100 meters
      if (distanceInMeters > 100) {
        // updating location to the database if distance greaterthan 100m
        updateLocationToDatabase(position.latitude, position.longitude);
        print('Location updated: ${position.latitude}, ${position.longitude}');
      }
    } else {
      // updating previous location for the first time
      updateLocationToDatabase(position.latitude, position.longitude);
      print('First location recorded: ${position.latitude}, ${position.longitude}');
    }

    return Future.value(true);
  });
}

// function to update location to the database
Future<void> updateLocationToDatabase(double latitude, double longitude) async {
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
    } else {
      print('Failed to update location: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating location: $e');
  }
}

// function to start location services in background
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
  // decreasing the connectedFlutterEngines count when a Flutter engine is disconnected
  connectedFlutterEngines--;
  
  // checking whether there are no active Flutter engines before stopping the service
  if (connectedFlutterEngines <= 0) {
    Workmanager().cancelAll(); // Cancels all background tasks
    _isLocationServiceRunning = false;
  }
}

bool isLocationServiceRunning() {
  return _isLocationServiceRunning;
}