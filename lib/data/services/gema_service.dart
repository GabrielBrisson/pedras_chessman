import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/gema.dart';

class GemaService {
  List<Gema> _gemas = [];
  late File _arquivo;

  List<Gema> get gemas => _gemas;

  Future<void> _salvarGemas() async {
    String conteudo = json.encode(_gemas.map((g) => g.toJson()).toList());
    await _arquivo.writeAsString(conteudo);
  }

  Future<void> getGems() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _arquivo = File('${dir.path}/gemas.json');

      if (await _arquivo.exists()) {
        String conteudo = await _arquivo.readAsString();
        List<dynamic> dados = json.decode(conteudo);
        _gemas = dados.map((item) => Gema.fromJson(item)).toList();
      }
    } catch (e) {
      _gemas = [];
    }
  }

  void add(Gema gema) {
    _gemas.add(gema);
    _salvarGemas();
  }

  void update(Gema gemaAtualizada) {
    int index = _gemas.indexWhere((g) => g.id == gemaAtualizada.id);
    if (index != -1) {
      _gemas[index] = gemaAtualizada;
      _salvarGemas();
    }
  }

  void delete(String id) {
    _gemas.removeWhere((g) => g.id == id);
    _salvarGemas();
  }
}