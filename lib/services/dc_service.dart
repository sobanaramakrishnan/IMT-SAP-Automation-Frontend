import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/dc_details.dart';

class DcService {
  static const String baseUrl = "http://127.0.0.1:8000";
  // Android Emulator -> http://10.0.2.2:8000

  // ================= CREATE DC =================
  static Future<void> submitDcDetails({
    required int userId,
    required String dcNumber,
    required String partName,
    required String partNumber,
    required int quantity,
    required double weight,
    File? imageFile,
  }) async {
    final uri = Uri.parse("$baseUrl/create-dc-details");
    final request = http.MultipartRequest("POST", uri);

    request.fields["user_id"] = userId.toString();
    request.fields["dc_number"] = dcNumber;
    request.fields["part_name"] = partName;
    request.fields["part_number"] = partNumber;
    request.fields["quantity"] = quantity.toString();
    request.fields["weight"] = weight.toString();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", imageFile.path),
      );
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to submit DC details");
    }
  }

  // ================= FETCH DC =================
  static Future<List<DcDetails>> fetchDcDetails() async {
    final response = await http.get(
      Uri.parse("$baseUrl/view-dc-details"),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded["data"];

      return data
          .map((item) => DcDetails.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to fetch DC details");
    }
  }

  // ================= VERIFY / APPROVE / REJECT DC =================
  static Future<void> verifyDc({
    required int dcId,
    required int userId,
    required String status, // Approved / Rejected
    required double reviewedWeight,
    required int reviewedQuantity,
    required String processType,
    required String notificationStatus,
  }) async {
    final uri = Uri.parse("$baseUrl/verify-dc-details");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "dc_id": dcId.toString(),
        "user_id": userId.toString(),
        "status": status,
        "reviewed_weight": reviewedWeight.toString(),
        "reviewed_quantity": reviewedQuantity.toString(),
        "process_type": processType,
        "notification_status": notificationStatus,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("DC verification failed: ${response.body}");
    }
  }
}