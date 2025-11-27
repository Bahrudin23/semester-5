import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// ===============================
/// HALAMAN PEMBUNGKUS UNTUK NAVBAR
/// ===============================
class Ke9_2Page extends StatelessWidget {
  const Ke9_2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const PraktikumGetXPage();
  }
}

/// ===============================
/// HALAMAN UTAMA PRAKTIKUM (MENU)
/// ===============================
class PraktikumGetXPage extends StatelessWidget {
  const PraktikumGetXPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItem("1. Dependency Management", () => Get.to(() => DepHomePage())),
      _MenuItem("2. Route Management", () => Get.to(() => RouteHomePage())),
      _MenuItem("3. Route Named", () => Get.to(() => NamedHomePage())),
      _MenuItem("4. Bindings Builder (Form)", () => Get.to(() => FormPage())),
      _MenuItem("5. Class Bindings", () => Get.to(() => ClassBindingPage())),
      _MenuItem("6. Get Storage", () => Get.to(() => StoragePage())),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Praktikum GetX")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          return ElevatedButton(
            onPressed: items[i].onTap,
            child: Text(items[i].title),
          );
        },
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final VoidCallback onTap;
  _MenuItem(this.title, this.onTap);
}

/// ==================================================
/// 1) DEPENDENCY MANAGEMENT
/// ==================================================
class MyController extends GetxController {
  var counter = 0.obs;
  void increment() => counter++;
}

class DepHomePage extends StatelessWidget {
  DepHomePage({super.key});

  final MyController c = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dependency Management")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
              "Counter: ${c.counter}",
              style: const TextStyle(fontSize: 24),
            )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: c.increment,
              child: const Text("Increment"),
            )
          ],
        ),
      ),
    );
  }
}

/// =========================================
/// 2) ROUTE MANAGEMENT
/// =========================================
class RouteHomePage extends StatelessWidget {
  const RouteHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Route Management")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.to(() => const RouteSecondPage()),
          child: const Text("Pindah ke Halaman Kedua"),
        ),
      ),
    );
  }
}

class RouteSecondPage extends StatelessWidget {
  const RouteSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Halaman Kedua")),
      body: Center(
        child: ElevatedButton(
          onPressed: Get.back,
          child: const Text("Kembali ke Halaman Pertama"),
        ),
      ),
    );
  }
}

/// =========================================
/// 3) ROUTE NAMED
/// =========================================
class NamedHomePage extends StatelessWidget {
  const NamedHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Route Named")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.toNamed('/named-second'),
          child: const Text("Pindah ke Halaman Kedua"),
        ),
      ),
    );
  }
}

class NamedSecondPage extends StatelessWidget {
  const NamedSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Halaman Kedua")),
      body: Center(
        child: ElevatedButton(
          onPressed: Get.back,
          child: const Text("Kembali ke Halaman Pertama"),
        ),
      ),
    );
  }
}

/// =================================================
/// 4) BINDINGS BUILDER (Form)
/// =================================================
class FormController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;

  void updateName(String v) => name.value = v;
  void updateEmail(String v) => email.value = v;

  bool validateForm() => name.isNotEmpty && email.isNotEmpty;
}

class FormBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FormController());
  }
}

/// ✅ STORAGE CONTROLLER (logika antrian + simpan 1 data)
class StorageController extends GetxController {
  final box = GetStorage();

  var pendingList = <Map<String, String>>[].obs;
  var selectedIndex = (-1).obs;
  var savedItem = Rxn<Map<String, String>>();

  @override
  void onInit() {
    super.onInit();

    pendingList.value = (box.read<List>('pendingList') ?? [])
        .map((e) => Map<String, String>.from(e))
        .toList();

    savedItem.value = box.read('savedItem') != null
        ? Map<String, String>.from(box.read('savedItem'))
        : null;
  }

  void addFromForm(String nama, String email) {
    pendingList.add({"nama": nama, "email": email});
    box.write('pendingList', pendingList.toList());
  }

  void select(int i) {
    selectedIndex.value = i;
  }

  void saveSelected() {
    if (savedItem.value != null) {
      Get.snackbar(
        "Gagal",
        "Masih ada data tersimpan. Hapus dulu sebelum simpan yang baru.",
      );
      return;
    }
    if (selectedIndex.value < 0 || selectedIndex.value >= pendingList.length) {
      Get.snackbar("Gagal", "Pilih data dulu yang mau disimpan.");
      return;
    }

    final item = pendingList[selectedIndex.value];

    savedItem.value = item;
    box.write('savedItem', item);

    pendingList.removeAt(selectedIndex.value);
    selectedIndex.value = -1;
    box.write('pendingList', pendingList.toList());

    Get.snackbar("Sukses", "Data berhasil disimpan.");
  }

  void showSaved() {
    if (savedItem.value == null) {
      Get.snackbar("Info", "Belum ada data tersimpan.");
      return;
    }
    final s = savedItem.value!;
    Get.snackbar(
      "Data Tersimpan",
      "Nama: ${s['nama']}\nEmail: ${s['email']}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteSaved() {
    if (savedItem.value == null) {
      Get.snackbar("Info", "Tidak ada data tersimpan untuk dihapus.");
      return;
    }
    savedItem.value = null;
    box.remove('savedItem');
    Get.snackbar(
      "Sukses",
      "Data tersimpan dihapus. Sekarang boleh simpan lagi.",
    );
  }
}

class FormPage extends StatelessWidget {
  FormPage({super.key});

  final FormController controller = Get.put(FormController());
  final StorageController storageC = Get.find<StorageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bindings Builder (Form)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Nama", controller.updateName),
            _buildTextField("Email", controller.updateEmail),
            const SizedBox(height: 20),
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nama: ${controller.name.value}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Email: ${controller.email.value}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.validateForm()) {
                  storageC.addFromForm(
                    controller.name.value,
                    controller.email.value,
                  );
                  Get.snackbar("Sukses", "Data masuk daftar Get Storage");
                  controller.name.value = "";
                  controller.email.value = "";
                } else {
                  Get.snackbar("Gagal", "Nama dan Email harus diisi");
                }
              },
              child: const Text("Kirim"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

/// =============================================
/// 5) CLASS BINDINGS
/// =============================================
class ControllerA extends GetxController {
  var valueA = "A".obs;
}

class ControllerB extends GetxController {
  var valueB = "B".obs;
}

class ClassBindingPage extends StatelessWidget {
  ClassBindingPage({super.key});

  final ControllerA a = Get.put(ControllerA());
  final ControllerB b = Get.put(ControllerB());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Class Bindings")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Value A: ${a.valueA}"),
            Text("Value B: ${b.valueB}"),
          ],
        ),
      ),
    );
  }
}

/// =======================================
/// 6) GET STORAGE
/// =======================================
class StoragePage extends StatelessWidget {
  StoragePage({super.key});

  final StorageController storageC = Get.find<StorageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Storage")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Daftar Data dari Form:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: storageC.pendingList.isEmpty
                    ? const Center(child: Text("Belum ada data masuk."))
                    : ListView.builder(
                  itemCount: storageC.pendingList.length,
                  itemBuilder: (context, i) {
                    final item = storageC.pendingList[i];
                    final isSelected =
                        storageC.selectedIndex.value == i;

                    return Card(
                      color: isSelected
                          ? Colors.deepPurple.withOpacity(0.2)
                          : null,
                      child: ListTile(
                        onTap: () => storageC.select(i),
                        title: Text("${i + 1}. ${item['nama']}"),
                        subtitle: Text(item['email'] ?? ""),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle,
                            color: Colors.deepPurple)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: storageC.saveSelected,
                      child: const Text("Simpan"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: storageC.showSaved,
                      child: const Text("Ambil Data"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: storageC.deleteSaved,
                      child: const Text("Hapus Data"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                storageC.savedItem.value == null
                    ? "Status: Belum ada data tersimpan."
                    : "Status: Ada 1 data tersimpan. Hapus dulu untuk simpan baru.",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          );
        }),
      ),
    );
  }
}
