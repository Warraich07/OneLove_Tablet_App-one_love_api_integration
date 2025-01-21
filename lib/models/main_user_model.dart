class MainUserModel {
  bool success;
  String message;
  String token;
  Data data;

  MainUserModel({
    required this.success,
    required this.message,
    required this.token,
    required this.data,
  });

  factory MainUserModel.fromJson(Map<String, dynamic> json) => MainUserModel(
    success: json["success"] ?? false,  // Default to false if success is null
    message: json["message"] ?? '',     // Default to an empty string if message is null
    token: json["token"] ?? '',         // Default to an empty string if token is null
    data: json["data"] != null
        ? Data.fromJson(json["data"])
        : Data(id: 0, name: '', email: '', userImage: UserImage(url: '', type: '')),  // Provide default value if data is null
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "token": token,
    "data": data.toJson(),
  };
}

class Data {
  int id;
  String name;
  String email;
  UserImage userImage;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.userImage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] ?? 0,  // Default to 0 if id is null
    name: json["name"] ?? '',  // Default to an empty string if name is null
    email: json["email"] ?? '',  // Default to an empty string if email is null
    userImage: json["image"] != null
        ? UserImage.fromJson(json["image"])
        : UserImage(url: '', type: ''),  // Provide default value if image is null
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "image": userImage.toJson(),
  };
}

class UserImage {
  String url;
  String type;

  UserImage({
    required this.url,
    required this.type,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
    url: json["url"] ?? '',  // Default to an empty string if url is null
    type: json["type"] ?? '',  // Default to an empty string if type is null
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "type": type,
  };
}
