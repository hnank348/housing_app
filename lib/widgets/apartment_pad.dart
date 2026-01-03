// import 'package:flutter/material.dart';
// import 'package:weather_app/models/apartment_model.dart';
// import 'package:weather_app/widgets/department_detailes.dart';

// class buildApartmentCard extends StatefulWidget {
//   const buildApartmentCard({super.key,required this.apartmentModel});

//   final ApartmentModel apartmentModel;

//   @override
//   State<buildApartmentCard> createState() => _buildApartmentCardState();
// }

// class _buildApartmentCardState extends State<buildApartmentCard> {
//   bool favorat =false;

//   // ApartmentModel apartmentModel;
//   @override
//   Widget build(BuildContext context) {
//     return  GestureDetector(
//       onTap: () => Navigator.pushNamed(context, '/apaDeta',arguments: widget.apartmentModel),
//       // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>RealEstateApp(),),),
//       child: Card(
//         margin: const EdgeInsets.only(bottom: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
//                   child: Image.network(
//                     widget.apartmentModel.image[0],
//                     // 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&auto=format&fit=crop',
//                     height: 180,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.star, color: Colors.amber, size: 16),
//                         const SizedBox(width: 4),
//                         Text(
//                           widget.apartmentModel.rating.toString(),
//                           // '*****',
//                           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: IconButton(
//                     icon: Icon(
//                       Icons.favorite,
//                       color:favorat ?Colors.red : Colors.white
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         favorat=!favorat;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
            
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.apartmentModel.title,
//                     // apartment['title'],
//                     // 'title',
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, size: 16, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(widget.apartmentModel.location,
//                         // apartment['location'],
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '${widget.apartmentModel.price.toString()}  S.P',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {},
//                         child: const Text('احجز الآن'),
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/model/apartment_model.dart';
import 'package:housing_app/widgets/department_detailes.dart';

import '../view/HomePage/Apartment/Book.dart';


class BuildApartmentCard extends StatefulWidget {
  const BuildApartmentCard({super.key, required this.apartmentModel});

  final ApartmentModel apartmentModel;

  @override
  State<BuildApartmentCard> createState() => _BuildApartmentCardState();
}

class _BuildApartmentCardState extends State<BuildApartmentCard> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RealEstateApp(apartment: widget.apartmentModel,)));
        // Navigator.pushNamed(
        //   context,
        //   '/apaDeta',
        //   arguments: widget.apartmentModel,
        // );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
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
                    widget.apartmentModel.images.isNotEmpty
                        ? widget.apartmentModel.images.first.imageUrl
                        : 'https://via.placeholder.com/400x200',
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print("Image Error Details: $error");
                      return Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: Icon(Icons.broken_image, size: 50),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                         // widget.apartmentModel.rating?.toStringAsFixed(1) ??
                              'N/A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.apartmentModel.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.apartmentModel.governorate,
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.apartmentModel.pricePerDay.toString()} S.P',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Book(apartmentId: widget.apartmentModel.id,)),
                          );                        },
                        child: const Text('Book Now').tr(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}































// Widget _buildApartmentCard(Map<String, dynamic> apartment) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
//                 child: Image.network(
//                   apartment['image'],
//                   height: 180,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.6),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.amber, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         apartment['rating'].toString(),
//                         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 10,
//                 left: 10,
//                 child: IconButton(
//                   icon: Icon(
//                     apartment['isFavorite'] ? Icons.favorite : Icons.favorite_border,
//                     color: apartment['isFavorite'] ? Colors.red : Colors.white,
//                   ),
//                   onPressed: () {
//                     // setState(() {
//                     //   apartment['isFavorite'] = !apartment['isFavorite'];
//                     // });
//                   },
//                 ),
//               ),
//             ],
//           ),
          
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   apartment['title'],
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 16, color: Colors.grey),
//                     const SizedBox(width: 4),
//                     Text(
//                       apartment['location'],
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Wrap(
//                   spacing: 8,
//                   children: (apartment['amenities'] as List<String>)
//                       .take(3)
//                       .map((amenity) => Chip(
//                             label: Text(amenity),
//                             backgroundColor: Colors.grey[100],
//                             labelStyle: const TextStyle(fontSize: 12),
//                           ))
//                       .toList(),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '${apartment['price']} ريال / ليلة',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: const Text('احجز الآن'),
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
