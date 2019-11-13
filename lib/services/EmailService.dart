import 'package:http/http.dart' as http;

class EmailService {
  static Future<Map<String, dynamic>> sendInviteLinkEmail(
      String groupId, String email) async {
    final url = 'https://obscure-ridge-85508.herokuapp.com/api/v1/group/mail';
    http.Response response =
        await http.post(url, body: {'groupId': groupId, 'toEmail': email});

    Map<String, dynamic> data;

    data['statusCode'] = response.statusCode;
    data['body'] = response.body;

    return data;
  }
}
