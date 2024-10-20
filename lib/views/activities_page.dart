import 'package:flutter/material.dart';
import '../models/activity.dart';
import 'activity_detail_dialog.dart';
import 'login_page.dart'; // Import the login page

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  int currentDayIndex = DateTime.now().weekday - 1;

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
          activityImage: 'https://www.example.com/yoga.jpg'),
      Activity(
          name: 'Art Class',
          description: 'Express yourself through art.',
          date: 'Monday',
          time: '11:00 AM',
          activityImage: 'https://www.example.com/art-class.jpg'),
      Activity(
          name: 'Grocery Shopping',
          description: 'Buy groceries for the week.',
          date: 'Monday',
          time: '3:00 PM',
          activityImage: 'https://www.example.com/grocery.jpg'),
      Activity(
          name: 'Dinner Prep',
          description: 'Prepare a healthy dinner.',
          date: 'Monday',
          time: '5:00 PM',
          activityImage: 'https://www.example.com/dinner.jpg'),
      Activity(
          name: 'Movie Night',
          description: 'Watch a movie with friends.',
          date: 'Monday',
          time: '7:00 PM',
          activityImage: 'https://www.example.com/movie.jpg'),
      Activity(
          name: 'Evening Walk',
          description: 'Relax with a walk.',
          date: 'Monday',
          time: '9:00 PM',
          activityImage: 'https://www.example.com/walk.jpg'),
    ],
    'Tuesday': [
      Activity(
          name: 'Cooking Workshop',
          description: 'Learn to cook healthy meals.',
          date: 'Tuesday',
          time: '10:00 AM',
          activityImage: 'https://www.example.com/cooking-workshop.jpg'),
      Activity(
          name: 'Dance Class',
          description: 'Learn new dance moves.',
          date: 'Tuesday',
          time: '5:00 PM',
          activityImage: 'https://www.example.com/dance-class.jpg'),
      Activity(
          name: 'Guitar Lessons',
          description: 'Learn to play the guitar.',
          date: 'Tuesday',
          time: '1:00 PM',
          activityImage: 'https://www.example.com/guitar.jpg'),
      Activity(
          name: 'Community Service',
          description: 'Help out at the local shelter.',
          date: 'Tuesday',
          time: '3:00 PM',
          activityImage: 'https://www.example.com/community-service.jpg'),
      Activity(
          name: 'Evening Yoga',
          description: 'Relax and unwind with yoga.',
          date: 'Tuesday',
          time: '8:00 PM',
          activityImage: 'https://www.example.com/evening-yoga.jpg'),
      Activity(
          name: 'Podcast Recording',
          description: 'Record the weekly podcast.',
          date: 'Tuesday',
          time: '6:00 PM',
          activityImage: 'https://www.example.com/podcast.jpg'),
    ],
    'Wednesday': [
      Activity(
          name: 'Book Club',
          description: 'Join us to discuss our favorite books.',
          date: 'Wednesday',
          time: '6:00 PM',
          activityImage: 'https://www.example.com/book-club.jpg'),
      Activity(
          name: 'Fitness Bootcamp',
          description: 'Get fit with our bootcamp workout.',
          date: 'Wednesday',
          time: '7:00 PM',
          activityImage: 'https://www.example.com/fitness-bootcamp.jpg'),
      Activity(
          name: 'Photography Class',
          description: 'Learn photography basics.',
          date: 'Wednesday',
          time: '4:00 PM',
          activityImage: 'https://www.example.com/photography.jpg'),
      Activity(
          name: 'Lunch with Friends',
          description: 'Catch up with friends over lunch.',
          date: 'Wednesday',
          time: '12:00 PM',
          activityImage: 'https://www.example.com/lunch.jpg'),
      Activity(
          name: 'Gardening',
          description: 'Tend to the garden.',
          date: 'Wednesday',
          time: '2:00 PM',
          activityImage: 'https://www.example.com/gardening.jpg'),
      Activity(
          name: 'Game Night',
          description: 'Have fun playing games with family.',
          date: 'Wednesday',
          time: '8:00 PM',
          activityImage: 'https://www.example.com/game-night.jpg'),
    ],
    // Add more activities for the remaining days...
  };

  void _nextDay() {
    setState(() {
      currentDayIndex = (currentDayIndex + 1) % daysOfWeek.length;
    });
  }

  void _previousDay() {
    setState(() {
      currentDayIndex =
          (currentDayIndex - 1 + daysOfWeek.length) % daysOfWeek.length;
    });
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> visibleDays = [
      daysOfWeek[currentDayIndex],
      daysOfWeek[(currentDayIndex + 1) % daysOfWeek.length],
      daysOfWeek[(currentDayIndex + 2) % daysOfWeek.length],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities', style: TextStyle(fontSize: 28)),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFfe6357), // Primary color from palette
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Arrow buttons for navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousDay,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _nextDay,
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: visibleDays.map((day) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3, // Control the width of each day column
                    child: _buildDayColumn(day, activitiesByDay[day] ?? []),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display activities for a day
  Widget _buildDayColumn(String day, List<Activity> activities) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color(0xFFfe6357), // Day header color
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white, // Changed to white for better contrast
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true, // Important for ensuring the ListView doesn't grow infinitely
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return _buildActivityTile(activities[index]);
            },
          ),
        ),
      ],
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
          color: const Color(0xFFF8D7DA), // Lighter tile color for professionalism
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Placeholder for the activity image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED), // Placeholder color
                borderRadius: BorderRadius.circular(8),
              ),
              child: activity.activityImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  activity.activityImage!,
                  fit: BoxFit.cover,
                ),
              )
                  : const Icon(Icons.image, size: 40),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(activity.description),
                  const SizedBox(height: 4),
                  Text(
                    '${activity.date} at ${activity.time}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show the activity details dialog
  void _showActivityDetail(BuildContext context, Activity activity) {
    showDialog(
      context: context,
      builder: (context) {
        return ActivityDetailDialog(activity: activity);
      },
    );
  }
}
