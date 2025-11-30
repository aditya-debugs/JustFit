import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/firestore_service.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final UserService _userService = Get.find<UserService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _targetWeightController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = _userService.currentUser.value;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _ageController = TextEditingController(text: '20'); // TODO: Get from Firestore
    _heightController = TextEditingController(text: '175.3');
    _weightController = TextEditingController(text: '65.0');
    _targetWeightController = TextEditingController(text: '69.0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _userService.currentUser.value;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PROFILE EDIT',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              user.photoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultAvatar(user);
                              },
                            ),
                          )
                        : _buildDefaultAvatar(user),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 24,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Image picker
                        Get.snackbar(
                          'Coming Soon',
                          'Photo upload will be available soon',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE31E52),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Basic Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Basic',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE31E52),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildEditItem('Name', user?.displayName ?? 'User', () {
              // TODO: Edit name
            }),
            _buildEditItem('Age', '20', () {
              // TODO: Edit age
            }),
            
            const SizedBox(height: 24),
            
            // Target Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Target',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE31E52),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildEditItem('Height', '175.3 cm', () {
              // TODO: Edit height
            }),
            _buildEditItem('Starting Weight', '65.0 kg', () {
              // TODO: Edit weight
            }),
            _buildEditItem('Target Weight', '69.0 kg', () {
              // TODO: Edit target
            }),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(dynamic user) {
    return Center(
      child: Text(
        (user?.displayName ?? 'U')[0].toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildEditItem(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}