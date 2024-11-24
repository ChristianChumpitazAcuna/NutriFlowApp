import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:myapp/models/ingredientModel.dart';
import 'package:myapp/screens/create/formScreens/instructionScreen.dart';
import 'package:myapp/services/ingredientService.dart';

class IngredientScreen extends StatefulWidget {
  final int? recipeId;
  const IngredientScreen({super.key, this.recipeId});

  @override
  State<IngredientScreen> createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  final IngredientService _ingredientService = IngredientService();
  final List<IngredientModel> _ingredients = [];
  final _formKey = GlobalKey<FormBuilderState>();

  void _addIngredients() {
    if (_formKey.currentState!.saveAndValidate()) {
      final formdata = _formKey.currentState?.value;

      if (formdata == null) return;
      if (widget.recipeId == null) return;

      final ingredient =
          IngredientModel(recipeId: widget.recipeId!, name: formdata['name']);

      setState(() {
        _ingredients.add(ingredient);
      });

      _formKey.currentState?.reset();
    }
  }

  Future<void> _submitForm() async {
    try {
      final response = await _ingredientService.postData(_ingredients);
      final recipeId = response.isNotEmpty ? response.first.recipeId : null;

      if (recipeId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InstructionScreen(recipeId: recipeId),
          ),
        );
      } else {
        print("Error al guardar los ingredientes");
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
      appBar: AppBar(title: const Text("Add Ingredients")),
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
            // Formulario para ingresar un ingrediente.
            FormBuilder(
              key: _formKey,
              child: FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(labelText: 'Ingredient Name'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addIngredients,
                  child: const Text('Add Ingredient'),
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
                itemCount: _ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = _ingredients[index];
                  return ListTile(
                    title: Text(ingredient.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _ingredients.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
