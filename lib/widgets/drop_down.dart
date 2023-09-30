import 'package:chat_gpt_clone/constants/colors.dart';
// import 'package:chat_gpt_clone/constants/models.dart';
import 'package:chat_gpt_clone/providers/api_provider.dart';
import 'package:chat_gpt_clone/providers/drop_down_provider.dart';
import 'package:chat_gpt_clone/widgets/response_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DropDownModels extends ConsumerStatefulWidget {
  const DropDownModels({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DropDownModelsState();
}

class _DropDownModelsState extends ConsumerState<DropDownModels> {
  @override
  Widget build(BuildContext context) {
    final modelsData = ref.watch(modelsDataProvider);
    final currentSelectedModel = ref.watch(dropdownProvider);
    return modelsData.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: TextWidget(label: 'No Models'),
            );
          } else {
            return FittedBox(
              child: DropdownButton(
                  underline: const SizedBox.shrink(),
                  dropdownColor: scaffoldBackgroundColor,
                  iconEnabledColor: Colors.white,
                  items: List<DropdownMenuItem<String>>.generate(data.length,
                      (index) {
                    return DropdownMenuItem<String>(
                      value: data[index].id,
                      child: TextWidget(
                        label: data[index].id,
                        fontSize: 20,
                      ),
                    );
                  }),
                  value: currentSelectedModel,
                  onChanged: (value) {
                    ref.read(dropdownProvider.notifier).state = value as String;
                  }),
            );
          }
        },
        error: (error, stackTrace) {
          return Center(
            child: TextWidget(label: 'Error ${error.toString()}'),
          );
        },
        loading: () => const Center(
              child: SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0,
              ),
            ));
  }
}
