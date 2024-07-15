import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:placeme/appbar/appbar.dart';
import 'package:placeme/appbar/navbar.dart';
import '../functions/crop_image.dart';
import '../functions/pick_image.dart';
import '../functions/upload_image.dart';
import '/app_state.dart';
import '/functions/get_credentials.dart';
import '/styles.dart';
import 'edit_profile.dart';
import 'friends.dart';
import 'user_avatar.dart';

class PlaceMeProfilePage extends StatefulWidget {
  const PlaceMeProfilePage({super.key});

  @override
  State<PlaceMeProfilePage> createState() => _PlaceMeProfilePageState();
}

class _PlaceMeProfilePageState extends State<PlaceMeProfilePage> {

  Future<void> changeProfileImage(BuildContext context) async {
    final image = await pickImage(context);
    if (image != null) {
      final croppedImage = await cropImage(image, context);
      final croppedXFile = XFile(croppedImage!.path);
      final imageUrl = await uploadImage(croppedXFile);
      await Provider.of<ApplicationState>(context, listen: false).updateUserProfile(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ApplicationState>(context).currentUser;

    void navigateToEditProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlaceMeEditProfilePage()),
      );
    }
    void navigateToFriendsPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlaceMeFriendsPage()),
      );
    }

    return Consumer<ApplicationState>(
        builder: (context, appState, child) {
          final userProfile = appState.userProfile;
          if (user != null && userProfile != null) {
            String username = userProfile.username;
            String fullName = userProfile.fullName;
            DateTime dob = userProfile.dob;
            int registerNumber = userProfile.registerNumber;
            int phoneNumber = userProfile.phoneNumber;
            int departmentID = userProfile.departmentID;
            int genderID = userProfile.genderID;
            String photoURL = userProfile.photoURL;
            bool isAdmin = userProfile.isAdmin;

            return Scaffold(
              appBar: PlaceMeAppbar(title: username),
              endDrawer: MyDrawer(
                onSignOutTap: Provider.of<ApplicationState>(context, listen: false).signOut,
                onSettingsTap: navigateToEditProfile,
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UserAvatar(changeProfileImage: changeProfileImage, providerImage: CachedNetworkImageProvider(photoURL!)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fullName, style: AppStyles.textStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w500)),
                          Text('${getDepartment(departmentID)}, ${getGender(genderID)}', style: AppStyles.textStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: AppStyles.thistleColor.withOpacity(0.8))),
                          const SizedBox(height: 4),
                          Text('Phone: $phoneNumber', style: AppStyles.textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                          Visibility(
                              visible: !isAdmin,
                              child: Column(
                                children: [
                                  const SizedBox(height: 4),
                                  Text('Register Number: $registerNumber', style: AppStyles.textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Text('Date of birth: ${DateFormat('dd MMMM yyyy').format(dob)}', style: AppStyles.textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(
                          onPressed: navigateToEditProfile,
                          style: AppStyles.buttonStyle.copyWith(
                              side: WidgetStatePropertyAll(BorderSide(color: AppStyles.thistleColor2, width: 1.5)),
                              elevation: const WidgetStatePropertyAll(0),
                              backgroundColor: const WidgetStatePropertyAll(Colors.white),
                              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                          ),
                          child: Text('Edit Profile', style: AppStyles.textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: AppStyles.thistleColor2)),
                        )),
                        const SizedBox(width: 8),
                        Expanded(child: OutlinedButton(
                          onPressed: navigateToFriendsPage,
                          style: AppStyles.buttonStyle.copyWith(
                              side: WidgetStatePropertyAll(BorderSide(color: AppStyles.thistleColor2, width: 1.5)),
                              elevation: const WidgetStatePropertyAll(0),
                              backgroundColor: const WidgetStatePropertyAll(Colors.white),
                              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                          ),
                          child: Text('Find Friends', style: AppStyles.textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: AppStyles.thistleColor2)),
                        ))
                      ],
                    )
                  ],
                ),
              ),
              bottomNavigationBar: const PlaceMeNavBar(),
            );
          }
          if (userProfile == null) {
            return Scaffold(
              appBar: const PlaceMeAppbar(title: 'user profile is null'),
              body: const CircularProgressIndicator(color: Colors.black),
              endDrawer: MyDrawer(
                onSignOutTap: Provider.of<ApplicationState>(context, listen: false).signOut,
                onSettingsTap: navigateToEditProfile,
              ),
              bottomNavigationBar: const PlaceMeNavBar(),
            );
          }
          if (user == null) {
            return Scaffold(
              appBar: const PlaceMeAppbar(title: 'user is null'),
              endDrawer: MyDrawer(
                onSignOutTap: Provider.of<ApplicationState>(context, listen: false).signOut,
                onSettingsTap: navigateToEditProfile,
              ),
              body: const SizedBox(height: double.infinity, width: double.infinity),
              bottomNavigationBar: const PlaceMeNavBar(),
            );
          }
          return const CircularProgressIndicator(color: Colors.black);
        });
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required this.onSignOutTap,
    required this.onSettingsTap,
  });

  final void Function()? onSignOutTap;
  final void Function()? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF342E5B),
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              size: 64,
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onTap: onSettingsTap,
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white), // Optional: Style the text
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onTap: onSignOutTap,
            title: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white), // Optional: Style the text
            ),
          ),
        ],
      ),
    );
  }
}