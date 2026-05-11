import 'package:flutter/material.dart';
import '../../data/models/gema.dart';
import '../../data/services/gema_service.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GemaService service = GemaService();

  @override
  void initState() {
    super.initState();
    service.getGems().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedras do Chessman'),
        centerTitle: true,
      ),
      body: service.gemas.isEmpty
          ? const Center(
        child: Text(
          'Nenhuma gema cadastrada ainda.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: service.gemas.length,
        itemBuilder: (context, index) {
          final gema = service.gemas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(gema.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${gema.tipo} • ${gema.carats} ct • R\$ ${gema.valorEstimado.toStringAsFixed(2)}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editarGema(context, gema),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmarExclusao(context, gema.id),
                  ),
                ],
              ),
              onTap: () => _mostrarDetalhes(context, gema),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarGema(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _adicionarGema(BuildContext context) async {
    final novaGema = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormPage()),
    );

    if (novaGema != null) {
      service.add(novaGema);
      setState(() {});
    }
  }

  void _editarGema(BuildContext context, Gema gema) async {
    final gemaEditada = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormPage(gema: gema)),
    );

    if (gemaEditada != null) {
      service.update(gemaEditada);
      setState(() {});
    }
  }

  void _confirmarExclusao(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir esta gema?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              service.delete(id);
              setState(() {});
              Navigator.pop(ctx);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalhes(BuildContext context, Gema gema) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(gema.nome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${gema.tipo}'),
            Text('Cor: ${gema.cor}'),
            Text('Peso: ${gema.carats} quilates'),
            Text('Valor estimado: R\$ ${gema.valorEstimado.toStringAsFixed(2)}'),
            Text('Origem: ${gema.origem}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}