import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/gema.dart';

class FormPage extends StatefulWidget {
  final Gema? gema;
  const FormPage({this.gema, super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeCtrl;
  late TextEditingController _tipoCtrl;
  late TextEditingController _corCtrl;
  late TextEditingController _pesoCtrl;
  late TextEditingController _valorCtrl;
  late TextEditingController _origemCtrl;

  @override
  void initState() {
    super.initState();
    _nomeCtrl = TextEditingController(text: widget.gema?.nome);
    _tipoCtrl = TextEditingController(text: widget.gema?.tipo);
    _corCtrl = TextEditingController(text: widget.gema?.cor);
    _pesoCtrl = TextEditingController(text: widget.gema?.carats.toString());
    _valorCtrl = TextEditingController(text: widget.gema?.valorEstimado.toString());
    _origemCtrl = TextEditingController(text: widget.gema?.origem);
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _tipoCtrl.dispose();
    _corCtrl.dispose();
    _pesoCtrl.dispose();
    _valorCtrl.dispose();
    _origemCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gema == null ? 'Nova Gema' : 'Editar Gema'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeCtrl,
                decoration: const InputDecoration(labelText: 'Nome da Gema *'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _tipoCtrl,
                decoration: const InputDecoration(labelText: 'Tipo (Ex: Esmeralda, Rubi)'),
              ),
              TextFormField(
                controller: _corCtrl,
                decoration: const InputDecoration(labelText: 'Cor'),
              ),
              TextFormField(
                controller: _pesoCtrl,
                decoration: const InputDecoration(labelText: 'Peso em Quilates'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: _valorCtrl,
                decoration: const InputDecoration(labelText: 'Valor Estimado (RS)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: _origemCtrl,
                decoration: const InputDecoration(labelText: 'Origem'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final gema = Gema(
                      id: widget.gema?.id ?? const Uuid().v4(),
                      nome: _nomeCtrl.text.trim(),
                      tipo: _tipoCtrl.text.trim(),
                      cor: _corCtrl.text.trim(),
                      carats: double.tryParse(_pesoCtrl.text) ?? 0.0,
                      valorEstimado: double.tryParse(_valorCtrl.text) ?? 0.0,
                      origem: _origemCtrl.text.trim(),
                    );
                    Navigator.pop(context, gema);
                  }
                },
                child: Text(
                  widget.gema == null ? 'Cadastrar Gema' : 'Salvar Alterações',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}