import 'package:client/pages/SOSFunctions/GetLocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OpenGoogleMap {
  Future launchGoogleMaps() async {
    GetLocation getLocation = GetLocation();
    Position currentPosition = await getLocation.getCurrentLocation();
    double latitude = currentPosition.latitude;
    double longitude = currentPosition.longitude;
    String url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
