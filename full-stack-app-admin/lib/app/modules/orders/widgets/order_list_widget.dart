import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopadmin/app/data/models/order_model.dart';

class OrderListWidget extends StatelessWidget {
  final RxList<OrderModel> orders;

  const OrderListWidget({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderItemWidget(order: order);
        },
      ),
    );
  }
}
