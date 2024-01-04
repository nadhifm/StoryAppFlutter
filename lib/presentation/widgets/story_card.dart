import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/story.dart';

class StoryCard extends StatelessWidget {
  final Story story;

  const StoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.goNamed('detail-story', extra: story);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: story.photoUrl,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: const BoxDecoration(color: Colors.grey),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0x40417D7A),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Color(0xFF1A3C40),
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            story.name,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF1A3C40),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy').format(story.createdAt),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1A3C40),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
