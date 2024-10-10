import 'package:flutter/material.dart';

class HomeScreenTile extends StatelessWidget {
  final Widget nextScreen;
  final String title;
  final String img;

  const HomeScreenTile({
    Key? key,
    required this.img,
    required this.title,
    required this.nextScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the next screen when the tile is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners for better aesthetics
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image section
              Image.asset(
                img,
                height: 80,
                width: 80,
                fit: BoxFit.cover, // Ensure the image fits properly
              ),
              const SizedBox(height: 12),
              
              // Title section
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Info button
              ElevatedButton(
                onPressed: () {
                  // Add any action for the Info button
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Customized button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Info",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
