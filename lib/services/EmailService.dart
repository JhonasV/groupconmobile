import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class EmailService {
  static Future<Map<String, dynamic>> sendInviteLinkEmail(
      String groupId, String email) async {
    final url = '$API_URI/api/v1/group/mail';
    http.Response response =
        await http.post(url, body: {'groupId': groupId, 'toEmail': email});

    Map<String, dynamic> data = {
      'statusCode': response.statusCode,
      'body': response.body
    };

    return data;
  }
}
