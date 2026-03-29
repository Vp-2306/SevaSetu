class LocationData {
  final double lat;
  final double lng;
  final String address;

  const LocationData({
    required this.lat,
    required this.lng,
    required this.address,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        address: json['address'] as String,
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'address': address,
      };
}

class AiExtractedData {
  final String category;
  final int urgency;
  final String description;
  final LocationData location;
  final int estimatedCount;
  final String languageDetected;
  final double confidence;
  final bool needsReview;

  const AiExtractedData({
    required this.category,
    required this.urgency,
    required this.description,
    required this.location,
    required this.estimatedCount,
    this.languageDetected = 'en',
    this.confidence = 1.0,
    this.needsReview = false,
  });

  factory AiExtractedData.fromJson(Map<String, dynamic> json) =>
      AiExtractedData(
        category: json['category'] as String,
        urgency: json['urgency'] as int,
        description: json['description'] as String,
        location:
            LocationData.fromJson(json['location'] as Map<String, dynamic>),
        estimatedCount: json['estimatedCount'] as int,
        languageDetected: json['languageDetected'] as String? ?? 'en',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
        needsReview: json['needsReview'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'urgency': urgency,
        'description': description,
        'location': location.toJson(),
        'estimatedCount': estimatedCount,
        'languageDetected': languageDetected,
        'confidence': confidence,
        'needsReview': needsReview,
      };

  AiExtractedData copyWith({
    String? category,
    int? urgency,
    String? description,
    LocationData? location,
    int? estimatedCount,
    String? languageDetected,
    double? confidence,
    bool? needsReview,
  }) {
    return AiExtractedData(
      category: category ?? this.category,
      urgency: urgency ?? this.urgency,
      description: description ?? this.description,
      location: location ?? this.location,
      estimatedCount: estimatedCount ?? this.estimatedCount,
      languageDetected: languageDetected ?? this.languageDetected,
      confidence: confidence ?? this.confidence,
      needsReview: needsReview ?? this.needsReview,
    );
  }
}

class SurveyModel {
  final String id;
  final String surveyorId;
  final String inputType;
  final String rawText;
  final String? mediaUrl;
  final AiExtractedData? aiExtracted;
  final String status;
  final String? coordinatorNote;
  final DateTime submittedAt;
  final String? zoneId;

  const SurveyModel({
    required this.id,
    required this.surveyorId,
    required this.inputType,
    required this.rawText,
    this.mediaUrl,
    this.aiExtracted,
    required this.status,
    this.coordinatorNote,
    required this.submittedAt,
    this.zoneId,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: json['id'] as String,
      surveyorId: json['surveyorId'] as String,
      inputType: json['inputType'] as String,
      rawText: json['rawText'] as String,
      mediaUrl: json['mediaUrl'] as String?,
      aiExtracted: json['aiExtracted'] != null
          ? AiExtractedData.fromJson(
              json['aiExtracted'] as Map<String, dynamic>)
          : null,
      status: json['status'] as String,
      coordinatorNote: json['coordinatorNote'] as String?,
      submittedAt: json['submittedAt'] is DateTime
          ? json['submittedAt'] as DateTime
          : DateTime.parse(json['submittedAt'] as String),
      zoneId: json['zoneId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'surveyorId': surveyorId,
        'inputType': inputType,
        'rawText': rawText,
        'mediaUrl': mediaUrl,
        'aiExtracted': aiExtracted?.toJson(),
        'status': status,
        'coordinatorNote': coordinatorNote,
        'submittedAt': submittedAt.toIso8601String(),
        'zoneId': zoneId,
      };

  SurveyModel copyWith({
    String? id,
    String? surveyorId,
    String? inputType,
    String? rawText,
    String? mediaUrl,
    AiExtractedData? aiExtracted,
    String? status,
    String? coordinatorNote,
    DateTime? submittedAt,
    String? zoneId,
  }) {
    return SurveyModel(
      id: id ?? this.id,
      surveyorId: surveyorId ?? this.surveyorId,
      inputType: inputType ?? this.inputType,
      rawText: rawText ?? this.rawText,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      aiExtracted: aiExtracted ?? this.aiExtracted,
      status: status ?? this.status,
      coordinatorNote: coordinatorNote ?? this.coordinatorNote,
      submittedAt: submittedAt ?? this.submittedAt,
      zoneId: zoneId ?? this.zoneId,
    );
  }
}
