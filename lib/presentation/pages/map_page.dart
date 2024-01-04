import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';
import 'package:story_app/presentation/provider/add_story_notifier.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final jakarta = const LatLng(-6.200000, 106.816666);

  late GoogleMapController mapController;
  late final Set<Marker> markers = {};

  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: jakarta, zoom: 8),
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            markers: markers,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            onLongPress: (LatLng latLng) {
              onLongPressGoogleMap(latLng);
            },
          ),
          Positioned(
            top: 64,
            right: 24,
            child: FloatingActionButton(
              heroTag: "btn_my_location",
              backgroundColor: const Color(0xFF1A3C40),
              foregroundColor: const Color(0xFFEDE6DB),
              child: const Icon(Icons.my_location),
              onPressed: () {
                onMyLocationButtonPress();
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFFEDE6DB),
              ),
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lokasi',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A3C40),
                    ),
                  ),
                  placemark == null
                      ? Text(
                          'Tekan beberapa detik pada Map untuk memilih lokasi',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1A3C40),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              placemark!.street!,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A3C40),
                              ),
                            ),
                            Text(
                              '${placemark!.subLocality}, ${placemark!.locality}, ${placemark!.postalCode}, ${placemark!.country}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1A3C40),
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
          markers.isNotEmpty && placemark != null
              ? Positioned(
                  bottom: 120,
                  right: 24,
                  child: FloatingActionButton(
                    heroTag: "btn_select_location",
                    backgroundColor: const Color(0xFF1A3C40),
                    foregroundColor: const Color(0xFFEDE6DB),
                    child: const Icon(Icons.check),
                    onPressed: () {
                      final location = markers.first.position;
                      context.read<AddStoryNotifier>().setLatLng(location);
                      context.read<AddStoryNotifier>().setPlacemark(placemark!);
                      context.goNamed('add-story');
                    },
                  ),
                )
              : const SizedBox(),
        ],
      )),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}
