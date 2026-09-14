import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopadmin/app/data/models/product_model.dart';

import 'product_item_widget.dart';

class ProductListWidget extends StatelessWidget {
  final RxList<ProductModel> products;

  const ProductListWidget({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductItemWidget(product: product);
        },
      ),
    );
  }
}
