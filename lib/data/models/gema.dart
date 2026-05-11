class Gema {
  final String id;
  String nome;
  String tipo;
  String cor;
  double carats;
  double valorEstimado;
  String origem;

  Gema({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.cor,
    required this.carats,
    required this.valorEstimado,
    required this.origem,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'cor': cor,
      'carats': carats,
      'valorEstimado': valorEstimado,
      'origem': origem,
    };
  }

  factory Gema.fromJson(Map<String, dynamic> json) {
    return Gema(
      id: json['id'],
      nome: json['nome'],
      tipo: json['tipo'],
      cor: json['cor'],
      carats: json['carats'].toDouble(),
      valorEstimado: json['valorEstimado'].toDouble(),
      origem: json['origem'],
    );
  }
}