// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileUploadResponse _$FileUploadResponseFromJson(Map<String, dynamic> json) =>
    _FileUploadResponse(
      key: json['key'] as String,
      url: json['url'] as String,
      contentType: json['content_type'] as String,
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$FileUploadResponseToJson(_FileUploadResponse instance) =>
    <String, dynamic>{
      'key': instance.key,
      'url': instance.url,
      'content_type': instance.contentType,
      'size': instance.size,
    };
