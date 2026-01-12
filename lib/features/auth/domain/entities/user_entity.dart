class UserEntity {
  final String id;
  final String email;
  final String name;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
  });

  // Um usuário vazio/anônimo para evitar null checks na UI toda hora
  factory UserEntity.empty() {
    return const UserEntity(id: '', email: '', name: 'Visitante');
  }
}