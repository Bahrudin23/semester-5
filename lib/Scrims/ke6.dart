import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class SimpleUser {
  final int id;
  String name;
  String email;

  SimpleUser({required this.id, required this.name, required this.email});

  factory SimpleUser.fromReqres(Map<String, dynamic> json) {
    return SimpleUser(
      id: json['id'] as int,
      name: "${json['first_name']} ${json['last_name']}",
      email: json['email'] as String,
    );
  }
}

class GetRequestPage extends StatefulWidget {
  final void Function(int index)? onGoTab;
  const GetRequestPage({super.key, this.onGoTab});

  @override
  State<GetRequestPage> createState() => _GetRequestPageState();
}

class _GetRequestPageState extends State<GetRequestPage> {
  final List<SimpleUser> _users = [];
  int _nextId = 1;

  void addLocalUser({required String name, required String email}) {
    final u = SimpleUser(id: _nextId++, name: name, email: email);
    setState(() => _users.add(u));
  }

  Future<void> fetchFromReqresAndAdd({required int id, BuildContext? ctx}) async {
    try {
      final res = await http.get(Uri.parse("https://reqres.in/api/users/$id"));
      if (res.statusCode == 200) {
        final body = json.decode(res.body) as Map<String, dynamic>;
        final data = body["data"] as Map<String, dynamic>;
        final fetched = SimpleUser.fromReqres(data);

        final idx = _users.indexWhere((e) => e.id == fetched.id);
        setState(() {
          if (idx >= 0) {
            _users[idx] = fetched;
          } else {
            _users.add(fetched);
          }
        });

        ScaffoldMessenger.of(ctx ?? context).showSnackBar(
          const SnackBar(content: Text("Berhasil GET dari reqres.in")),
        );
      } else {
        ScaffoldMessenger.of(ctx ?? context).showSnackBar(
          SnackBar(content: Text("Gagal GET: ${res.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx ?? context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void deleteLocalById(int id, {BuildContext? ctx}) {
    final before = _users.length;
    _users.removeWhere((e) => e.id == id);
    final removed = _users.length < before;

    setState(() {});
    ScaffoldMessenger.of(ctx ?? context).showSnackBar(
      SnackBar(content: Text(removed ? "Berhasil hapus id=$id" : "ID $id tidak ditemukan")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("HTTP Requests"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "GET"),
              Tab(text: "POST"),
              Tab(text: "PATCH"),
              Tab(text: "DELETE"),
              Tab(text: "FUTURE"),
              Tab(text: "MODEL"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _GetTab(
              users: _users,
              onFetchOne: (id) => fetchFromReqresAndAdd(id: id),
            ),
            _PostTab(
              onSubmit: (name, email) {
                addLocalUser(name: name, email: email);
                DefaultTabController.of(context).animateTo(0);
              },
            ),
            _PatchTab(
              onPatch: (id, newName, newEmail) {
                final idx = _users.indexWhere((e) => e.id == id);
                if (idx >= 0) {
                  setState(() {
                    if (newName != null && newName.trim().isNotEmpty) {
                      _users[idx].name = newName.trim();
                    }
                    if (newEmail != null && newEmail.trim().isNotEmpty) {
                      _users[idx].email = newEmail.trim();
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Berhasil update")),
                  );
                  DefaultTabController.of(context).animateTo(0);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ID $id tidak ditemukan")),
                  );
                }
              },
            ),
            _DeleteTab(
              onDelete: (id) {
                deleteLocalById(id);
                DefaultTabController.of(context).animateTo(0);
              },
            ),
            const _FutureUsersTab(),
            const _ModelUserTab(),
          ],
        ),
      ),
    );
  }
}

class _GetTab extends StatefulWidget {
  final List<SimpleUser> users;
  final Future<void> Function(int id) onFetchOne;

  const _GetTab({required this.users, required this.onFetchOne});

  @override
  State<_GetTab> createState() => _GetTabState();
}

class _GetTabState extends State<_GetTab> {
  final idC = TextEditingController(text: "");
  bool loading = false;

  @override
  void dispose() {
    idC.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => loading = true);
    await widget.onFetchOne(int.tryParse(idC.text) ?? 5);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: idC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Masukkan Data ID",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: loading ? null : _fetch,
                icon: const Icon(Icons.cloud_download),
                label: Text(loading ? "Loading..." : "Fetch & Add"),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: widget.users.isEmpty
              ? const Center(child: Text("Belum ada data. Tambah dari POST atau Fetch dari GET."))
              : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: widget.users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final u = widget.users[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(u.id.toString())),
                  title: Text(u.name),
                  subtitle: Text(u.email),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PostTab extends StatefulWidget {
  final void Function(String name, String email) onSubmit;
  const _PostTab({required this.onSubmit});

  @override
  State<_PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<_PostTab> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: nameC,
          decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: emailC,
          decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            final name = nameC.text.trim();
            final email = emailC.text.trim();
            if (name.isEmpty || email.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Name & Email tidak boleh kosong")),
              );
              return;
            }
            widget.onSubmit(name, email);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Berhasil tambah")),
            );
            nameC.clear();
            emailC.clear();
          },
          icon: const Icon(Icons.add),
          label: const Text("Tambah"),
        ),
      ],
    );
  }
}


class _PatchTab extends StatefulWidget {
  final void Function(int id, String? name, String? email) onPatch;
  const _PatchTab({required this.onPatch});

  @override
  State<_PatchTab> createState() => _PatchTabState();
}

class _PatchTabState extends State<_PatchTab> {
  final idC = TextEditingController();
  final nameC = TextEditingController();
  final emailC = TextEditingController();

  @override
  void dispose() {
    idC.dispose();
    nameC.dispose();
    emailC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: idC,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Masukkan ID yang mau diubah", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: nameC,
          decoration: const InputDecoration(labelText: "Nama baru", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: emailC,
          decoration: const InputDecoration(labelText: "Email baru", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            final id = int.tryParse(idC.text);
            if (id == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("ID harus angka")),
              );
              return;
            }
            widget.onPatch(
              id,
              nameC.text.trim().isEmpty ? null : nameC.text.trim(),
              emailC.text.trim().isEmpty ? null : emailC.text.trim(),
            );
          },
          icon: const Icon(Icons.save_alt),
          label: const Text("Update"),
        ),
      ],
    );
  }
}

class _DeleteTab extends StatefulWidget {
  final void Function(int id) onDelete;
  const _DeleteTab({required this.onDelete});

  @override
  State<_DeleteTab> createState() => _DeleteTabState();
}

class _DeleteTabState extends State<_DeleteTab> {
  final idC = TextEditingController();

  @override
  void dispose() {
    idC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: idC,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Masukkan ID yang mau dihapus", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            final id = int.tryParse(idC.text);
            if (id == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("ID harus angka")),
              );
              return;
            }
            widget.onDelete(id);
          },
          icon: const Icon(Icons.delete),
          label: const Text("Hapus"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        ),
      ],
    );
  }
}

// ===== Helpers untuk tab FUTURE & MODEL =====
Future<List<User>> _fetchUsersPage(int page) async {
  final r = await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));
  if (r.statusCode == 200) {
    final body = json.decode(r.body) as Map<String, dynamic>;
    final list = (body['data'] as List).cast<Map<String, dynamic>>();
    return list.map((e) => User(
      id: e['id'] as int,
      name: '${e['first_name']} ${e['last_name']}',
      email: e['email'] as String,
    )).toList();
  }
  throw Exception('Gagal GET users (status ${r.statusCode})');
}

Future<User> _fetchUserById(int id) async {
  final r = await http.get(Uri.parse('https://reqres.in/api/users/$id'));
  if (r.statusCode == 200) {
    final body = json.decode(r.body) as Map<String, dynamic>;
    final d = body['data'] as Map<String, dynamic>;
    return User(
      id: d['id'] as int,
      name: '${d['first_name']} ${d['last_name']}',
      email: d['email'] as String,
    );
  }
  throw Exception('User $id tidak ditemukan (status ${r.statusCode})');
}


class _FutureUsersTab extends StatefulWidget {
  const _FutureUsersTab();

  @override
  State<_FutureUsersTab> createState() => _FutureUsersTabState();
}

class _FutureUsersTabState extends State<_FutureUsersTab> {
  late Future<List<User>> _future;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _future = _fetchUsersPage(_page);
  }

  void _reload() {
    setState(() => _future = _fetchUsersPage(_page));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Text('Page:'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _page,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1')),
                  DropdownMenuItem(value: 2, child: Text('2')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _page = v;
                    _future = _fetchUsersPage(_page);
                  });
                },
              ),
              const Spacer(),
              IconButton(onPressed: _reload, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: FutureBuilder<List<User>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              }
              final data = snap.data!;
              if (data.isEmpty) {
                return const Center(child: Text('Tidak ada data'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final u = data[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(u.id.toString())),
                      title: Text(u.name),
                      subtitle: Text(u.email),
                      trailing: Text('#${u.id}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ModelUserTab extends StatefulWidget {
  const _ModelUserTab();

  @override
  State<_ModelUserTab> createState() => _ModelUserTabState();
}

class _ModelUserTabState extends State<_ModelUserTab> {
  final _idC = TextEditingController(text: '');
  Future<User>? _future;

  @override
  void dispose() {
    _idC.dispose();
    super.dispose();
  }

  void _load() {
    final id = int.tryParse(_idC.text.trim());
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID harus angka')),
      );
      return;
    }
    setState(() => _future = _fetchUserById(id));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _idC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ID User (reqres)',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _load(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.search),
                label: const Text('Cari'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _future == null
                ? const Center(child: Text('Masukkan ID lalu tekan Cari'))
                : FutureBuilder<User>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(
                    child: Text(
                      'Data tidak ditemukan / error:\n${snap.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                final u = snap.data!;
                return Center(
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(child: Text(u.id.toString())),
                          const SizedBox(height: 10),
                          Text(u.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          Text(u.email),
                          const SizedBox(height: 8),
                          Text('ID: ${u.id}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}