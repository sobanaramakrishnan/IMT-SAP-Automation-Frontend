import 'package:flutter/material.dart';
import '../services/dc_service.dart';
import '../models/dc_details.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DC Details (Admin)"),
      ),
      body: FutureBuilder<List<DcDetails>>(
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

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final dc = data[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("DC No: ${dc.dcNumber}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Part Name: ${dc.partName}"),
                      Text("Part Number: ${dc.partNumber}"),
                      Text("Quantity: ${dc.quantity}"),
                      Text("Weight: ${dc.weight}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
