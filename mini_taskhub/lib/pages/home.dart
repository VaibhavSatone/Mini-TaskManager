import 'package:flutter/material.dart';
import 'package:mini_taskhub/pages/Login.dart';
import 'package:mini_taskhub/pages/create_task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  List<dynamic> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() => isLoading = true);

    try {
      final response = await Supabase.instance.client
          .from('tasks')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        tasks = response;
        isLoading = false;
        print('Fetched tasks: $response');
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tasks: ${e.toString()}')),
      );
    }
  }

  Future<void> refreshTasks() async => await fetchTasks();

  Future<void> signOut() async {
  await Supabase.instance.client.auth.signOut();
  if (mounted) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212730),
      appBar: AppBar(
        title: const Text(
          'All Tasks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF212730),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(
                  child: Text('No tasks found',
                      style: TextStyle(color: Colors.white)),
                )
              : RefreshIndicator(
                  onRefresh: refreshTasks,
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        color: const Color(0xFF37474F),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            '${task['Title'] ?? 'No Title'}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${task['description'] ?? 'No Description'}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (task['date'] != null)
                                Text('${task['date']}',
                                    style: const TextStyle(
                                        color: Colors.white60)),
                              if (task['time'] != null)
                                Text('${task['time']}',
                                    style: const TextStyle(
                                        color: Colors.white60)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const create_task()),
          );
          fetchTasks(); // Refresh list after returning
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
