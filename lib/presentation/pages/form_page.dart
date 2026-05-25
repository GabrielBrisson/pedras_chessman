import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/gema.dart';
import '../../data/services/gema_service.dart';

class FormPage extends StatefulWidget {
  final Gema? gema;        // Para edição
  final String? parentId;  // ← NOVO: Para criar sub-gema

  const FormPage({
    super.key,
    this.gema,
    this.parentId,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final GemaService service = GemaService();

  late TextEditingController _nomeController;
  late TextEditingController _tipoController;
  late TextEditingController _corController;
  late TextEditingController _caratsController;
  late TextEditingController _valorController;
  late TextEditingController _origemController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.gema?.nome);
    _tipoController = TextEditingController(text: widget.gema?.tipo);
    _corController = TextEditingController(text: widget.gema?.cor);
    _caratsController = TextEditingController(text: widget.gema?.carats.toString());
    _valorController = TextEditingController(text: widget.gema?.valorEstimado.toString());
    _origemController = TextEditingController(text: widget.gema?.origem);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tipoController.dispose();
    _corController.dispose();
    _caratsController.dispose();
    _valorController.dispose();
    _origemController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final gema = Gema(
        id: widget.gema?.id ?? const Uuid().v4(),
        nome: _nomeController.text.trim(),
        tipo: _tipoController.text.trim(),
        cor: _corController.text.trim(),
        carats: double.parse(_caratsController.text),
        valorEstimado: double.parse(_valorController.text),
        origem: _origemController.text.trim(),
        parentId: widget.parentId,   // ← Aqui salva o pai
      );

      Navigator.pop(context, gema);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.gema != null;
    final bool isSubGema = widget.parentId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Gema' : isSubGema ? 'Nova Sub-Gema' : 'Nova Gema'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (isSubGema)
                Card(
                  color: Colors.green[50],
                  child: const ListTile(
                    leading: Icon(Icons.subdirectory_arrow_right, color: Colors.green),
                    title: Text('Sub-gema'),
                    subtitle: Text('Esta gema será filha de outra'),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Gema'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _corController,
                decoration: const InputDecoration(labelText: 'Cor'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _caratsController,
                decoration: const InputDecoration(labelText: 'Peso (quilates)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo obrigatório';
                  if (double.tryParse(value) == null) return 'Valor inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor Estimado (RS)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo obrigatório';
                  if (double.tryParse(value) == null) return 'Valor inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: _origemController,
                decoration: const InputDecoration(labelText: 'Origem'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isEditing ? 'Atualizar Gema' : 'Cadastrar Gema'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}