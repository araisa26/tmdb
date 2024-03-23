import 'package:intl/intl.dart';

abstract class DateConvert {
  static String locale = '';
  static String stringFromDate(DateTime? date) =>
      date != null ? DateFormat.yMMMMd(locale).format(date) : "";
}
