import 'package:flutter/material.dart';

//PopUP window
import 'custom_pop_up_subject.dart';

class AddSubjectButton extends StatelessWidget {
  const AddSubjectButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context, 
          builder: (context) {
            return CustomPopUpSubject();
          }
        );
      },
      child: const Icon(Icons.add),
    );
  }
}

