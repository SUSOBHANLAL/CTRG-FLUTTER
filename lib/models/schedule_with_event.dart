import 'package:my_flutter_app/models/event.dart';
import 'package:my_flutter_app/models/schedule_data.dart';

class ScheduleWithEvent {
  final Schedule schedule;
  final Event? event;

  ScheduleWithEvent({required this.schedule, this.event});

  @override
  String toString() {
    return 'ScheduleWithEvent{schedule: $schedule, event: $event}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleWithEvent &&
          runtimeType == other.runtimeType &&
          schedule == other.schedule &&
          event == other.event);

  @override
  int get hashCode => schedule.hashCode ^ (event?.hashCode ?? 0);
}
