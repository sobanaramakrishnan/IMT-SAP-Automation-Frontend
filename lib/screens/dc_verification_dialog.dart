import 'package:flutter/material.dart';
import '../models/dc_details.dart';
import '../services/dc_service.dart';

class DcVerificationDialog extends StatefulWidget {
  final DcDetails dc;

  const DcVerificationDialog({super.key, required this.dc});

  @override
  State<DcVerificationDialog> createState() => _DcVerificationDialogState();
}

class _DcVerificationDialogState extends State<DcVerificationDialog> {
  String processDecision = "Machining";
  bool isLoading = false;

  final TextEditingController remarksCtrl = TextEditingController();
  final TextEditingController verifiedWeightCtrl = TextEditingController();
  final TextEditingController verifiedQuantityCtrl = TextEditingController();

  @override
  void dispose() {
    remarksCtrl.dispose();
    verifiedWeightCtrl.dispose();
    verifiedQuantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(String status) async {
    if (verifiedWeightCtrl.text.isEmpty ||
        verifiedQuantityCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter verified weight & quantity")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await DcService.verifyDc(
        dcId: widget.dc.dcId,
        userId: widget.dc.userId,
        status: status,
        reviewedWeight: double.parse(verifiedWeightCtrl.text),
        reviewedQuantity: int.parse(verifiedQuantityCtrl.text),
        processType: processDecision,
        notificationStatus: "true",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("DC $status successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
                  /// LEFT
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
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: widget.dc.imageUrl != null
                              ? Image.network(widget.dc.imageUrl!,
                                  fit: BoxFit.cover)
                              : const Icon(Icons.image, size: 40),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// RIGHT
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: verifiedWeightCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Verified Weight (kg)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: verifiedQuantityCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Verified Quantity",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
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

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed:
                          isLoading ? null : () => _submit("Approved"),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Verify & Approve"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed:
                          isLoading ? null : () => _submit("Rejected"),
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
      child: Text.rich(
        TextSpan(
          text: "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}