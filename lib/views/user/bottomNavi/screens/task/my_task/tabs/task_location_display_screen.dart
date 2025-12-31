import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class TaskLocationDisplayScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String title;
  final String address;
  final bool showDirections; // 🔥 Controls visibility of direction button

  const TaskLocationDisplayScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.address,
    this.showDirections = true, // Default to true
  });

  @override
  State<TaskLocationDisplayScreen> createState() => _TaskLocationDisplayScreenState();
}

class _TaskLocationDisplayScreenState extends State<TaskLocationDisplayScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final String _googleApiKey = "AIzaSyCOMKFm2vVK0w3FRoUWJvv6wv1NvD_s60k";
  Position? _currentPosition;

  bool _isFetchingRoute = false;

  @override
  void initState() {
    super.initState();
    _setInitialMarkers();
    // Removed automatic route fetching
  }

  void _setInitialMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('taskLocation'),
          position: LatLng(widget.latitude, widget.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: widget.title,
            snippet: widget.address,
          ),
        ),
      );
    });
  }

  Future<void> _getAndDrawRoute() async {
    if (_isFetchingRoute) return;
    
    setState(() => _isFetchingRoute = true);
    
    try {
      // 1. Get current location
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        _currentPosition = await Geolocator.getCurrentPosition();
        
        if (_currentPosition != null) {
          // Add marker for user location
          setState(() {
            _markers.add(
              Marker(
                markerId: const MarkerId('userLocation'),
                position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                infoWindow: const InfoWindow(title: "My Location"),
              ),
            );
          });

          // 2. Fetch directions from Google
          await _fetchRoute();
        }
      }
    } catch (e) {
      debugPrint("Error fetching route: $e");
      Get.snackbar("Error", "Could not fetch directions. Please check your internet.");
    } finally {
      setState(() => _isFetchingRoute = false);
    }
  }

  Future<void> _fetchRoute() async {
    if (_currentPosition == null) return;

    final url = "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&"
        "destination=${widget.latitude},${widget.longitude}&"
        "key=$_googleApiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final points = data['routes'][0]['overview_polyline']['points'];
        final List<LatLng> polylineCoordinates = _decodePolyline(points);

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });

        // Zoom out to show both markers
        _fitBounds(polylineCoordinates);
      } else {
        debugPrint("Google Directions API Error: ${data['status']}");
        Get.snackbar("Notice", "Route not found between locations.");
      }
    }
  }

  void _fitBounds(List<LatLng> points) {
    if (_mapController == null || points.isEmpty) return;

    double? minLat, maxLat, minLng, maxLng;
    for (var point in points) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat!, minLng!),
          northeast: LatLng(maxLat!, maxLng!),
        ),
        80.0, // increased padding for better view
      ),
    );
  }

  // Helper method to decode Google Polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(
        title: CustomText('Task Location', fontSize: 20, fontWeight: FontVariant.bold),
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: location,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
            compassEnabled: true,
            padding: const EdgeInsets.only(bottom: 180, right: 10), // Moved controls higher up
          ),
          Positioned(
            bottom: 20,
            left: 15,
            right: 15, // Full width for better readability
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: redColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_pin, color: redColor, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText("Task Address", fontSize: 12, color: greyColor),
                            CustomText(
                              widget.address,
                              fontSize: 14,
                              fontWeight: FontVariant.medium,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.showDirections) ...[
                    const Divider(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: ElevatedButton.icon(
                        onPressed: _getAndDrawRoute,
                        icon: _isFetchingRoute 
                          ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(color: whiteColor, strokeWidth: 2))
                          : const Icon(Icons.directions, size: 18),
                        label: CustomText(
                          _isFetchingRoute ? "Loading..." : "Get Directions", 
                          color: whiteColor, 
                          fontSize: 12,
                          fontWeight: FontVariant.bold
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

