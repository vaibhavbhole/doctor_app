class ServiceItem {
  final int serviceId;
  final String title;
  final String description;
  final String petType;
  final String charges;

  ServiceItem(
      {required this.serviceId,
      required this.title,
      required this.description,
      required this.petType,
      required this.charges});

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
        serviceId: json["service_id"],
        title: json["title"],
        description: json["description"],
        petType: json["pet_type"],
        charges: json["charges"]);
  }
}
