// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class ApiService {
//   static String apiUrl =
//       'https://yourbaseurl/AppRemoteConfiguration/remote-configure.php';
//
//   static fetchAppConfigUrl() async {
//     final Map<String, dynamic> requestBody = {
//       "app_id": "yor partner app id",
//       "app_package_name": "com.yourapp.package",
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestBody),
//       );
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseBody = jsonDecode(response.body);
//         if (responseBody['status'] == 'success' &&
//             responseBody['data'] != null) {
//           String appConfigUrl = responseBody['data']['app_config_url'];
//           print('\n\n\n\n\n\n App Config URL: $appConfigUrl \n\n\n\n\n\n\n');
//           return appConfigUrl;
//         } else {
//           print('Error: ${responseBody['message']}');
//           throw Exception(responseBody['message'] ?? 'Unknown error occurred');
//         }
//       } else {
//         print('Failed to fetch data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }
// }
