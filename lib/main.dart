import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
          textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          primarySwatch: Colors.teal,
          accentColor: Colors.tealAccent,
          appBarTheme: const AppBarTheme(
              elevation: 15,
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          fontFamily: 'Quicksand'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

bool _showChart = false;

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // old Testing Data
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  // @override
  // void didChangeAppLifeCycleState(AppLifecycleState state) {
  //   print(state);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime selectedDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: selectedDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  List<Widget> _buildFunctionWidgetLandScape(
      MediaQueryData mediaCustomQuery, AppBar MyAppBar, Widget txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch(
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart
          ? Container(
              height: (mediaCustomQuery.size.height -
                      MyAppBar.preferredSize.height -
                      mediaCustomQuery.padding.top) *
                  0.65,
              child: Chart(_recentTransactions))
          : txList,
    ];
  }

  List<Widget> _buildFunctionWidgetPortrait(
      MediaQueryData mediaCustomQuery, AppBar MyAppBar, Widget txList) {
    return [
      Container(
          height: (mediaCustomQuery.size.height -
                  MyAppBar.preferredSize.height -
                  mediaCustomQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaCustomQuery = MediaQuery.of(context);
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final MyAppBar = AppBar(
      leading: Icon(Icons.money),
      title: Text('Personal Expenses'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add_box_sharp),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    final txList = Container(
        height: (mediaCustomQuery.size.height -
                MyAppBar.preferredSize.height -
                mediaCustomQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    return Scaffold(
      appBar: MyAppBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandScape)
              ..._buildFunctionWidgetLandScape(
                  mediaCustomQuery, MyAppBar, txList),
            if (!isLandScape)
              ..._buildFunctionWidgetPortrait(
                  mediaCustomQuery, MyAppBar, txList),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
