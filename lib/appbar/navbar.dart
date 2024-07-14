import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/app_state.dart';

import '../styles.dart';

class PlaceMeNavBar extends StatefulWidget{
  const PlaceMeNavBar({super.key});

  @override
  State<PlaceMeNavBar> createState() => _PlaceMeNavBarState();
}

class _PlaceMeNavBarState extends State<PlaceMeNavBar> {
  @override
  Widget build(BuildContext context) {
    Color color = AppStyles.thistleColor;
    final user = Provider.of<ApplicationState>(context).currentUser;

    return NavigationBar(
      destinations: [
        NavigationDestination(icon: Icon(Icons.home, color: color), label: 'Feed'),
        Consumer<ApplicationState>(
          builder: (context, appState, child) {
            final userProfile = appState.userProfile;
            if (user != null && userProfile != null) {
              bool isAdmin = userProfile.isAdmin;
              if (isAdmin) return NavigationDestination(icon: Icon(Icons.add_box, color: color), label: 'Post');
            }
            return const SizedBox(height: 0);
          }
        ),
        NavigationDestination(icon: Icon(Icons.person, color: color), label: 'Profile'),
      ],
      backgroundColor: AppStyles.onThistleColor,
      selectedIndex: Provider.of<ApplicationState>(context).selectedIndex,
      onDestinationSelected: Provider.of<ApplicationState>(context, listen: false).onNavBarTap,
    );
  }
}