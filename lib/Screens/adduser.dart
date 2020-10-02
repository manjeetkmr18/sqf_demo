import 'package:sqf_demo/models/user.dart';
import 'package:sqf_demo/utils/database_helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class AddUserView extends StatefulWidget {
  @override
  _AddUserViewState createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  User _user = User();
  final formKey = GlobalKey<FormState>();
  List<User> _users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add User',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (val) => setState(() => _user.name = val),
                  validator: (val) =>
                      (val.length == 0 ? 'Number can\t be empty' : null),
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Number'),
                    onSaved: (val) => setState(() => _user.mobile = val),
                    validator: (val) {
                      if (val.length != 10)
                        return 'Mobile Number must be of 10 digit';
                      else
                        return null;
                    }),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    onSaved: (val) => setState(() => _user.email = val),
                    validator: (val) => EmailValidator.validate(val)
                        ? null
                        : "Invalid email address"),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Interest'),
                  onSaved: (val) => setState(() => _user.interest = val),
                  validator: (val) =>
                      (val.length == 0 ? 'this fied is required' : null),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  onSaved: (val) => setState(() => _user.address = val),
                  validator: (val) =>
                      (val.length == 0 ? 'this fied is required' : null),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    onPressed: () => _onSubmit(),
                    child: Text('Submit'),
                    color: Colors.red,
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onSubmit() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      DatabaseHelper.instance.insertUser(_user);
      Navigator.pop(context);
      refreshContactList();
    }
  }

  refreshContactList() async {
    List<User> e = await DatabaseHelper.instance.fetchUser();
    setState(() {
      _users = e;
    });
  }
}
