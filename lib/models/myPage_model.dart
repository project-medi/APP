class MypageModel {
  final String name;
  final String phoneNumber;
  final String brithday;
  final String weight;
  final String note;

  MypageModel({
    required this.name,
    required this.phoneNumber,
    required this.brithday,
    required this.weight,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'brithday': brithday,
      'weight': weight,
      'note': note,
    };
  }

  factory MypageModel.fromMap(Map<String, dynamic> map) {
    return MypageModel(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      brithday: map['brithday'] ?? '',
      weight: map['weight'] ?? '',
      note: map['note'] ?? '',
    );
  }
}
