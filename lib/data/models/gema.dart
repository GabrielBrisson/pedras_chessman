import 'package:uuid/uuid.dart';

class Gema {
  final String id;
  String nome;
  String tipo;
  String cor;
  double carats;
  double valorEstimado;
  String origem;
  String? parentId;
  List<Gema> filhos = [];

  Gema({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.cor,
    required this.carats,
    required this.valorEstimado,
    required this.origem,
    this.parentId,
    List<Gema>? filhos,
  }) {
    this.filhos = filhos ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'cor': cor,
      'carats': carats,
      'valorEstimado': valorEstimado,
      'origem': origem,
      'parentId': parentId,
    };
  }

  factory Gema.fromMap(Map<String, dynamic> map) {
    return Gema(
      id: map['id'],
      nome: map['nome'],
      tipo: map['tipo'],
      cor: map['cor'],
      carats: map['carats'].toDouble(),
      valorEstimado: map['valorEstimado'].toDouble(),
      origem: map['origem'],
      parentId: map['parentId'],
      filhos: [],
    );
  }
}