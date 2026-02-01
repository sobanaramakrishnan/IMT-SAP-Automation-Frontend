import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/dc_details.dart';

class DcService {
  static const String baseUrl = "http://127.0.0.1:8000";
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
}