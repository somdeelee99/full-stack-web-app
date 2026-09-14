class OrderModel {
  final int? id;
  final String orderNumber;
  final int customerId;
  final String? customerName;
  final String? customerEmail;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String status;
  final String? paymentMethod;
  final String? shippingAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.customerId,
    this.customerName,
    this.customerEmail,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    this.shippingAddress,
    this.createdAt,
    this.updatedAt,
  });

  OrderModel copyWith({
    int? id,
    String? orderNumber,
    int? customerId,
    String? customerName,
    String? customerEmail,
    List<OrderItemModel>? items,
    double? totalAmount,
    String? status,
    String? paymentMethod,
    String? shippingAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List?;
    List<OrderItemModel> items =
        itemsList?.map((i) => OrderItemModel.fromJson(i)).toList() ?? [];
    return OrderModel(
      id: json['id'],
      orderNumber: json['order_number'] ?? '',
      customerId: json['customer_id'] ?? 0,
      customerName: json['customer_name'],
      customerEmail: json['customer_email'],
      items: items,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['payment_method'],
      shippingAddress: json['shipping_address'],
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
      'order_number': orderNumber,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'items': items.map((i) => i.toJson()).toList(),
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class OrderItemModel {
  final int? id;
  final int productId;
  final String? productName;
  final int quantity;
  final double price;
  final double subtotal;

  OrderItemModel({
    this.id,
    required this.productId,
    this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  OrderItemModel copyWith({
    int? id,
    int? productId,
    String? productName,
    int? quantity,
    double? price,
    double? subtotal,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      productId: json['product_id'] ?? 0,
      productName: json['product_name'],
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal,
    };
  }
}
