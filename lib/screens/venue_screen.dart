import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/venue_data.dart';
import 'package:my_flutter_app/services/api_service.dart';

class VenueScreen extends StatefulWidget {
  const VenueScreen({super.key});

  @override
  _VenueScreenState createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
  late Future<List<VenueData>> futureVenueData;

  @override
  void initState() {
    super.initState();
    futureVenueData = ApiService().getVenueData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Venue',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<VenueData>>(
        future: futureVenueData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 16), // Top padding for the list
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final venue = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    8,
                  ), // LTRB margins (Left, Top, Right, Bottom)
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Optional rounded corners
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Match container radius
                    child: Image.network(
                      venue.image,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          color: Colors.grey[200],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, size: 50),
                                SizedBox(height: 8),
                                Text('Failed to load image'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
