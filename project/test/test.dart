import 'package:flutter_test/flutter_test.dart';
import 'package:service_package/pkg.dart';

void main() {
  test('adds one to input values', () { // test() provided by flutter_test package, 1st arg is a string, 2nd arg contains test code
    final calculator = Calculator(); // calculator obj
    expect(calculator.addOne(2), 3); // tests 2 + 1
    expect(calculator.addOne(-7), -6); // tests -7 + 1
    expect(calculator.addOne(0), 1); // tests 0 + 1
  }); // expect() checks in input value equals expected value
}