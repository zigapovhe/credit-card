import 'package:flutter/material.dart';
import 'package:credit_card/credit_card_form.dart';
import 'package:credit_card/credit_card_model.dart';
import 'package:credit_card/flutter_credit_card.dart';
import 'package:credit_card/credit_card_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kBlue
              ),
              child: const Text('Credit Card Form',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => FormScreen()));
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kBlue
              ),
              child: const Text('Credit card slider',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => CreditCardSliderScreen(),
                  ),
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kBlue
              ),
              child: const Text('Credit card slider with tabs',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => UniBillScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Color kPink = const Color(0xFFEE4CBF);
Color kRed = const Color(0xFFFA3754);
Color kBlue = const Color(0xFF4AA3F2);
Color kPurple = const Color(0xFFAF92FB);

final List<CreditCardWidget> _creditCards = [
  const CreditCardWidget(
      cardNumber: '4106 6900 1046 7531',
      expiryDate: '06/25',
      cardHolderName: 'ZIGA POVHE',
      cvvCode: '000',
      showBackView: false),
  const CreditCardWidget(
      cardNumber: '5273 4689 9296 5788',
      expiryDate: '09/24',
      cardHolderName: 'ZIGA POVHE',
      cvvCode: '721',
      showBackView: false),
  const CreditCardWidget(
      cardNumber: '4748 1900 1035 0245',
      expiryDate: '09/24',
      cardHolderName: 'ZIGA POVHE',
      cvvCode: '721',
      showBackView: false)
];

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: CreditCardForm(
                    formKey: _formKey,
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ),
              ),
              ElevatedButton(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: const Text('Validate',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'halter',
                        fontSize: 14,
                        package: 'flutter_credit_card'),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print('valid!');
                  } else {
                    print('invalid!');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

class CreditCardSliderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CreditCardSlider(
            _creditCards,
          initialCard: 1,
          onCardClicked: (int index) {
            print('Clicked at index: $index');
          },
        ),
      ),
    );
  }
}

class UniBillScreen extends StatefulWidget {
  @override
  _UniBillScreenState createState() => _UniBillScreenState();
}

class _UniBillScreenState extends State<UniBillScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> myTabs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    myTabs = [
      const Tab(text: 'Payment'),
      const Tab(text: 'Loyality'),
    ];
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

   return Scaffold(
     body: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: TabBar(
                  tabs: myTabs,
                  controller: _tabController,
                ),
              ),
            ),
            Expanded(
              flex: 93,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: TabBarView(controller: _tabController, children: [
                  Center(
                      child: Expanded(
                        child: CreditCardSlider(_creditCards,
                          initialCard: 1,
                          onCardClicked: (int index) {
                          },
                          //List of credit cards),
                        ),
                      )
                  ),
                  const Center(child: Text('Testtt2')),
                ]),
              ),
            )
          ],
        )
    );
  }

  final List<CreditCardWidget> _creditCards = [
    const CreditCardWidget(
        cardNumber: '4106 6900 1046 7531',
        expiryDate: '06/25',
        cardHolderName: 'ZIGA POVHE',
        cvvCode: '000',
        showBackView: false),
    const CreditCardWidget(
        cardNumber: '5273 4689 9296 5788',
        expiryDate: '09/24',
        cardHolderName: 'ZIGA POVHE',
        cvvCode: '721',
        showBackView: false),
    const CreditCardWidget(
        cardNumber: '4748 1900 1035 0245',
        expiryDate: '09/24',
        cardHolderName: 'ZIGA POVHE',
        cvvCode: '721',
        showBackView: false)
  ];
}





