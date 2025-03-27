import 'dart:async';
import 'package:educator/widgets/grid_subject/animated_grid_subject.dart';
import 'package:flutter/material.dart';
import 'package:educator/models/subject_model.dart';
import '../../state/subject_list_state.dart';
import '../../state/animation_state.dart';
import 'package:provider/provider.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isInitialized = false;
  int _subjectsCount = 0;

  // Configuration for staggered animations.
  final int _itemAnimationDuration = 500; // in milliseconds
  final int _itemDelay = 100; // delay between items in milliseconds

  @override
  void initState() {
    super.initState();
    // Delay initialization until after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final subjectListState =
          Provider.of<SubjectListState>(context, listen: false);
      await subjectListState.subjectInit();
      final subjects = subjectListState.subjects;

      int count = subjects.length;
      int totalDuration = count > 0
          ? _itemDelay * (count - 1) + _itemAnimationDuration
          : _itemAnimationDuration;

      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: totalDuration),
      );

      _controller.forward();
      setState(() {
        _isInitialized = true;
        _subjectsCount = count;
      });
    });
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _reAnimate() {
    _controller.reset();
    _controller.forward();
  }

  /// Dispose the old controller and create a new one based on the updated subject list.
  void _updateController(List<SubjectModel> subjects) {
    int newCount = subjects.length;

    int totalDuration = newCount > 0
        ? _itemDelay * (newCount - 1) + _itemAnimationDuration
        : _itemAnimationDuration;

    _controller.duration = Duration(milliseconds: totalDuration);

    setState(() {
      _subjectsCount = newCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjects = Provider.of<SubjectListState>(context).subjects;
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (subjects.length != _subjectsCount) {
      if (mounted) {
        _updateController(subjects);
      }
    }

    return Consumer<AnimationState>(
      builder: (_, animationState, __) {
        // Schedule reanimation if requested.
        if (animationState.reAnimate) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _reAnimate();
              animationState.reAnimate = false;
            }
          });
        }
        // If this page isn’t active and the animation is running, schedule a reset.
        if (animationState.selectedIndex != 1 && _controller.isAnimating) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _controller.reset();
            }
          });
        }
        int crossAxisCount =
            (MediaQuery.of(context).size.width / 200).clamp(1, 6).toInt();
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
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
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      int delay = _itemDelay * index;
                      double start =
                          delay / _controller.duration!.inMilliseconds;
                      double end = (delay + _itemAnimationDuration) /
                          _controller.duration!.inMilliseconds;
                      // Clamp end to 1.0.
                      if (end > 1.0) end = 1.0;
                      Animation<double> childAnimation = Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve:
                              Interval(start, end, curve: Curves.easeOutBack),
                        ),
                      );
                      return AnimatedGridSubject(
                        subject: subjects[index],
                        animation: childAnimation,
                      );
                    },
                    childCount: subjects.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
