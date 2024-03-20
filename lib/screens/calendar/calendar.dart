import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/screens/calendar/list_view.dart';
import 'package:smart_care/screens/calendar/schedule_view.dart';
import 'package:smart_care/utils/globals.dart';

class CalendarV extends StatefulWidget {
  const CalendarV({super.key});

  @override
  State<CalendarV> createState() => _CalendarVState();
}

class _CalendarVState extends State<CalendarV> with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          TabBar(
            labelColor: grey,
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: 'Schedule', icon: Icon(FontAwesomeIcons.timeline, size: 15)),
              Tab(text: 'List', icon: Icon(FontAwesomeIcons.list, size: 15)),
            ],
          ),
          Expanded(child: TabBarView(physics: const NeverScrollableScrollPhysics(), controller: _tabController, children: const <Widget>[ScheduleView(), LView()])),
        ],
      ),
    );
  }
}
