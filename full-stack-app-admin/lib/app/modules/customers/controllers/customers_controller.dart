import 'package:get/get.dart';

class CustomersController extends GetxController {
  final RxList<Map<String, dynamic>> customers = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      isLoading.value = true;
      // TODO: Call repository to fetch customers
      await Future.delayed(const Duration(seconds: 1));
      customers.value = [
        {
          'id': 1,
          'name': 'John Doe',
          'email': 'john@example.com',
          'phone': '123456789',
        },
        {
          'id': 2,
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'phone': '987654321',
        },
      ];
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<Map<String, dynamic>> get filteredCustomers {
    if (searchQuery.isEmpty) {
      return customers;
    }
    return customers.where((customer) {
      final name = customer['name'].toString().toLowerCase();
      final email = customer['email'].toString().toLowerCase();
      final query = searchQuery.value.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }
}
