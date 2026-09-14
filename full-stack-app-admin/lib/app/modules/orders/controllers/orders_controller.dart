import 'package:get/get.dart';
import 'package:shopadmin/app/data/models/order_model.dart';
import 'package:shopadmin/app/data/repositories/order_repository.dart';

class OrdersController extends GetxController {
  final OrderRepository _repository = OrderRepository(Get.find());

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedOrders = await _repository.getOrders();
      orders.value = fetchedOrders;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load orders');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      await _repository.updateOrderStatus(orderId, status);
      final index = orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        orders[index] = orders[index].copyWith(status: status);
        orders.refresh();
      }
      Get.snackbar('Success', 'Order status updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status');
    }
  }
}
