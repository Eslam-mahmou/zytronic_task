import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:zytronic_task/presentaion/layout/manager/layout_cubit/layout_state.dart';

import '../../tabs/home_screen.dart';
import '../../tabs/story_screen.dart';

class LayoutViewModel extends Cubit<LayoutState> {
  LayoutViewModel() : super(LayoutInitial());
  int currentIndex = 0;
  List<Widget> tabs = [
    HomeScreen(),
    StoryScreen(),
  ];
  void changeBottomNav(int index){
    emit(LayoutInitial());
    currentIndex = index;
    emit(LayoutChangeBottomNavState());
  }
}