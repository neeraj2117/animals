import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'feed_screen.dart';

class FeedbackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feedback App',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: FeedbackScreen(),
    );
  }
}
  
class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FeedScreen()));
          },
        ),
        title: Text('Provide Feedback',
            style:
                GoogleFonts.barlow(fontSize: 29, fontWeight: FontWeight.w500)),
      ),
      body: FeedbackForm(),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController email = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Lottie.asset(
              'lib/animations/feedback.json',
              height: 200,
              reverse: true,
              repeat: true,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 120,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8.0),
                ),
                maxLines: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Feedback',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8.0),
                ),
                maxLines: 10,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide feedback';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 40.0),
            SizedBox(
              height: 60.0,
              child: ElevatedButton(
                onPressed: () async {
                  // if (_formKey.currentState!.validate()) {
                  //   final feedbackText = _feedbackController.text;

                  //   final smtpServer =
                  //       gmail("3050740@rdnational.ac.in", "574253703780");

                  //   // Create the email message.
                  //   final message = Message()
                  //     ..from = Address("r3050740@rdnational.ac.in")
                  //     ..recipients.add("3050740@rdnational.ac.in")
                  //     ..subject = "Feedback from Feedback App"
                  //     ..text = feedbackText;

                  //   try {
                  //     await send(message, smtpServer);
                  //     print('Message sent successfully!');
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         content: Text('Feedback submitted successfully!'),
                  //       ),
                  //     );
                  //   } catch (e) {
                  //     print('Error sending message: $e');
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         content: Text('Failed to submit feedback.'),
                  //       ),
                  //     );
                  //   }
                  // }
                  encodeQueryParameters(Map<String, String> params) {
                    return params.entries
                        .map((MapEntry<String, String> e) =>
                            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                        .join('&');
                  }

                  final Uri emailUri = Uri(
                      scheme: 'maito',
                      path: 'royal.nanu21@gmail.com',
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Appreiacte us!!.',
                        'body': 'paisa bhej saale..'
                      }));

                  if (await canLaunchUrl(emailUri)) {
                    launchUrl(emailUri);
                  } else {
                    throw Exception('Could not launch $emailUri');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
