import 'package:chat_gpt_clone/widgets/response_widget.dart';
import 'package:flutter/material.dart';

List<String> models = [
  'Model1',
  'Model2',
  'Model3',
];

List<DropdownMenuItem<String>>? get getModels {
  List<DropdownMenuItem<String>>? modelsItems =
      List<DropdownMenuItem<String>>.generate(models.length, (index) {
    return DropdownMenuItem<String>(
      value: models[index],
      child: TextWidget(
        label: models[index],
        fontSize: 15,
      ),
    );
  });

  return modelsItems;
}
