import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timecare/screens/EditProfileScreen.dart'; // Import the edit screen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Placeholder data for demonstration
  String _userName = 'Vitor Militão';
  String _userEmail = 'vitor@email.com';
  int _medicinesTaken = 12;
  int _medicinesPending = 2;
  int _medicineGoal = 14;

  // This function would typically fetch real user data
  void _fetchUserData() {
    // TODO: Implement data fetching logic here
    // For now, using static placeholder data
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Call fetch data when the widget is created
  }

  void _navigateToEditProfile() async {
    // TODO: Pass current user data to EditProfileScreen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                const EditProfileScreen(), // Navigate to EditProfileScreen
      ),
    );
    // If the edit screen returns true (indicating data was saved), refresh the profile data
    if (result == true) {
      _fetchUserData();
    }
  }

  void _logout() {
    // TODO: Implement logout logic
    print('Logout tapped');
    // Example: Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          CupertinoColors.systemGroupedBackground, // Light background color
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white, // Set background color to white
        elevation: 0,
        centerTitle: true,
        actions: const [
          // Use const if actions are static
          // Placeholder for more options if needed
          // IconButton(
          //   icon: Icon(Icons.more_vert),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture with Edit Icon
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Replace with actual user avatar/image
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFE1BEE7), // Light purple background
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.purple,
                  ), // Purple icon
                ),
                // Edit icon on avatar
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background for icon
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.blueAccent,
                  ), // Edit icon color
                ),
              ],
            ),
            const SizedBox(height: 16),
            // User Name
            Text(
              _userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // User Email
            Text(
              _userEmail,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            // Statistics Card
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Tomados', _medicinesTaken.toString()),
                    _buildStatItem('Pendentes', _medicinesPending.toString()),
                    _buildStatItem('Meta', _medicineGoal.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Settings List Card
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.edit,
                      color: Colors.black54,
                    ), // Icon color
                    title: const Text('Editar Perfil'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black54,
                    ), // Arrow icon
                    onTap: _navigateToEditProfile, // Navigate on tap
                  ),
                  Divider(
                    height: 0,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.grey[300],
                  ), // Divider
                  ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.black54,
                    ), // Icon color
                    title: const Text('Notificações'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black54,
                    ), // Arrow icon
                    onTap: () {
                      // TODO: Implement notifications settings navigation
                    },
                  ),
                  Divider(
                    height: 0,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.grey[300],
                  ), // Divider
                  ListTile(
                    leading: const Icon(
                      Icons.dark_mode,
                      color: Colors.black54,
                    ), // Icon color
                    title: const Text('Modo escuro'),
                    trailing: Switch(
                      value: false,
                      onChanged: (val) {
                        // TODO: Implement dark mode toggle logic
                      },
                    ),
                    onTap: () {
                      // Tapping the ListTile should also toggle the switch if desired
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Logout Button
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Red background
                foregroundColor: Colors.white, // White text
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 15,
                ), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ), // Rounded corners
                elevation: 2, // Shadow
              ),
              child: const Text('Sair', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
