
main() {
  Payment jaib = JaibBank();
  jaib.pay(1000);
}

abstract class Payment {
  void pay(double amount);
}

class JaibBank implements Payment {  
  void pay(double amount) {
    print('$amount paid using Jaib Bank');
  }
}

class Floosakbank implements Payment {
  void pay(double amount) {
    print('$amount paid using Floosak Bank');
  }
}



