import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  const DefaultButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Icon(
                label == 'Comparar exames'
                    ? Icons.compare_arrows
                    : Icons.get_app,
                color: Colors.white,
              ),
        label: Text(
          label,
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
