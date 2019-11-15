import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerExample extends StatefulWidget {
  @override
  _DateTimePickerExampleState createState() {
    return _DateTimePickerExampleState();
  }
}

class _DateTimePickerExampleState extends State<DateTimePickerExample> {
  DateTime date1;
  DateTime date2;
  DateTime date3;
  Locale supportedLocale = Locale('es', 'AR');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('DateTime Picker Example'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              DateTimePickerFormField(
                inputType: InputType.both,
                format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
                editable: false,
                decoration: InputDecoration(
                    labelText: 'DateTime', hasFloatingPlaceholder: false),
                onChanged: (dt) {
                  setState(() => date1 = dt);
                  print('Selected date: $date1');
                },
              ),
              DateTimePickerFormField(
                inputType: InputType.date,
                format: DateFormat("yyyy-MM-dd"),
                initialDate: DateTime(2019, 1, 1),
                editable: false,
                decoration: InputDecoration(
                    labelText: 'Date', hasFloatingPlaceholder: false),
                onChanged: (dt) {
                  setState(() => date2 = dt);
                  print('Selected date: $date2');
                },
              ),
              DateTimePickerFormField(
                inputType: InputType.time,
                format: DateFormat("HH:mm"),
                initialTime: TimeOfDay(hour: 5, minute: 5),
                editable: false,
                decoration: InputDecoration(
                    labelText: 'Time', hasFloatingPlaceholder: false),
                onChanged: (dt) {
                  setState(() => date3 = dt);
                  print('Selected date: $date3');
                  print('Hour: $date3.hour');
                  print('Minute: $date3.minute');
                },
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ));
  }
}
