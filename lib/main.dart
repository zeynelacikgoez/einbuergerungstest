import 'package:flutter/material.dart';

void main() {
  runApp(EinbuergerungstestApp());
}

class EinbuergerungstestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Einbürgerungstest App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24),
              _buildProgressCard(),
              SizedBox(height: 16),
              _buildQuickActionsCard(),
              Spacer(),
              _buildNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Einbürgerungstest',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.account_circle),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dein Lernfortschritt",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '75%',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Gesamtfortschritt',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Icon(Icons.school, size: 48, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lernoptionen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            _buildQuickActionItem('Übungsmodus starten', Icons.play_circle_filled),
            _buildQuickActionItem('Prüfungssimulation', Icons.assignment),
            _buildQuickActionItem('Themen wiederholen', Icons.repeat),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              SizedBox(width: 12),
              Text(title),
            ],
          ),
          Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, color: Colors.blue),
          Icon(Icons.book, color: Colors.grey),
          Icon(Icons.insert_chart, color: Colors.grey),
          Icon(Icons.settings, color: Colors.grey),
        ],
      ),
    );
  }
}