import 'package:intl/intl.dart';

class DateUtil {
  // Method to format a DateTime object (or a String that can be parsed to DateTime)
  static String formatDate(dynamic date) {
    DateTime parsedDate;

    if (date is String) {
      // Try parsing the string into a DateTime object
      parsedDate = DateTime.parse(date);
    } else if (date is DateTime) {
      parsedDate = date;
    } else {
      throw FormatException("Invalid type, expected a DateTime or a String.");
    }

    final DateFormat formatter = DateFormat('yyyy-MM-dd'); // Format as '2025-03-18'
    return formatter.format(parsedDate); // Return the formatted string
  }
}
