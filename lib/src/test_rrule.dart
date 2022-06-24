import '../rrule.dart';

//:TODO include start date into getInstances method
//:TODO include start date into text

Future<void> main() async {
  final endDate = DateTime.now();

  DateTime? until;
  DateTime start;

  start = endDate.toUtc();
  until = endDate.add(Duration(days: 5)).toUtc();

  final recurrenceRule = RecurrenceRule(
    frequency: Frequency.daily,
    until: until,
    interval: 2,
    startDate: start,
  );

  print(recurrenceRule.toString());
  print(recurrenceRule.toJson());

  final rrule = RecurrenceRule.fromString(
    'RRULE:FREQ=DAILY;UNTIL=20220629T052759Z;DTSTART=20220624T052759Z;INTERVAL=2',
  );

  print('String to R Rule End Date ${rrule.until}');
  print('String to R Rule Start Date ${rrule.startDate}');

  final jsonDate = <String, dynamic>{'freq': 'DAILY', 'until': '2022-06-29T05:45:07', 'startdate': '2022-06-24T05:45:07', 'interval': 2};
  final rruleJson = RecurrenceRule.fromJson(jsonDate);

  print('print json to RRule ${rruleJson.until}');
  print('print json to RRule ${rruleJson.startDate}');
}
