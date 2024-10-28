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
    final residentProvider = Provider.of<ResidentProvider>(context, listen: false);
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
            return _buildResidentList(residentProvider);
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

  Widget _buildResidentList(ResidentProvider residentProvider) {
    return ListView.builder(
      itemCount: residentProvider.residentList.length, // List of residents
      itemBuilder: (context, index) {
        final ResidentModel resident = residentProvider.residentList[index];
        return _buildResidentCard(resident, residentProvider);
      },
    );
  }

  Widget _buildResidentCard(ResidentModel resident, ResidentProvider residentProvider) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
      elevation: 4, // Shadow effect
      child: ListTile(
        title: Text(
          resident.name,
          style: const TextStyle(fontWeight: FontWeight.bold), // Bold text
        ),
        subtitle: Text('Apartment: ${resident.apartmentNumber}'), // Additional info
        trailing: const Icon(Icons.arrow_forward, color: Color(0xFFff6357)), // Arrow icon
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
      ),
    );
  }
}
