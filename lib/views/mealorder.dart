import 'package:flutter/material.dart';
import '../models/activity.dart';
import 'activity_detail_dialog.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';
import '../providers/text_size_provider.dart'; // Import your provider

class MealOrderPage extends StatefulWidget {
  @override
  _MealOrderPageState createState() => _MealOrderPageState();
}

class _MealOrderPageState extends State<MealOrderPage> {

  // Sample meals for the day
  //TODO: make this with meal type rather than activity type
  final List<Activity> MealOrder = [
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
      )
  ];

  // // Navigate to the next day
  // void _nextDay() {
  //   setState(() {
  //     currentDayIndex = (currentDayIndex + 1) % daysOfWeek.length;
  //   });
  // }

  // // Navigate to the previous day
  // void _previousDay() {
  //   setState(() {
  //     currentDayIndex = (currentDayIndex - 1 + daysOfWeek.length) % daysOfWeek.length;
  //   });
  // }

  // Logout function
  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double minTextSize = Provider.of<TextSizeProvider>(context).minTextSize; // Access min text size

    // // Determine number of days to show based on text size
    // int visibleDaysCount = minTextSize > 16 ? 2 : 3; // Adjust based on text size
    // List<String> visibleDays = List.generate(visibleDaysCount, (index) {
    //   return daysOfWeek[(currentDayIndex + index) % daysOfWeek.length];
    // });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MealOrder -- Tuesday Lunch', // should be dynamic, also moved down
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
      body: 
      Padding(
        padding: EdgeInsets.all(minTextSize), // General padding for the body
        child: GridView.count(
        mainAxisSpacing: minTextSize,
        crossAxisSpacing: minTextSize,
        crossAxisCount: 4,
        children: MealOrder.map((order) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _buildActivityTile(order, minTextSize),
              );
              }).toList(),
        ),
      ),
    );
  }

  // // Build each day's column of MealOrder
  // Widget _buildDayColumn(Activity meal, double minTextSize) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         padding: EdgeInsets.all(minTextSize * 0.75),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFFfe6357),
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: Center(
  //           child: Text(
  //             day,
  //             style: TextStyle(
  //               fontSize: minTextSize * 1.5, // Dynamic text size
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: minTextSize * 1.5), // Increased spacing between day header and MealOrder
  //       Expanded(
  //         child: ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: MealOrder.length,
  //           itemBuilder: (context, index) {
  //             return _buildActivityTile(MealOrder[index], minTextSize);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
var isHover = false; //TODO: should be per item but this has it for all the items
  // Build each activity tile
  Widget _buildActivityTile(Activity activity, double minTextSize) {
    return InkWell(
      onTap: () => _addItem(context, activity),
      onHover: (val) {
        setState((){
          isHover = val;
        });
      },
      // child: Container(
      //   decoration: BoxDecoration(
      //     color: const Color(0xFFF8D7DA),
      //     borderRadius: BorderRadius.circular(8),
      //   ),
        child: isHover ? 
        Row( //when hovering
          children:[
            ClipRRect( //when not hovering
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 250, //TODO: this should span the whole thing and use the image
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.2,
                      0.5,
                      0.7,
                      0.6,
                    ],
                    colors: [
                      Colors.transparent,
                      Colors.white10,
                      Colors.white54,
                      Color.fromARGB(190, 255, 255, 255),
                    ],
                  ),
                ),
              )
            )
          ]
        ) : 
        ClipRRect( //when not hovering
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: Colors.purple
          )
        )
      );
    // );
  }

  // Show activity detail dialog
  void _addItem(BuildContext context, Activity activity) {
    showDialog(
      context: context,
      builder: (context) {
        return ActivityDetailDialog(activity: activity);
      },
    );
  }
}
