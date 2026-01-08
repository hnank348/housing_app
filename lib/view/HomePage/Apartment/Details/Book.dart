import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/data/api/Book/Book_api.dart';
import 'package:housing_app/itemWidget/button.dart';
import '../../../../itemWidget/text_field.dart';

class Book extends StatefulWidget {
  final int apartmentId;

  const Book({super.key, required this.apartmentId});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  final adminStartDateController = TextEditingController();
  final adminEndDateController = TextEditingController();
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2D5C7A),
        title: Text(
          'Book Now'.tr(),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Icon(Icons.book, color: Colors.white),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  SizedBox(height: 30),

                  TextFieldItem(
                    hinit: 'Start Date'.tr(),
                    color: Color(0xff2D5C7A),
                    hiding: false,
                    controller: adminStartDateController,
                    iconButton: IconButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          initialDate: DateTime.now(),
                        );

                        if (newDate == null) return;

                        setState(() {
                          date = newDate;

                          String formattedDate =
                              '${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}';

                          adminStartDateController.text = formattedDate;
                        });
                      },
                      icon: Icon(Icons.date_range),
                    ),
                    colorIcon: Colors.white,
                  ),

                  SizedBox(height: 24),

                  TextFieldItem(
                    hinit: 'End Date'.tr(),
                    color: Color(0xff2D5C7A),
                    hiding: false,
                    controller: adminEndDateController,
                    iconButton: IconButton(
                      onPressed: () async {
                        DateTime startDate = adminStartDateController.text.isNotEmpty
                            ? DateTime.parse(adminStartDateController.text)
                            : DateTime.now();

                        DateTime? newDate = await showDatePicker(
                          context: context,
                          firstDate: startDate.add(Duration(days: 1)),
                          lastDate: DateTime(2100),
                          initialDate: startDate.add(Duration(days: 1)),
                        );

                        if (newDate == null) return;

                        setState(() {
                          date = newDate;

                          String formattedDate =
                              '${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}';

                          adminEndDateController.text = formattedDate;
                        });
                      },
                      icon: Icon(Icons.date_range),
                    ),
                    colorIcon: Colors.white,
                  ),

                  SizedBox(height: 50),

                  Button(
                    text: 'Booking Confirmation'.tr(),
                    color: Color(0xff2D5C7A),
                    colorText: Colors.white,
                    onPressed: () {
                      if (adminStartDateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select start date'.tr())),
                        );
                        return;
                      }

                      if (adminEndDateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select end date'.tr())),
                        );
                        return;
                      }

                      bookApi(
                        context,
                        adminStartDateController.text,
                        adminEndDateController.text,
                        widget.apartmentId,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    adminStartDateController.dispose();
    adminEndDateController.dispose();
    super.dispose();
  }
}