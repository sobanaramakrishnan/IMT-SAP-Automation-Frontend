class DcDetails {
  final String dcNumber;
  final String partName;
  final String partNumber;
  final int quantity;
  final double weight;

  DcDetails({
    required this.dcNumber,
    required this.partName,
    required this.partNumber,
    required this.quantity,
    required this.weight,
  });

  factory DcDetails.fromJson(Map<String, dynamic> json) {
    return DcDetails(
      dcNumber: json["dc_number"],
      partName: json["part_name"],
      partNumber: json["part_number"],
      quantity: json["quantity"],
      weight: (json["weight"] as num).toDouble(),
    );
  }
}
