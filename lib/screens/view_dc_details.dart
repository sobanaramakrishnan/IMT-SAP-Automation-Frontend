import '../main.dart' show ThemeToggleAction;
import 'package:flutter/material.dart';
import '../services/dc_service.dart';
import '../models/dc_details.dart';
import '../screens/dc_verification_dialog.dart';

class ViewDcDetails extends StatefulWidget {
  const ViewDcDetails({super.key});

  @override
  State<ViewDcDetails> createState() => _ViewDcDetailsState();
}

class _ViewDcDetailsState extends State<ViewDcDetails> {
  late Future<List<DcDetails>> dcList;

  @override
  void initState() {
    super.initState();
    dcList = DcService.fetchDcDetails();
  }

  bool _isVerified(DcDetails dc) {
    final status = (dc.verifiedStatus ?? "").toLowerCase();
    return status == "approved" || status == "verified";
  }

  int _pendingCount(List<DcDetails> list) {
    return list.where((dc) {
      final status = (dc.verifiedStatus ?? "").toLowerCase();
      return status.isEmpty || status == "pending";
    }).length;
  }

  int _verifiedCount(List<DcDetails> list) {
    return list.where(_isVerified).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: const [
          ThemeToggleAction(),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<DcDetails>>(
          future: dcList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final data = snapshot.data ?? [];
            final isCompact = MediaQuery.sizeOf(context).width < 800;

            return Column(
              children: [
                Row(
                  children: [
                    _summaryCard(
                      color: const Color(0xFFCA8A04),
                      icon: Icons.hourglass_empty,
                      title: "Pending Verification",
                      count: _pendingCount(data).toString(),
                    ),
                    const SizedBox(width: 10),
                    _summaryCard(
                      color: const Color(0xFF287D59),
                      icon: Icons.check_circle_outline,
                      title: "Verified",
                      count: _verifiedCount(data).toString(),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                if (!isCompact)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        _TableHeader("DC No"),
                        _TableHeader("Part Name"),
                        _TableHeader("Part No"),
                        _TableHeader("Qty"),
                        _TableHeader("Weight"),
                        _TableHeader("Status"),
                        _TableHeader("DC Verification"),
                      ],
                    ),
                  ),

                Expanded(
                  child: data.isEmpty
                      ? const Center(
                          child: Text("No DC records available"),
                        )
                      : ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final dc = data[index];

                            final status =
                                dc.verifiedStatus?.isNotEmpty == true
                                    ? dc.verifiedStatus!
                                    : "Pending";

                            final isVerified = _isVerified(dc);

                            if (isCompact) {
                              return _recordCard(
                                context,
                                dc,
                                status,
                                isVerified,
                              );
                            }

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: index.isEven
                                    ? Theme.of(context)
                                        .colorScheme
                                        .surface
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerLowest,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  _TableCell(dc.dcNumber),
                                  _TableCell(dc.partName),
                                  _TableCell(dc.partNumber),
                                  _TableCell(
                                    dc.quantity.toString(),
                                  ),
                                  _TableCell("${dc.weight} kg"),

                                  Expanded(
                                    child: Center(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (isVerified
                                                  ? Colors.green
                                                  : status.toLowerCase() ==
                                                          "rejected"
                                                      ? Colors.red
                                                      : Colors.orange)
                                              .withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color: isVerified
                                                ? Colors.green
                                                : status.toLowerCase() ==
                                                        "rejected"
                                                    ? Colors.red
                                                    : Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: isVerified
                                            ? null
                                            : () => _openVerification(dc),
                                        child: const Text("View"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _recordCard(
    BuildContext context,
    DcDetails dc,
    String status,
    bool isVerified,
  ) {
    final statusColor = isVerified
        ? Colors.green
        : status.toLowerCase() == "rejected"
            ? Colors.red
            : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailLine("DC No", dc.dcNumber),
            _detailLine("Part Name", dc.partName),
            _detailLine("Part No", dc.partNumber),
            _detailLine("Quantity", dc.quantity.toString()),
            _detailLine("Weight", "${dc.weight} kg"),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isVerified ? null : () => _openVerification(dc),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text("View DC"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }

  Future<void> _openVerification(DcDetails dc) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => DcVerificationDialog(dc: dc),
    );

    if (result != null && mounted) {
      setState(() {
        dcList = DcService.fetchDcDetails();
      });
    }
  }

  Widget _summaryCard({
    required Color color,
    required IconData icon,
    required String title,
    required String count,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;

  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}