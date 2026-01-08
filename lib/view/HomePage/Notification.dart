import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/api/notification/notification_api.dart'; // تأكدي من المسار الصحيح
import '../../model/notification_model.dart';           // تأكدي من المسار الصحيح

class Esharscreen extends StatefulWidget {
  const Esharscreen({super.key});

  @override
  State<Esharscreen> createState() => _EsharscreenState();
}

class _EsharscreenState extends State<Esharscreen> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    // تهيئة جلب البيانات عند تشغيل الصفحة أول مرة
    _notificationsFuture = getNotifications();
  }

  // دالة لتحديث البيانات يدوياً
  void _refreshNotifications() {
    setState(() {
      _notificationsFuture = getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // خلفية رمادية فاتحة لتمييز الكروت
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).tr(),
        actions: [
          IconButton(
            onPressed: _refreshNotifications, // زر لتحديث القائمة
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // يمكنكِ هنا إضافة كود حذف جميع الإشعارات
            },
            icon: const Icon(Icons.delete_outline, size: 25, color: Colors.white),
          ),
        ],
        backgroundColor: const Color(0xff073D5F),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshNotifications();
        },
        child: FutureBuilder<List<NotificationModel>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 10),
                    Text("Error: ${snapshot.error}"),
                    ElevatedButton(
                      onPressed: _refreshNotifications,
                      child: const Text("Retry"),
                    )
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 10),
                    const Text("No notifications found").tr(),
                  ],
                ),
              );
            }

            final notifications = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return eshareItem(
                  title: item.title,
                  message: item.message,
                  // تم اعتبار is_read == 1 يعني مقروء
                  isRead: item.isRead == 1,
                  icon: item.title.contains('Approved') ? Icons.check_circle : Icons.notifications,
                  color: item.title.contains('Approved') ? Colors.green : const Color(0xff073D5F),
                  time: item.createdAt, // يمكنكِ تمرير الوقت من الـ Model
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget eshareItem({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    required bool isRead,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          // الإشعار غير المقروء يظهر بخلفية زرقاء خفيفة جداً
          color: isRead ? Colors.white : const Color(0xffE3F2FD),
          border: Border.all(
            color: isRead ? Colors.grey.shade300 : const Color(0xff073D5F).withOpacity(0.3),
            width: isRead ? 0.8 : 1.5,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color, size: 28),
              ),
              if (!isRead) // نقطة حمراء للإشعارات الجديدة
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              // خط عريض للإشعار غير المقروء
              fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
              color: const Color(0xff073D5F),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: isRead ? Colors.black54 : Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                time.split('T')[0],
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          onTap: () {
            // هنا يمكنكِ برمجة الانتقال لتفاصيل الحجز أو تحديث حالة الإشعار لمقروء
          },
        ),
      ),
    );
  }
}