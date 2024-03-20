import 'package:flutter/material.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/calendar/fetch_data.dart';
import 'package:smart_care/utils/callbacks.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class LView extends StatelessWidget {
  const LView({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: generateAppointments(),
        builder: (BuildContext context, AsyncSnapshot<List<Appointment>> snapshot) {
          if (snapshot.hasData) {
            return SfCalendar(
              allowAppointmentResize: true,
              allowDragAndDrop: true,
              firstDayOfWeek: 1,
              showWeekNumber: true,
              view: CalendarView.schedule,
              resourceViewSettings: const ResourceViewSettings(visibleResourceCount: 4),
              showNavigationArrow: true,
              showDatePickerButton: true,
              dataSource: FetchData(snapshot.data!),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ErrorRoom(error: snapshot.error.toString());
          }
        },
      );
}
