import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  static const EdgeInsets textFieldPadding = EdgeInsets.all(10);
  final TextEditingController _DescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text("Incident Report"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orange,
                  fixedSize: const Size(1000, 50)),
              onPressed: () {},
              child: const Text('+ add Video'),
            ),
          ),
          Container(
            padding: textFieldPadding,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orange,
                  fixedSize: const Size(1000, 50)),
              onPressed: () {},
              child: const Text('+ add Voice'),
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
            padding: textFieldPadding,
            child: ElevatedButton(
              onPressed: _submitIncident,
              child: const Text("Submit"),
            ),
          ),
        ],
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

  void _submitIncident() {
    // Implement your incident submission logic here
    // This function will be called when the submit button is pressed
  }

  void _onBottomNavBarItemTapped(int index) {
    // Implement navigation logic based on the selected bottom navigation bar item
    // You can use Navigator to push or pop screens based on the selected index
  }
}
