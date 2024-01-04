import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:story_app/presentation/provider/story_list_notifier.dart';

import '../../common/state_enum.dart';
import '../widgets/story_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    final storyListNotifier = context.read<StoryListNotifier>();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (storyListNotifier.pageItems != null) {
          storyListNotifier.fetchAllStories(false);
        }
      }
    });

    super.initState();
    Future.microtask(() => storyListNotifier.fetchAllStories(true));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Story App',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A3C40),
                  ),
                ),
                Text(
                  'Bagikan Momen Terbaikmu',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1A3C40),
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Cerita Terbaru',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A3C40),
                  ),
                ),
                const SizedBox(height: 16.0),
                Consumer<StoryListNotifier>(
                  builder: (context, data, child) {
                    if (data.state == RequestState.Loading &&
                        data.pageItems == 1) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1A3C40),
                        ),
                      );
                    }
                    if (data.state == RequestState.Loaded) {
                      final stories = data.stories;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.stories.length +
                            (data.pageItems != null ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == data.stories.length &&
                              data.pageItems != null) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(
                                  color: Color(0xFF1A3C40),
                                ),
                              ),
                            );
                          }
                          final story = stories[index];
                          return StoryCard(story: story);
                        },
                      );
                    } else {
                      return Center(
                        child: Text(data.message),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
