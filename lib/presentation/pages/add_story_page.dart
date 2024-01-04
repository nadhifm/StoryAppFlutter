import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/state_enum.dart';
import 'package:story_app/presentation/provider/add_story_notifier.dart';
import 'package:story_app/presentation/provider/story_list_notifier.dart';
import 'package:story_app/presentation/widgets/primary_button.dart';

import '../widgets/custom_text_field.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Tambah Cerita',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A3C40),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: context.watch<AddStoryNotifier>().imagePath == null
                    ? const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image,
                          size: 80,
                        ),
                      )
                    : _showImage(),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => _onGalleryView(),
                      text: "Gallery",
                    ),
                  ),
                  const SizedBox(
                    width: 32.0,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => _onCameraView(),
                      text: "Camera",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                controller: descriptionController,
                hint: "Deskripisi",
                inputType: TextInputType.multiline,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Consumer<AddStoryNotifier>(
                builder: (context, data, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lokasi',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A3C40),
                              ),
                            ),
                            data.latLng == null && data.placemark == null
                                ? Text(
                                    'Tidak ada lokasi yang dipilih',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF1A3C40),
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.placemark!.street!,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF1A3C40),
                                        ),
                                      ),
                                      Text(
                                        '${data.placemark!.subLocality}, ${data.placemark!.locality}',
                                        overflow: TextOverflow.ellipsis,
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
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          iconSize: 32,
                          onPressed: () {
                            context.goNamed('map');
                          },
                          icon: data.latLng == null && data.placemark == null
                              ? const Icon(
                                  Icons.add_circle,
                                  color: Color(0xFF1A3C40),
                                )
                              : const Icon(
                                  Icons.edit,
                                  color: Color(0xFF1A3C40),
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              context.watch<AddStoryNotifier>().state == RequestState.Loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1A3C40),
                      ),
                    )
                  : PrimaryButton(
                      onPressed: () => _onUpload(),
                      text: "Unggah Gambar",
                    ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  _onUpload() async {
    FocusScope.of(context).unfocus();
    final addStoryNotifier = context.read<AddStoryNotifier>();
    await addStoryNotifier.addStory(descriptionController.text);

    if (!mounted) return;

    addStoryNotifier.setImageFile(null);
    addStoryNotifier.setImagePath(null);

    final state = addStoryNotifier.state;
    if (state == RequestState.Loaded) {
      context.read<StoryListNotifier>().fetchAllStories(true);
      context.goNamed("home");
    } else if (state == RequestState.Error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(addStoryNotifier.message),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  _onGalleryView() async {
    final addStoryNotifier = context.read<AddStoryNotifier>();
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      addStoryNotifier.setImageFile(pickedFile);
      addStoryNotifier.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final addStoryNotifier = context.read<AddStoryNotifier>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      addStoryNotifier.setImageFile(pickedFile);
      addStoryNotifier.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = Provider.of<AddStoryNotifier>(
      context,
      listen: false,
    ).imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }
}
