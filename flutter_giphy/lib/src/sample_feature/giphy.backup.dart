class Data {
  final String images;
  const Data({required this.images});

  factory Data.fromJson(){
    return Data();
  }
}

class Giphy {
  // final int userId;
  // final int id;
  // final String title;
  final any data[];

  const Giphy({required t});
  // const Giphy({required this.userId, required this.id, required this.title});

  factory Giphy.fromJson(Map<String, dynamic> json) {
    return Giphy(
      data: json['data']
      // userId: json['userId'],
      // id: json['id'],
      // title: json['title'],
    );
  }
}
