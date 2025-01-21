class NotificationsModel {
  String id;
  Type type;
  NotifiableType notifiableType;
  int notifiableId;
  Data data;
  DateTime? readAt;
  DateTime createdAt;
  DateTime updatedAt;
  String markAsRead;

  NotificationsModel({
    required this.id,
    required this.type,
    required this.notifiableType,
    required this.notifiableId,
    required this.data,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
    required this.markAsRead
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
    id: json["id"],
    type: typeValues.map[json["type"]]!,
    notifiableType: notifiableTypeValues.map[json["notifiable_type"]]!,
    notifiableId: json["notifiable_id"],
    data: Data.fromJson(json["data"]),
    readAt: json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    markAsRead: json["mark_as"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": typeValues.reverse[type],
    "notifiable_type": notifiableTypeValues.reverse[notifiableType],
    "notifiable_id": notifiableId,
    "data": data.toJson(),
    "read_at": readAt?.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "mark_as":markAsRead
  };
}

class Data {
  int? id;
  String? name;
  String? title;
  String? message;
  int? createdBy;
  String? createdAt;
  String? status;
  int? roomId;
  String? member;
  String? durability;
  int? updatedBy;
  DateTime? updatedAt;
  ReportedProblem? reportedProblem;

  Data({
    this.id,
    this.name,
    this.title,
    this.message,
    this.createdBy,
    this.createdAt,
    this.status,
    this.roomId,
    this.member,
    this.durability,
    this.updatedBy,
    this.updatedAt,
    this.reportedProblem,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    title: json["title"],
    message: json["message"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    status: json["status"]==null?'':json["status"],
    roomId: json["room_id"],
    member: json["member"],
    durability: json["durability"],
    updatedBy: json["updated_by"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    reportedProblem: json["reported_problem"] == null ? null : ReportedProblem.fromJson(json["reported_problem"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "title": title,
    "message": message,
    "created_by": createdBy,
    "created_at": createdAt,
    "status": statusValues.reverse[status],
    "room_id": roomId,
    "member": member,
    "durability": durability,
    "updated_by": updatedBy,
    "updated_at": updatedAt?.toIso8601String(),
    "reported_problem": reportedProblem?.toJson(),
  };
}

class ReportedProblem {
  int id;
  String name;
  String email;
  String title;
  String message;
  int createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  ReportedProblem({
    required this.id,
    required this.name,
    required this.email,
    required this.title,
    required this.message,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReportedProblem.fromJson(Map<String, dynamic> json) => ReportedProblem(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    title: json["title"],
    message: json["message"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "title": title,
    "message": message,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

enum Status {
  COMPLETED,
  PENDING
}

final statusValues = EnumValues({
  "Completed": Status.COMPLETED,
  "Pending": Status.PENDING
});

enum NotifiableType {
  APP_MODELS_USER
}

final notifiableTypeValues = EnumValues({
  "App\\Models\\User": NotifiableType.APP_MODELS_USER
});

enum Type {
  APP_NOTIFICATIONS_REPORT_PROBLEM_NOTIFICATION,
  APP_NOTIFICATIONS_TASK_STATUS_NOTIFICATION
}

final typeValues = EnumValues({
  "App\\Notifications\\ReportProblemNotification": Type.APP_NOTIFICATIONS_REPORT_PROBLEM_NOTIFICATION,
  "App\\Notifications\\TaskStatusNotification": Type.APP_NOTIFICATIONS_TASK_STATUS_NOTIFICATION
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
