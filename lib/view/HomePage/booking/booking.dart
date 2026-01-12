// my_bookings_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/api/Book/booking_api.dart';
import '../../../model/booking_model.dart';

class MyBookingsScreen extends StatefulWidget {
  MyBookingsScreen({Key? key}) : super(key: key);

  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> activeBookings = [];
  List<Booking> waitingBookings = [];
  List<Booking> cancelledBookings = [];
  List<Booking> completedBookings = [];
  bool isLoading = true;
  String errorMessage = '';

  final Color primaryColor = Color(0xff2D5C7A);
  final Color secondaryColor = Color(0xff4A90E2);
  final Color lightBlue = Color(0xffE8F4FD);
  final Color darkText = Color(0xff333333);
  final Color lightText = Color(0xff666666);
  final Color goldColor = Color(0xffFFD700);
  final Color completedColor = Color(0xff34A853);
  final adminReviewTextController=TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final result = await ApiService.fetchBookings();

    setState(() {
      isLoading = false;

      if (result['success'] == true) {
        final List<Booking> allBookings = result['bookings'];

        activeBookings.clear();
        waitingBookings.clear();
        cancelledBookings.clear();
        completedBookings.clear();

        for (var booking in allBookings) {
          print('Booking ID: ${booking.id}, Status: "${booking.status}"');

          if (booking.ownerApproval.toLowerCase() == 'approved' || booking.status.toLowerCase() == 'approved') {
            activeBookings.add(booking);
          } else if (booking.ownerApproval.toLowerCase() == 'pending' || booking.status.toLowerCase() == 'waiting') {
            waitingBookings.add(booking);
          } else if (booking.status.toLowerCase() == 'cancelled') {
            cancelledBookings.add(booking);
          } else if (booking.ownerApproval.toLowerCase() == 'completed') {
            completedBookings.add(booking);
          } else {
            print(' Unknown status: "${booking.status}"');
          }
        }
      } else {
        errorMessage = result['error'] ?? 'حدث خطأ غير متوقع';
      }
    });
  }

  Future<void> _cancelBooking(int bookingId) async {
    final result = await ApiService.cancelBooking(bookingId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] == true
              ? result['message'] ?? 'The operation was completed'.tr()
              : result['error'] ?? 'error'.tr(),
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result['success'] == true) {
      _fetchBookings();
    }
  }

  Future<void> _updateBooking(Booking booking) async {
    await _showUpdateDialog(booking);
  }

  Future<void> _submitReview(Booking booking) async {
    await _showReviewDialog(booking);
  }

  Future<void> _processUpdateBooking(
      int bookingId,
      DateTime startDate,
      DateTime endDate
      ) async {
    final result = await ApiService.updateBooking(
      bookingId,
      DateFormat('yyyy-MM-dd').format(startDate),
      DateFormat('yyyy-MM-dd').format(endDate),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] == true
              ? result['message'] ?? 'Successfully updated'.tr()
              : result['error'] ?? 'error'.tr(),
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result['success'] == true) {
      _fetchBookings();
    }
  }

  Future<void> _submitReviewToServer(
      int bookingId,
      int rating,
      String review
      ) async {
    final result = await ApiService.submitReview(bookingId, rating, review);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] == true
              ? result['message'] ?? 'The operation was completed'.tr()
              : result['error'] ?? 'error'.tr(),
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result['success'] == true) {
      _fetchBookings();
    }
  }

  Widget _buildBookingCard(Booking booking) {
    if (booking.apartment == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "هذا الحجز مرتبط ببيانات غير متوفرة حالياً (ربما تم حذف الشقة)",
                style: TextStyle(
                    fontFamily: 'Cairo', color: Colors.red.shade900),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .cardColor, // يتغير تلقائياً بين الأبيض والأسود
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme
                .of(context)
                .brightness == Brightness.dark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .brightness == Brightness.dark
                  ? primaryColor.withOpacity(0.2)
                  : lightBlue, // خلفية الهيدر في الوضعين
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.apartment?['title'] ?? 'Real Estate'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.white
                              : primaryColor,
                          fontFamily: 'Cairo',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${'Booking ID:'.tr()} ${booking.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme
                              .of(context)
                              .hintColor, // لون رمادي مناسب للوضعين
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(booking.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location
                if (booking.apartment?['city'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 18,
                            color: secondaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${booking.apartment?['city']} - ${booking
                                .apartment?['address'] ?? ''}',
                            style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .hintColor,
                              fontSize: 14,
                              fontFamily: 'Cairo',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Dates
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 18,
                          color: secondaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${"from".tr()} ${_formatDate(booking
                              .startDate)} ${"to".tr()} ${_formatDate(booking
                              .endDate)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge
                                ?.color,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Apartment Details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.05)
                        : const Color(0xffF8FAFD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailItem(
                        icon: Icons.king_bed_outlined,
                        value: '${booking.apartment?['rooms'] ?? 0}',
                        label: 'Rooms'.tr(),
                      ),
                      _buildDetailItem(
                        icon: Icons.bathtub_outlined,
                        value: '${booking.apartment?['bathrooms'] ?? 0}',
                        label: 'Bathrooms'.tr(),
                      ),
                      _buildDetailItem(
                        icon: Icons.square_foot_outlined,
                        value: '${booking.apartment?['area'] ?? 0}',
                        label: 'm²'.tr(),
                      ),
                      _buildDetailItem(
                        icon: Icons.attach_money_outlined,
                        value: '${double
                            .tryParse(booking
                            .apartment?['price_per_day']?.toString() ?? '0')
                            ?.toStringAsFixed(0) ?? '0'}',
                        label: 'day/SYP'.tr(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Total Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge
                            ?.color,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ).tr(),
                    Text(
                      '${booking.totalPrice.toStringAsFixed(2)} ${'SYP'.tr()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? goldColor
                            : primaryColor,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                if (booking.canModify || booking.canReview ||
                    booking.ownerApproval == 'approved')
                  Column(
                    children: [
                      if (booking.canModify ||
                          booking.ownerApproval == 'approved')
                        Row(
                          children: [
                            if (booking.canModify)
                              Expanded(
                                child: _buildActionButton(
                                  icon: Icons.edit_outlined,
                                  text: 'update booking'.tr(),
                                  color: primaryColor,
                                  onPressed: () => _updateBooking(booking),
                                ),
                              ),
                            if (booking.canModify &&
                                (booking.ownerApproval == 'approved' ||
                                    booking.ownerApproval == 'pending'))
                              const SizedBox(width: 12),
                            if (booking.ownerApproval == 'approved' ||
                                booking.ownerApproval == 'pending')
                              Expanded(
                                child: _buildActionButton(
                                  icon: Icons.cancel_outlined,
                                  text: 'cancel booking'.tr(),
                                  color: Colors.red,
                                  onPressed: () =>
                                      _showCancelDialog(booking.id),
                                ),
                              ),
                          ],
                        ),
                      if (booking.canReview ||
                          booking.ownerApproval == 'approved')
                        const SizedBox(height: 12),
                      if (booking.ownerApproval == 'approved')
                        _buildActionButton(
                          icon: Icons.star_outline,
                          text: 'Real state valuation'.tr(),
                          color: goldColor,
                          onPressed: () => _submitReview(booking),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: secondaryColor, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(
              color: lightText,
              fontSize: 11,
              fontFamily: 'Cairo',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      return date.substring(0, 10);
    } catch (e) {
      return date;
    }
  }

  void _showCancelDialog(int bookingId) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                'cancel confirm',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : primaryColor,
                  fontFamily: 'Cairo',
                ),
              ).tr(),
              SizedBox(height: 12),
              Text(
                'Are you sure you want to cancel this reservation?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : lightText,
                  fontFamily: 'Cairo',
                ),
              ).tr(),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: isDark ? secondaryColor : primaryColor),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDark ? secondaryColor : primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ).tr(),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffFF6B6B),
                            Color(0xffFF8E8E),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _cancelBooking(bookingId);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            child: Center(
                              child: Text(
                                'cancel confirm',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Cairo',
                                ),
                              ).tr(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showUpdateDialog(Booking booking) async {
    DateTime? newStartDate;
    DateTime? newEndDate;
    final startController = TextEditingController(text: booking.startDate);
    final endController = TextEditingController(text: booking.endDate);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'update booking',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : primaryColor,
                  fontFamily: 'Cairo',
                ),
              ).tr(),
              SizedBox(height: 16),
              Text(
                '${'Booking ID:'.tr()} ${booking.id}',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : lightText,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: startController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: 'Start Date'.tr(),
                  labelStyle: TextStyle(color: isDark ? Colors.grey[400] : null),
                  prefixIcon: Icon(Icons.calendar_today, color: isDark ? secondaryColor : primaryColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(booking.startDate),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    startController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                    newStartDate = selectedDate;
                  }
                },
              ),
              SizedBox(height: 12),
              TextField(
                controller: endController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: 'End Date'.tr(),
                  labelStyle: TextStyle(color: isDark ? Colors.grey[400] : null),
                  prefixIcon: Icon(Icons.calendar_today, color: isDark ? secondaryColor : primaryColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(booking.endDate),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    endController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                    newEndDate = selectedDate;
                  }
                },
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: isDark ? secondaryColor : primaryColor),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDark ? secondaryColor : primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ).tr(),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () {
                            if (newStartDate != null || newEndDate != null) {
                              _processUpdateBooking(
                                booking.id,
                                newStartDate ?? DateTime.parse(booking.startDate),
                                newEndDate ?? DateTime.parse(booking.endDate),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('You did not change any dates',
                                      style: TextStyle(fontFamily: 'Cairo')).tr(),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            child: Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Cairo',
                                ),
                              ).tr(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showReviewDialog(Booking booking) async {
    double rating = 5.0;

    // 1. تنظيف الـ Controller قبل فتح الديالوج لضمان عدم إرسال قيم قديمة أو null
    adminReviewTextController.clear();

    await showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Real state valuation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : primaryColor,
                          fontFamily: 'Cairo',
                        ),
                      ).tr(),
                      const SizedBox(height: 8),
                      Text(
                        booking.apartment?['title'] ?? 'شقة',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'How was your experience in this real state?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.grey[300] : Colors.black87,
                          fontFamily: 'Cairo',
                        ),
                      ).tr(),
                      const SizedBox(height: 16),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < rating.floor() ? Icons.star : Icons.star_border,
                                size: 40,
                                color: goldColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  rating = index + 1.0;
                                });
                              },
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${rating.toInt()} / 5',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? goldColor : primaryColor,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: adminReviewTextController,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Write your review (optional)'.tr(),
                          labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                          filled: true,
                          fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor, width: 1),
                          ),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: isDark ? Colors.grey[600]! : primaryColor),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ).tr(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [goldColor, const Color(0xffFFB347)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: isDark ? [] : [
                                  BoxShadow(
                                    color: goldColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () {
                                    String finalComment = adminReviewTextController.text.trim();

                                    _submitReviewToServer(
                                      booking.id,
                                      rating.toInt(),
                                      finalComment,
                                    );

                                    Navigator.pop(context);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    child: Center(
                                      child: Text(
                                        'Submit the evaluation',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Cairo',
                                        ),
                                      ).tr(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'confirmed':
        return Colors.green;
      case 'pending':
      case 'waiting':
        return Colors.orange;
      case 'completed':
        return completedColor;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'confirmed':
        return 'نشط / مؤكد';
      case 'pending':
      case 'waiting':
        return 'قيد الانتظار';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  Widget _buildTabContent(List<Booking> bookings) {
    return RefreshIndicator(
      onRefresh: _fetchBookings,
      backgroundColor: Colors.white,
      color: primaryColor,
      child: _buildTabBody(bookings),
    );
  }

  Widget _buildTabBody(List<Booking> bookings) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
            SizedBox(height: 16),
            Text(
              'Loading reservations...',
              style: TextStyle(
                fontSize: 16,
                color: lightText,
                fontFamily: 'Cairo',
              ),
            ).tr(),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: darkText,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              'Swipe down to try again',
              style: TextStyle(
                fontSize: 14,
                color: lightText,
                fontFamily: 'Cairo',
              ),
            ).tr(),
          ],
        ),
      );
    }

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 80,
              color: Color(0xffE0E0E0),
            ),
            SizedBox(height: 16),
            Text(
              'No reservation',
              style: TextStyle(
                fontSize: 20,
                color: lightText,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ).tr(),
            SizedBox(height: 8),
            Text(
              'Swipe down to refresh',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff999999),
                fontFamily: 'Cairo',
              ),
            ).tr(),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 8, bottom: 24),
      itemCount: bookings.length,
      itemBuilder: (context, index) => _buildBookingCard(bookings[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My booking',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ).tr(),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: [
            Tab(
              icon: const Icon(Icons.check_circle_outline, size: 20),
              text: "${'active'.tr()} (${activeBookings.length})",
            ),
            Tab(
              icon: const Icon(Icons.access_time_outlined, size: 20),
              text: "${'pending'.tr()} (${waitingBookings.length})",
            ),
            Tab(
              icon: const Icon(Icons.done_all_outlined, size: 20),
              text: "${'complete'.tr()} (${completedBookings.length})",
            ),
            Tab(
              icon: const Icon(Icons.cancel_outlined, size: 20),
              text: "${'cancelled'.tr()} (${cancelledBookings.length})",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(activeBookings),
          _buildTabContent(waitingBookings),
          _buildTabContent(completedBookings),
          _buildTabContent(cancelledBookings),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}