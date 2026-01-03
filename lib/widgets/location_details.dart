import 'package:flutter/material.dart';

class LocationDetails extends StatelessWidget {
 const LocationDetails({super.key,required this.address,required this.price});
 final String address;
 final double price ;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 20, color: Colors.blue),
              Text(
                address,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

            ],

          ),
        ),
          Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    const Icon(Icons.attach_money, size: 20, color: Colors.blue),
    Text(
    '$price',
    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
      ],
    ),
    ),
    ],
    );

  }
}
