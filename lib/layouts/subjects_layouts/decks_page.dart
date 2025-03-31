//Material
import 'package:educator/models/deck_model.dart';
import 'package:educator/state/animation_state.dart';
import 'package:educator/state/deck_list_state.dart';
import 'package:educator/state/main_state.dart';
import 'package:educator/widgets/grid_deck/animated_grid_deck.dart';
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';

class DecksPage extends StatefulWidget {
  const DecksPage({
    super.key,
  });

  @override
  State<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends State<DecksPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _decksCount = 0;
  bool _isInitialized = false;

  final int _itemAnimationDuration = 500;
  final int _itemDelay = 100;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final deckListState = Provider.of<DeckListState>(context, listen: false);
      final mainState = Provider.of<MainState>(context, listen: false);

      await deckListState.decksInit(mainState.subjectId);

      final decks = deckListState.decks;

      int count = decks.length;

      int totalDuration = count > 0
          ? _itemDelay * (count - 1) + _itemAnimationDuration
          : _itemAnimationDuration;

      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: totalDuration));

      _controller.forward();

      setState(() {
        _decksCount = count;
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

  void _updateController(List<DeckModel> decks) {
    int newCount = decks.length;

    int totalDuration = newCount > 0
        ? _itemDelay * (newCount - 1) + _itemAnimationDuration
        : _itemAnimationDuration;

    _controller.duration = Duration(milliseconds: totalDuration);

    setState(() => _decksCount = newCount);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final decks = Provider.of<DeckListState>(context).decks;

    if (decks.length != _decksCount) {
      if (mounted) _updateController(decks);
    }

    return Consumer<AnimationState>(
      builder: (_, animationState, ___) {
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
            (MediaQuery.of(context).size.width / 200).clamp(1, 6).toInt();
        return _body(context, crossAxisCount, decks);
      },
    );
  }

  Widget _body(
      BuildContext context, int crossAxisCount, List<DeckModel> deckList) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Decks",
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
                  double start = delay / _controller.duration!.inMilliseconds;
                  double end = (delay + _itemAnimationDuration) /
                      _controller.duration!.inMilliseconds;

                  Animation<double> childAnimation = Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(start, end, curve: Curves.easeOutBack),
                    ),
                  );
                  return AnimatedGridDeck(
                      deck: deckList[index], animation: childAnimation);
                },
                childCount: deckList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
