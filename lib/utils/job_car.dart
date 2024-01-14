import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  const JobCard({
    required this.dogName,
    required this.logoImagePath,
    required this.price,
  });

  final String dogName;
  final String logoImagePath;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.grey[200],
          ),
          width: 150,
          padding: const EdgeInsets.all(12.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      width: 120,
                      height: 80,
                      child: Image.asset(logoImagePath),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    dogName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                Text(
                  ' \$$price',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ]),
        ),
      ),
    );
  }
}
