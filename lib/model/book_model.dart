class BookingResponse {
  final bool status;
  final int count;
  final List<BookingModel> bookings;

  BookingResponse({
    required this.status,
    required this.count,
    required this.bookings,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      status: json['status'] ?? false,
      count: json['count'] ?? 0,
      bookings: (json['users'] as List?)
          ?.map((item) => BookingModel.fromJson(item))
          .toList() ?? [],
    );
  }
}

class BookingModel {
  final int bookingId;
  final ApartmentShort apartment;
  final Client client;
  final String startDate;
  final String endDate;
  final String totalPrice;
  final String status;
  final String ownerApproval;

  BookingModel({
    required this.bookingId,
    required this.apartment,
    required this.client,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.ownerApproval,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['booking_id'],
      apartment: ApartmentShort.fromJson(json['apartment'] ?? {}),
      client: Client.fromJson(json['client'] ?? {}),
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      totalPrice: json['total_price'] ?? '0.00',
      status: json['status'] ?? '',
      ownerApproval: json['owner_approval'] ?? '',
    );
  }
}

class ApartmentShort {
  final int id;
  final String title;

  ApartmentShort({required this.id, required this.title});

  factory ApartmentShort.fromJson(Map<String, dynamic> json) {
    return ApartmentShort(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }
}

class Client {
  final int id;
  final String firstName;
  final String lastName;

  Client({required this.id, required this.firstName, required this.lastName});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}