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

  int _pendingCount(List<DcDetails> list) =>
      list.where((d) => (d.verifiedStatus ?? "").toLowerCase() != "verified").length;

  int _verifiedCount(List<DcDetails> list) =>
      list.where((d) => (d.verifiedStatus ?? "").toLowerCase() == "verified").length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<DcDetails>>(
          future: dcList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data!;

            return Column(
              children: [
                /// SUMMARY CARDS
                Row(
                  children: [
                    _summaryCard(
                      color: Colors.orange,
                      icon: Icons.hourglass_empty,
                      title: "Pending Verification",
                      count: _pendingCount(data).toString(),
                    ),
                    const SizedBox(width: 10),
                    _summaryCard(
                      color: Colors.green,
                      icon: Icons.check_circle,
                      title: "Verified",
                      count: _verifiedCount(data).toString(),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// TABLE HEADER
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.grey.shade200,
                  child: const Row(
                    children: [
                      _TableHeader("DC No"),
                      _TableHeader("Part Name"),
                      _TableHeader("Qty"),
                      _TableHeader("Weight"),
                      _TableHeader("Status"),
                      _TableHeader("DC Verification"),
                    ],
                  ),
                ),

                /// TABLE BODY
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final dc = data[index];
                      final status =
                          (dc.verifiedStatus ?? "").toLowerCase() == "verified"
                              ? "Verified"
                              : "Pending";

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            _TableCell(dc.dcNumber),
                            _TableCell(dc.partName),
                            _TableCell(dc.quantity.toString()),
                            _TableCell("${dc.weight} kg"),

                            Expanded(
                              child: Center(
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: status == "Verified"
                                        ? Colors.green
                                        : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: status == "Verified"
                                      ? null
                                      : () async {
                                          final result =
                                              await showDialog<String>(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) =>
                                                DcVerificationDialog(dc: dc),
                                          );

                                          if (result != null && mounted) {
                                            setState(() {
                                              // 🔥 REFRESH FROM BACKEND
                                              dcList =
                                                  DcService.fetchDcDetails();
                                            });
                                          }
                                        },
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
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
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
        style: const TextStyle(fontWeight: FontWeight.bold),
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
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}