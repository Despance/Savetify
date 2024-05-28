
import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier{
  
  Widget getProfilePage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Profile Page'),
      ),
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
      
    );
  }
  /*final _repository = locator<HomeRepository>();

  List<HomeModel> _homeList = [];
  List<HomeModel> get homeList => _homeList;

  void getHomeList() async {
    setState(ViewState.Busy);
    _homeList = await _repository.getHomeList();
    setState(ViewState.Idle);
  }
  */
}

