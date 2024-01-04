import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../../domain/entities/story.dart';

class DetailStoryPage extends StatefulWidget {
  final Story story;
  const DetailStoryPage({super.key, required this.story});

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {
  late LatLng location;

  @override
  Widget build(BuildContext context) {
    if (widget.story.lat != null) {
      location = LatLng(widget.story.lat!, widget.story.lon!);
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Detail Cerita',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A3C40),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: CachedNetworkImage(
                  imageUrl: widget.story.photoUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Color(0xFF1A3C40),
                        size: 28,
                      ),
                      Text(
                        widget.story.name,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1A3C40),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Color(0xFF1A3C40),
                        size: 28,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy').format(widget.story.createdAt),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1A3C40),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              widget.story.lat != null
                  ? FutureBuilder<List<geo.Placemark>>(
                      future: geo.placemarkFromCoordinates(
                          location.latitude, location.longitude),
                      builder: (context,
                          AsyncSnapshot<List<geo.Placemark>> snapshot) {
                        if (snapshot.hasData) {
                          final place = snapshot.data![0];
                          final street = place.street!;
                          final address =
                              '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                          final marker = Marker(
                            markerId: const MarkerId("source"),
                            position: location,
                            infoWindow: InfoWindow(
                              title: street,
                              snippet: address,
                            ),
                          );
                          final Set<Marker> markers = {marker};

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lokasi",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF1A3C40),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              SizedBox(
                                height: 180,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: location,
                                    zoom: 18,
                                  ),
                                  markers: markers,
                                  zoomControlsEnabled: false,
                                  mapToolbarEnabled: false,
                                  myLocationButtonEnabled: false,
                                  zoomGesturesEnabled: false,
                                  scrollGesturesEnabled: false,
                                  tiltGesturesEnabled: false,
                                  rotateGesturesEnabled: false,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1A3C40),
                            ),
                          );
                        }
                      },
                    )
                  : const SizedBox(),
              Text(
                "Deskripsi",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1A3C40),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                widget.story.description,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1A3C40),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    ),);
  }
}
