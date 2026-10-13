import 'package:flutter/material.dart';
import '../models/dc_details.dart';
import '../services/dc_service.dart';

class DcVerificationDialog extends StatefulWidget {
  final DcDetails dc;

  const DcVerificationDialog({
    super.key,
    required this.dc,
  });

  @override
  State<DcVerificationDialog> createState() =>
      _DcVerificationDialogState();
}

class _DcVerificationDialogState
    extends State<DcVerificationDialog> {
  String processDecision = "Machining";
  bool isLoading = false;

  final TextEditingController remarksCtrl = TextEditingController();
  final TextEditingController verifiedWeightCtrl =
      TextEditingController();
  final TextEditingController verifiedQuantityCtrl =
      TextEditingController();

  @override
  void dispose() {
    remarksCtrl.dispose();
    verifiedWeightCtrl.dispose();
    verifiedQuantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(String action) async {
    if (verifiedWeightCtrl.text.isEmpty ||
        verifiedQuantityCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter verified weight & quantity"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await DcService.verifyDc(
        dcId: widget.dc.dcId,
        userId: widget.dc.userId,
        status: action,
        reviewedWeight: double.parse(
          verifiedWeightCtrl.text,
        ),
        reviewedQuantity: int.parse(
          verifiedQuantityCtrl.text,
        ),
        processType: processDecision,
        notificationStatus: "true",
      );

      Navigator.pop(
        context,
        action == "Approved" ? "Verified" : "Pending",
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DC Verification",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const Divider(),

              if (MediaQuery.sizeOf(context).width < 700) ...[
                _detailsSection(context),
                const SizedBox(height: 16),
                _verificationFields(),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _detailsSection(context)),
                    const SizedBox(width: 16),
                    Expanded(child: _verificationFields()),
                  ],
                ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isLoading
                          ? null
                          : () => _submit("Approved"),
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Verify & Approve"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isLoading
                          ? null
                          : () => _submit("Rejected"),
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

  Widget _detailsSection(BuildContext context) {
    return Column(
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
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.dc.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.dc.imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                    ),
                  ),
                )
              : const Center(
                  child: Icon(Icons.image_outlined, size: 40),
                ),
        ),
      ],
    );
  }

  Widget _verificationFields() {
    return Column(
      children: [
        TextField(
          controller: verifiedWeightCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Verified Weight (kg)",
            prefixIcon: Icon(Icons.scale_outlined),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: verifiedQuantityCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Verified Quantity",
            prefixIcon: Icon(Icons.inventory_2_outlined),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: processDecision,
          items: const [
            DropdownMenuItem(value: "Machining", child: Text("Machining")),
            DropdownMenuItem(value: "Assembly", child: Text("Assembly")),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => processDecision = value);
            }
          },
          decoration: const InputDecoration(
            labelText: "Process Decision",
            prefixIcon: Icon(Icons.precision_manufacturing),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: remarksCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: "Remarks (Optional)",
            prefixIcon: Icon(Icons.notes),
          ),
        ),
      ],
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          text: "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}