import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coiffinder/main.dart';

class Salon {
  final String id;
  final String name;
  final String description;
  final String? backgroundImage; // Add a field for the background image URL

  Salon({required this.id, required this.name, required this.description, this.backgroundImage});
}

class SalonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Salons')),
      body: SalonList(),
      drawer: AppDrawer(),
    );
  }
}

class SalonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('salons').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Icon(
              Icons.shop,
              size: 100,
              color: Colors.grey,
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemExtent: 100, // Set the height of each item
          itemBuilder: (context, index) {
            var salonData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            var salon = Salon(
              id: snapshot.data!.docs[index].id,
              name: salonData['name'] ?? '',
              description: salonData['description'] ?? '',
              backgroundImage: salonData['backgroundImage'],
            );

            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3), // Pink shadow color with opacity
                    offset: Offset(0, 2),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    salon.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(salon.description),
                  onTap: () {
                    // Navigate to salon details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalonDetailsPage(salon: salon)),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SalonDetailsPage extends StatelessWidget {
  final Salon salon;

  SalonDetailsPage({required this.salon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(salon.name)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${salon.description}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
