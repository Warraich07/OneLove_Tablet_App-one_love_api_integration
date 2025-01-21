class CreatedRoomModel {
  int id;
  String name;
  int createdBy;
  dynamic updatedBy;
  String createdAt;
  String updatedAt;

  CreatedRoomModel({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreatedRoomModel.fromJson(Map<String, dynamic> json) => CreatedRoomModel(
    id: json["id"],
    name: json["name"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
