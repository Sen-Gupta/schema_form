import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:json_schema/json_schema.dart';
import 'package:json_schema/vm.dart';
import 'package:rxdart/subjects.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';

class JsonSchemaBloc extends Bloc<JsonSchemaEvent, JsonSchemaState>
    implements ClickListener {
  final Map<String, BehaviorSubject<dynamic>> _formData =
      Map<String, BehaviorSubject<dynamic>>();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  final PublishSubject<String> _submitData = PublishSubject<String>();

  VoidCallback onFormChanged;
  WillPopCallback onFormWillPop;

  BuildContext formContext;

  Stream<String> get submitData => _submitData;

  JsonSchemaBloc({
    @required this.formContext,
    this.onFormChanged,
    this.onFormWillPop,
  }) {
    configureJsonSchemaForVm();
//    configureJsonSchemaForBrowser();
  }

  JsonSchema getPropertySchema(String fieldName) =>
      state?.dataSchema?.properties[fieldName];

  Stream<dynamic> getFieldStream(String fieldName) =>
      _formData[fieldName].stream;

  void initDataBinding(Map<String, dynamic> properties) {
    print("properties: $properties");
    properties?.forEach((key, prop) {
      print("Creating: $key");
      print("prop: $prop");
      print("currentState.data: ${state.data}");
      print("currentState.data[key]: ${state.data[key]}");
      print(
          "currentState.data[key] ?? prop.defaultValue: ${state.data[key] ?? prop.defaultValue}");
      _formData[key] =
          BehaviorSubject<dynamic>.seeded(state.data[key] ?? prop.defaultValue);
      print("Created: $key");
    });
  }

  String getFormData() {
    if (validate()) {
      return json.encode(state.data);
    }

    return "Não foi possível validar os dados";
  }

  bool validate() {
    print("_data: ${state.data}");
    return state.dataSchema == null
        ? false
        : state.dataSchema.validate(state.data, reportMultipleErrors: true);
  }

  close() {
    _formDataClose();

    super.close();
  }

  void _formDataClose() {
    print("Initial _formData.length: ${_formData.length}");

    _formData.removeWhere((key, value) {
      print("Closing: $key");
      value.close();
      print("Closed: $key");

      return true;
    });

    print("Final _formData.length: ${_formData.length}");
  }

  @override
  get initialState => JsonSchemaState.initial();

  @override
  Stream<JsonSchemaState> mapEventToState(event) async* {
    if (event is LoadDataSchemaEvent) {
      _formDataClose();

      initDataBinding(event.dataSchema?.properties);

      yield state.copyWith(dataSchema: event.dataSchema);
      print("LoadJsonSchemaEvent executed");
//
//      currentState.data?.forEach((key, value) {
//        print("Loaded(key: ${key}, value: ${value})");
//        if (_formData.containsKey(key)) {
//          _formData[key].add(value);
//        }
//      });
    } else if (event is LoadDataEvent) {
      Map<String, dynamic> currentData = event.data ?? state.data;

      currentData?.forEach((key, value) {
        if (_formData.containsKey(key)) {
          _formData[key].add(value);
          print("Loaded(key: $key, value: $value)");
        }
      });

      yield state.copyWith(data: event.data);
      print("LoadDataEvent executed");
    } else if (event is LoadLayoutSchemaEvent) {
      yield state.copyWith(layout: event.layout);
      print("LoadLayoutSchemaEvent executed");
    } else if (event is ChangeValueJsonSchemaEvent) {
      print("event.key: ${event.key}, event.value: ${event.value}");

      if (_formData.containsKey(event.key)) {
        _formData[event.key].add(event.value);
      }

      Map<String, dynamic> currentData = state.data;

      currentData[event.key] = event.value;

      print("ChangeValueJsonSchemaEvent executed");
      yield state.copyWith(data: currentData);
    } else if (event is SubmitJsonSchemaEvent) {
      try {
        print("currentState.data: ${state.data}");

        FormState formState = formKey?.currentState ?? Form.of(formContext);

        print("formState: $formState");

        if (formState.validate()) {
          print("Valid form state");

          formState.save();

          Validator validator = new Validator(state.dataSchema);

          if (validator.validate(state.data)) {
            _submitData.add(json.encode(state.data));
          } else {
            _submitData.add(validator.errors.toString());
          }
        } else {
          _submitData.add("Invalid form state");
        }
      } catch (e) {
        _submitData.add(e.toString());
      }

      yield state;
    }
  }

  @override
  void onClicked(String event) {
    if ('SchemaForm://submit' == event) {
      print("Executing: $event");

      add(SubmitJsonSchemaEvent());
    } else {
      print("Click event not implemented: $event");
    }
  }
}
