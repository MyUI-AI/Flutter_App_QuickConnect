import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity.dart';
import 'activity_detail_dialog.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';
import '../providers/text_size_provider.dart';
import 'package:intl/intl.dart';

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  DateTime currentDate = DateTime.now(); // Track current date
  bool _isDialogOpen = false; // Flag to manage dialog state

  final List<String> daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  int currentDayIndex = DateTime.now().weekday - 1; // Index of the current day

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _nextDay() {
    setState(() {
      currentDate = currentDate.add(Duration(days: 1)); // Move to next day
      currentDayIndex = (currentDayIndex + 1) % daysOfWeek.length; // Update current day index
    });
  }

  void _previousDay() {
    setState(() {
      currentDate = currentDate.subtract(Duration(days: 1)); // Move to previous day
      currentDayIndex = (currentDayIndex - 1 + daysOfWeek.length) % daysOfWeek.length; // Update current day index
    });
  }

  @override
  Widget build(BuildContext context) {
    double minTextSize = Provider.of<TextSizeProvider>(context).minTextSize;

    int visibleDaysCount = minTextSize > 16 ? 2 : 3;
    List<String> visibleDays = List.generate(visibleDaysCount, (index) {
      DateTime dayDate = currentDate.add(Duration(days: index));
      return '${daysOfWeek[(currentDate.weekday - 1 + index) % daysOfWeek.length]} ${DateFormat('dd/MM').format(dayDate)}'; // Correctly format the date
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activities',
          style: TextStyle(fontSize: minTextSize * 1.75),
        ),
        backgroundColor: const Color(0xFFfe6357),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(minTextSize),
        child: Column(
          children: [
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
                  children: visibleDays.map((day) {
                    return SizedBox(
                        width: MediaQuery.of(context).size.width * (1 / visibleDaysCount),
                        child: _buildDayColumn(day.split(' ')[0], minTextSize, day.split(' ')[1])
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

  Widget _buildDayColumn(String day, double minTextSize, String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(minTextSize * 1.5), // Increased padding for day container
          margin: EdgeInsets.symmetric(vertical: minTextSize * 2, horizontal: minTextSize), // Uniform vertical and horizontal margin
          decoration: BoxDecoration(
            color: const Color(0xFFfe6357),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: minTextSize * 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: minTextSize * 1.0), // Spacing below day name
              Center(
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: minTextSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('activities').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No activities found.'));
              }

              List<Activity> activities = [];
              DateTime startDate = DateTime.now();
              for (var doc in snapshot.data!.docs) {
                var data = doc.data() as Map<String, dynamic>;
                DateTime startTime = (data['startTime'] as Timestamp).toDate();
                String dayFromStartTime = DateFormat('EEEE').format(startTime);

                // Check if the day matches the startTime
                if (dayFromStartTime == day) {
                  activities.add(Activity(
                    name: data['name'],
                    description: data['description'],
                    activityImage: data['activityImage'],
                    startTime: startTime,
                    endTime: (data['endTime'] as Timestamp).toDate(),
                    location: data['location'],
                    capacity: data['capacity'],
                    count: data['count'] ?? 0,
                  ));
                  // Store the start date to display below the day name
                  startDate = startTime;
                }
              }

              // Sort activities by start time
              activities.sort((a, b) => a.startTime.compareTo(b.startTime));

              // Format the date to display
              String formattedDate = DateFormat('dd/MM').format(startDate);

              return ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return _buildActivityTile(activities[index], minTextSize);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTile(Activity activity, double minTextSize) {
    return GestureDetector(
      onTap: () => _showActivityDetail(activity, minTextSize),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: minTextSize, horizontal: minTextSize * 1.5), // Uniform vertical and horizontal margin
        padding: EdgeInsets.all(minTextSize), // Padding within activity tiles
        decoration: BoxDecoration(
          color: const Color(0xFFF8D7DA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: minTextSize * 6,
              height: minTextSize * 6,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: activity.activityImage != null && activity.activityImage!.isNotEmpty
                    ? Image.network(
                  activity.activityImage!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: Colors.grey);
                  },
                )
                    : Icon(Icons.image, color: Colors.grey),
              ),
            ),
            SizedBox(width: minTextSize), // Spacing between image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: TextStyle(fontSize: minTextSize * 1.1, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: minTextSize * 0.5), // Spacing between name and time
                  Text(
                    '${activity.startTime.hour}:${activity.startTime.minute.toString().padLeft(2, '0')} - ${activity.endTime.hour}:${activity.endTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: minTextSize, fontWeight: FontWeight.bold),
                  ),
                  //SizedBox(height: minTextSize * 0.5), // Spacing between time and registration info
                  //if (activity.count < activity.capacity) // Check if count is less than capacity
                    //Text(
                      //'Registrations: ${activity.count} / ${activity.capacity}',
                      //style: TextStyle(fontSize: minTextSize * 0.9, color: Colors.grey[700]),
                    //)
                  //else
                    //Text(
                      //'No seats left', // Display when count exceeds capacity
                      //style: TextStyle(fontSize: minTextSize * 0.9, color: Colors.red), // Optional styling for "No seats left"
                    //),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showActivityDetail(Activity activity, double minTextSize) {
    if (_isDialogOpen) return; // Prevent multiple dialogs from opening

    _isDialogOpen = true; // Set the flag to true
    showDialog(
      context: context,
      builder: (context) {
        return ActivityDetailDialog(activity: activity, minTextSize: minTextSize);
      },
    ).then((_) {
      _isDialogOpen = false; // Reset the flag when the dialog is closed
    });
  }
}
