class CodeModel{

  String id;
  String dateTime;

  CodeModel({this.id, this.dateTime});

  Map<String, dynamic> toMap() => {
    'id': id,
    'dateTime': dateTime,
  };
}