import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/discover_post.dart';

class CommunityManifest {
  static Future<List<DiscoverPost>> loadDefaultPosts() async {
    final raw = await rootBundle.loadString('assets/Cockl_TY/users_manifest.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final users = decoded['users'] as List<dynamic>? ?? const [];
    return users
        .map((item) => DiscoverPost.fromManifestUser(item as Map<String, dynamic>))
        .toList();
  }
}
