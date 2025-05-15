import 'package:get/get.dart';
import 'package:gotrip/controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    // Inject the HistoryController as a dependency
    Get.lazyPut<HistoryController>(() => HistoryController());
    
    // If you have other dependencies required by the HistoryController
    // you can inject them here as well
    // For example:
    // Get.lazyPut<SomeOtherService>(() => SomeOtherService());
  }
}