class ItemModel {
  final int id;
  final String itname;
  int kitchenstatus;

  ItemModel({
    required this.id,
    required this.itname,
    required this.kitchenstatus,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      itname: json['itname'] ?? '',
      kitchenstatus: json['kitchenstatus'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itname': itname,
      'kitchenstatus': kitchenstatus,
    };
  }
}




