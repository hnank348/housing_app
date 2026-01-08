class Booking {
  final int id;
  final int clientId;
  final String startDate;
  final String endDate;
  final double totalPrice;
  final String status;
  final String ownerApproval;
  final Map<String, dynamic>? apartment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool canModify;
  final bool canReview;

  Booking({
    required this.id,
    required this.clientId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.ownerApproval,
    this.apartment,
    required this.createdAt,
    required this.updatedAt,
    this.canModify = false,
    this.canReview = false,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    final status = json['status'] ?? 'pending';
    final canModify = status == 'pending' || status == 'waiting';
    final canReview = status == 'active' || status == 'confirmed' || status == 'completed';

    Map<String, dynamic>? apartmentData;

    if (json['apartment'] != null) {
      apartmentData = json['apartment'];
    } else if (json['change_reservation'] != null && json['change_reservation']['apartment'] != null) {
      apartmentData = json['change_reservation']['apartment'];
    }

    return Booking(
      id: json['id'],
      clientId: json['client_id'],
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      status: status,
      ownerApproval: json['owner_approval'] ?? 'pending',
      apartment: apartmentData, // قد تكون null ولن ينهار المودل
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      canModify: canModify,
      canReview: canReview,
    );
  }
}
