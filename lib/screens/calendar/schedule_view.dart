import 'package:flutter/material.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/calendar/fetch_data.dart';
import 'package:smart_care/utils/classes.dart';
import 'package:smart_care/utils/callbacks.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

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
              view: CalendarView.timelineWorkWeek,
              showNavigationArrow: true,
              showDatePickerButton: true,
              dataSource: FetchData(snapshot.data!),
              appointmentBuilder: (BuildContext context, CalendarAppointmentDetails calendarAppointmentDetails) => Container(
                padding: const EdgeInsets.all(2),
                width: calendarAppointmentDetails.bounds.width,
                height: calendarAppointmentDetails.bounds.height,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: calendarAppointmentDetails.appointments.toList().first.color),
                child: Center(child: CustomizedText(fontSize: 12, text: calendarAppointmentDetails.appointments.toList().first.notes)),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ErrorRoom(error: snapshot.error.toString());
          }
        },
      );
}
