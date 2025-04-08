// import 'dart:io';
//only for mobile
// class InternetChecker {
//   static Future<bool> hasInternetConnection() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } catch (_) {
//       return false;
//     }
//   }
// }

//for website
import 'package:gymapp/main.dart';
import 'package:http/http.dart' as http;

class InternetChecker {
  static Future<bool> hasInternetConnection() async {
    try {
      const testUrls = [
        'https://www.google.com',
        'https://www.cloudflare.com',
        'https://www.apple.com',
      ];

      // Try multiple URLs in case one is blocked
      for (final url in testUrls) {
        try {
          final response = await http
              .get(Uri.parse(url))
              .timeout(const Duration(seconds: 5));
          logger.i('InternetChecker: $url statusCode: ${response.statusCode}');
          if (response.statusCode == 200) return true;
        } catch (_) {
          continue;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
