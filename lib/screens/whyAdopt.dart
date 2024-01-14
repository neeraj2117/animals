import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhyAdopt extends StatefulWidget {
  const WhyAdopt({Key? key}) : super(key: key);

  @override
  State<WhyAdopt> createState() => _WhyAdoptState();
}

class _WhyAdoptState extends State<WhyAdopt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.blue,
        title: Text('Why Adopt ?',
            style:
                GoogleFonts.barlow(fontSize: 27, fontWeight: FontWeight.w500)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 290,
              width: 500,
              child: Center(
                child: Image.asset(
                  'lib/images/adopt.png',
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: .5,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Why Adopt ?',
                            style: GoogleFonts.pacifico(
                              color: Colors.black,
                              fontSize: 55,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50), // Adjust the gap as needed
                      Text(
                        'Adopting animals is a compassionate and responsible choice for several reasons. Firstly, adopting a pet from a shelter or rescue organization provides a loving home to an animal in need. Many animals in shelters are abandoned, neglected, or surrendered due to various reasons, and by adopting them, we give them a second chance at a happy and fulfilling life. It\'s a humane way to combat the problem of pet overpopulation and reduce the number of animals euthanized in shelters each year.\n\n Secondly, adopting a pet is a rewarding experience for individuals and families. Pets bring joy, companionship, and unconditional love into our lives. They can improve our mental and physical well-being by reducing stress, providing emotional support, and encouraging regular exercise. Moreover, adopted animals often display immense gratitude, forming strong bonds with their new families. By adopting, we not only enrich our own lives but also contribute to creating a more compassionate society where animals are valued and cared for. In summary, adopting animals is a win-win situation, benefiting both the adopted pet and their human caregivers while making a positive impact on society as a whole.\n                                          ❤️❤️❤️',
                        style: GoogleFonts.barlow(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
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
}
