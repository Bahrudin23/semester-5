import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get_storage/get_storage.dart';

import 'Scrims/beranda.dart';
import 'Scrims/ke5.dart';
import 'Scrims/ke6.dart';
import 'Scrims/ke6_2.dart';
import 'Scrims/ke9.dart';
import 'Scrims/ke9_2.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'id_ID';
  await initializeDateFormatting('id_ID', null);

  await GetStorage.init();

  Get.put(StorageController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navbar Demo',

      home: const MainNavbar(),

      getPages: [
        GetPage(
          name: '/named-second',
          page: () => const NamedSecondPage(),
        ),
      ],
    );
  }
}

class MainNavbar extends StatefulWidget {
  const MainNavbar({super.key});

  @override
  State<MainNavbar> createState() => _MainNavbarState();
}

class _MainNavbarState extends State<MainNavbar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const beranda(),
      const Ke5Page(),
      GetRequestPage(onGoTab: _onItemTapped),
      const Ke6_2Page(),
      const Ke9Page(),
      const Ke9_2Page(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Modul 5'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_download), label: 'GET'),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Modul 6'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Modul 9'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Modul 9_2'),
        ],
      ),
    );
  }
}