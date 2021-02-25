library credit_card_slider;

import 'dart:math';

import 'package:credit_card/credit_card_widget.dart';
import 'package:flutter/material.dart';

typedef OnCardClicked = void Function(int index);

enum RepeatCards { down, bothDirection, none }

///[initialCard] is 0 based index
///[repeatCards] can have 3 values - [RepeatCards.none], [RepeatCards.down] or [RepeatCards.bothDirection]
///Use [RepeatCards.bothDirection] for repeating cards on both sides
///Use [RepeatCards.down] for repeating cards only down
class CreditCardSlider extends StatelessWidget {
  PageController? _pageController;

  final List<CreditCardWidget> creditCards;
  final double percentOfUpperCard;
  final OnCardClicked? onCardClicked;
  final RepeatCards repeatCards;
  int initialCard;

  CreditCardSlider(
      this.creditCards, {
        this.onCardClicked,
        this.repeatCards = RepeatCards.none,
        this.initialCard = 0,
        this.percentOfUpperCard = 0.35,
      }) {
    assert(initialCard >= 0);
    assert(initialCard < creditCards.length);
    assert(percentOfUpperCard >= 0);
    assert(percentOfUpperCard <= pi / 2);

    if (repeatCards == RepeatCards.bothDirection) {
      initialCard = (creditCards.length * 1000000) + initialCard;
    }
    _pageController = PageController(
      viewportFraction: 0.3,
      initialPage: initialCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (repeatCards == RepeatCards.down ||
        repeatCards == RepeatCards.bothDirection) {
      return PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) => _builder(index, creditCards.length),
      );
    }
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: creditCards.length,
      itemBuilder: (BuildContext context, int index) => _builder(index, creditCards.length),
    );
  }

  AnimatedBuilder _builder(int index, int length) {
    return AnimatedBuilder(
      animation: _pageController!,
      builder: (BuildContext context, Widget? child) {
        return Center(
            child: child,
          );
      },
      child: GestureDetector(
        onTap: () {
          onCardClicked?.call(index % length);
        },
        child: creditCards[index % length],
      ),
    );
  }
}