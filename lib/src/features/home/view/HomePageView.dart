import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:savetify/src/features/home/view/HomePageWidget.dart';
import 'package:savetify/src/features/home/view_model/HomePageViewModel.dart';
import 'package:savetify/src/features/report/model/ReportRepository.dart';
import 'package:savetify/src/features/report/view/ReportView.dart';
import 'package:savetify/src/features/report/view_model/ReportViewModel.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  HomePageViewModel homePageViewModel = HomePageViewModel();
  late final ReportView _reportView;
  late List<Widget> _widgetOptions;
  int _selectedIndex = 0;

  @override
  void initState() {
    // ilk calisan fonksiyon, burda olustur classlari
    // super ile cekme de burdan
    super.initState();

    _reportView = ReportView(
      reportViewModel: ReportViewModel.retrieveReports(
        ReportRepository(),
      ),
    );


    _widgetOptions = <Widget>[
    const HomePageWidget(title: 'Home Page'),
    const Center(
      child: Text(
        'Search Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
    ),
    Center(child: _reportView),
  ];
  }

  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget navbar() {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Report',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.person_2),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => homePageViewModel.getProfilePage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: navbar(),
          ),
        ],
      ),
    );
  }
}
