// lib/models/assessment_data.dart
class PersonalInfo {
  String? age;
  String? gender;
  String? skinType;
  String? ethnicity;

  PersonalInfo({
    this.age,
    this.gender,
    this.skinType,
    this.ethnicity,
  });

  Map<String, dynamic> toJson() => {
        'age': age,
        'gender': gender,
        'skinType': skinType,
        'ethnicity': ethnicity,
      };

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
        age: json['age'],
        gender: json['gender'],
        skinType: json['skinType'],
        ethnicity: json['ethnicity'],
      );
}

class MedicalHistory {
  String? familyHistory;
  String? sunExposure;
  String? skinProducts;
  String? allergies;

  MedicalHistory({
    this.familyHistory,
    this.sunExposure,
    this.skinProducts,
    this.allergies,
  });

  Map<String, dynamic> toJson() => {
        'familyHistory': familyHistory,
        'sunExposure': sunExposure,
        'skinProducts': skinProducts,
        'allergies': allergies,
      };

  factory MedicalHistory.fromJson(Map<String, dynamic> json) => MedicalHistory(
        familyHistory: json['familyHistory'],
        sunExposure: json['sunExposure'],
        skinProducts: json['skinProducts'],
        allergies: json['allergies'],
      );
}

class AssessmentData {
  PersonalInfo personalInfo;
  MedicalHistory medicalHistory;
  List<String> photoUrls;

  AssessmentData({
    required this.personalInfo,
    required this.medicalHistory,
    this.photoUrls = const [],
  });

  Map<String, dynamic> toJson() => {
        'personalInfo': personalInfo.toJson(),
        'medicalHistory': medicalHistory.toJson(),
        'photoUrls': photoUrls,
      };

  factory AssessmentData.fromJson(Map<String, dynamic> json) => AssessmentData(
        personalInfo: PersonalInfo.fromJson(json['personalInfo']),
        medicalHistory: MedicalHistory.fromJson(json['medicalHistory']),
        photoUrls: List<String>.from(json['photoUrls']),
      );
}
