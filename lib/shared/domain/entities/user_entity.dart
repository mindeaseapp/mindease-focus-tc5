class UserEntity {
  final String id;
  final String email;
  final String name;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
  });

  String get displayName => (name.isNotEmpty) ? name : (email.isNotEmpty ? email : 'Usuário');

  // Um usuário vazio/anônimo para evitar null checks na UI toda hora
  factory UserEntity.empty() {
    return const UserEntity(id: '', email: '', name: '');
  }
}
