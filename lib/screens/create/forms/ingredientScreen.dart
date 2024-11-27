import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/models/ingredientModel.dart';
import 'package:myapp/screens/create/forms/instructionScreen.dart';
import 'package:myapp/services/ingredientService.dart';
import 'package:myapp/services/notificationService.dart';
import 'package:toastification/toastification.dart';

class IngredientScreen extends StatefulWidget {
  final int recipeId;
  const IngredientScreen({super.key, required this.recipeId});

  @override
  State<IngredientScreen> createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  final IngredientService _ingredientService = IngredientService();
  final List<IngredientModel> _ingredients = [];
  final _formKey = GlobalKey<FormBuilderState>();
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = false;

  void _addIngredients() {
    if (_formKey.currentState!.saveAndValidate()) {
      final formdata = _formKey.currentState?.value;

      if (formdata == null) return;
      if (widget.recipeId <= 0) return;

      final ingredient =
          IngredientModel(recipeId: widget.recipeId, name: formdata['name']);

      setState(() {
        _ingredients.add(ingredient);
      });

      _formKey.currentState?.reset();
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _ingredientService.postData(_ingredients);
      final recipeId = response.isNotEmpty ? response.first.recipeId : null;

      if (recipeId == null) return;
      if (context.mounted == false) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InstructionScreen(recipeId: recipeId),
        ),
      );
    } catch (e) {
      _notificationService.showNotification(
          context: context,
          message: 'Error al crear los ingredientes',
          type: ToastificationType.error);
      throw Exception("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Acción no permitida'),
              content: Text('No puedes retroceder en este momento.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Entendido'),
                ),
              ],
            ),
          );
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: screenWidth,
                        height: screenHeight / 4,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ingredientes',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 15, left: 30, right: 30),
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(50))),
                          child: Center(
                              child: SingleChildScrollView(
                                  child: FormBuilder(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormBuilderTextField(
                                          style: const TextStyle(
                                              color: Colors.white70),
                                          name: 'name',
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            labelText: 'Ingrediente',
                                            hintText: 'Nombre del ingrediente',
                                          ),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText:
                                                    'Debes ingresar un nombre'),
                                            FormBuilderValidators.minLength(4,
                                                errorText:
                                                    'El nombre debe tener al menos 4 caracteres'),
                                          ])),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          iconColor: Colors.black,
                                          shape: const CircleBorder(),
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: _addIngredients,
                                        child: const Icon(Icons.add)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color:
                                        const Color.fromARGB(255, 24, 24, 24),
                                  ),
                                  height: screenHeight / 2.5,
                                  child: ListView.builder(
                                    itemCount: _ingredients.length,
                                    itemBuilder: (context, index) {
                                      final ingredient = _ingredients[index];
                                      return ListTile(
                                        title: Text(
                                          ingredient.name,
                                          style: const TextStyle(
                                              color: Colors.white54),
                                        ),
                                        trailing: IconButton(
                                          style: IconButton.styleFrom(
                                              backgroundColor: Colors.black38),
                                          color: Colors.white54,
                                          icon:
                                              const Icon(Icons.delete_outline),
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
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            _submitForm(context);
                                          },
                                    child: Text(
                                      _isLoading ? 'Cargando...' : 'Siguiente',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                              ],
                            ),
                          )))),
                    ),
                  ],
                ),
                if (_isLoading)
                  Stack(
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      // Widget de animación de carga
                      Center(
                        child: LoadingAnimationWidget.dotsTriangle(
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            )));
  }
}
