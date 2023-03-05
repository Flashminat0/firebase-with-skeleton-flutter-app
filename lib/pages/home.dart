import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/account.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  late String? userName = '';

  Future getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then(
      (snapshot) {
        setState(() {
          userName = snapshot.docs[0]['name'];
        });
      },
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  int currentPage = 0;

  changePage(int index) {
    debugPrint(index.toString());
    // if (index == 0) {
    //   Navigator.of(context).push(
    //       MaterialPageRoute(builder: (BuildContext context) => const Todo()));
    // } else if (index == 1) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (BuildContext context) => const AccountPage()));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Account',
            selectedIcon: Icon(Icons.account_circle),
          ),
        ],
        onDestinationSelected: (int index) {
          // debugPrint('destination $index');
          setState(
            () {
              currentPage = index;
            },
          );

          changePage(index);
        },
        selectedIndex: currentPage,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (currentPage == 0) {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['email']),
                );
              }).toList(),
            );
          } else if (currentPage == 1) {
            return AccountPage();
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }
}
