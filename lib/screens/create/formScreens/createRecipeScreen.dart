import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:myapp/models/recipeModel.dart';
import 'package:myapp/screens/create/formScreens/ingredientScreen.dart';
import 'package:myapp/services/recipeService.dart';

class CreateRecipeScreen extends StatefulWidget {
  final String imageUrl;
  const CreateRecipeScreen({super.key, required this.imageUrl});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final RecipeService _recipeService = RecipeService();
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _timeController = TextEditingController();

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState?.value;

      if (formData == null) return;
      if (widget.imageUrl.isEmpty) return;

      print(formData.toString());

      final servings = int.tryParse(formData['servings'].toString()) ?? 0;
      final recipe = RecipeModel(
          name: formData['name'],
          description: formData['description'],
          time: formData['time'],
          servings: servings,
          imageUrl: widget.imageUrl);

      try {
        // final response = await _recipeService.postData(recipe);
        // final recipeId = response.id;

        // if (context.mounted == false) return;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => IngredientScreen(recipeId: recipeId),
        //   ),
        // );
      } catch (e) {
        throw Exception("Error: $e");
      }
    } else {
      print('Form is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        Container(
            height: screenHeight,
            width: screenWidth - 10,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                      name: 'name',
                      decoration: const InputDecoration(labelText: 'Nombre '),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(10),
                      ])),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                      name: 'description',
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(10),
                      ])),
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(Icons.timelapse),
                    onPressed: () async {
                      final selectedDuration = await showDurationPicker(
                        context: context,
                        initialDuration: Duration.zero,
                      );
                      if (selectedDuration != null) {
                        _timeController.text = selectedDuration
                            .toString(); // Actualizar el controlador
                        // Opcional: actualizar el campo del formulario con el valor
                        _formKey.currentState?.fields['time']
                            ?.didChange(selectedDuration.toString());
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                      name: 'servings',
                      decoration: const InputDecoration(labelText: 'Porciones'),
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(1),
                      ])),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _submitForm(context);
                    },
                    child: const Text('Siguiente'),
                  ),
                ],
              ),
            ))
      ],
    ));
  }
}
