import 'package:flutter/material.dart';

List<String> fNameList = [];
List<String> lNameList = [];
List<String> mNameList = [];
List<int> ssnNumberList = [];
List<DateTime> d = [];

int? length1;

List<String> monthNames = [
  "jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];
int count = 1;
int baggageCount = 1;
int baggagePrice = 0;

List<String> passengerType = ['guest', 'business'];
String currentPassenger = passengerType[0];
DateTimeRange dateRange = DateTimeRange(start: dateTime, end: dateTime);

DateTime dateTime =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

String? fromName;
String? toName;
List<String> flightName = [
  'Abha',
  'Al Baha',
  'AlUla',
  'Arar',
  'Bisha',
  'Dammam',
  'Dawadmi',
  'Gassim',
  'Gizan',
  'Gurayat',
  'Hail',
  'Hofuf',
  'Jeddah',
  'Jouf',
  'Madinah',
  'Nejran',
  'Neom',
  'Qaisumah',
  'Rafha',
  'Riyadh',
  'Sharurah',
  'Tabuk',
  'Taif',
  'Turaif',
  'Wadi Al Dawaser',
  'Wedjh',
  'Yanbu Al Bahr'
];
final From = TextEditingController();

late double price; //will be initialized after calculating each ticket price
