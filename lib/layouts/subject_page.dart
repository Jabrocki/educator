import 'package:educator/state/tab_state.dart';
import 'package:flutter/material.dart';

// Custom widgets
import 'package:educator/widgets/grid_subject.dart';

// Models
import 'package:educator/models/subject_model.dart';

//State
import '../state/subject_list_state.dart';

//Packages
import 'package:provider/provider.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<SubjectListState>(context).subjectInit(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<SubjectModel> subjectList =
              Provider.of<SubjectListState>(context).subjects;
          return _body(context, subjectList);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _body(BuildContext context, List<SubjectModel> subjectList) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Dynamically calculate crossAxisCount based on screen width
    int crossAxisCount = (screenWidth / 200).floor().clamp(2, 6);
    // Ensures a minimum of 2 columns and a maximum of 6 columns
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Subjects",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: Consumer<TabState>(builder: (context, tabState, _) {
            List<GlobalKey<AnimatedGridSubjectState>> animatedGridKeys =
                List.generate(subjectList.length,
                    (index) => GlobalKey<AnimatedGridSubjectState>());

            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if(tabState.activeTabIndex == 1) {
                    animatedGridKeys[index].currentState?.startAnimation();
                  }
                  return AnimatedGridSubject(
                    key: animatedGridKeys[index],
                    subject: subjectList[index],
                    index: index,
                  );
                },
                childCount: subjectList.length,
              ),
            );
          }),
        ),
      ],
    );
  }
}
