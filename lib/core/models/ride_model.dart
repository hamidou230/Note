class RideModel {
  final String id;
  final String clientId;
  final String clientName;
  final String driverId;
  final String driverName;
  final String pickup;
  final String destination;
  final double distanceKm;
  final double price;
  final String status; // 'en_attente', 'en_cours', 'termine', 'annule'
  final String date;

  RideModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.driverId,
    required this.driverName,
    required this.pickup,
    required this.destination,
    required this.distanceKm,
    required this.price,
    this.status = 'en_attente',
    required this.date,
  });

  double get calculatedPrice => distanceKm * 40; // 40 MRU/km

  Map<String, dynamic> toMap() => {
    'id': id, 'clientId': clientId, 'clientName': clientName,
    'driverId': driverId, 'driverName': driverName,
    'pickup': pickup, 'destination': destination,
    'distanceKm': distanceKm, 'price': price,
    'status': status, 'date': date,
  };

  factory RideModel.fromMap(Map<String, dynamic> map) => RideModel(
    id: map['id'], clientId: map['clientId'], clientName: map['clientName'],
    driverId: map['driverId'], driverName: map['driverName'],
    pickup: map['pickup'], destination: map['destination'],
    distanceKm: (map['distanceKm'] ?? 0.0).toDouble(),
    price: (map['price'] ?? 0.0).toDouble(),
    status: map['status'] ?? 'en_attente', date: map['date'],
  );
}
