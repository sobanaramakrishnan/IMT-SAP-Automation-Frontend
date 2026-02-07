class DcDetails {
  final int dcId;
  final int userId;
  final String dcNumber;
  final String partName;
  final String partNumber;
  final String? imageUrl;
  final int quantity;
  final double weight;

  DcDetails({
    required this.dcId,
    required this.userId,
    required this.dcNumber,
    required this.partName,
    required this.partNumber,
    this.imageUrl,
    required this.quantity,
    required this.weight,
  });

  factory DcDetails.fromJson(Map<String, dynamic> json) {
    return DcDetails(
      dcId: json["dc_id"],
      userId: json["user_id"], 
      dcNumber: json["dc_number"],
      partName: json["part_name"],
      partNumber: json["part_number"],
      imageUrl: json["image_url"],
      quantity: json["quantity"] ?? 0,
      weight: (json["weight"] as num).toDouble(),
    );
  }
}