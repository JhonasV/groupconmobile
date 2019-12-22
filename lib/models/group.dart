class Group {
  String name;
  String id;
  String url;
  dynamic user;
  bool private;

  Group({this.id, this.name, this.url, this.user, this.private});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'],
      name: json['name'],
      url: json['url'],
      user: json['user'],
      private: json['private'],
    );
  }

  // static final List<Group> groups = [
  //   Group(name: "React Dominicana"),
  //   Group(name: "Angular Dominicana"),
  //   Group(name: "DevBorrachosTV"),
  //   Group(name: "Otra grasita"),
  //   Group(name: "Ecopeta"),
  // ];
}
