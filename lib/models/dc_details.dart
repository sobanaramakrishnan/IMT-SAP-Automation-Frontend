class DcDetails {
  final String dcNumber;
  final String partName;
  final String partNumber;
  final String? imageUrl;
  final int quantity;
  final double weight;

  DcDetails({
    required this.dcNumber,
    required this.partName,
    required this.partNumber,
    this.imageUrl,
    required this.quantity,
    required this.weight,
  });

  factory DcDetails.fromJson(Map<String, dynamic> json) {
    return DcDetails(
      dcNumber: json["dc_number"],
      partName: json["part_name"],
      partNumber: json["part_number"],
      imageUrl: (json["image_url"] ?? json["imageUrl"])?.toString(),
      quantity: json["quantity"],
      weight: (json["weight"] as num).toDouble(),
    );
  }
}
