import 'package:one_love/models/tasks_model.dart';

class RoomsModel {
  int id;
  String name;
  int createdBy;
  int? updatedBy;
  String createdAt;
  String updatedAt;
  int sortId;
  List<TasksModel>? pendingDailyTasksList;
  List<TasksModel>? pendingWeeklyTasksList;
  List<TasksModel>? pendingMonthlyTasksList;
  List<TasksModel>? completedDailyTasksList;
  List<TasksModel>? completedWeeklyTasksList;
  List<TasksModel>? completedMonthlyTasksList;



  RoomsModel({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.sortId,
    this.pendingDailyTasksList,
    this.pendingWeeklyTasksList,
    this.pendingMonthlyTasksList,
    this.completedDailyTasksList,
    this.completedWeeklyTasksList,
    this.completedMonthlyTasksList,
  });

  factory RoomsModel.fromJson(Map<String, dynamic> json) => RoomsModel(
    id: json["id"],
    name: json["name"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
      sortId: json["sort_id"],
      pendingDailyTasksList: [],
    pendingWeeklyTasksList: [],
    pendingMonthlyTasksList: [],
    completedDailyTasksList: [],
    completedWeeklyTasksList: [],
    completedMonthlyTasksList: [],


  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "sort_id": sortId,
    "pendingDailyTasksList": pendingDailyTasksList,
    "pendingWeeklyTasksList": pendingWeeklyTasksList,
    "pendingMonthlyTasksList": pendingMonthlyTasksList,
    "completedDailyTasksList":completedDailyTasksList ,
    "completedWeeklyTasksList": completedWeeklyTasksList,
    "completedMonthlyTasksList":completedMonthlyTasksList ,

  };
}
