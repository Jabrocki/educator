//Provider
import 'package:educator/models/flashcard_model.dart';
import 'package:educator/state/flashcard_list_state.dart';
import 'package:educator/widgets/flashcard_edit/animated_flashcard_edit.dart';
import '../../state/animation_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class FlashcardEditPage extends StatefulWidget {
  const FlashcardEditPage({
    super.key,
  });

  @override
  State<FlashcardEditPage> createState() => _FlashcardEditPageState();
}

class _FlashcardEditPageState extends State<FlashcardEditPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  int _flashcardCount = 0;
  bool _isInitialized = false;

  final int _itemAnimationDuration = 500;
  final int _itemDelay = 100;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final flashcardListState =
          Provider.of<FlashcardListState>(context, listen: false);

      await flashcardListState.flashcardsInit();

      final flashcards = flashcardListState.flashcards;

      int count = flashcards.length;

      int totalDuration = count > 0
          ? _itemDelay * (count - 1) + _itemAnimationDuration
          : _itemAnimationDuration;

      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: totalDuration));

      _controller.forward();

      setState(() {
        _flashcardCount = count;
        _isInitialized = true;
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

  void _updateController(List<FlashcardModel> flashcards) {
    int newCount = flashcards.length;

    int totalDuration = newCount > 0
        ? _itemDelay * (newCount - 1) + _itemAnimationDuration
        : _itemAnimationDuration;

    _controller.duration = Duration(milliseconds: totalDuration);

    setState(() => _flashcardCount = newCount);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final flashcards = Provider.of<FlashcardListState>(context).flashcards;
    print(flashcards);
    if (flashcards.length != _flashcardCount) {
      if (mounted) _updateController(flashcards);
    }

    return Consumer<AnimationState>(builder: (_, animationState, __) {
      if (animationState.reAnimate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _reAnimate();
            animationState.reAnimate = false;
          }
        });
      }

      if (animationState.selectedIndex != 1 && _controller.isAnimating) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _controller.reset();
        });
      }

      int crossAxisCount =
          (MediaQuery.of(context).size.width / 800).clamp(1, 2).toInt();
      return _body(context, crossAxisCount, flashcards);
    });
  }

  Widget _body(BuildContext context, int crossAxisCount,
      List<FlashcardModel> flashcards) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Flashcards edit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
                padding: const EdgeInsets.all(8.0),
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
                      return AnimatedFlashcardEdit(
                        animation: childAnimation,
                        flashcard: flashcards[index],
                      );
                    },
                    childCount: flashcards.length,
                  ),
                ))
          ],
        ));
  }
}
