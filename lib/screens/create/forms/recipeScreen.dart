import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:myapp/models/recipeModel.dart';
import 'package:myapp/screens/create/forms/ingredientScreen.dart';
import 'package:myapp/services/auth/authService.dart';
import 'package:myapp/services/notificationService.dart';
import 'package:myapp/services/recipeService.dart';
import 'package:toastification/toastification.dart';

class RecipeScreen extends StatefulWidget {
  final String imageUrl;
  const RecipeScreen({super.key, required this.imageUrl});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final RecipeService _recipeService = RecipeService();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _timeController = TextEditingController();
  final NotificationService _notificationService = NotificationService();
  String _displayTime = "00h 00min";
  bool _isLoading = false;
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<int> _getUserId() async {
    try {
      final id = await _authService.getUserId();
      setState(() {
        _userId = id;
      });

      return id;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void _validateForm(BuildContext context) async {
    if (_formKey.currentState!.saveAndValidate()) {
      FocusScope.of(context).unfocus();
      final formData = _formKey.currentState?.value;

      if (formData == null) return;
      if (widget.imageUrl.isEmpty) return;

      final servings = int.tryParse(formData['servings'].toString()) ?? 0;
      final recipe = RecipeModel(
          id: _userId,
          name: formData['name'],
          description: formData['description'],
          time: _timeController.text,
          servings: servings,
          imageUrl: widget.imageUrl);

      await _submitForm(context, recipe);
    }
  }

  Future<void> _submitForm(BuildContext context, RecipeModel recipe) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _recipeService.postData(recipe);
      final recipeId = response.id;
      if (recipeId == null || recipeId <= 0) return;

      if (context.mounted == false) return;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => IngredientScreen(
                  recipeId: recipeId,
                )),
      );
    } catch (e) {
      _notificationService.showNotification(
          context: context,
          message: 'Error: $e',
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                    width: screenWidth,
                    height: screenHeight / 4,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mi Receta',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                Expanded(
                  child: Container(
                      padding:
                          const EdgeInsets.only(top: 15, left: 30, right: 30),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(50))),
                      child: Center(
                          child: SingleChildScrollView(
                              child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                                style: const TextStyle(color: Colors.white70),
                                name: 'name',
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Nombre',
                                  hintText: 'Nombre de la receta',
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(6),
                                ])),
                            const SizedBox(height: 16),
                            FormBuilderTextField(
                                name: 'description',
                                style: const TextStyle(color: Colors.white70),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Descripción',
                                  hintText: 'Breve descripción de la receta',
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(10),
                                ])),
                            const SizedBox(height: 16),
                            FormBuilderTextField(
                                name: 'servings',
                                style: const TextStyle(color: Colors.white70),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: 'Porciones',
                                  hintText: 'Cantidad de porciones',
                                ),
                                keyboardType: TextInputType.number,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(1),
                                ])),
                            const SizedBox(height: 20),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        final selectedDuration =
                                            await showDurationPicker(
                                          helpText: 'Selecciona el tiempo',
                                          context: context,
                                          initialDuration: Duration.zero,
                                        );
                                        if (selectedDuration != null) {
                                          String formatTime =
                                              '${selectedDuration.inHours}h ${(selectedDuration.inMinutes % 60)} min';

                                          setState(() {
                                            _displayTime = formatTime;
                                          });

                                          _timeController.text = formatTime;
                                          _formKey.currentState?.fields['time']
                                              ?.didChange(
                                                  selectedDuration.toString());
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.timelapse_rounded,
                                              size: 30, color: Colors.white70),
                                          const SizedBox(width: 5),
                                          Text(
                                            _displayTime,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white60),
                                          ),
                                        ],
                                      ))
                                ]),
                            const SizedBox(height: 80),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        _validateForm(context);
                                      },
                                child: Text(
                                  _isLoading ? 'Cargando...' : 'Siguiente',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
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
        ));
  }
}
