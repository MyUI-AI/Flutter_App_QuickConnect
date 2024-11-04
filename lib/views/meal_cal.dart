import 'package:flutter/material.dart';
import '../models/activity.dart';
import 'activity_detail_dialog.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';
import '../providers/text_size_provider.dart'; // Import your provider

class MealCalPage extends StatefulWidget {
  @override
  _MealCalPageState createState() => _MealCalPageState();
}

class _MealCalPageState extends State<MealCalPage> {
  int currentDayIndex = DateTime.now().weekday - 1;

  // Sample days of the week
  final List<String> daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  // Sample MealCal per day
  final Map<String, List<Activity>> MealCalByDay = {
    'Monday': [
      Activity(
        name: 'Morning Yoga',
        description: 'Start your week with yoga.',
        date: 'Monday',
        time: '8:00 AM',
        activityImage: 'https://www.example.com/yoga.jpg',
      ),
      Activity(
        name: 'Team Meeting',
        description: 'Weekly sync-up with the team.',
        date: 'Monday',
        time: '10:00 AM',
        activityImage: 'https://www.example.com/team-meeting.jpg',
      ),
      Activity(
        name: 'Lunch Break',
        description: 'Take a break and relax.',
        date: 'Monday',
        time: '12:00 PM',
        activityImage: 'https://www.example.com/lunch.jpg',
      ),
      Activity(
        name: 'Grocery Shopping',
        description: 'Get fresh groceries for the week.',
        date: 'Monday',
        time: '3:00 PM',
        activityImage: 'https://www.example.com/grocery.jpg',
      ),
      Activity(
        name: 'Evening Walk',
        description: 'Enjoy a refreshing walk in the park.',
        date: 'Monday',
        time: '6:00 PM',
        activityImage: 'https://www.example.com/walk.jpg',
      ),
      Activity(
        name: 'Dinner Preparation',
        description: 'Prepare a healthy dinner.',
        date: 'Monday',
        time: '7:30 PM',
        activityImage: 'https://www.example.com/dinner.jpg',
      ),
    ],
    'Tuesday': [
      Activity(
        name: 'Cooking Workshop',
        description: 'Learn to cook healthy meals.',
        date: 'Tuesday',
        time: '10:00 AM',
        activityImage: 'https://www.example.com/cooking-workshop.jpg',
      ),
      Activity(
        name: 'Project Planning',
        description: 'Plan out your projects for the week.',
        date: 'Tuesday',
        time: '1:00 PM',
        activityImage: 'https://www.example.com/planning.jpg',
      ),
      Activity(
        name: 'Gym Session',
        description: 'Hit the gym for a workout.',
        date: 'Tuesday',
        time: '5:00 PM',
        activityImage: 'https://www.example.com/gym.jpg',
      ),
      Activity(
        name: 'Book Club',
        description: 'Discuss this month\'s book.',
        date: 'Tuesday',
        time: '8:00 PM',
        activityImage: 'https://www.example.com/book-club.jpg',
      ),
    ],
    'Wednesday': [
      Activity(
        name: 'Morning Run',
        description: 'Start your day with a run.',
        date: 'Wednesday',
        time: '7:00 AM',
        activityImage: 'https://www.example.com/run.jpg',
      ),
      Activity(
        name: 'Work on Projects',
        description: 'Focus on ongoing projects.',
        date: 'Wednesday',
        time: '10:00 AM',
        activityImage: 'https://www.example.com/projects.jpg',
      ),
      Activity(
        name: 'Lunch with Friends',
        description: 'Catch up with friends over lunch.',
        date: 'Wednesday',
        time: '1:00 PM',
        activityImage: 'https://www.example.com/lunch-friends.jpg',
      ),
      Activity(
        name: 'Visit to Art Gallery',
        description: 'Explore new art exhibitions.',
        date: 'Wednesday',
        time: '4:00 PM',
        activityImage: 'https://www.example.com/art-gallery.jpg',
      ),
      Activity(
        name: 'Movie Night',
        description: 'Watch a movie with family or friends.',
        date: 'Wednesday',
        time: '7:00 PM',
        activityImage: 'https://www.example.com/movie-night.jpg',
      ),
    ],
    // Define other days if needed
  };

  // Navigate to the next day
  void _nextDay() {
    setState(() {
      currentDayIndex = (currentDayIndex + 1) % daysOfWeek.length;
    });
  }

  // Navigate to the previous day
  void _previousDay() {
    setState(() {
      currentDayIndex = (currentDayIndex - 1 + daysOfWeek.length) % daysOfWeek.length;
    });
  }

  // Logout function
  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double minTextSize = Provider.of<TextSizeProvider>(context).minTextSize; // Access min text size

    // Determine number of days to show based on text size
    int visibleDaysCount = minTextSize > 16 ? 2 : 3; // Adjust based on text size
    List<String> visibleDays = List.generate(visibleDaysCount, (index) {
      return daysOfWeek[(currentDayIndex + index) % daysOfWeek.length];
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meal Plan',
          style: TextStyle(fontSize: minTextSize * 1.75), // Dynamic title size
        ),
        backgroundColor: const Color(0xFFfe6357), // Primary color
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(minTextSize), // General padding for the body
        child: Column(
          children: [
            // Navigation arrows
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
            // Display days and MealCal
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: visibleDays.map((day) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * (1 / visibleDaysCount),
                      child: _buildDayColumn(day, MealCalByDay[day] ?? [], minTextSize),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build each day's column of MealCal
  Widget _buildDayColumn(String day, List<Activity> MealCal, double minTextSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(minTextSize * 0.75),
          decoration: BoxDecoration(
            color: const Color(0xFFfe6357),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: minTextSize * 1.5, // Dynamic text size
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: minTextSize * 1.5), // Increased spacing between day header and MealCal
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: MealCal.length,
            itemBuilder: (context, index) {
              return _buildActivityTile(MealCal[index], minTextSize);
            },
          ),
        ),
      ],
    );
  }

  // Build each activity tile
  Widget _buildActivityTile(Activity activity, double minTextSize) {
    return GestureDetector(
      onTap: () => _showActivityDetail(context, activity),
      child: Container(
        margin: EdgeInsets.only(bottom: minTextSize * 1.5), // Increased margin between MealCal
        padding: EdgeInsets.all(minTextSize * 1.25), // Increased padding inside activity tiles
        decoration: BoxDecoration(
          color: const Color(0xFFF8D7DA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Activity image or placeholder
            Container(
              width: minTextSize * 5,
              height: minTextSize * 5,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: activity.activityImage != null
                    ? Image.network(activity.activityImage!, fit: BoxFit.cover)
                    : Icon(Icons.image, color: Colors.grey),
              ),
            ),
            SizedBox(width: minTextSize * 0.75), // Space between image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: TextStyle(fontSize: minTextSize * 1.25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: minTextSize * 0.25), // Space between title and description
                  Text(
                    activity.description,
                    style: TextStyle(fontSize: minTextSize, color: Colors.grey[700]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show activity detail dialog
  void _showActivityDetail(BuildContext context, Activity activity) {
    showDialog(
      context: context,
      builder: (context) {
        return ActivityDetailDialog(activity: activity);
      },
    );
  }
}
