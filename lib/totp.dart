import 'package:http/http.dart' as http;
import 'dart:convert';

class TotpClient {
  final String apiUrl;

  TotpClient(this.apiUrl);

  Future<bool> validateOtp(String otp) async {
    final response = await http.post(
      Uri.parse('$apiUrl/validate-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'otp': otp}),
    );

    return response.statusCode == 200;
  }
}
