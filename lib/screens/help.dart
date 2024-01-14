import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final Uri phoneNumber = Uri.parse("tel:+91-7715949586");
  final Uri watsapp = Uri.parse("https://wa.me/917715949586");
  final String animalHelplineNumber = "+91-9820335799";

  // Function to make a phone call
  void _makePhoneCall() async {
    final String url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openDialPad(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching dial pad: $e');
    }
  }

  // Function to send a message
  void _sendMessage() async {
    final String url = "sms:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to show the dialog with call and message options
  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an Option"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Navigator.of(context).pop(); // Close the dialog
                // FlutterPhoneDirectCaller.callNumber('+91 7715949586');
                // // launchUrl('tel: +91 7715949586' as Uri);
                print(await canLaunchUrl(phoneNumber));
              },
              child: const Text("Call"),
            ),
            TextButton(
              onPressed: () async {
                // Navigator.of(context).pop(); // Close the dialog
                // final _sms = 'sms:$phoneNumber';
                launchUrl(watsapp);
              },
              child: Text("Message"),
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
        elevation: 1,
        backgroundColor: Colors.blue,
        title: Text(
          'Need Help ?',
          style: GoogleFonts.barlow(fontSize: 28, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Center(
                          child: Text(
                            'Basic tips for handling an injured pet.',
                            style: GoogleFonts.barlow(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 300,
                        width: 400,
                        child: Image.asset('lib/images/health.png'),
                      ),
                      // const SizedBox(height: 10),
                      const Divider(
                        color: Colors.black,
                      ),
                      _buildImageWithText(
                          imageAsset: 'lib/images/bleed.jpeg',
                          description:
                              'BLEEDING requires immediate first aid. Press down firmly on the bleeding area with your fingers or the palm of your hand, and then apply a firm, but not tight, bandage. Any long pieces of fabric or gauze can be used.'),
                      _buildImageWithText(
                          imageAsset: 'lib/images/burns.png',
                          description:
                              'BURNS can be difficult to evaluate because the fur makes it hard to examine the injury. Large deep burns need immediate attention. Use cold water on the affected area, and cover the burn with a dressing.'),
                      _buildImageWithText(
                          imageAsset: 'lib/images/choking.jpeg',
                          description:
                              'Animals that are CHOKING may cough forcefully, drool, gag, or paw at their mouth. You can try to dislodge the object by thumping the animal, squeezing on the compressions on both sides of the ribcage.'),

                      const SizedBox(height: 20),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 15.0),
                      //   child: Text(
                      //     'Bird and Animal Helpline: $animalHelplineNumber WILDLIFE: +91 9920777536 (24 HRS)                WhatsApp emergency helpline: +91 9962998886.',
                      //     style: GoogleFonts.barlow(
                      //         color: Colors.black,
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.w400),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            _openDialPad('+91-9820335799');
                          },
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.barlow(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Bird and Animal Helpline: ',
                                ),
                                TextSpan(
                                  text: '$animalHelplineNumber',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: ' WILDLIFE Helpline: ',
                                ),
                                const TextSpan(
                                  text: '+91 9920777536 (24 HRS)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text:
                                      '         WhatsApp emergency helpline: ',
                                ),
                                const TextSpan(
                                  text: '+91 9962998886',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 330.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            _showDialog(context);
                          },
                          tooltip: 'Call or Message',
                          child: const Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithText(
      {required String imageAsset, required String description}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 23.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 1.0,
                ),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageAsset,
                  height: 110,
                  width: 135,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
