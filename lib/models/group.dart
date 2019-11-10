class Group {
  String name;
  String id;
  String url;
  dynamic user;

  Group({this.id, this.name, this.url, this.user});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
        id: json['_id'],
        name: json['name'],
        url: json['url'],
        user: json['user']);
  }

  // static final List<Group> groups = [
  //   Group(name: "React Dominicana"),
  //   Group(name: "Angular Dominicana"),
  //   Group(name: "DevBorrachosTV"),
  //   Group(name: "Otra grasita"),
  //   Group(name: "Ecopeta"),
  // ];
}
