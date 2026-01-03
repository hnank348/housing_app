import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/view/HomePage/Profile/request_details.dart';

import '../../../data/api/Owner/all_booking_request.dart';
import '../../../model/book_model.dart';

class BookingRequests extends StatelessWidget {
  const BookingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2D5C7A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Booking requests'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        actions: const [ Padding(
          padding: EdgeInsets.only(right: 20,left: 20),
          child: Icon(Icons.reorder_outlined,color: Colors.white,),
        )],
      ),
      body: FutureBuilder<BookingResponse>(
        future: getAllRequests(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.bookings.isEmpty) {
            return Center(child: Text('No requests found'.tr()));
          }

          final bookings = snapshot.data!.bookings;

          return ListView.builder(
            itemCount: bookings.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final item = bookings[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xff2D5C7A).withOpacity(0.1),
                    child: const Icon(Icons.call_missed_outgoing, color: Color(0xff2D5C7A)),
                  ),
                  title: Text(
                    "${'Order ID'.tr()}: ${item.bookingId }",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${'Client Name'.tr()}: ${item.client.firstName} ${item.client.lastName}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestDetails(booking: item),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}