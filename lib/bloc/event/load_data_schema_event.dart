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

import 'package:json_schema/json_schema.dart';
import 'package:meta/meta.dart';
import 'package:schema_form/bloc/event/json_schema_event.dart';

/// [JsonSchemaEvent] to load a [JsonSchema].
class LoadDataSchemaEvent extends JsonSchemaEvent {
  /// [JsonSchema] that will be loaded.
  final JsonSchema dataSchema;

  /// Create a [LoadDataSchemaEvent] using a [dataSchema].
  LoadDataSchemaEvent({@required this.dataSchema});

  @override
  List<Object> get props => [dataSchema];
}
