import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/category_model.dart';
import 'category_item_widget.dart';

class CategoryListWidget extends StatelessWidget {
  final RxList<CategoryModel> categories;
  
  const CategoryListWidget({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryItemWidget(category: category);
      },
    ));
  }
}
