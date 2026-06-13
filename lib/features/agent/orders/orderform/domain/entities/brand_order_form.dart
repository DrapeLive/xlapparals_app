class BrandOrderForm {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String addressLine1;
  final String? addressLine2;
  final String gst;
  final String logoUrl;

  const BrandOrderForm({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.addressLine1,
    required this.addressLine2,
    required this.gst,
    required this.logoUrl,
  });
}
