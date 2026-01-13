import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/data/api/Owner/approved_request.dart';
import 'package:housing_app/data/api/Owner/delete_request.dart';
import 'package:housing_app/data/api/Owner/reject_request.dart';
import 'package:housing_app/itemWidget/button.dart';

import '../../../model/book_model.dart';

class RequestDetails extends StatefulWidget {
  const RequestDetails({super.key, required this.booking});
  final BookingModel booking;

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  // متغير لتخزين الحالة الحالية والتحكم بظهور الأزرار
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.booking.ownerApproval; // القيمة القادمة من السيرفر
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool?> showConfirmDialog(BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title.tr()),
        content: Text(content.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2D5C7A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Order details'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Icon(Icons.details, color: Colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('${'Client Name'.tr()} : ${widget.booking.client.firstName} ${widget.booking.client.lastName}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'PurplePurse')),
                const SizedBox(height: 10),
                Text('${'Real state name'.tr()} : ${widget.booking.apartment.title}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'PurplePurse')),
                const SizedBox(height: 10),
                Text('${'Real state ID'.tr()} : ${widget.booking.apartment.id}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'PurplePurse')),
                const SizedBox(height: 10),
                Text('${'Order ID'.tr()} : ${widget.booking.bookingId}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'PurplePurse')),
                const SizedBox(height: 10),
                Text('${'Start Date'.tr()} : ${widget.booking.startDate}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'PurplePurse')),
                const SizedBox(height: 10),
                Text('${'End Date'.tr()} : ${widget.booking.endDate}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'PurplePurse')),
                const SizedBox(height: 10),
                Text('${'Price / Day'.tr()} : ${widget.booking.totalPrice}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'PurplePurse')),
                const SizedBox(height: 10),
                Text('${'Order status'.tr()} : ${currentStatus.tr()}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'PurplePurse')),
                const SizedBox(height: 40),

                if (currentStatus != 'approved' && currentStatus != 'rejected')
                  Button(
                    text: 'Approved'.tr(),
                    color: const Color(0xff2D5C7A),
                    colorText: Colors.white,
                    onPressed: () async {
                      bool? confirm = await showConfirmDialog(context, 'Confirm Approval', 'Are you sure you want to approve this request?');
                      if (confirm == true) {
                        String result = await ApprovedRequests(widget.booking.bookingId, widget.booking.client.id);
                        if (context.mounted) {
                          showMessage(context, result);
                          setState(() {
                            currentStatus = 'approved';
                          });
                        }
                      }
                    },
                  ),

                if (currentStatus != 'approved' && currentStatus != 'rejected')
                  const SizedBox(height: 20),

                if (currentStatus != 'approved' && currentStatus != 'rejected')
                  Button(
                    text: 'Reject'.tr(),
                    color: const Color(0xff2D5C7A),
                    colorText: Colors.white,
                    onPressed: () async {
                      bool? confirm = await showConfirmDialog(context, 'Confirm Rejection', 'Are you sure you want to reject this request?');
                      if (confirm == true) {
                        String result = await RejectRequests(widget.booking.bookingId, widget.booking.client.id);
                        if (context.mounted) {
                          showMessage(context, result);
                          setState(() {
                            currentStatus = 'rejected';
                          });
                        }
                      }
                    },
                  ),

                if (currentStatus != 'approved' && currentStatus != 'rejected')
                  const SizedBox(height: 20),

                Button(
                  text: 'Delete'.tr(),
                  color: const Color(0xff2D5C7A),
                  colorText: Colors.white,
                  onPressed: () async {
                    bool? confirm = await showConfirmDialog(context, 'Confirm Deletion', 'Are you sure you want to delete this request?');
                    if (confirm == true) {
                      String result = await DeleteRequests(widget.booking.bookingId, widget.booking.client.id);
                      if (context.mounted) {
                        showMessage(context, result);
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}