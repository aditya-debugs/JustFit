import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageOptionCard extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const ImageOptionCard({
    Key? key,
    required this.label,
    this.imageUrl,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 16),
      height: 140,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF0F5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFFFA2A55) : const Color(0xFFE8E8E8),
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              // Left side - Text label
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFFFA2A55)
                            : const Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
              ),

              // Right side - Image
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: imageUrl != null
                      ? Image.asset(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                        )
                      : _buildPlaceholder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
