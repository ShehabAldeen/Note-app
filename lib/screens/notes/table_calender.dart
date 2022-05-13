import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDay = DateTime.now();

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      selectedDayPredicate: (day) {
        return isSameDay(day, selectedDay);
      },
      onDaySelected: (sDay, fDay) {
        setState(() {
          selectedDay = sDay;
          focusedDay = fDay; // update `_focusedDay` here as well
        });
      },
      calendarFormat: CalendarFormat.week,
      focusedDay: focusedDay,
      firstDay: DateTime.now().subtract(Duration(days: 100 * 365)),
      lastDay: DateTime.now().add(Duration(days: 100 * 365)),
      calendarStyle: CalendarStyle(
        selectedTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        todayTextStyle: TextStyle(
          color: Colors.white,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(20),
        ),
        defaultTextStyle: TextStyle(color: Colors.black, fontSize: 18),
        defaultDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      weekendDays: [],
    );
  }
}
