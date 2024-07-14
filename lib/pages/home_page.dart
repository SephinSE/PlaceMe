import 'package:flutter/material.dart';
import 'package:placeme/app_state.dart';
import 'package:placeme/pages/post.dart';
import 'package:placeme/pages/profile.dart';
import 'package:provider/provider.dart';

import 'feed.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  final List<Widget> pages =  const [
    PlaceMeFeedPage(),
    PlaceMePostPage(),
    PlaceMeProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return pages[context.watch<ApplicationState>().selectedIndex];
  }

}