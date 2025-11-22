import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers.dart';


class Ke9Page extends StatelessWidget {
  const Ke9Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modul 9 - GetX")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // 1. Stateless vs Stateful
            Text(
              "1. Stateless vs Stateful",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Card(child: Padding(padding: EdgeInsets.all(12), child: StatelessExample())),
            SizedBox(height: 8),
            Card(child: Padding(padding: EdgeInsets.all(12), child: StatefulExample())),
            SizedBox(height: 16),

            // 2. GetX State Management
            Text(
              "2. GetX State Management",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Card(child: Padding(padding: EdgeInsets.all(12), child: GetXCounterSection())),
            SizedBox(height: 16),

            // 3. Snackbar
            Text(
              "3. Snackbar GetX",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Card(child: Padding(padding: EdgeInsets.all(12), child: SnackBarSection())),
            SizedBox(height: 16),

            // 4. Dialog
            Text(
              "4. Dialog GetX",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Card(child: Padding(padding: EdgeInsets.all(12), child: DialogSection())),
            SizedBox(height: 16),

            // 5. Bottom Sheet
            Text(
              "5. Bottom Sheet GetX",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Card(child: Padding(padding: EdgeInsets.all(12), child: BottomSheetSection())),
            SizedBox(height: 16),

            // 6. Reactive Variables
            Text(
              "6. Reactive Variables",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Card(child: Padding(padding: EdgeInsets.all(12), child: ReactiveSection())),
            SizedBox(height: 16),

            // 7. Worker
            Text(
              "7. Worker",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Card(child: Padding(padding: EdgeInsets.all(12), child: WorkerSection())),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 1. Stateless & Stateful
// ============================================================

class StatelessExample extends StatelessWidget {
  const StatelessExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Ini adalah Stateless Widget"),
    );
  }
}

class StatefulExample extends StatefulWidget {
  const StatefulExample({super.key});

  @override
  State<StatefulExample> createState() => _StatefulExampleState();
}

class _StatefulExampleState extends State<StatefulExample> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Counter: $counter"),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => counter++),
              child: const Text("Increment"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => setState(() => counter--),
              child: const Text("Decrement"),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// 2. GetX State Management
// ============================================================

class GetXCounterSection extends StatelessWidget {
  const GetXCounterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Text("Counter: ${counterController.counter}")),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: counterController.increment,
              child: const Text("Increment"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: counterController.decrement,
              child: const Text("Decrement"),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// 3. SnackBar
// ============================================================

class SnackBarSection extends StatelessWidget {
  const SnackBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ini Adalah SnackBar Normal")),
            );
          },
          child: const Text("Normal SnackBar"),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            Get.snackbar(
              "Hello",
              "Ini Adalah GetX SnackBar",
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: const Text("GetX SnackBar"),
        ),
      ],
    );
  }
}

// ============================================================
// 4. Dialog
// ============================================================

class DialogSection extends StatelessWidget {
  const DialogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Hello"),
                content: const Text("Ini Adalah normal dialog"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ],
              ),
            );
          },
          child: const Text("Normal Dialog"),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            Get.defaultDialog(
              title: "Hello",
              middleText: "Ini Adalah GetX Dialog",
            );
          },
          child: const Text("GetX Dialog"),
        ),
      ],
    );
  }
}

// ============================================================
// 5. Bottom Sheet
// ============================================================

class BottomSheetSection extends StatelessWidget {
  const BottomSheetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => Container(
                padding: const EdgeInsets.all(16),
                child: const Text("Ini Adalah normal Bottom Sheet"),
              ),
            );
          },
          child: const Text("Normal Bottom Sheet"),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            Get.bottomSheet(
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: const Text("Ini Adalah GetX Bottom Sheet"),
              ),
            );
          },
          child: const Text("GetX Bottom Sheet"),
        ),
      ],
    );
  }
}

// ============================================================
// 6. Reactive Variables
// ============================================================

class ReactiveSection extends StatelessWidget {
  const ReactiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Text("Name: ${reactiveController.name}")),
        const SizedBox(height: 8),
        TextField(
          onChanged: reactiveController.changeName,
          decoration: const InputDecoration(labelText: "Enter name"),
        ),
      ],
    );
  }
}

// ============================================================
// 7. Worker
// ============================================================

class WorkerSection extends StatelessWidget {
  const WorkerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
              () => Text(
            "Count: ${workerController.count}",
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: workerController.increment,
              child: const Text("Increment"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: workerController.decrement,
              child: const Text("Decrement"),
            ),
          ],
        ),
      ],
    );
  }
}
