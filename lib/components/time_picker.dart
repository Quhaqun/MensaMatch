import 'package:flutter/material.dart';

Future<DateTime?> showDatePickerDialog(BuildContext context) async {
  DateTime currentDate = DateTime.now();
  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: currentDate,
    lastDate: currentDate.add(Duration(days: 1)),
    selectableDayPredicate: (DateTime date) {
      // Allow only today and tomorrow
      return date.isAfter(currentDate.subtract(Duration(days: 1))) &&
          date.isBefore(currentDate.add(Duration(days: 2)));
    },
  );

  if (selectedDate != null) {
    print('Selected Date: $selectedDate');
    // Handle the selected date as needed
  } else {
    print('User canceled the date picker');
  }

  return selectedDate;
}

Future<TimeOfDay?> showTimePickerDialog(BuildContext context) async {
  TimeOfDay currentTime = TimeOfDay.now();
  TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: currentTime,
    builder: (BuildContext context, Widget? child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: child!,
    );
  },
  );

  if (selectedTime != null) {
    // Round the selected time to the nearest 15 minutes
    int minuteIncrement = 15;
    int roundedMinutes = (selectedTime.minute / minuteIncrement).round() * minuteIncrement;
    
    // Ensure not to exceed 59 minutes
    roundedMinutes = roundedMinutes % 60;
    selectedTime = TimeOfDay(hour: selectedTime.hour, minute: roundedMinutes);
    print('Selected Time: $selectedTime');
  } else {
    print('User canceled the time picker');
  }

  return selectedTime;
}

String getDateButtonText(DateTime selectedDate) {
  DateTime now = DateTime.now();
  DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);

  if (isSameDay(selectedDate, now)) {
    return 'Today';
  } else if (isSameDay(selectedDate, tomorrow)) {
    return 'Tomorrow';
  }

  // If not today or tomorrow, display the formatted date
  return '${selectedDate.year}-${_twoDigits(selectedDate.month)}-${_twoDigits(selectedDate.day)}';
}

String _twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String formatTime(int value) {
  return value < 10 ? '0$value' : '$value';
}