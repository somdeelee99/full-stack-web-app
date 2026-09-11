class ProductModel {
  final int? id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String? imageUrl;
  final int? categoryId;
  final String? categoryName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.categoryId,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
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
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'category_id': categoryId,
      'category_name': categoryName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
