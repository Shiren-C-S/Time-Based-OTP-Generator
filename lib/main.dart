import 'package:flutter/material.dart';
import 'totp.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time-Based OTP Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OtpPage(),
    );
  }
}

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final Totp _totp = Totp(
    secret: [0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0], // Example secret
  );
  String _generatedCode = '';

  @override
  void initState() {
    super.initState();
    _updateCode();
  }

  void _updateCode() {
    setState(() {
      _generatedCode = _totp.now();
    });
  }

  void _navigateToVerifyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyPage(
          generatedCode: _generatedCode,
          onCodeVerified: _updateCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time-Based OTP Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Generated Code: $_generatedCode',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToVerifyPage,
              child: Text('Verify Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCode,
              child: Text('Regenerate Code'),
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyPage extends StatefulWidget {
  final String generatedCode;
  final VoidCallback onCodeVerified;

  VerifyPage({required this.generatedCode, required this.onCodeVerified});

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final TextEditingController _passwordController = TextEditingController();
  String _validationResult = '';

  void _validateCode() {
    final inputCode = _passwordController.text;
    final isValid = widget.generatedCode == inputCode;
    setState(() {
      _validationResult = isValid ? 'Correct OTP entered' : 'Wrong OTP entered';
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isValid ? 'Success' : 'Error'),
          content: Text(_validationResult),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Return to the OTP page
                widget.onCodeVerified(); // Regenerate OTP
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time-Based OTP Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter OTP Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: widget.generatedCode.length,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateCode,
              child: Text('Validate Code'),
            ),
            SizedBox(height: 20),
            Text(
              _validationResult,
              style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),
      ),
    );
  }
}
