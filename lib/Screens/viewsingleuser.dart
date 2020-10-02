import 'package:sqf_demo/models/user.dart';
import 'package:sqf_demo/utils/database_helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignleUserView extends StatefulWidget {
  final User user;
  const SignleUserView({Key key, this.user}) : super(key: key);

  @override
  _SignleUserViewState createState() => _SignleUserViewState(user);
}

class _SignleUserViewState extends State<SignleUserView> {
  User user;

  List<User> _users;
  _SignleUserViewState(this.user);
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _interestController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _nameController.text = user.name;
    _mobileController.text = user.mobile;
    _emailController.text = user.email;
    _interestController.text = user.interest;
    _addressController.text = user.address;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.name,
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
                  controller: _nameController,
                  onSaved: (val) => setState(() => user.name = val),
                  validator: (val) =>
                      (val.length == 0 ? 'Number can\t be empty' : null),
                ),
                TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(labelText: 'Number'),
                    onSaved: (val) => setState(() => user.mobile = val),
                    validator: (val) {
                      if (val.length < 5)
                        return 'Mobile Number must be of 10 digit';
                      else
                        return null;
                    }),
                TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    onSaved: (val) => setState(() => user.email = val),
                    validator: (val) => EmailValidator.validate(val)
                        ? null
                        : "Invalid email address"),
                TextFormField(
                  controller: _interestController,
                  decoration: InputDecoration(labelText: 'Interest'),
                  onSaved: (val) => setState(() => user.interest = val),
                  validator: (val) =>
                      (val.length == 0 ? 'this fied is required' : null),
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  onSaved: (val) => setState(() => user.address = val),
                  validator: (val) =>
                      (val.length == 0 ? 'this fied is required' : null),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        child: Text('update'),
                        textColor: Colors.white,
                        color: Colors.red,
                        onPressed: () => _onUpdate()),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onUpdate() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      await DatabaseHelper.instance.updateUser(user);
      refreshContactList();
      _resetForm();
    }
  }

  void _resetForm() {
    setState(() {
      formKey.currentState.reset();
      _nameController.clear();
      _mobileController.clear();
      _emailController.clear();
      _interestController.clear();
      _addressController.clear();
      user.id = null;
    });
  }

  refreshContactList() async {
    List<User> e = await DatabaseHelper.instance.fetchUser();
    setState(() {
      _users = e;
    });
  }
}
