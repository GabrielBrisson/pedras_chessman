import '../database/gems_database.dart';
import '../models/gema.dart';

class GemaService {
  final GemaDatabase _db = GemaDatabase.instance;

  List<Gema> _gemas = [];

  List<Gema> get gemas => _gemas;

  Future<void> getGems() async {
    _gemas = await _db.getAllHierarchical();
  }

  Future<void> add(Gema gema) async {
    await _db.insert(gema);
    await getGems();
  }

  Future<void> update(Gema gemaAtualizada) async {
    await _db.update(gemaAtualizada);
    await getGems();
  }

  Future<void> delete(String id) async {
    await _db.delete(id);
    await getGems();

    Future<List<Gema>> getFilhos(String parentId) async {
      return await _db.getFilhos(parentId);
    }

    Future<bool> hasFilhos(String id) async {
      return await _db.hasFilhos(id);
    }

    Future<void> deleteAll() async {
      await _db.deleteAll();
      _gemas.clear();
    }
  }
}
