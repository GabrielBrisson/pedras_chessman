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
    _carregarGemas();
  }

  Future<void> _carregarGemas() async {
    await service.getGems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedras do Chessman'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildDrawer(context),
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
          return _buildGemaTile(gema, 0);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarGema(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Pedras do Chessman',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Gestão de Gemas',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text('Novo Cadastro'),
            onTap: () {
              Navigator.pop(context);
              _adicionarGema(context);
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Todas as Gemas'),
            onTap: () {
              Navigator.pop(context);
              // Já estamos na tela principal
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGemaTile(Gema gema, int nivel) {
    final bool temFilhos = gema.filhos.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(left: nivel * 20.0, right: 12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ExpansionTile(
          leading: Icon(Icons.diamond, color: _getCorGema(gema.cor)),
          title: GestureDetector(
            onTap: () => _mostrarDetalhes(context, gema),
            child: Text(
              gema.nome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: GestureDetector(
            onTap: () => _mostrarDetalhes(context, gema),
            child: Text(
              '${gema.tipo} • ${gema.carats} ct • R\$ ${gema.valorEstimado.toStringAsFixed(2)}',
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (temFilhos)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '${gema.filhos.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
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
          children: [
            if (temFilhos)
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                child: Text(
                  'Sub-gemas:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),

            ...gema.filhos.map((filho) => _buildGemaTile(filho, nivel + 1)),

            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Colors.green),
              title: const Text('Adicionar sub-gema'),
              onTap: () => _adicionarSubGema(context, gema),
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Ver detalhes completos'),
              onTap: () => _mostrarDetalhes(context, gema),
            ),
          ],
        ),
      ),
    );
  }

  void _adicionarGema(BuildContext context) async {
    final novaGema = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormPage()),
    );

    if (novaGema != null) {
      await service.add(novaGema);
      _carregarGemas();
    }
  }

  void _adicionarSubGema(BuildContext context, Gema parent) async {
    final novaGema = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormPage(parentId: parent.id)),
    );

    if (novaGema != null) {
      await service.add(novaGema);
      _carregarGemas();
    }
  }

  void _editarGema(BuildContext context, Gema gema) async {
    final gemaEditada = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormPage(gema: gema)),
    );

    if (gemaEditada != null) {
      await service.update(gemaEditada);
      _carregarGemas();
    }
  }

  void _confirmarExclusao(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza? Todas as sub-gemas também serão excluídas.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              service.delete(id);
              _carregarGemas();
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
            Text('Valor: R\$ ${gema.valorEstimado.toStringAsFixed(2)}'),
            Text('Origem: ${gema.origem}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fechar'))],
      ),
    );
  }

  Color _getCorGema(String cor) {
    switch (cor.toLowerCase()) {
      case 'azul':
        return Colors.blue;
      case 'vermelho':
        return Colors.red;
      case 'verde':
        return Colors.green;
      case 'amarelo':
        return Colors.yellow;
      default:
        return Colors.purple;
    }
  }
}