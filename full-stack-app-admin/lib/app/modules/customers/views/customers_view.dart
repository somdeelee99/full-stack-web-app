import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopadmin/app/modules/customers/controllers/customers_controller.dart';

import '../widgets/customers_list_widget.dart';

class CustomersView extends GetView<CustomersController> {
  const CustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchCustomers(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: controller.updateSearchQuery,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredCustomers.isEmpty) {
                return const Center(child: Text('No customers found'));
              }
              return CustomersListWidget(
                customers: controller.filteredCustomers,
              );
            }),
          ),
        ],
      ),
    );
  }
}
