import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserStore extends ChangeNotifier {
  final Map<int, User> _users = {
    5: User(id: 5, name: "Janet Weaver", email: "janet.weaver@reqres.in"),
  };
  int _nextId = 100;

  User? getById(int id) => _users[id];
  List<User> get all => _users.values.toList();

  User create({required String name, required String email}) {
    final u = User(id: _nextId++, name: name, email: email);
    _users[u.id] = u;
    notifyListeners();
    return u;
  }

  bool update({required int id, String? name, String? email}) {
    final u = _users[id];
    if (u == null) return false;
    _users[id] = u.copyWith(name: name, email: email);
    notifyListeners();
    return true;
  }

  bool delete(int id) {
    final removed = _users.remove(id) != null;
    if (removed) notifyListeners();
    return removed;
  }
}
