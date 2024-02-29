import 'package:flutter/material.dart';

class add_event extends StatefulWidget {
  const add_event({super.key});

  @override
  State<add_event> createState() => _addEventState();
}

class _addEventState extends State<add_event> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _EventTypeController = TextEditingController();
  final TextEditingController _EventDateController = TextEditingController();
  final TextEditingController _EventTimeController = TextEditingController();
  final TextEditingController _DescriptionController = TextEditingController();

  Future<void> _datePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(
          DateTime.now().year, 1, 1), // Set initial date to current year
      firstDate: DateTime(2024, 1, 1), // Set first date to 2024
      lastDate: DateTime(2036, 12, 31), // Set last date to 2030
    );

    if (picked != null) {
      setState(() {
        _EventDateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _EventTimeController.text = pickedTime.format(context);
      });
    }
  }

  static const EdgeInsets textFieldPadding = EdgeInsets.all(10);
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text("ADD Event"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: textFieldPadding,
              child: TextFormField(
                controller: _EventTypeController,
                decoration: const InputDecoration(
                    labelText: "Event Type",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                validator: (value) {
                  value = value!
                      .trim(); // In a TextFormField f the user doesn't enter anything, the value returned will be an empty string "", not null.
                  if (value.isEmpty) return "This field is required";
                  return null;
                },
              ),
            ),
            Container(
              padding: textFieldPadding,
              child: TextFormField(
                  controller: _EventDateController,
                  decoration: const InputDecoration(
                      labelText: "Select Date",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(Icons.calendar_month)),
                  readOnly: true,
                  onTap: () => _datePicker(context),
                  validator: (value) =>
                      (value == "") ? "This field is required" : null),
            ),
            Container(
              padding: textFieldPadding,
              child: TextFormField(
                  controller: _EventTimeController,
                  decoration: const InputDecoration(
                      labelText: "Select Time",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(Icons.access_time_rounded)),
                  readOnly: true,
                  onTap: () => _showTimePicker(context),
                  validator: (value) =>
                      (value == "") ? "This field is required" : null),
            ),
            Container(
              padding: textFieldPadding,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orange,
                    fixedSize: const Size(1000, 50)),
                onPressed: () {},
                child: const Text('+ add Image'),
              ),
            ),
            Container(
              padding: textFieldPadding,
              child: TextFormField(
                controller: _DescriptionController,
                decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                validator: (value) {
                  value = value!
                      .trim(); // In a TextFormField f the user doesn't enter anything, the value returned will be an empty string "", not null.
                  if (value.isEmpty) return "This field is required";
                  return null;
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: textFieldPadding,
                    child: ElevatedButton(
                      onPressed: _submitIncident,
                      child: const Text("Cancel"),
                    ),
                  ),
                  Container(
                    padding: textFieldPadding,
                    child: ElevatedButton(
                      onPressed: _submitIncident,
                      child: const Text("Add Event"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Link",
            icon: Icon(Icons.link),
          ),
          BottomNavigationBarItem(
            label: "History",
            icon: Icon(Icons.history),
          ),
        ],
        onTap: _onBottomNavBarItemTapped,
      ),
    );
  }

  void _submitIncident() {}

  void _onBottomNavBarItemTapped(int index) {
    // Implement navigation logic based on the selected bottom navigation bar item
    // You can use Navigator to push or pop screens based on the selected index
  }
}
