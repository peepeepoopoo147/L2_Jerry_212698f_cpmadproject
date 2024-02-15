import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25),
              Text(
                'About us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Discover and Stream the Best Music',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 40),
              Image.asset(
                'images/aboutusimage.png',
                height: 200,
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Our mission',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'At TuneTune, we are committed to providing the best '
                      'music streaming and discovery services to our '
                      'customers and clients. We believe that music has '
                      'the power to make a positive impact on our '
                      'community, industry, and the world. Our TuneTune '
                      'team is dedicated to providing the best possible '
                      'music streaming experience, and we are always '
                      'looking for ways to improve and innovate.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.phone),
                      label: Text('Call Us'),
                      onPressed: () {
                        launch('tel:+123');
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.email),
                      label: Text('Email Us'),
                      onPressed: () {
                        launch(
                            'mailto:rajatrrpalankar@gmail.com?subject=This is Subject Title&body= This is Body of Email');
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
