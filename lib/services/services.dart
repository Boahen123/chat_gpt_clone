import 'package:chat_gpt_clone/constants/colors.dart';
import 'package:chat_gpt_clone/widgets/drop_down.dart';
import 'package:chat_gpt_clone/widgets/response_widget.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showModal(BuildContext context) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: TextWidget(
                label: "Chosen Model:",
                fontSize: 16,
              )),
              SizedBox(
                width: 15,
              ),
              Flexible(child: DropDownModels())
            ],
          ),
        );
      },
    );
  }
}
