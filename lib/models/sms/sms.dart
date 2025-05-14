import 'package:http/http.dart' as http;

class SendSms {
  void sendSms(String number, String content) async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://www.egosms.co/api/v1/plain/?number=$number&message=$content&username=alpha22&password=Mibfrizzy22&sender=Bridge'),
      );
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
