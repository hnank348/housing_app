import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/api/notification/notification_api.dart';
import '../../model/notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  late Future<List<NotificationModel>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = getNotifications();
  }

  void refreshNotifications() {
    setState(() {
      notifications = getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).tr(),
        actions: [
          IconButton(
            onPressed: refreshNotifications,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
        backgroundColor:const Color(0xff2D5C7A),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshNotifications();
        },
        child: FutureBuilder<List<NotificationModel>>(
          future: notifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                     SizedBox(height: 10),
                    Text("Error: ${snapshot.error}", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                    ElevatedButton(
                      onPressed: refreshNotifications,
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
                    Icon(Icons.notifications_off_outlined, size: 80, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                    SizedBox(height: 10),
                    Text(
                      "No notifications found",
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                    ).tr(),
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
                return Item(
                  title: item.title,
                  message: item.message,
                  isRead: item.isRead == 1,
                  icon: item.title.contains('Approved') ? Icons.check_circle : Icons.notifications,
                  color: item.title.contains('Approved') ? Colors.green : (isDark ? const Color(0xff4690bd) : const Color(0xff073D5F)),
                  time: item.createdAt,
                  isDark: isDark,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget Item({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    required bool isRead,
    required String time,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: isRead
              ? (isDark ? const Color(0xff1E1E1E) : Colors.white)
              : (isDark ? const Color(0xff0D212F) : const Color(0xffE3F2FD)),
          border: Border.all(
            color: isRead
                ? (isDark ? Colors.grey[800]! : Colors.grey.shade300)
                : (isDark ? const Color(0xff4690bd) : const Color(0xff073D5F)).withOpacity(0.3),
            width: isRead ? 0.8 : 1.5,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
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
              if (!isRead)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xff1E1E1E) : Colors.white,
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
              fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
              color: isDark ? const Color(0xff4690bd) : const Color(0xff073D5F),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? (isRead ? Colors.white70 : Colors.white) : (isRead ? Colors.black54 : Colors.black87),
                  height: 1.3,
                ),
              ),
              SizedBox(height: 8),
              Text(
                time.split('T')[0],
                style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[500] : Colors.grey[600]),
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}