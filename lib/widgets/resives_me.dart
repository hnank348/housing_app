// import 'package:flutter/material.dart';

// class ResivesMe extends StatelessWidget {
//   ResivesMe({super.key});

// final List<Map<String, dynamic>> _bookings = [
//     {
//       'id': 'B001',
//       'apartment': 'شقة فاخرة في الرياض',
//       'date': '2025-12-01 إلى 2025-12-05',
//       'status': 'مؤكد',
//       'total': 2500,
//       'image': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w-800&auto=format&fit=crop',
//     },
//     {
//       'id': 'B002',
//       'apartment': 'شقة عائلية في جدة',
//       'date': '2025-11-20 إلى 2025-11-25',
//       'status': 'ملغى',
//       'total': 1750,
//       'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&auto=format&fit=crop',
//     },
//     {
//       'id': 'B003',
//       'apartment': 'شقة حديثة في الدمام',
//       'date': '2025-12-10 إلى 2025-12-15',
//       'status': 'قيد الانتظار',
//       'total': 1800,
//       'image': 'https://images.unsplash.com/photo-1558036117-15e82a2c9a9a?w=800&auto=format&fit=crop',
//     },
//   ];


//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'حجوزاتي',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
              
//               Resives(title: 'مؤكد', value: _bookings.where((b) => b['status'] == 'مؤكد').length.toString(), color:Colors.green),
//               const SizedBox(width: 10),
//               Resives(title: 'قيد الانتظار',value:  _bookings.where((b) => b['status'] == 'قيد الانتظار').length.toString(),color:  Colors.orange),
//               const SizedBox(width: 10),
//               Resives(title: 'ملغى',value:  _bookings.where((b) => b['status'] == 'ملغى').length.toString(),color:  Colors.red),
//               // ('مؤكد', _bookings.where((b) => b['status'] == 'مؤكد').length.toString(), Colors.green),
//               // const SizedBox(width: 10),
//               // _buildStatCard('قيد الانتظار', _bookings.where((b) => b['status'] == 'قيد الانتظار').length.toString(), Colors.orange),
//               // const SizedBox(width: 10),
//               // _buildStatCard('ملغى', _bookings.where((b) => b['status'] == 'ملغى').length.toString(), Colors.red),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // ListView.builder(
//           //   shrinkWrap: true,
//           //   physics: const NeverScrollableScrollPhysics(),
//           //   itemCount: 5,
//           //   itemBuilder: (context, index) {
//           //     return _buildBookingCard(_bookings[index]);
//           //   },
//           // ),
//         ],
//       ),
//     );
//   }
// }

// class Resives extends StatelessWidget {
//   const Resives({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.color,
//   });
//   final String title;
//   final String value;
//   final Color color;
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(title, style: TextStyle(color: color)),
//           ],
//         ),
//       ),
//     );
//   }
// }



//   Widget _buildBookingCard(Map<String, dynamic> booking) {
//     Color statusColor;
//     if (booking['status'] == 'مؤكد') {
//       statusColor = Colors.green;
//     } else if (booking['status'] == 'ملغى') {
//       statusColor = Colors.red;
//     } else {
//       statusColor = Colors.orange;
//     }

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 booking['image'],
//                 width: 80,
//                 height: 80,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     booking['apartment'],
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     booking['date'],
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: statusColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           booking['status'],
//                           style: TextStyle(color: statusColor, fontSize: 12),
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         '${booking['total']} ريال',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
