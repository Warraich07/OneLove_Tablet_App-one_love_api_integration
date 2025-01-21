class TasksModel {
  int id;
  String name;
  String status;
  String durability;
  String member;
  int roomId;
  int createdBy;
  dynamic updatedBy;
  String createdAt;
  String updatedAt;
  String? lastCompletedDateTime;

  TasksModel({
    required this.id,
    required this.name,
    required this.status,
    required this.durability,
    required this.member,
    required this.roomId,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.lastCompletedDateTime,
  });

  factory TasksModel.fromJson(Map<String, dynamic> json) => TasksModel(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    durability: json["durability"],
    member: json["member"],
    roomId: json["room_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt:json["last_completed_date_time"]==null? json["created_at"]:json["last_completed_date_time"],
    updatedAt: json["updated_at"],
    lastCompletedDateTime: json["last_completed_date_time"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "durability": durability,
    "member": member,
    "room_id": roomId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "last_completed_date_time":lastCompletedDateTime
  };
}
