import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class VaccineCalendarPage extends StatefulWidget {
  final DateTime dob;
  const VaccineCalendarPage({super.key, required this.dob});

  @override
  State<VaccineCalendarPage> createState() => _VaccineCalendarPageState();
}

class _VaccineCalendarPageState extends State<VaccineCalendarPage> {
  DateTime today = DateTime.now();
  late Map<DateTime, Map<String, dynamic>?> events = {};

  @override
  void initState() {
    super.initState();
    generateEvents();
  }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void generateEvents() {
    Map<DateTime, Map<String, dynamic>?> temp = {};

    // Vaccine schedules
    List<Map<String, dynamic>> vaccines = [
      {
        "age": "At Birth",
        "vaccines": [
          "BCG",
          "Hepatitis B (Birth Dose)",
          "OPV (Oral Polio Vaccine 0)"
        ],
        "daysAfterBirth": 0
      },
      {
        "age": "6 Weeks",
        "vaccines": ["DPT", "OPV", "Hepatitis B"],
        "daysAfterBirth": 42
      },
      {
        "age": "10 Weeks",
        "vaccines": ["DPT", "OPV"],
        "daysAfterBirth": 70
      },
      {
        "age": "14 Weeks",
        "vaccines": ["DPT", "OPV", "Hepatitis B"],
        "daysAfterBirth": 98
      },
    ];

    for (var vaccine in vaccines) {
      DateTime vaccineDate =
          widget.dob.add(Duration(days: vaccine["daysAfterBirth"]));
      temp[normalizeDate(vaccineDate)] = vaccine;
    }

    setState(() {
      events.addAll(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccine Calendar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Vaccination Schedule",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 16.0),

          // Calendar Section
          TableCalendar(
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, 
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            focusedDay: today,
            firstDay: widget.dob.subtract(const Duration(days: 30)),
            lastDay: widget.dob.add(const Duration(days: 200)),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                today = normalizeDate(selectedDay);
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(today, day);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                DateTime normalizedDay = normalizeDate(day);
                if (events.containsKey(normalizedDay)) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16.0),

          // Vaccine Information Section
          events[normalizeDate(today)] == null || events[normalizeDate(today)]!["vaccines"].isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "No vaccines scheduled for this day.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: events[normalizeDate(today)]!["vaccines"].length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: const Icon(
                              Icons.vaccines_outlined,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              events[normalizeDate(today)]!["vaccines"][index],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              "Scheduled at ${events[normalizeDate(today)]!["age"]}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
