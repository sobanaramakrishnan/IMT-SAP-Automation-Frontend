import 'dart:io';
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

  @override
  void dispose() {
    try {
      dcNumberCtrl.dispose();
    } catch (_) {}
    try {
      partNameCtrl.dispose();
    } catch (_) {}
    try {
      partNumberCtrl.dispose();
    } catch (_) {}
    try {
      quantityCtrl.dispose();
    } catch (_) {}
    try {
      weightCtrl.dispose();
    } catch (_) {}
    super.dispose();
  }

  /// PICK IMAGE (OPTIONAL)
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  /// SUBMIT DC DETAILS
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
        imageFile: image, // OPTIONAL
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("DC details submitted successfully"),
        ),
      );

      /// CLEAR FORM AFTER SUBMIT
      dcNumberCtrl.clear();
      partNameCtrl.clear();
      partNumberCtrl.clear();
      quantityCtrl.clear();
      weightCtrl.clear();
      setState(() => image = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  InputDecoration input(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Delivery Challan (DC)"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// DC NUMBER
                  TextField(
                    controller: dcNumberCtrl,
                    decoration: input("DC Number"),
                  ),
                  const SizedBox(height: 16),

                  /// PART NAME
                  TextField(
                    controller: partNameCtrl,
                    decoration: input("Part Name"),
                  ),
                  const SizedBox(height: 16),

                  /// PART NUMBER
                  TextField(
                    controller: partNumberCtrl,
                    decoration: input("Part Number"),
                  ),
                  const SizedBox(height: 16),

                  /// WEIGHT + QUANTITY
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: weightCtrl,
                          keyboardType: TextInputType.number,
                          decoration: input("Weight (kg)"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: quantityCtrl,
                          keyboardType: TextInputType.number,
                          decoration: input("Quantity"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// IMAGE UPLOAD
                  const Text(
                    "Upload Image (Optional)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Container(
                        height: 90,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: image == null
                            ? const Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.grey,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: pickImage,
                          icon: const Icon(Icons.upload),
                          label: const Text(
                            "Browse or Drag & Drop",
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// SUBMIT BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: isLoading ? null : submit,
                        child: isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Submit"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}