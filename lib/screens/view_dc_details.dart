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
  final Map<String, String> dcStatus = {};
  @override
  void initState() {
    super.initState();
    dcList = DcService.fetchDcDetails();
  }

  int get pendingCount =>
      dcStatus.values.where((s) => s == "Pending").length;

  int get verifiedCount =>
      dcStatus.values.where((s) => s == "Verified").length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: const [
          Icon(Icons.settings),
          SizedBox(width: 12),
          CircleAvatar(child: Icon(Icons.person)),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// SUMMARY CARDS
            Row(
              children: [
                _summaryCard(
                  color: Colors.orange,
                  icon: Icons.hourglass_empty,
                  title: "Pending Verification",
                  count: pendingCount.toString(),
                ),
                const SizedBox(width: 10),
                _summaryCard(
                  color: Colors.green,
                  icon: Icons.check_circle,
                  title: "Verified",
                  count: verifiedCount.toString(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// TABLE HEADER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.grey.shade200,
              child: Row(
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
                  if (data.isEmpty) {
                    return const Center(child: Text("No DC details found"));
                  }

                  /// Initialize default status
                  for (var dc in data) {
                    dcStatus.putIfAbsent(dc.dcNumber, () => "Pending");
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final dc = data[index];
                      final status = dcStatus[dc.dcNumber]!;

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

                            /// STATUS DROPDOWN
                            Expanded(
                              child: Center(
                                child: DropdownButton<String>(
                                  value: status,
                                  underline: const SizedBox(),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "Pending",
                                      child: Text(
                                        "Pending",
                                        style:
                                            TextStyle(color: Colors.orange),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "Verified",
                                      child: Text(
                                        "Verified",
                                        style:
                                            TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      dcStatus[dc.dcNumber] = value!;
                                    });
                                  },
                                ),
                              ),
                            ),

                            /// VIEW BUTTON
                            Expanded(
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) =>
                                          DcVerificationDialog(dc: dc),
                                    );
                                  },
                                  child: const Text("View"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SUMMARY CARD
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
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/// TABLE HEADER CELL
class _TableHeader extends StatelessWidget {
  final String text;
  _TableHeader(this.text);

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

/// TABLE BODY CELL
class _TableCell extends StatelessWidget {
  final String text;
  _TableCell(this.text);

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