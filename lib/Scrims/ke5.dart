import 'dart:async';
import 'package:flutter/material.dart';

class Ke5Page extends StatelessWidget {
  const Ke5Page({super.key});

  @override
  Widget build(BuildContext context) => const MenuPage();
}

/// ===================== MENU =====================
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final demos = <_DemoItem>[
      _DemoItem('1) Penjumlahan & Pengurangan', const StatefulCounterPage()),
      _DemoItem('2) Dialog', const DialogDemo()),
      _DemoItem('3) SnackBar', const SnackbarSaveDemo()),
      _DemoItem('4) TextField + Form', const TextFieldFormDemo()),
      _DemoItem('5) TabBar', const TabBarDemo()),
      _DemoItem('6) Dropdown', const DropdownDemo()),
      _DemoItem('7) BottomNavigationBar', const BottomNavDemo()),
      _DemoItem('8) BottomSheet', const BottomSheetDemo()),
      _DemoItem('9) Drawer', const DrawerDemo()),
      _DemoItem('10) Navigation', const NavigationDemo()),
      _DemoItem('11) Studi Kasus: Todo + Reminder UI', const StudyCaseTodoDemo()),
    ];

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Flutter Modul Demo')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final item = demos[i];
          return ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => _DemoScaffold(title: item.title, child: item.child)),
            ),
          );
        },
      ),
    );
  }
}

class _DemoItem {
  final String title;
  final Widget child;
  _DemoItem(this.title, this.child);
}

class _DemoScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const _DemoScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: child);
  }
}

/// ===================== 1) STATEFUL =====================
class StatefulCounterPage extends StatefulWidget {
  const StatefulCounterPage({super.key});

  @override
  State<StatefulCounterPage> createState() => _StatefulCounterPageState();
}

class _StatefulCounterPageState extends State<StatefulCounterPage> {
  int nilai = 0;
  Timer? _timer;

  void _startChanging(bool tambah) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() => tambah ? nilai++ : nilai--);
    });
  }

  void _stopChanging() => _timer?.cancel();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Nilai', style: TextStyle(fontSize: 20)),
          Text('$nilai', style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTapDown: (_) => _startChanging(false),
                onTapUp: (_) => _stopChanging(),
                onTapCancel: _stopChanging,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => nilai--),
                  icon: const Icon(Icons.remove),
                  label: const Text('Kurangi'),
                ),
              ),
              GestureDetector(
                onTapDown: (_) => _startChanging(true),
                onTapUp: (_) => _stopChanging(),
                onTapCancel: _stopChanging,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => nilai++),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ===================== 2) DIALOG =====================
class DialogDemo extends StatelessWidget {
  const DialogDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.center, children: [
        FilledButton(
          onPressed: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text('Apakah kamu yakin?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                  FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
                ],
              ),
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pilihan: ${ok == true ? 'Ya' : 'Batal'}')),
              );
            }
          },
          child: const Text('AlertDialog'),
        ),
        OutlinedButton(
          onPressed: () async {
            final pilih = await showDialog<String>(
              context: context,
              builder: (_) => SimpleDialog(
                title: const Text('Pilih Bahasa'),
                children: [
                  SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Dart'), child: const Text('Dart')),
                  SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Kotlin'), child: const Text('Kotlin')),
                  SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Swift'), child: const Text('Swift')),
                ],
              ),
            );
            if (pilih != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kamu memilih: $pilih')));
            }
          },
          child: const Text('SimpleDialog'),
        ),
      ]),
    );
  }
}

/// ===================== 3) SNACKBAR  =====================
class SnackbarSaveDemo extends StatefulWidget {
  const SnackbarSaveDemo({super.key});
  @override
  State<SnackbarSaveDemo> createState() => _SnackbarSaveDemoState();
}

class _SnackbarSaveDemoState extends State<SnackbarSaveDemo> {
  int nilai = 0;
  Timer? _timer;

  void _startChanging(bool tambah) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() => tambah ? nilai++ : nilai--);
    });
  }

  void _stopChanging() => _timer?.cancel();

  void _simpan() {
    final tersimpan = nilai;
    setState(() => nilai = 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nilai kamu yang tersimpan adalah $tersimpan'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Nilai', style: TextStyle(fontSize: 20)),
          Text('$nilai', style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTapDown: (_) => _startChanging(false),
                onTapUp: (_) => _stopChanging(),
                onTapCancel: _stopChanging,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => nilai--),
                  icon: const Icon(Icons.remove),
                  label: const Text('Kurangi'),
                ),
              ),
              GestureDetector(
                onTapDown: (_) => _startChanging(true),
                onTapUp: (_) => _stopChanging(),
                onTapCancel: _stopChanging,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => nilai++),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _simpan,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

/// ===================== 4) TEXTFIELD + FORM =====================
class TextFieldFormDemo extends StatefulWidget {
  const TextFieldFormDemo({super.key});
  @override
  State<TextFieldFormDemo> createState() => _TextFieldFormDemoState();
}

class _TextFieldFormDemoState extends State<TextFieldFormDemo> {
  final _formKey = GlobalKey<FormState>();
  final _namaC = TextEditingController();
  final _emailC = TextEditingController();

  @override
  void dispose() {
    _namaC.dispose();
    _emailC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _namaC,
              decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailC,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v != null && v.contains('@')) ? null : 'Email tidak valid',
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final msg = 'Halo ${_namaC.text}, email: ${_emailC.text}';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}

/// ===================== 5) TABBAR =====================
class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Demo'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                tabs: const [
                  _ChipTab('Semua'),
                  _ChipTab('Trending'),
                  _ChipTab('Live'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Feed: Semua')),
            Center(child: Text('Feed: Trending')),
            Center(child: Text('Feed: Live')),
          ],
        ),
        backgroundColor: cs.surface,
      ),
    );
  }
}

class _ChipTab extends StatelessWidget {
  final String label;
  const _ChipTab(this.label);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: ShapeDecoration(
          color: cs.surfaceContainerHighest,
          shape: const StadiumBorder(),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

/// ===================== 6) DROPDOWN =====================
class DropdownDemo extends StatefulWidget {
  const DropdownDemo({super.key});
  @override
  State<DropdownDemo> createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<DropdownDemo> {
  final _opsi = ['Dart', 'Kotlin', 'Swift', 'Java'];
  String? _terpilih;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        hint: const Text('Pilih bahasa'),
        value: _terpilih,
        items: _opsi.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => setState(() => _terpilih = v),
      ),
    );
  }
}

/// ===================== 7) BOTTOM NAVIGATION BAR =====================
class BottomNavDemo extends StatefulWidget {
  const BottomNavDemo({super.key});
  @override
  State<BottomNavDemo> createState() => _BottomNavDemoState();
}

class _BottomNavDemoState extends State<BottomNavDemo> {
  int _index = 0;
  final _pages = const [
    Center(child: Text('Beranda')),
    Center(child: Text('Pencarian')),
    Center(child: Text('Profil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}

/// ===================== 8) BOTTOMSHEET =====================
class BottomSheetDemo extends StatelessWidget {
  const BottomSheetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(spacing: 12, children: [
        FilledButton(
          child: const Text('Modal BottomSheet'),
          onPressed: () => showModalBottomSheet(
            context: context,
            showDragHandle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            builder: (_) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  _AttachItem(icon: Icons.image,   label: 'Galeri',  color: Colors.blue),
                  _AttachItem(icon: Icons.camera_alt, label: 'Kamera',  color: Colors.pink),
                  _AttachItem(icon: Icons.location_on, label: 'Lokasi',  color: Colors.green),
                  _AttachItem(icon: Icons.contacts, label: 'Kontak',  color: Colors.cyan),
                  _AttachItem(icon: Icons.description, label: 'Dokumen', color: Colors.deepPurple),
                  _AttachItem(icon: Icons.audiotrack, label: 'Audio',   color: Colors.orange),
                ],
              ),
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            final scaffoldState = Scaffold.of(context);
            scaffoldState.showBottomSheet((context) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Expanded(child: Text('1 Pesan dihapus untuk saya')),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Urungkan')),
                  ],
                ),
              );
            });
          },
          child: const Text('Persistent BottomSheet'),
        ),
      ]),
    );
  }
}

class _AttachItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _AttachItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 26, backgroundColor: color, child: Icon(icon, color: Colors.white)),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

/// ===================== 9) DRAWER =====================
class DrawerDemo extends StatefulWidget {
  const DrawerDemo({super.key});
  @override
  State<DrawerDemo> createState() => _DrawerDemoState();
}

class _DrawerDemoState extends State<DrawerDemo> {
  bool _dark = false;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final titles = ['Dashboard', 'Deposit', 'Saldo Gratis'];
    return Theme(
      data: _dark ? ThemeData.dark(useMaterial3: true)
          : Theme.of(context).copyWith(useMaterial3: true),
      child: Scaffold(
        appBar: AppBar(title: Text(titles[_selected])),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const ListTile(
                  title: Text('MENU', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: .6)),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Dashboard'),
                  selected: _selected == 0,
                  onTap: () { setState(() => _selected = 0); Navigator.pop(context); },
                ),
                ExpansionTile(
                  leading: const Icon(Icons.shopping_cart_outlined),
                  title: const Text('Beli Nomor'),
                  children: const [
                    ListTile(leading: Icon(Icons.public),  title: Text('Semua Layanan')),
                    ListTile(leading: Icon(Icons.history), title: Text('Riwayat')),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  title: const Text('Deposit'),
                  selected: _selected == 1,
                  onTap: () { setState(() => _selected = 1); Navigator.pop(context); },
                ),
                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('Dapatkan saldo gratis'),
                  selected: _selected == 2,
                  onTap: () { setState(() => _selected = 2); Navigator.pop(context); },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('LAINNYA', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const ListTile(leading: Icon(Icons.info_outline),        title: Text('Informasi')),
                const ListTile(leading: Icon(Icons.description_outlined), title: Text('Ketentuan')),
                const ListTile(leading: Icon(Icons.code),                 title: Text('API Dokumentasi')),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Tema'),
                  value: _dark,
                  onChanged: (v) => setState(() => _dark = v),
                ),
              ],
            ),
          ),
        ),
        body: IndexedStack(
          index: _selected,
          children: const [
            Center(child: Text('Ringkasan Dashboard')),
            Center(child: Text('Menu Deposit')),
            Center(child: Text('Bagikan tautan untuk saldo gratis')),
          ],
        ),
      ),
    );
  }
}

/// ===================== 10) NAVIGATION =====================
class NavigationDemo extends StatelessWidget {
  const NavigationDemo({super.key});

  static PageRoute _animated(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, .08), end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/product':
            return _animated(const _NiceProduct(), settings: settings);
          case '/profile':
            return _animated(const _NiceProfile(), settings: settings);
          case '/':
          default:
            return _animated(const _NiceHome(), settings: settings);
        }
      },
    );
  }
}

class _NiceHome extends StatelessWidget {
  const _NiceHome();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text(
            'Selamat datang!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),

          _NavCard(
            leading: Hero(
              tag: 'hero-product',
              child: CircleAvatar(backgroundColor: cs.primary, child: const Icon(Icons.shopping_bag, color: Colors.white)),
            ),
            title: 'Product',
            subtitle: 'Lihat detail produk & aksi cepat',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed('/product'),
          ),
          const SizedBox(height: 12),

          _NavCard(
            leading: Hero(
              tag: 'hero-profile',
              child: CircleAvatar(backgroundColor: cs.secondary, child: const Icon(Icons.person, color: Colors.white)),
            ),
            title: 'Profile',
            subtitle: 'Kartu profil bergaya',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed('/profile'),
          ),
        ],
      ),
    );
  }
}

class _NiceProduct extends StatelessWidget {
  const _NiceProduct();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/profile'),
        icon: const Icon(Icons.person),
        label: const Text('Ke Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'hero-product',
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: cs.primary,
                    child: const Icon(Icons.shopping_bag, color: Colors.white, size: 32),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Nama Produk', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Deskripsi singkat produk untuk contoh tampilan.'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add_shopping_cart), label: const Text('Tambah')),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Kembali')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NiceProfile extends StatelessWidget {
  const _NiceProfile();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'hero-profile',
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: cs.secondary,
                    child: const Icon(Icons.person, color: Colors.white, size: 32),
                  ),
                ),
                const SizedBox(height: 12),
                Text('User Demo', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Ini hanya contoh kartu profil sederhana.'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Kembali')),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false), icon: const Icon(Icons.home_outlined), label: const Text('Home')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _NavCard({
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

/// ===================== 11) STUDI KASUS =====================
class StudyCaseTodoDemo extends StatefulWidget {
  const StudyCaseTodoDemo({super.key});
  @override
  State<StudyCaseTodoDemo> createState() => _StudyCaseTodoDemoState();
}

class _StudyCaseTodoDemoState extends State<StudyCaseTodoDemo> {
  final _todos = <_Todo>[];
  final _textC = TextEditingController();
  Duration _snooze = const Duration(minutes: 30);

  void _add() {
    if (_textC.text.trim().isEmpty) return;
    setState(() {
      _todos.add(_Todo(text: _textC.text.trim(), deadline: DateTime.now().add(const Duration(days: 1))));
      _textC.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tugas ditambahkan')));
  }

  @override
  void dispose() {
    _textC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo & Reminder (UI Saja)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _textC,
                  decoration: const InputDecoration(labelText: 'Tambah tugas', border: OutlineInputBorder()),
                  onSubmitted: (_) => _add(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _add, child: const Text('Tambah')),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              const Text('Snooze:'),
              const SizedBox(width: 8),
              DropdownButton<Duration>(
                value: _snooze,
                items: const [
                  DropdownMenuItem(value: Duration(minutes: 15), child: Text('15 menit')),
                  DropdownMenuItem(value: Duration(minutes: 30), child: Text('30 menit')),
                  DropdownMenuItem(value: Duration(hours: 1), child: Text('1 jam')),
                  DropdownMenuItem(value: Duration(hours: 2), child: Text('2 jam')),
                ],
                onChanged: (v) => setState(() => _snooze = v ?? _snooze),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Simulasi Notifikasi (UI)',
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notifikasi: 1 tugas mendekati deadline. Snooze ${_snooze.inMinutes} menit')),
                ),
                icon: const Icon(Icons.notifications_active_outlined),
              )
            ]),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: _todos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final t = _todos[i];
                  return ListTile(
                    leading: Checkbox(value: t.done, onChanged: (v) => setState(() => t.done = v ?? false)),
                    title: Text(t.text, style: TextStyle(decoration: t.done ? TextDecoration.lineThrough : null)),
                    subtitle: Text('Deadline: ${t.deadline}'),
                    trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() => _todos.removeAt(i))),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Todo {
  final String text;
  final DateTime deadline;
  bool done;
  _Todo({required this.text, required this.deadline, this.done = false});
}
