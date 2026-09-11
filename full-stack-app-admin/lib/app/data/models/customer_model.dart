class CustomerModel {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final int totalOrders;
  final double totalSpent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.totalOrders = 0,
    this.totalSpent = 0.0,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      totalOrders: json['total_orders'] ?? 0,
      totalSpent: (json['total_spent'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'total_orders': totalOrders,
      'total_spent': totalSpent,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
