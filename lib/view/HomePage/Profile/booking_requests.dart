import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/view/HomePage/Profile/request_details.dart';
import 'package:housing_app/itemWidget/card_item.dart';
import '../../../data/api/Owner/all_booking_request.dart';
import '../../../model/book_model.dart';

class BookingRequests extends StatefulWidget {
  const BookingRequests({super.key});

  @override
  State<BookingRequests> createState() => BookingRequestsState();
}

class BookingRequestsState extends State<BookingRequests> {
  late Future<BookingResponse> requestsList;

  @override
  void initState() {
    super.initState();
    requestsList = getAllRequests();
  }

  void Refresh() {
    setState(() {
      requestsList = getAllRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xff2D5C7A);

    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Booking requests'.tr(),
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo'
          ),
        ),
        actions: [
          IconButton(
            onPressed: Refresh,
            icon: const Icon(Icons.refresh, color: Colors.white),
          )
        ],
      ),
      body: FutureBuilder<BookingResponse>(
        future: requestsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (!snapshot.hasData || snapshot.data!.bookings.isEmpty) {
            return Empty(primaryColor, isDarkMode);
          }

          final bookings = snapshot.data!.bookings;

          return RefreshIndicator(
            onRefresh: () async => Refresh(),
            child: ListView.builder(
              itemCount: bookings.length,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemBuilder: (context, index) {
                final item = bookings[index];

                return CardItem(
                  [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: primaryColor.withOpacity(0.15),
                        child: Icon(Icons.person_pin_outlined, color: primaryColor, size: 30),
                      ),
                      title: Text(
                        "${'Order ID'.tr()}: ${item.bookingId}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Cairo'
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${'Client Name'.tr()}: ${item.client.firstName} ${item.client.lastName}",
                              style: TextStyle(color: secondaryTextColor, fontFamily: 'Cairo'),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${'Apartment'.tr()}: ${item.apartment.title}",
                              style: TextStyle(
                                  color: secondaryTextColor?.withOpacity(0.7),
                                  fontSize: 12,
                                  fontFamily: 'Cairo'
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: primaryColor.withOpacity(0.7)
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestDetails(booking: item),
                          ),
                        ).then((_) => Refresh());
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget Empty(Color color, bool isDarkMode) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calendar_month_outlined, size: 80, color: color),
            ),
            SizedBox(height: 24),
            Text(
              'No requests found'.tr(),
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : color,
                  fontFamily: 'Cairo'
              ),
            ),
            SizedBox(height: 8),
            Text(
              "You don't have any booking requests yet".tr(),
              style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey,
                  fontFamily: 'Cairo'
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: Refresh,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text('Refresh'.tr(), style: const TextStyle(color: Colors.white, fontFamily: 'Cairo')),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}