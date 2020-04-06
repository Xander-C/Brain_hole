import 'package:json_annotation/json_annotation.dart';

part 'TodoThing.g.dart';

@JsonSerializable()
class TodoThing {
  TodoThing(this.todo, this.deadline, this.isToday, this.isDone);
  String todo;
  DateTime deadline;
  bool isToday;
  bool isDone;

  factory TodoThing.fromJson(Map<String, dynamic> json) => _$TodoThingFromJson(json);
  Map<String, dynamic> toJson() => _$TodoThingToJson(this);
}