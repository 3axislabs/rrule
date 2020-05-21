import 'dart:collection';

import 'package:basics/basics.dart';
import 'package:meta/meta.dart';
import 'package:time_machine/time_machine.dart';

import 'codecs/string/string.dart';

enum RecurrenceFrequency {
  secondly,
  minutely,
  hourly,
  daily,
  weekly,
  monthly,
  yearly,
}

/// Specified in [RFC 5545 Section 3.8.5.3: Recurrence Rule](https://tools.ietf.org/html/rfc5545#section-3.8.5.3).
@immutable
class RecurrenceRule {
  RecurrenceRule({
    @required this.frequency,
    this.until,
    this.count,
    this.interval,
    Set<int> bySeconds = const {},
    Set<int> byMinutes = const {},
    Set<int> byHours = const {},
    Set<ByWeekDayEntry> byWeekDays = const {},
    Set<int> byMonthDays = const {},
    Set<int> byYearDays = const {},
    Set<int> byWeeks = const {},
    Set<int> byMonths = const {},
    Set<int> bySetPositions = const {},
    this.weekStart,
  })  : assert(frequency != null),
        assert(count == null || count >= 1),
        assert(until == null || count == null),
        assert(interval == null || interval >= 1),
        assert(bySeconds != null),
        assert(bySeconds.all(_debugCheckIsValidSecond)),
        bySeconds = SplayTreeSet.of(bySeconds),
        assert(byMinutes != null),
        assert(byMinutes.all(_debugCheckIsValidMinute)),
        byMinutes = SplayTreeSet.of(byMinutes),
        assert(byHours != null),
        assert(byHours.all(_debugCheckIsValidHour)),
        byHours = SplayTreeSet.of(byHours),
        assert(byWeekDays != null),
        byWeekDays = SplayTreeSet.of(byWeekDays),
        assert(byMonthDays != null),
        assert(byMonthDays.all(_debugCheckIsValidMonthDayEntry)),
        byMonthDays = SplayTreeSet.of(byMonthDays),
        assert(byYearDays != null),
        assert(byYearDays.all(_debugCheckIsValidDayOfYear)),
        byYearDays = SplayTreeSet.of(byYearDays),
        assert(byWeeks != null),
        assert(byWeeks.all(_debugCheckIsValidWeekNumber)),
        byWeeks = SplayTreeSet.of(byWeeks),
        assert(byMonths != null),
        assert(byMonths.all(_debugCheckIsValidMonthEntry)),
        byMonths = SplayTreeSet.of(byMonths),
        assert(bySetPositions != null),
        assert(bySetPositions.all(_debugCheckIsValidDayOfYear)),
        bySetPositions = SplayTreeSet.of(bySetPositions);

  /// Corresponds to the `FREQ` property.
  final RecurrenceFrequency frequency;

  /// (Inclusive)
  ///
  /// Corresponds to the `UNTIL` property.
  final LocalDateTime until;

  /// Corresponds to the `COUNT` property.
  final int count;

  /// Corresponds to the `INTERVAL` property.
  final int interval;

  /// Corresponds to the `BYSECOND` property.
  final Set<int> bySeconds;

  /// Corresponds to the `BYMINUTE` property.
  final Set<int> byMinutes;

  /// Corresponds to the `BYHOUR` property.
  final Set<int> byHours;

  /// Corresponds to the `BYDAY` property.
  final Set<ByWeekDayEntry> byWeekDays;

  /// Corresponds to the `BYMONTHDAY` property.
  final Set<int> byMonthDays;

  /// Corresponds to the `BYYEARDAY` property.
  final Set<int> byYearDays;

  /// Corresponds to the `BYWEEKNO` property.
  final Set<int> byWeeks;

  /// Corresponds to the `BYMONTH` property.
  final Set<int> byMonths;

  /// Corresponds to the `BYSETPOS` property.
  final Set<int> bySetPositions;

  /// Corresponds to the `WKST` property.
  final DayOfWeek weekStart;

  @override
  String toString() => RecurrenceRuleStringCodec().encode(this);

  // TODO(JonasWanke): ==, hashCode
}

/// Corresponds to a single entry in the `BYDAY` list of a [RecurrenceRule].
@immutable
class ByWeekDayEntry implements Comparable<ByWeekDayEntry> {
  ByWeekDayEntry(this.day, [this.occurrence])
      : assert(day != null),
        assert(occurrence == null || _debugCheckIsValidWeekNumber(occurrence));

  final DayOfWeek day;
  final int occurrence;

  @override
  int compareTo(ByWeekDayEntry other) {
    final result = (occurrence ?? 0).compareTo(other.occurrence ?? 0);
    if (result != 0) {
      return result;
    }
    // This correctly starts with monday.
    return day.value.compareTo(other.day.value);
  }

  // TODO(JonasWanke): toString(), ==, hashCode
}

/// Validates the `seconds` rule.
bool _debugCheckIsValidSecond(int number) {
  // "<= 60" is intentional due to leap seconds.
  assert(0 <= number && number <= TimeConstants.secondsPerMinute);
  return true;
}

/// Validates the `minutes` rule.
bool _debugCheckIsValidMinute(int number) {
  assert(0 <= number && number < TimeConstants.minutesPerHour);
  return true;
}

/// Validates the `hour` rule.
bool _debugCheckIsValidHour(int number) {
  assert(0 <= number && number < TimeConstants.hoursPerDay);
  return true;
}

/// Validates the `monthdaynum` rule.
bool _debugCheckIsValidMonthDayEntry(int number) {
  assert(1 <= number.abs() && number.abs() <= 31);
  return true;
}

/// Validates the `monthnum` rule.
bool _debugCheckIsValidMonthEntry(int number) {
  assert(1 <= number && number <= 12);
  return true;
}

/// Validates the `weeknum` rule and the first part of the `weekdaynum` rule.
bool _debugCheckIsValidWeekNumber(int number) {
  assert(1 <= number.abs() && number.abs() <= 53);
  return true;
}

/// Validates the `yeardaynum` rule.
bool _debugCheckIsValidDayOfYear(int number) {
  assert(1 <= number.abs() && number.abs() <= 366);
  return true;
}