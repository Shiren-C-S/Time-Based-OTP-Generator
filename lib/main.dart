import 'package:flutter/material.dart';
import 'totp.dart';

void main() {
  runApp(OTPApp());
}

class OTPApp extends StatefulWidget {
  @override
  _OTPAppState createState() => _OTPAppState();
}

class _OTPAppState extends State<OTPApp> {
  final TotpClient totpClient = TotpClient('http://127.0.0.1:5500');
  String enteredOtp = '';
  String statusMessage = '';
  bool isValidating = false;

  Future<void> validateOtp() async {
    if (enteredOtp.isEmpty) {
      setState(() {
        statusMessage = 'Please enter an OTP';
      });
      return;
    }

    setState(() {
      isValidating = true;
      statusMessage = '';
    });

    final isValid = await totpClient.validateOtp(enteredOtp);

    setState(() {
      isValidating = false;
      statusMessage = isValid ? 'OTP is valid!' : 'OTP is invalid!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('OTP Verification'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter the OTP below:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      enteredOtp = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: validateOtp,
                  child: isValidating
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Validate OTP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  statusMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: isValidating ? Colors.grey : (statusMessage.contains('valid') ? Colors.green : Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
