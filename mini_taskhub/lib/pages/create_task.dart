import 'package:flutter/material.dart';
import 'package:mini_taskhub/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(const create_task());
}

/// Root widget to run the app.
class create_task extends StatelessWidget {
  const create_task({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreateTaskScreen(),
    );
  }
}

/// Screen for creating a new task
class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  /// Function to pick a date from calendar
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// Function to pick a time using clock interface
  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212730), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF212730),
        elevation: 0,
        leading: IconButton(
          color: const Color.fromARGB(255, 255, 255, 255),
          icon: const Icon(Icons.arrow_back,),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
        title: const Text('Create New Task',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Task Title
            const Text(
              'Task Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Hi-Fi Wireframe',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF2A2E36),
              ),
            ),

            const SizedBox(height: 16),

            /// Task Details
            const Text(
              'Task Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: detailsController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry...',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF2A2E36),
              ),
            ),

            const SizedBox(height: 16),

            /// Date & Time Pickers
            Row(
              children: [
                IconButton(
                  onPressed: () => pickTime(context),
                  icon: const Icon(Icons.access_time, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  selectedTime != null
                      ? selectedTime!.format(context)
                      : 'Pick Time',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: () => pickDate(context),
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : 'Pick Date',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),

            const Spacer(),

            /// Create Button
            ElevatedButton(
  onPressed: () async {
    final title = titleController.text.trim();
    final details = detailsController.text.trim();
    final date = selectedDate?.toIso8601String().split('T').first;
    final time = selectedTime?.format(context);

    if (title.isEmpty || details.isEmpty || date == null || time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client.from('tasks').insert({
        'Title': title,
        'description': details,
        'date': date,
        'time': time,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added successfully!')),
      );

      // Redirect to HomeScreenWidget after task creation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreenWidget()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.yellow,
    foregroundColor: Colors.black,
    minimumSize: const Size(double.infinity, 50),
  ),
  child: const Text('Create'),
)
          ],
        ),
      ),
    );
  }
}
