import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'credit_card_model.dart';
import 'credit_card_widget.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key? key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    required this.formKey,
    this.cvvValidationMessage = 'Please input a valid CVV',
    this.dateValidationMessage = 'Please input a valid date',
    this.numberValidationMessage = 'Please input a valid number',
    required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String? cardNumber;
  final String? expiryDate;
  final String? cardHolderName;
  final String? cvvCode;
  final String? cvvValidationMessage;
  final String? dateValidationMessage;
  final String? numberValidationMessage;
  final void Function(CreditCardModel?) onCreditCardModelChange;
  final Color? themeColor;
  final Color textColor;
  final Color? cursorColor;
  final GlobalKey<FormState> formKey;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String? cardNumber;
  String? expiryDate;
  String? cardHolderName;
  String? cvvCode;
  bool isCvvFocused = false;
  Color? themeColor;

  late void Function(CreditCardModel?) onCreditCardModelChange;
  CreditCardModel? creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000 000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '000');

  FocusNode cardNumberNode = FocusNode();
  FocusNode cvvFocusNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();
  FocusNode cardHolderNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel!.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel!.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel!.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel!.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel!.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor!.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        key: widget.formKey,
        child: AutofillGroup(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: TextFormField(
                  controller: _cardNumberController,
                  autofillHints: const <String> [AutofillHints.creditCardNumber],
                  cursorColor: widget.cursorColor ?? themeColor,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(expiryDateNode);
                  },
                  style: TextStyle(
                    color: widget.textColor,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Card number',
                    hintText: 'xxxx xxxx xxxx xxxx',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (String? value) {
                    // Validate less that 13 digits +3 white spaces
                    if (value!.isEmpty || value.length < 19) {
                      return widget.numberValidationMessage;
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                      child: TextFormField(
                        controller: _expiryDateController,
                        autofillHints: const <String> [AutofillHints.creditCardExpirationDate],
                        cursorColor: widget.cursorColor ?? themeColor,
                        style: TextStyle(
                          color: widget.textColor,
                        ),
                        focusNode: expiryDateNode,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(cvvFocusNode);
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Expired Date',
                            hintText: 'MM/YY'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return widget.dateValidationMessage;
                          }

                          final DateTime now = DateTime.now();
                          final List<String> date = value.split(RegExp(r'/'));
                          final int month = int.parse(date.first);
                          final int year = int.parse('20${date.last}');
                          final DateTime cardDate = DateTime(year, month);

                          if (cardDate.isBefore(now) || month > 12 || month == 0) {
                            return widget.dateValidationMessage;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                      child: TextFormField(
                        focusNode: cvvFocusNode,
                        controller: _cvvCodeController,
                        autofillHints: const <String> [AutofillHints.creditCardSecurityCode],
                        cursorColor: widget.cursorColor ?? themeColor,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(cardHolderNode);
                        },
                        style: TextStyle(
                          color: widget.textColor,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: (String text) {
                          setState(() {
                            cvvCode = text;
                          });
                        },
                        validator: (String? value) {
                          if (value!.isEmpty || value.length < 3) {
                            return widget.cvvValidationMessage;
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: TextFormField(
                  controller: _cardHolderNameController,
                  autofillHints: const <String> [AutofillHints.creditCardGivenName],
                  focusNode: cardHolderNode,
                  cursorColor: widget.cursorColor ?? themeColor,
                  style: TextStyle(
                    color: widget.textColor,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Card Holder',
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    onCreditCardModelChange(creditCardModel);
                  },
                ),
              ),

            ],
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    cvvFocusNode.dispose();
    expiryDateNode.dispose();
    cardHolderNode.dispose();
    cardNumberNode.dispose();
    super.dispose();
  }
}
