import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';

class DevModeToggle extends StatelessWidget {
  const DevModeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    
    return Obx(() => Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.developer_mode,
                  color: authService.isDevMode.value ? Colors.orange : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Development Mode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authService.isDevMode.value
                            ? 'Skip authentication while developing'
                            : 'Authentication required',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: authService.isDevMode.value,
                  onChanged: (value) => authService.toggleDevMode(value),
                  activeColor: Colors.orange,
                ),
              ],
            ),
            if (authService.isAuthenticated) ...[
              const Divider(height: 24),
              Row(
                children: [
                  Icon(
                    authService.isAnonymous ? Icons.person_outline : Icons.person,
                    size: 20,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      authService.isAnonymous
                          ? 'Signed in anonymously (Dev Mode)'
                          : 'Signed in as: ${authService.userEmail ?? authService.userName ?? "User"}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ));
  }
}