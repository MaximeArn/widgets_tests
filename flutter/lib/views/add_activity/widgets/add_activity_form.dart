import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_tests/models/activity_model.dart';
import 'package:widgets_tests/providers/city_provider.dart';

class AddActivityForm extends StatefulWidget {
  final String cityName;

  AddActivityForm({required this.cityName});

  @override
  _AddActivityFormState createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _priceFocusNode;
  late FocusNode _urlFocusNode;
  late Activity _newActivity;
  bool _isLoading = false;

  @override
  void initState() {
    _priceFocusNode = FocusNode();
    _urlFocusNode = FocusNode();
    _newActivity = Activity(
        name: "",
        city: widget.cityName,
        id: "",
        image: "",
        price: 0,
        status: ActivityStatus.ongoing);
    super.initState();
  }

  Future<void> submitForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        _formKey.currentState?.save();
        await Provider.of<CityProvider>(context, listen: false).addActivity(_newActivity);
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return value!.isEmpty ? "remplissez le nom" : null;
                },
                autofocus: true,
                decoration: InputDecoration(labelText: "Nom"),
                onSaved: (value) => _newActivity.name = value!,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocusNode),
              ),
              SizedBox(height: 20),
              TextFormField(
                focusNode: _priceFocusNode,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return value!.isEmpty ? "remplissez le prix" : null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Prix"),
                onSaved: (value) => _newActivity.price = double.parse(value!),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_urlFocusNode),
              ),
              SizedBox(height: 20),
              TextFormField(
                autocorrect: false,
                focusNode: _urlFocusNode,
                validator: (value) {
                  return value!.isEmpty ? "remplissez l' Url" : null;
                },
                decoration: InputDecoration(labelText: "Url image"),
                onSaved: (value) => _newActivity.image = value!,
                onFieldSubmitted: (_) => submitForm(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Annuler"),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            submitForm();
                          },
                    child: Text("Confirmer"),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
