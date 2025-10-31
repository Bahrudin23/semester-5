import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:intl/intl.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String binderApiKey =
    'b3bd081224ad7ffda42761d5e8c3c5ee5c7b1e3ff3bbdc85d6b2018aca46725a';

class Ke6_2Page extends StatefulWidget {
  const Ke6_2Page({super.key});

  @override
  State<Ke6_2Page> createState() => _Ke6_2PageState();
}

class _Ke6_2PageState extends State<Ke6_2Page> {
  int _selectedIndex = 0;
  final faker = Faker();
  final DateTime now = DateTime.now();

  List<dynamic> _provinces = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProvince();
  }

  Future<void> _fetchProvince() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final url = Uri.parse(
        'https://api.binderbyte.com/wilayah/provinsi?api_key=$binderApiKey',
      );
      final res = await http.get(url).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final List list = (data['value'] ?? []) as List;
        if (list.isNotEmpty) {
          setState(() => _provinces = list);
        } else {
          throw Exception('Data kosong');
        }
      } else {
        throw Exception('HTTP ${res.statusCode}');
      }
    } catch (e) {
      _error =
      'Gagal ambil API (${e.toString()}). Menampilkan data lokal sementara.';
      _provinces = const [
        {'name': 'Jawa Barat'},
        {'name': 'Jawa Tengah'},
        {'name': 'Jawa Timur'},
        {'name': 'DKI Jakarta'},
        {'name': 'Banten'},
      ];
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _fakerPage(),
      _avatarPage(),
      _dropdownPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modul 6 – Flutter Packages'),
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.people, title: 'Faker'),
          TabItem(icon: Icons.face, title: 'Avatar'),
          TabItem(icon: Icons.list_alt, title: 'Dropdown'),
        ],
        initialActiveIndex: 0,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }

  // ===== TAB 1: Faker + Intl =====
  Widget _fakerPage() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 10,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final name = faker.person.name();
        final email = faker.internet.email();
        final address = faker.address.city();
        final dateStr = DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
            .format(now.subtract(Duration(days: index * 2)));

        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(name),
          subtitle: Text('$email\n$address\nDibuat: $dateStr'),
          isThreeLine: true,
          trailing: Text('#${index + 1}'),
        );
      },
    );
  }

  // ===== TAB 2: Avatar Glow =====
  Widget _avatarPage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AvatarGlow(
            glowColor: Colors.blue,
            endRadius: 120,
            duration: const Duration(seconds: 2),
            repeatPauseDuration: const Duration(milliseconds: 120),
            child: Material(
              elevation: 8.0,
              shape: const CircleBorder(),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/icon/icon.jpeg'),
                radius: 60.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ===== TAB 3: DropdownSearch + API =====
  Widget _dropdownPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Pilih Provinsi Indonesia:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          if (_loading)
            const LinearProgressIndicator()
          else
            DropdownSearch<String>(
              items: _provinces.map((e) => e['name'].toString()).toList(),
              popupProps: const PopupProps.menu(showSearchBox: true),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Provinsi",
                  border: OutlineInputBorder(),
                ),
              ),
              onChanged: (value) {
                if (value == null) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Provinsi dipilih: $value')),
                );
              },
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _fetchProvince,
                icon: const Icon(Icons.refresh),
                label: const Text('Muat Ulang'),
              ),
              const SizedBox(width: 12),
              if (_error != null)
                Expanded(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.orange),
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
