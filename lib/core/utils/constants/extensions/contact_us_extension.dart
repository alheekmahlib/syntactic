import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

extension ContactUsExtension on Object {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> contactUs(
      {required String subject, required String stringText}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'haozo89@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': subject, // Corrected here
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      log("No email client found");
    }
  }
}
