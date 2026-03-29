import 'survey_model.dart';

class NeedModel {
  final String id;
  final String surveyId;
  final String category;
  final int urgency;
  final String description;
  final LocationData location;
  final int estimatedCount;
  final String status;
  final String? assignedVolunteerId;
  final DateTime createdAt;
  final DateTime? scheduledFor;
  final String? zoneId;
  final String? ngoId;
  final List<String> requiredSkills;

  const NeedModel({
    required this.id,
    required this.surveyId,
    required this.category,
    required this.urgency,
    required this.description,
    required this.location,
    required this.estimatedCount,
    required this.status,
    this.assignedVolunteerId,
    required this.createdAt,
    this.scheduledFor,
    this.zoneId,
    this.ngoId,
    this.requiredSkills = const [],
  });

  bool get isUrgent => urgency >= 5;

  factory NeedModel.fromJson(Map<String, dynamic> json) {
    return NeedModel(
      id: json['id'] as String,
      surveyId: json['surveyId'] as String,
      category: json['category'] as String,
      urgency: json['urgency'] as int,
      description: json['description'] as String,
      location:
          LocationData.fromJson(json['location'] as Map<String, dynamic>),
      estimatedCount: json['estimatedCount'] as int,
      status: json['status'] as String,
      assignedVolunteerId: json['assignedVolunteerId'] as String?,
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt'] as DateTime
          : DateTime.parse(json['createdAt'] as String),
      scheduledFor: json['scheduledFor'] != null
          ? (json['scheduledFor'] is DateTime
              ? json['scheduledFor'] as DateTime
              : DateTime.parse(json['scheduledFor'] as String))
          : null,
      zoneId: json['zoneId'] as String?,
      ngoId: json['ngoId'] as String?,
      requiredSkills: (json['requiredSkills'] as List<dynamic>?)
              ?.cast<String>() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'surveyId': surveyId,
        'category': category,
        'urgency': urgency,
        'description': description,
        'location': location.toJson(),
        'estimatedCount': estimatedCount,
        'status': status,
        'assignedVolunteerId': assignedVolunteerId,
        'createdAt': createdAt.toIso8601String(),
        'scheduledFor': scheduledFor?.toIso8601String(),
        'zoneId': zoneId,
        'ngoId': ngoId,
        'requiredSkills': requiredSkills,
      };

  NeedModel copyWith({
    String? id,
    String? surveyId,
    String? category,
    int? urgency,
    String? description,
    LocationData? location,
    int? estimatedCount,
    String? status,
    String? assignedVolunteerId,
    DateTime? createdAt,
    DateTime? scheduledFor,
    String? zoneId,
    String? ngoId,
    List<String>? requiredSkills,
  }) {
    return NeedModel(
      id: id ?? this.id,
      surveyId: surveyId ?? this.surveyId,
      category: category ?? this.category,
      urgency: urgency ?? this.urgency,
      description: description ?? this.description,
      location: location ?? this.location,
      estimatedCount: estimatedCount ?? this.estimatedCount,
      status: status ?? this.status,
      assignedVolunteerId:
          assignedVolunteerId ?? this.assignedVolunteerId,
      createdAt: createdAt ?? this.createdAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      zoneId: zoneId ?? this.zoneId,
      ngoId: ngoId ?? this.ngoId,
      requiredSkills: requiredSkills ?? this.requiredSkills,
    );
  }
}

class TaskAssignment {
  final String id;
  final String needId;
  final String volunteerId;
  final String status;
  final DateTime assignedAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final String? cancellationReason;
  final int creditsEarned;
  final int? rating;

  const TaskAssignment({
    required this.id,
    required this.needId,
    required this.volunteerId,
    required this.status,
    required this.assignedAt,
    this.acceptedAt,
    this.completedAt,
    this.cancellationReason,
    this.creditsEarned = 0,
    this.rating,
  });

  factory TaskAssignment.fromJson(Map<String, dynamic> json) {
    return TaskAssignment(
      id: json['id'] as String,
      needId: json['needId'] as String,
      volunteerId: json['volunteerId'] as String,
      status: json['status'] as String,
      assignedAt: json['assignedAt'] is DateTime
          ? json['assignedAt'] as DateTime
          : DateTime.parse(json['assignedAt'] as String),
      acceptedAt: json['acceptedAt'] != null
          ? (json['acceptedAt'] is DateTime
              ? json['acceptedAt'] as DateTime
              : DateTime.parse(json['acceptedAt'] as String))
          : null,
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] is DateTime
              ? json['completedAt'] as DateTime
              : DateTime.parse(json['completedAt'] as String))
          : null,
      cancellationReason: json['cancellationReason'] as String?,
      creditsEarned: json['creditsEarned'] as int? ?? 0,
      rating: json['rating'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'needId': needId,
        'volunteerId': volunteerId,
        'status': status,
        'assignedAt': assignedAt.toIso8601String(),
        'acceptedAt': acceptedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'cancellationReason': cancellationReason,
        'creditsEarned': creditsEarned,
        'rating': rating,
      };
}
