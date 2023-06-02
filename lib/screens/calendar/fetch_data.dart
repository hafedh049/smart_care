import 'package:syncfusion_flutter_calendar/calendar.dart';

class FetchData extends CalendarDataSource<Appointment> {
  FetchData(List<Appointment> source) {
    appointments = source;
  }
}
