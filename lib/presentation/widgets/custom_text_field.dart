import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? asset;
  final String hint;
  final TextInputType inputType;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.asset,
    required this.hint,
    required this.inputType,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: inputType == TextInputType.visiblePassword ? true : false,
      maxLines: inputType == TextInputType.multiline ? 5 : 1,
      minLines: inputType == TextInputType.multiline ? 5 : 1,
      controller: controller,
      cursorColor: const Color(0xFF1A3C40),
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: const Color(0xFF1A3C40),
      ),
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: asset != null
            ? Container(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: SvgPicture.asset(
                  asset!,
                ),
              )
            : Container(),
        prefixIconConstraints: asset != null
            ? const BoxConstraints(minHeight: 24, minWidth: 24)
            : const BoxConstraints(maxWidth: 16, maxHeight: 0),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        isDense: true,
        filled: true,
        fillColor: const Color(0x40417D7A),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color(0xFF417D7A),
        ),
      ),
    );
  }
}