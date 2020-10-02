import 'package:sqf_demo/Screens/adduser.dart';
import 'package:sqf_demo/Screens/viewsingleuser.dart';
import 'package:sqf_demo/models/user.dart';
import 'package:sqf_demo/utils/database_helper.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    refreshContactList();
  }

  final formKey = GlobalKey<FormState>();

  List<User> _users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_list()],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
              heroTag: 'button1',
              onPressed: () => refreshContactList(),
              child: Icon(Icons.refresh)),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddUserView()),
            ),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  _list() => Expanded(
        child: Card(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(_users[index].name.toUpperCase()),
                    subtitle: Text(_users[index].mobile),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignleUserView(
                                    user: _users[index],
                                  )));
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await DatabaseHelper.instance
                            .deleteUser(_users[index].id);
                        refreshContactList();
                      },
                    ),
                  ),
                  Divider(
                    height: 5.0,
                  )
                ],
              );
            },
            itemCount: _users.length,
          ),
        ),
      );

  refreshContactList() async {
    List<User> e = await DatabaseHelper.instance.fetchUser();
    setState(() {
      _users = e;
    });
  }
}
