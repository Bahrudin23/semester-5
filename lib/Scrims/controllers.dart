import 'package:get/get.dart';

class CounterController extends GetxController {
  var counter = 0.obs;

  void increment() => counter.value++;
  void decrement() => counter.value--;
}

class ReactiveController extends GetxController {
  var name = "User".obs;

  void changeName(String newName) => name.value = newName;
}

class WorkerController extends GetxController {
  var count = 0.obs;

  @override
  void onInit() {
    ever(count, (_) => print("ever: Count changed to $count"));
    once(count, (_) => print("once: Count first changed to $count"));
    interval(
      count,
          (_) => print("interval: Count changed to $count"),
      time: const Duration(seconds: 2),
    );
    super.onInit();
  }

  void increment() => count.value++;
  void decrement() => count.value--;
}

final CounterController counterController = Get.put(CounterController());
final ReactiveController reactiveController = Get.put(ReactiveController());
final WorkerController workerController = Get.put(WorkerController());
