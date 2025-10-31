class User {
  final int id;
  String name;
  String email;

  User({required this.id, required this.name, required this.email});

  User copyWith({int? id, String? name, String? email}) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
  );
}
