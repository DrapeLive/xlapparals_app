class CustomerDetails {
  final int id;

  final String name;
  final String contact;
  final String address;
  final String gst;

  const CustomerDetails({
    required this.id,
    required this.name,
    required this.contact,
    required this.address,
    required this.gst,
  });

  bool get hasGst => gst.trim().isNotEmpty;

  bool get hasAddress => address.trim().isNotEmpty;
}
