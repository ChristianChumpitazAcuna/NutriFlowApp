import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/models/instructionModel.dart';
import 'package:myapp/services/instructionService.dart';
import 'package:myapp/services/notificationService.dart';
import 'package:myapp/widgets/navigationMenu.dart';
import 'package:toastification/toastification.dart';

class InstructionScreen extends StatefulWidget {
  final int recipeId;
  const InstructionScreen({super.key, required this.recipeId});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  final InstructionService _instructionService = InstructionService();
  final List<InstructionModel> _instructions = [];
  final _formKey = GlobalKey<FormBuilderState>();
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = false;

  void _addInstructions() {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState?.value;

      if (formData == null) return;
      if (widget.recipeId <= 0) return;

      final instruction = InstructionModel(
          recipeId: widget.recipeId,
          stepNumber: _instructions.length + 1,
          name: formData['name']);

      setState(() {
        _instructions.add(instruction);
      });

      _formKey.currentState?.reset();
    }
  }

  void _submitForm(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await _instructionService.postData(_instructions);

      if (response.isEmpty) return;
      await Future.delayed(Duration.zero);

      if (context.mounted == false) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationMenu(),
        ),
      );
    } catch (e) {
      _notificationService.showNotification(
          context: context,
          message: 'Error al crear las instrucciones',
          type: ToastificationType.error);

      print('Error: $e');
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
                              'Preparación',
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
                                            labelText: 'Instrucción',
                                            hintText: 'Instrucción a seguir',
                                          ),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText:
                                                    'Debes ingresar una instrucción'),
                                            FormBuilderValidators.minLength(6,
                                                errorText:
                                                    'La instrucción debe tener al menos 6 caracteres'),
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
                                        onPressed: _addInstructions,
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
                                    itemCount: _instructions.length,
                                    itemBuilder: (context, index) {
                                      final ingredient = _instructions[index];
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              (index + 1).toString(),
                                              style: const TextStyle(
                                                  color: Colors.white54),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              ingredient.name,
                                              style: const TextStyle(
                                                  color: Colors.white54),
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          style: IconButton.styleFrom(
                                              backgroundColor: Colors.black38),
                                          color: Colors.white54,
                                          icon:
                                              const Icon(Icons.delete_outline),
                                          onPressed: () {
                                            setState(() {
                                              _instructions.removeAt(index);
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
                                        : () async {
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
