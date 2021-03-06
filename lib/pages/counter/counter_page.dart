import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft/pages/counter/counter_provider.dart';
import 'package:nft/widgets/screen_widget.dart';
import 'package:provider/provider.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({Key key, this.argument}) : super(key: key);

  final String argument;

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      body: Column(children: <Widget>[
        AppBar(
          title: const Text('Counter Page'),
        ),
        ScreenHeader(title: widget.argument ?? ''),
        const Expanded(
          child: ScreenBody(),
        ),
      ]),
    );
  }
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({@required this.title, Key key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 20), child: Text(title));
  }
}

class ScreenBody extends StatelessWidget {
  const ScreenBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CounterProvider>(
      create: (_) => CounterProvider(),
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Text(
                '${context.watch<CounterProvider>().count}',

                /// Provide a Key to this specific Text widget. This allows
                /// identifying the widget from inside the test suite,
                /// and reading the text.
                key: const Key('counter'),
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              /// Provide a Key to this button. This allows finding this
              /// specific button inside the test suite, and tapping it.
              key: const Key('increment'),
              onPressed: () {
                context.read<CounterProvider>().increase();
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
