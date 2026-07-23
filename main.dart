
main() {
  
}

abstract class Payment {
  void pay(double amount);
}

class JaibBank implements Payment {  
  void pay(double amount) {
    print('$amount paid using Jaib Bank');
  }
}



