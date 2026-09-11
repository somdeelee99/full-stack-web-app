import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/order_model.dart';
import 'order_item_widget.dart';

class OrderListWidget extends StatelessWidget {
  final RxList<OrderModel> orders;
  
  const OrderListWidget({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderItemWidget(order: order);
      },
    ));
  }
}
