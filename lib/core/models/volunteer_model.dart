import 'survey_model.dart';

class VolunteerModel {
  final String uid;
  final String name;
  final List<String> skills;
  final List<String> availableDays;
  final List<String> availableTimeSlots;
  final LocationData location;
  final double rating;
  final int completedTasks;
  final int credits;
  final int streakDays;
  final DateTime? lastActiveDate;
  final bool isVerified;
  final List<String> verificationDocs;

  const VolunteerModel({
    required this.uid,
    required this.name,
    required this.skills,
    required this.availableDays,
    required this.availableTimeSlots,
    required this.location,
    this.rating = 0.0,
    this.completedTasks = 0,
    this.credits = 0,
    this.streakDays = 0,
    this.lastActiveDate,
    this.isVerified = false,
    this.verificationDocs = const [],
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  factory VolunteerModel.fromJson(Map<String, dynamic> json) {
    return VolunteerModel(
      uid: json['uid'] as String,
      name: json['name'] as String? ?? '',
      skills:
          (json['skills'] as List<dynamic>?)?.cast<String>() ?? [],
      availableDays:
          (json['availableDays'] as List<dynamic>?)?.cast<String>() ?? [],
      availableTimeSlots:
          (json['availableTimeSlots'] as List<dynamic>?)?.cast<String>() ?? [],
      location:
          LocationData.fromJson(json['location'] as Map<String, dynamic>),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      completedTasks: json['completedTasks'] as int? ?? 0,
      credits: json['credits'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? (json['lastActiveDate'] is DateTime
              ? json['lastActiveDate'] as DateTime
              : DateTime.parse(json['lastActiveDate'] as String))
          : null,
      isVerified: json['isVerified'] as bool? ?? false,
      verificationDocs:
          (json['verificationDocs'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'skills': skills,
        'availableDays': availableDays,
        'availableTimeSlots': availableTimeSlots,
        'location': location.toJson(),
        'rating': rating,
        'completedTasks': completedTasks,
        'credits': credits,
        'streakDays': streakDays,
        'lastActiveDate': lastActiveDate?.toIso8601String(),
        'isVerified': isVerified,
        'verificationDocs': verificationDocs,
      };

  VolunteerModel copyWith({
    String? uid,
    String? name,
    List<String>? skills,
    List<String>? availableDays,
    List<String>? availableTimeSlots,
    LocationData? location,
    double? rating,
    int? completedTasks,
    int? credits,
    int? streakDays,
    DateTime? lastActiveDate,
    bool? isVerified,
    List<String>? verificationDocs,
  }) {
    return VolunteerModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      skills: skills ?? this.skills,
      availableDays: availableDays ?? this.availableDays,
      availableTimeSlots:
          availableTimeSlots ?? this.availableTimeSlots,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      completedTasks: completedTasks ?? this.completedTasks,
      credits: credits ?? this.credits,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      isVerified: isVerified ?? this.isVerified,
      verificationDocs:
          verificationDocs ?? this.verificationDocs,
    );
  }
}
