class Country {
  final String code;
  final String name;
  final String capital;
  final String continent;
  final String emoji;

  Country({
    required this.code,
    required this.name,
    required this.capital,
    required this.continent,
    required this.emoji,
  });

  // Factory para crear Country desde JSON de GraphQL
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      capital: json['capital'] as String? ?? 'N/A',
      continent: json['continent']?['name'] as String? ?? 'N/A',
      emoji: json['emoji'] as String? ?? '🏳️',
    );
  }

  // Método para convertir Country a JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'capital': capital,
      'continent': continent,
      'emoji': emoji,
    };
  }

  @override
  String toString() {
    return 'Country(code: $code, name: $name, capital: $capital)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Country && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}