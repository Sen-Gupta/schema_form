// Copyright (c) 2019 Legytma Soluções Inteligentes (https://legytma.com.br).
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:meta/meta.dart';
import 'package:schema_form/bloc/event/json_schema_event.dart';

/// [JsonSchemaEvent] data change. Used by [JsonSchemaBloc] to update [Object]
/// data being edited in the form.
class ChangeValueJsonSchemaEvent extends JsonSchemaEvent {
  /// [String] representing the property name of the [Object] being edited.
  final String key;

  /// [dynamic] with the property value of the [Object] being edited.
  final dynamic value;

  /// Create a [ChangeValueJsonSchemaEvent] using the [key] and [value].
  ChangeValueJsonSchemaEvent({@required this.key, @required this.value});

  @override
  List<Object> get props => [key, value];
}
