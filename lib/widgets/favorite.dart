// import 'package:flutter/material.dart';

// class Favorite extends StatelessWidget {
//   const Favorite({super.key, required this.favorites});
//   final Map<String,dynamic> favorites;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'المفضلة',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               '${favorites.length} شقة في قائمة المفضلة',
//               style: TextStyle(color: Colors.grey[600]),
//             ),

//             const SizedBox(height: 20),

//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 0.7,
//               ),
//               itemCount: favorites.length,
//               itemBuilder: (context, index) {
//                 return FavoraiteApartment(favorites);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FavoraiteApartment extends StatefulWidget {
//   const FavoraiteApartment({super.key,this.apartment});

//   @override
//   State<FavoraiteApartment> createState() => _FavoraiteApartmentState();
// }

// class _FavoraiteApartmentState extends State<FavoraiteApartment> {
//   // _FavoraiteApartmentState({required this.apartment})
//   Map<String,dynamic> apartment;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
//                 child: Image.network(
//                   apartment['image'],
//                   height: 120,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 5,
//                 right: 5,
//                 child: IconButton(
//                   icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
//                   onPressed: () {
//                     setState(() {
//                       apartment['isFavorite'] = false;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   apartment['title'],
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   apartment['location'],
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.star, color: Colors.amber, size: 14),
//                     const SizedBox(width: 4),
//                     Text(
//                       apartment['rating'].toString(),
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                     const Spacer(),
//                     Text(
//                       '${apartment['price']} ريال',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key, required this.favoriteList});
  final Map<String, dynamic> favoriteList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المفضلة',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${favoriteList.length} شقة في قائمة المفضلة',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            favoriteList.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد شقق في المفضلة',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: favoriteList.length,
                    itemBuilder: (context, index) {
                      // تمرير كل شقة على حدة
                      return FavoriteApartment(
                        apartment: favoriteList[index].value,
                        apartmentId: favoriteList[index].key,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class FavoriteApartment extends StatefulWidget {
  const FavoriteApartment({
    super.key,
    required this.apartment,
    required this.apartmentId,
  });

  final Map<String, dynamic> apartment;
  final String apartmentId;

  @override
  State<FavoriteApartment> createState() => _FavoriteApartmentState();
}

class _FavoriteApartmentState extends State<FavoriteApartment> {
  bool isFavorite = true;

  @override
  void initState() {
    super.initState();
    // تحميل حالة المفضلة من البيانات
    isFavorite = widget.apartment['isFavorite'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: Image.network(
                  widget.apartment['image'] ??
                      'https://via.placeholder.com/150',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.home,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                      // هنا يمكنك تحديث البيانات في الـ favorites الرئيسي
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.apartment['title'] ?? 'بدون عنوان',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.apartment['location'] ?? 'موقع غير محدد',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      (widget.apartment['rating'] ?? 0).toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.apartment['price'] ?? 0} ريال',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (widget.apartment['type'] != null)
                  Text(
                    widget.apartment['type'],
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

