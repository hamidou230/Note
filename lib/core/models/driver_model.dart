class DriverModel {
  final String id;
  final String name;
  final String phone;
  final String carModel;
  final String carColor;
  final String licensePlate;
  final String status; // 'en_attente', 'approuve', 'suspendu'
  final double rating;
  final int totalRides;
  final bool isOnline;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.carModel,
    required this.carColor,
    required this.licensePlate,
    this.status = 'en_attente',
    this.rating = 0.0,
    this.totalRides = 0,
    this.isOnline = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'phone': phone,
    'carModel': carModel, 'carColor': carColor,
    'licensePlate': licensePlate, 'status': status,
    'rating': rating, 'totalRides': totalRides, 'isOnline': isOnline,
  };

  factory DriverModel.fromMap(Map<String, dynamic> map) => DriverModel(
    id: map['id'], name: map['name'], phone: map['phone'],
    carModel: map['carModel'], carColor: map['carColor'],
    licensePlate: map['licensePlate'], status: map['status'] ?? 'en_attente',
    rating: (map['rating'] ?? 0.0).toDouble(),
    totalRides: map['totalRides'] ?? 0,
    isOnline: map['isOnline'] ?? false,
  );
}
