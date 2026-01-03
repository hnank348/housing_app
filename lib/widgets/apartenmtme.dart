// import 'package:flutter/material.dart';

// class ApartmentMeResive extends StatelessWidget {
//   const ApartmentMeResive({super.key, required this.booking});
//   final Map<String,dynamic> booking;

//   @override
//   Widget build(BuildContext context) {
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
// }




