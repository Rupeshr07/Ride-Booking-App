import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/text_styles.dart';

class LocationSelectionScreen extends StatefulWidget {
  final String title;
  final LatLng? initialPosition;

  const LocationSelectionScreen({
    super.key,
    required this.title,
    this.initialPosition,
  });

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  GoogleMapController? _mapController;
  late LatLng _selectedPosition;
  String _selectedAddress = "Fetching address...";
  bool _isFetchingAddress = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _suggestions = [];
  Timer? _debounce;
  final String _googleMapsApiKey = "AIzaSyDj28V785a82kAE0tmEDFEEoCE-NtUatsU";

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition ?? const LatLng(37.7749, -122.4194);
    _getAddressFromLatLng(_selectedPosition);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _getSuggestions(_searchController.text);
      } else {
        setState(() {
          _suggestions = [];
        });
      }
    });
  }

  Future<void> _getSuggestions(String query) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_googleMapsApiKey&components=country:in";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          setState(() {
            _suggestions = data["predictions"];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching suggestions: $e");
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleMapsApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          final lat = data["result"]["geometry"]["location"]["lat"];
          final lng = data["result"]["geometry"]["location"]["lng"];
          final newPos = LatLng(lat, lng);
          
          _mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
          setState(() {
            _selectedPosition = newPos;
            _selectedAddress = data["result"]["formatted_address"];
            _suggestions = [];
            _searchController.text = ""; // Clear search after selection
          });
          FocusScope.of(context).unfocus();
        }
      }
    } catch (e) {
      debugPrint("Error fetching place details: $e");
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() {
      _isFetchingAddress = true;
    });
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _selectedAddress = "${place.name ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}";
          _selectedAddress = _selectedAddress.replaceAll(RegExp(r'^, | , | ,$'), '').trim();
          if (_selectedAddress.isEmpty) _selectedAddress = "Selected Location";
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = "Unknown Location";
      });
    } finally {
      setState(() {
        _isFetchingAddress = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      LatLng newPos = LatLng(position.latitude, position.longitude);
      _mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
      setState(() {
        _selectedPosition = newPos;
      });
      _getAddressFromLatLng(newPos);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not fetch current location')),
      );
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations[0];
        LatLng newPos = LatLng(location.latitude, location.longitude);
        _mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
        setState(() {
          _selectedPosition = newPos;
          _suggestions = [];
        });
        _getAddressFromLatLng(newPos);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedPosition,
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) {
              _selectedPosition = position.target;
            },
            onCameraIdle: () {
              _getAddressFromLatLng(_selectedPosition);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          
          // Center Marker Pin
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35),
              child: Image(
                image: AssetImage('assets/icons/location-pin.gif'),
                width: 60,
                height: 60,
              ),
            ),
          ),

          // Top Search Bar and Suggestions
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppConstants.intenseShadow,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search ${widget.title}...",
                            border: InputBorder.none,
                            hintStyle: AppTextStyles.bodyMedium,
                          ),
                          onSubmitted: _searchLocation,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => _searchLocation(_searchController.text),
                      ),
                    ],
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppConstants.cardShadow,
                    ),
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.location_on, color: AppColors.textSecondary),
                          title: Text(
                            _suggestions[index]["description"],
                            style: AppTextStyles.bodyMedium,
                          ),
                          onTap: () => _getPlaceDetails(_suggestions[index]["place_id"]),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // My Location Button
          Positioned(
            bottom: 210,
            right: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppConstants.intenseShadow,
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location, color: AppColors.accent, size: 24),
                onPressed: _getCurrentLocation,
              ),
            ),
          ),

          // Bottom Selection Card
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppConstants.intenseShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SELECT ${widget.title}",
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/location-pin.gif',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedAddress,
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_isFetchingAddress)
                        const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'address': _selectedAddress,
                          'position': _selectedPosition,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Confirm ${widget.title}",
                        style: AppTextStyles.buttonLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
