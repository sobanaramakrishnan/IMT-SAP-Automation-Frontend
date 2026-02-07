import 'package:flutter/material.dart';
import '../models/dc_details.dart';

class DcVerificationDialog extends StatefulWidget {
  final DcDetails dc;

  const DcVerificationDialog({super.key, required this.dc});

  @override
  State<DcVerificationDialog> createState() => _DcVerificationDialogState();
}

class _DcVerificationDialogState extends State<DcVerificationDialog> {
  String processDecision = "Machining";
  final TextEditingController remarksCtrl = TextEditingController();
  final TextEditingController verifiedWeightCtrl = TextEditingController();
  final TextEditingController verifiedQuantityCtrl = TextEditingController();

  @override
  void dispose() {
    try {
      remarksCtrl.dispose();
    } catch (_) {}
    try {
      verifiedWeightCtrl.dispose();
    } catch (_) {}
    try {
      verifiedQuantityCtrl.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "DC Verification",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const Divider(),

              /// BODY
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT SIDE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _info("DC Number", widget.dc.dcNumber),
                        _info("Part Name", widget.dc.partName),
                        _info("Part Number", widget.dc.partNumber),
                        _info("Weight", "${widget.dc.weight} kg"),
                        _info("Quantity", widget.dc.quantity.toString()),
                        const SizedBox(height: 12),

                        /// IMAGE
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: widget.dc.imageUrl != null
                              ? Image.network(
                                  widget.dc.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 40),
                                )
                              : const Center(
                                  child: Icon(Icons.image, size: 40),
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// RIGHT SIDE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// VERIFIED WEIGHT
                        TextField(
                          controller: verifiedWeightCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Verified Weight (kg)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// VERIFIED QUANTITY
                        TextField(
                          controller: verifiedQuantityCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Verified Quantity",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// PROCESS DECISION
                        DropdownButtonFormField<String>(
                          value: processDecision,
                          items: const [
                            DropdownMenuItem(
                              value: "Machining",
                              child: Text("Machining"),
                            ),
                            DropdownMenuItem(
                              value: "Assembly",
                              child: Text("Assembly"),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => processDecision = v!),
                          decoration: const InputDecoration(
                            labelText: "Process Decision",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// REMARKS
                        TextField(
                          controller: remarksCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: "Remarks (Optional)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ACTION BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        // TODO: Approve API
                        Navigator.pop(context);
                      },
                      child: const Text("Verify & Approve"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      onPressed: () {
                        // TODO: Reject API
                        Navigator.pop(context);
                      },
                      child: const Text("Reject"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}