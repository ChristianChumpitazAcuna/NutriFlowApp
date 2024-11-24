import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:myapp/models/instructionModel.dart';
import 'package:myapp/services/instructionService.dart';

class InstructionScreen extends StatefulWidget {
  final int? recipeId;
  const InstructionScreen({super.key, this.recipeId});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  final InstructionService _instructionService = InstructionService();
  final List<InstructionModel> _instructions = [];
  final _formKey = GlobalKey<FormBuilderState>();

  void _addInstructions() {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState?.value;

      if (formData == null) return;
      if (widget.recipeId == null) return;

      final instruction = InstructionModel(
          recipeId: widget.recipeId!,
          stepNumber: _instructions.length + 1,
          name: formData['name']);

      setState(() {
        _instructions.add(instruction);
      });

      _formKey.currentState?.reset();
      print(_instructions);
    }
  }

  void _removeInstruction(int index) {
    setState(() {
      _instructions.removeAt(index);
    });
  }

  void _submitForm() async {
    try {
      final response = await _instructionService.postData(_instructions);

      if (response.isNotEmpty) {
        Navigator.pop(context);
      } else {
        print("Error al guardar las instrucciones");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: const Text("Add Instructions")),
        body: Container(
          height: screenHeight,
          width: screenWidth - 10,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                        name: 'name',
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(3),
                        ])),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _addInstructions,
                    child: const Text('Add Instruction'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _instructions.length,
                  itemBuilder: (context, index) {
                    final instruction = _instructions[index];
                    return ListTile(
                      title: Text(instruction.name),
                      subtitle: Text(
                        (index + 1).toString(),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeInstruction(index),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
