import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/dc_service.dart';

class DcForm extends StatefulWidget {
  final int userId;
  const DcForm({super.key, required this.userId});

  @override
  State<DcForm> createState() => _DcFormState();
}

class _DcFormState extends State<DcForm> {
  final dcNumberCtrl = TextEditingController();
  final partNameCtrl = TextEditingController();
  final partNumberCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  File? image;
  bool isLoading = false;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => image = File(picked.path));
  }

  Future<void> submit() async {
    setState(() => isLoading = true);

    try {
      await DcService.submitDcDetails(
        userId: widget.userId,
        dcNumber: dcNumberCtrl.text,
        partName: partNameCtrl.text,
        partNumber: partNumberCtrl.text,
        quantity: int.parse(quantityCtrl.text),
        weight: double.parse(weightCtrl.text),
        imageFile: image,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("DC details submitted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("DC FORM"),
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE0E0E0),
                  Color(0xFFBDBDBD),
                ],
              ),
            ),
          ),

          // Blur Layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(color: Colors.white.withOpacity(0.1)),
          ),

          // Form Card
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Delivery Challan Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextField(
                        controller: dcNumberCtrl,
                        decoration: _inputStyle("DC Number", Icons.confirmation_number),
                      ),
                      const SizedBox(height: 14),

                      TextField(
                        controller: partNameCtrl,
                        decoration: _inputStyle("Part Name", Icons.precision_manufacturing),
                      ),
                      const SizedBox(height: 14),

                      TextField(
                        controller: partNumberCtrl,
                        decoration: _inputStyle("Part Number", Icons.numbers),
                      ),
                      const SizedBox(height: 14),

                      TextField(
                        controller: quantityCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputStyle("Quantity", Icons.inventory),
                      ),
                      const SizedBox(height: 14),

                      TextField(
                        controller: weightCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputStyle("Weight (Kg)", Icons.scale),
                      ),
                      const SizedBox(height: 20),

                      // Image Picker Card
                      InkWell(
                        onTap: pickImage,
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: image == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image, size: 40, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text("Tap to upload image"),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(image!, fit: BoxFit.cover),
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 6,
                          ),
                          onPressed: isLoading ? null : submit,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "SUBMIT DC",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
