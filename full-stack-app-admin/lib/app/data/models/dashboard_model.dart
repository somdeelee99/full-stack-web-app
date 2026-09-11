class DashboardStatsModel {
  final double totalRevenue;
  final int totalOrders;
  final int totalProducts;
  final int totalCustomers;
  final double revenueGrowth;
  final double ordersGrowth;
  final List<RecentOrderModel> recentOrders;
  final List<TopProductModel> topProducts;

  DashboardStatsModel({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalProducts,
    required this.totalCustomers,
    this.revenueGrowth = 0.0,
    this.ordersGrowth = 0.0,
    required this.recentOrders,
    required this.topProducts,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    var recentOrdersList = json['recent_orders'] as List?;
    var topProductsList = json['top_products'] as List?;

    return DashboardStatsModel(
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      totalOrders: json['total_orders'] ?? 0,
      totalProducts: json['total_products'] ?? 0,
      totalCustomers: json['total_customers'] ?? 0,
      revenueGrowth: (json['revenue_growth'] ?? 0).toDouble(),
      ordersGrowth: (json['orders_growth'] ?? 0).toDouble(),
      recentOrders: recentOrdersList?.map((o) => RecentOrderModel.fromJson(o)).toList() ?? [],
      topProducts: topProductsList?.map((p) => TopProductModel.fromJson(p)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'total_orders': totalOrders,
      'total_products': totalProducts,
      'total_customers': totalCustomers,
      'revenue_growth': revenueGrowth,
      'orders_growth': ordersGrowth,
      'recent_orders': recentOrders.map((o) => o.toJson()).toList(),
      'top_products': topProducts.map((p) => p.toJson()).toList(),
    };
  }
}

class RecentOrderModel {
  final int? id;
  final String orderNumber;
  final String customerName;
  final double amount;
  final String status;
  final DateTime? createdAt;

  RecentOrderModel({
    this.id,
    required this.orderNumber,
    required this.customerName,
    required this.amount,
    required this.status,
    this.createdAt,
  });

  factory RecentOrderModel.fromJson(Map<String, dynamic> json) {
    return RecentOrderModel(
      id: json['id'],
      orderNumber: json['order_number'] ?? '',
      customerName: json['customer_name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'customer_name': customerName,
      'amount': amount,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class TopProductModel {
  final int? id;
  final String name;
  final int soldCount;
  final double revenue;
  final String? imageUrl;

  TopProductModel({
    this.id,
    required this.name,
    required this.soldCount,
    required this.revenue,
    this.imageUrl,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      soldCount: json['sold_count'] ?? 0,
      revenue: (json['revenue'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sold_count': soldCount,
      'revenue': revenue,
      'image_url': imageUrl,
    };
  }
}
