import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../../../../../../utils/colors.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(24.7136, 46.6753); // Default: Riyadh
  String _address = "Fetching address...";
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _suggestions = [];
  Timer? _debounce;
  final String _googleApiKey = "AIzaSyCOMKFm2vVK0w3FRoUWJvv6wv1NvD_s60k";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _fetchSuggestions(String input) async {
    if (input.isEmpty) {
      if (mounted) setState(() => _suggestions = []);
      return;
    }

    final url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_googleApiKey";
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && mounted) {
          setState(() {
            _suggestions = data['predictions'];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching suggestions: $e");
    }
  }

  Future<void> _searchPlace(String query) async {
    if (query.isEmpty) return;
    
    // Hide keyboard
    FocusScope.of(context).unfocus();
    
    setState(() {
      _isSearching = true;
      _suggestions = [];
    });
    
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final latLng = LatLng(loc.latitude, loc.longitude);
        
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 16),
        );
        
        setState(() {
          _selectedLocation = latLng;
          _isSearching = false;
        });
        
        _updateAddress(latLng);
      } else {
        setState(() => _isSearching = false);
        Get.snackbar("Notice", "Could not find this location. Try being more specific.");
      }
    } catch (e) {
      setState(() => _isSearching = false);
      Get.snackbar("Error", "Search failed. Please check your internet or API settings.");
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Get.snackbar("Error", "Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        Get.snackbar("Error", "Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Get.snackbar("Error", "Location permissions are permanently denied.");
      return;
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (!mounted) return;
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });

    _updateAddress(_selectedLocation);
    
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_selectedLocation, 16),
    );
  }

  Future<void> _updateAddress(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (!mounted) return;
        
        // Clean address from plus codes and redundant info
        String name = place.name ?? "";
        // If name is just a plus code (contains +), try to use subLocality or street
        if (name.contains('+')) {
          name = (place.subLocality != null && place.subLocality!.isNotEmpty) 
              ? place.subLocality! 
              : (place.street ?? "");
        }

        setState(() {
          _address = "$name, ${place.locality ?? ""}, ${place.country ?? ""}";
          _address = _address.replaceAll(RegExp(r', ,'), ',').replaceAll(RegExp(r'^, '), '').trim();
          if (_address.startsWith(',')) _address = _address.substring(1).trim();
          if (_address.endsWith(',')) _address = _address.substring(0, _address.length - 1).trim();
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _address = "Address not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText('Pick Location', fontSize: 20, fontWeight: FontVariant.bold),
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: redColor))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  onCameraMove: (position) {
                    _selectedLocation = position.target;
                  },
                  onCameraIdle: () {
                    _updateAddress(_selectedLocation);
                  },
                  onTap: (latLng) {
                    _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
                    setState(() {
                      _selectedLocation = latLng;
                    });
                    _updateAddress(latLng);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
          
          // Search Bar
          if (!_isLoading)
            Positioned(
              top: 10,
              left: 15,
              right: 15,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: blackColor.withOpacity(0.1), blurRadius: 10),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _searchPlace,
                      decoration: InputDecoration(
                        hintText: "Enter city, area or street...",
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.location_on_outlined, color: redColor),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_searchController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear, color: greyColor),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              ),
                            IconButton(
                              icon: _isSearching 
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: redColor))
                                  : const Icon(Icons.search, color: redColor),
                              onPressed: () => _searchPlace(_searchController.text),
                            ),
                          ],
                        ),
                      ),
                  onChanged: (val) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 600), () {
                      _fetchSuggestions(val);
                    });
                    setState(() {});
                  },
                ),
              ),
              // Search Suggestions List
              if (_suggestions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  constraints: const BoxConstraints(maxHeight: 250),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: blackColor.withOpacity(0.1), blurRadius: 10),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final item = _suggestions[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on_outlined, color: greyColor),
                        title: Text(item['description'], style: const TextStyle(fontSize: 14)),
                        onTap: () {
                          _searchController.text = item['description'];
                          _searchPlace(item['description']);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),

          // Center Marker
          if (!_isLoading)
            IgnorePointer(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Image.network(
                    "https://cdn-icons-png.flaticon.com/512/684/684908.png",
                    width: 45,
                    height: 45,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.location_on, color: redColor, size: 45),
                  ),
                ),
              ),
            ),

          // Bottom Info Card
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(20),
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
                            CustomText("Selected Address", fontSize: 12, color: greyColor),
                            CustomText(
                              _address,
                              fontSize: 14,
                              fontWeight: FontVariant.medium,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: 'Confirm Location',
                    bgColor: _address == "Fetching address..." || _address == "Address not found" ? greyColor : red2Color,
                    onPressed: _address == "Fetching address..." || _address == "Address not found" 
                    ? null 
                    : () {
                      Get.back(result: {
                        'address': _address,
                        'latitude': _selectedLocation.latitude,
                        'longitude': _selectedLocation.longitude,
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // My Location Button
          Positioned(
            right: 20,
            bottom: 220,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: whiteColor,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location, color: redColor),
            ),
          ),
        ],
      ),
    );
  }
}
