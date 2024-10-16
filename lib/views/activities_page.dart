import 'package:flutter/material.dart';
import '../models/activity.dart';
import 'activity_detail_dialog.dart';

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  int currentDayIndex = DateTime.now().weekday - 1;
  int? selectedDayIndex; // Track which day is expanded

  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final Map<String, List<Activity>> activitiesByDay = {
    'Monday': [
      Activity(
        name: 'Morning Yoga',
        description: 'Start your week with yoga.',
        date: 'Monday',
        time: '8:00 AM',
      ),
      Activity(
        name: 'Art Class',
        description: 'Express yourself through art.',
        date: 'Monday',
        time: '11:00 AM',
      ),
    ],
    'Tuesday': [
      Activity(
        name: 'Cooking Workshop',
        description: 'Learn to cook healthy meals.',
        date: 'Tuesday',
        time: '10:00 AM',
      ),
    ],
  };

  void _nextDay() {
    setState(() {
      currentDayIndex = (currentDayIndex + 2) % daysOfWeek.length;
    });
  }

  void _previousDay() {
    setState(() {
      currentDayIndex =
          (currentDayIndex - 2 + daysOfWeek.length) % daysOfWeek.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> visibleDays = [
      daysOfWeek[currentDayIndex],
      daysOfWeek[(currentDayIndex + 1) % daysOfWeek.length],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities', style: TextStyle(fontSize: 28)),
      ),
      body: Column(
        children: [
          // Arrow buttons and visible days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousDay,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: visibleDays.map((day) {
                    int dayIndex = daysOfWeek.indexOf(day);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDayIndex = selectedDayIndex == dayIndex
                                ? null
                                : dayIndex; // Toggle selection
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Text(
                                  day,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      8), // Space between day name and activities
                              if (selectedDayIndex == dayIndex)
                                _buildActivitiesBox(activitiesByDay[day] ?? []),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _nextDay,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget to display the collapsible activities box
  Widget _buildActivitiesBox(List<Activity> activities) {
    return Container(
      width: double.infinity, // Ensure the box fills the tile width
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white, // White background for the collapsible box
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 3,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        children: activities.map((activity) {
          return _buildActivityTile(activity);
        }).toList(),
      ),
    );
  }

  // Widget to display individual activity tiles
  Widget _buildActivityTile(Activity activity) {
    return GestureDetector(
      onTap: () => _showActivityDetail(context, activity),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent, // Activity tile color
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.name,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              activity.time,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the activity detail dialog
  void _showActivityDetail(BuildContext context, Activity activity) {
    showDialog(
      context: context,
      builder: (context) => ActivityDetailDialog(activity: activity),
    );
  }
}
