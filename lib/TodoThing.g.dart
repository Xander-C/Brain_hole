// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TodoThing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoThing _$TodoThingFromJson(Map<String, dynamic> json) {
  return TodoThing(
    json['todo'] as String,
    json['deadline'] == null
        ? null
        : DateTime.parse(json['deadline'] as String),
    json['isToday'] as bool,
    json['isDone'] as bool,
  );
}

Map<String, dynamic> _$TodoThingToJson(TodoThing instance) => <String, dynamic>{
      'todo': instance.todo,
      'deadline': instance.deadline?.toIso8601String(),
      'isToday': instance.isToday,
      'isDone': instance.isDone,
    };
