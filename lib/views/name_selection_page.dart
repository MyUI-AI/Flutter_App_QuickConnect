import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_connect_application/views/dashboard_page.dart';
import '../providers/resident_provider.dart';
import '../models/resident.dart';

class NameSelectionPage extends StatefulWidget {
  final String apartmentNumber;

  const NameSelectionPage({Key? key, required this.apartmentNumber}) : super(key: key);

  @override
  _NameSelectionPageState createState() => _NameSelectionPageState();
}

class _NameSelectionPageState extends State<NameSelectionPage> {
  late Future<void> _fetchResidentsFuture;

  @override
  void initState() {
    super.initState();
    // Initiate resident fetching
    _fetchResidentsFuture = _fetchResidents();
  }

  Future<void> _fetchResidents() async {
    final residentProvider = Provider.of<ResidentProvider>(
        context, listen: false);
    await residentProvider.fetchResidentsByApartment(widget.apartmentNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Resident'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFff6357), // Set AppBar color
      ),
      body: FutureBuilder<void>(
        future: _fetchResidentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while fetching data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message if fetching failed
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          // Check for residents
          final residentProvider = Provider.of<ResidentProvider>(context);
          if (residentProvider.residentList.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildResidentGrid(residentProvider);
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: const Text(
        'No residents found.',
        style: TextStyle(fontSize: 18, color: Colors.black54),
      ),
    );
  }
  Widget _buildResidentGrid(ResidentProvider residentProvider) {
    final residentCount = residentProvider.residentList.length;

    if (residentCount <= 4) {
      // Divide the screen equally for up to 4 residents.
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildResidentCard(
                    residentProvider.residentList[0],
                    residentProvider,
                  ),
                ),
                if (residentCount > 1)
                  Expanded(
                    child: _buildResidentCard(
                      residentProvider.residentList[1],
                      residentProvider,
                    ),
                  ),
              ],
            ),
          ),
          if (residentCount > 2)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildResidentCard(
                      residentProvider.residentList[2],
                      residentProvider,
                    ),
                  ),
                  if (residentCount > 3)
                    Expanded(
                      child: _buildResidentCard(
                        residentProvider.residentList[3],
                        residentProvider,
                      ),
                    ),
                ],
              ),
            ),
        ],
      );
    } else {
      // Use a scrollable GridView when there are more than 4 residents.
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: residentCount,
          itemBuilder: (context, index) {
            final ResidentModel resident = residentProvider.residentList[index];
            return _buildResidentCard(resident, residentProvider);
          },
        ),
      );
    }
  }




  Widget _buildResidentCard(ResidentModel resident,
      ResidentProvider residentProvider) {
    return GestureDetector(
      onTap: () {
        // Set the selected resident in the provider
        residentProvider.setResident(resident);

        // Navigate to the dashboard page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(resident: resident),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center( // Center the content inside the tile
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: resident.profilePic?.isNotEmpty == true
                      ? NetworkImage(
                      resident.profilePic!) // Load profile picture if available
                      : const AssetImage(
                      'assets/default_profile.png') as ImageProvider, // Default image if not
                ),
              ),
              const SizedBox(height: 8),
              Text(
                resident.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Apartment: ${resident.apartmentNumber}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
