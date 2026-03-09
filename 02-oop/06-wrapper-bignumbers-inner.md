# 06 - Wrapper Classes, Big Numbers, Inner Classes

## Wrapper Classes

### Wrapper Class nima?
**Wrapper Class** - primitive data type'ni object ga o'rab oladigan class. U primitive value'ni object'ga va object'ni primitive'ga convert qilish imkonini beradi.

| Primitive Type | Wrapper Class | Package |
|----------------|---------------|---------|
| `byte` | `Byte` | `java.lang.Byte` |
| `short` | `Short` | `java.lang.Short` |
| `int` | `Integer` | `java.lang.Integer` |
| `long` | `Long` | `java.lang.Long` |
| `float` | `Float` | `java.lang.Float` |
| `double` | `Double` | `java.lang.Double` |
| `char` | `Character` | `java.lang.Character` |
| `boolean` | `Boolean` | `java.lang.Boolean` |

### Number Class
`Number` - bu abstract class bo'lib, `Byte`, `Short`, `Integer`, `Long`, `Float`, `Double` class'larining superclass'i hisoblanadi.

### Wrapper Class Misollari:

```java
public class WrapperClassExample {
    public static void main(String[] args) {
        // Creating wrapper objects
        Integer intObj = Integer.valueOf(100);
        Double doubleObj = Double.valueOf(99.99);
        Character charObj = Character.valueOf('A');
        Boolean boolObj = Boolean.valueOf(true);
        
        // Getting primitive values
        int intValue = intObj.intValue();
        double doubleValue = doubleObj.doubleValue();
        char charValue = charObj.charValue();
        boolean boolValue = boolObj.booleanValue();
        
        System.out.println("Integer: " + intValue);
        System.out.println("Double: " + doubleValue);
        System.out.println("Character: " + charValue);
        System.out.println("Boolean: " + boolValue);
        
        // Useful methods
        System.out.println("\n=== Useful Methods ===");
        
        // Integer methods
        System.out.println("Integer.MAX_VALUE: " + Integer.MAX_VALUE);
        System.out.println("Integer.MIN_VALUE: " + Integer.MIN_VALUE);
        System.out.println("Integer.parseInt(\"123\"): " + Integer.parseInt("123"));
        System.out.println("Integer.toBinaryString(10): " + Integer.toBinaryString(10));
        System.out.println("Integer.toHexString(255): " + Integer.toHexString(255));
        
        // Character methods
        System.out.println("\nCharacter.isDigit('5'): " + Character.isDigit('5'));
        System.out.println("Character.isLetter('A'): " + Character.isLetter('A'));
        System.out.println("Character.isUpperCase('A'): " + Character.isUpperCase('A'));
        System.out.println("Character.toLowerCase('A'): " + Character.toLowerCase('A'));
        
        // Boolean methods
        System.out.println("\nBoolean.TRUE: " + Boolean.TRUE);
        System.out.println("Boolean.FALSE: " + Boolean.FALSE);
        System.out.println("Boolean.parseBoolean(\"true\"): " + Boolean.parseBoolean("true"));
        
        // Compare objects
        Integer a = 100;
        Integer b = 100;
        Integer c = 200;
        Integer d = 200;
        
        System.out.println("\n=== Integer Cache ===");
        System.out.println("a == b (100 == 100): " + (a == b));  // true (cache)
        System.out.println("c == d (200 == 200): " + (c == d));  // false (not cached)
        System.out.println("a.equals(b): " + a.equals(b));      // true
        System.out.println("c.equals(d): " + c.equals(d));      // true
    }
}
```

---

## Auto-boxing va Auto-unboxing

### Auto-boxing nima?
**Auto-boxing** - primitive type'ni avtomatik ravishda wrapper object'ga o'rab olish.

### Auto-unboxing nima?
**Auto-unboxing** - wrapper object'dan primitive value'ni avtomatik ravishda olish.

```java
public class AutoBoxingExample {
    public static void main(String[] args) {
        // Auto-boxing: primitive -> wrapper
        Integer intObj = 100;           // Auto-boxing: int -> Integer
        Double doubleObj = 99.99;       // Auto-boxing: double -> Double
        Character charObj = 'A';        // Auto-boxing: char -> Character
        Boolean boolObj = true;         // Auto-boxing: boolean -> Boolean
        
        // Auto-unboxing: wrapper -> primitive
        int intValue = intObj;          // Auto-unboxing: Integer -> int
        double doubleValue = doubleObj; // Auto-unboxing: Double -> double
        char charValue = charObj;       // Auto-unboxing: Character -> char
        boolean boolValue = boolObj;    // Auto-unboxing: Boolean -> boolean
        
        // Arithmetic operations with auto-unboxing
        Integer num1 = 10;
        Integer num2 = 20;
        int sum = num1 + num2;          // Auto-unboxing + arithmetic
        System.out.println("Sum: " + sum);  // 30
        
        // Collections with auto-boxing
        java.util.ArrayList<Integer> list = new java.util.ArrayList<>();
        list.add(1);   // Auto-boxing: int -> Integer
        list.add(2);
        list.add(3);
        
        int first = list.get(0);  // Auto-unboxing: Integer -> int
        System.out.println("First element: " + first);
        
        // Method parameters
        printNumber(42);  // Auto-boxing: int -> Integer
    }
    
    public static void printNumber(Integer num) {
        System.out.println("Number: " + num);
    }
}
```

---

## Big Numbers (BigInteger va BigDecimal)

### BigInteger
`BigInteger` - cheksiz hajmdagi butun sonlar bilan ishlash uchun.

### BigDecimal
`BigDecimal` - yuqori aniq'likdagi o'nlik sonlar bilan ishlash uchun.

```java
import java.math.BigInteger;
import java.math.BigDecimal;
import java.math.RoundingMode;

public class BigNumberExample {
    public static void main(String[] args) {
        System.out.println("=== BIGINTEGER EXAMPLES ===");
        
        // Creating BigInteger
        BigInteger bigInt1 = new BigInteger("123456789012345678901234567890");
        BigInteger bigInt2 = new BigInteger("987654321098765432109876543210");
        
        // Arithmetic operations
        BigInteger sum = bigInt1.add(bigInt2);
        BigInteger difference = bigInt1.subtract(bigInt2);
        BigInteger product = bigInt1.multiply(bigInt2);
        BigInteger quotient = bigInt2.divide(bigInt1);
        BigInteger remainder = bigInt2.remainder(bigInt1);
        
        System.out.println("BigInt1: " + bigInt1);
        System.out.println("BigInt2: " + bigInt2);
        System.out.println("Sum: " + sum);
        System.out.println("Difference: " + difference);
        System.out.println("Product: " + product);
        System.out.println("Quotient: " + quotient);
        System.out.println("Remainder: " + remainder);
        
        // Other operations
        System.out.println("\nPower: " + bigInt1.pow(3));
        System.out.println("GCD: " + bigInt1.gcd(bigInt2));
        System.out.println("Is Probable Prime: " + bigInt1.isProbablePrime(100));
        
        // Factorial using BigInteger
        System.out.println("\nFactorial of 50: " + factorial(50));
        
        System.out.println("\n=== BIGDECIMAL EXAMPLES ===");
        
        // Creating BigDecimal
        BigDecimal decimal1 = new BigDecimal("1234567890.12345678901234567890");
        BigDecimal decimal2 = new BigDecimal("9876543210.98765432109876543210");
        
        // Arithmetic operations
        BigDecimal decimalSum = decimal1.add(decimal2);
        BigDecimal decimalProduct = decimal1.multiply(decimal2);
        
        // Division with precision
        BigDecimal division = decimal2.divide(decimal1, 10, RoundingMode.HALF_UP);
        
        System.out.println("Decimal1: " + decimal1);
        System.out.println("Decimal2: " + decimal2);
        System.out.println("Sum: " + decimalSum);
        System.out.println("Product: " + decimalProduct);
        System.out.println("Division: " + division);
        
        // Financial calculations
        BigDecimal price = new BigDecimal("99.99");
        BigDecimal quantity = new BigDecimal("100");
        BigDecimal discount = new BigDecimal("0.10"); // 10%
        
        BigDecimal total = price.multiply(quantity);
        BigDecimal discountAmount = total.multiply(discount);
        BigDecimal finalAmount = total.subtract(discountAmount);
        
        System.out.println("\n=== FINANCIAL CALCULATION ===");
        System.out.println("Price: $" + price);
        System.out.println("Quantity: " + quantity);
        System.out.println("Total: $" + total);
        System.out.println("Discount: $" + discountAmount);
        System.out.println("Final Amount: $" + finalAmount.setScale(2, RoundingMode.HALF_UP));
        
        // Compare BigDecimal (use compareTo, not equals)
        BigDecimal a = new BigDecimal("1.0");
        BigDecimal b = new BigDecimal("1.00");
        System.out.println("\na.equals(b): " + a.equals(b));        // false (scale different)
        System.out.println("a.compareTo(b): " + a.compareTo(b));    // 0 (equal value)
    }
    
    // Factorial using BigInteger
    public static BigInteger factorial(int n) {
        BigInteger result = BigInteger.ONE;
        for (int i = 2; i <= n; i++) {
            result = result.multiply(BigInteger.valueOf(i));
        }
        return result;
    }
}
```

---

## Type Casting (Tur O'zgartirish)

### Widening Casting (Avtomatik)
Kichik turdan katta turga avtomatik o'tkaziladi:
```
byte -> short -> int -> long -> float -> double
```

```java
public class WideningExample {
    public static void main(String[] args) {
        byte b = 100;
        short s = b;      // byte -> short
        int i = s;        // short -> int
        long l = i;       // int -> long
        float f = l;      // long -> float
        double d = f;     // float -> double
        
        System.out.println("byte: " + b);
        System.out.println("short: " + s);
        System.out.println("int: " + i);
        System.out.println("long: " + l);
        System.out.println("float: " + f);
        System.out.println("double: " + d);
        
        char c = 'A';
        int charToInt = c;  // char -> int
        System.out.println("\nChar 'A' to int: " + charToInt);  // 65
    }
}
```

### Narrowing Casting (Qo'lda)
Katta turdan kichik turga qo'lda o'tkazish kerak:
```
double -> float -> long -> int -> char -> short -> byte
```

```java
public class NarrowingExample {
    public static void main(String[] args) {
        double d = 100.99;
        float f = (float) d;   // double -> float
        long l = (long) f;     // float -> long
        int i = (int) l;       // long -> int
        char c = (char) i;     // int -> char
        short s = (short) c;   // char -> short
        byte b = (byte) s;     // short -> byte
        
        System.out.println("Original double: " + d);
        System.out.println("To float: " + f);
        System.out.println("To long: " + l);
        System.out.println("To int: " + i);
        System.out.println("To char: " + c);
        System.out.println("To short: " + s);
        System.out.println("To byte: " + b);
        
        // Data loss example
        double bigNumber = 123456.789;
        int smallNumber = (int) bigNumber;
        System.out.println("\nBig number: " + bigNumber);
        System.out.println("After narrowing to int: " + smallNumber);  // 123456 (decimal part lost)
        
        // Overflow example
        int largeInt = 1000;
        byte smallByte = (byte) largeInt;
        System.out.println("\nLarge int: " + largeInt);
        System.out.println("After narrowing to byte: " + smallByte);  // -24 (overflow!)
    }
}
```

---

## Inner Classes (Ichki Class'lar)

### 1. Normal (Non-static) Inner Class

```java
public class OuterClass {
    private String outerField = "Outer field";
    private static String staticOuterField = "Static outer field";
    
    // Normal inner class
    class InnerClass {
        private String innerField = "Inner field";
        
        public void display() {
            // Can access outer class fields (even private)
            System.out.println("Accessing outer field: " + outerField);
            System.out.println("Accessing static outer field: " + staticOuterField);
            System.out.println("Inner field: " + innerField);
        }
        
        // Inner class can have static members (Java 16+)
        static void staticMethod() {
            System.out.println("Static method in inner class");
        }
    }
    
    public void createInner() {
        // Create inner class instance
        InnerClass inner = new InnerClass();
        inner.display();
    }
    
    public static void main(String[] args) {
        // To create inner class instance, need outer class instance
        OuterClass outer = new OuterClass();
        OuterClass.InnerClass inner = outer.new InnerClass();
        inner.display();
        
        // Or in one line
        OuterClass.InnerClass inner2 = new OuterClass().new InnerClass();
        inner2.display();
        
        // Call outer method that creates inner class
        outer.createInner();
    }
}
```

### 2. Method Local Inner Class

```java
public class MethodLocalClass {
    private String outerField = "Outer field";
    
    public void outerMethod() {
        final String localVariable = "Local variable";
        String effectivelyFinal = "Effectively final";  // Not reassigned, so effectively final
        
        // Method local inner class
        class LocalInnerClass {
            public void display() {
                System.out.println("Accessing outer field: " + outerField);
                System.out.println("Accessing local variable: " + localVariable);
                System.out.println("Accessing effectively final: " + effectivelyFinal);
                
                // Cannot access non-final local variables
                // String nonFinal = "Test";
                // System.out.println(nonFinal);  // OK, but can't modify outer non-final
            }
        }
        
        // Create and use local inner class
        LocalInnerClass local = new LocalInnerClass();
        local.display();
        
        // Can't create local inner class outside the method
    }
    
    public void anotherMethod() {
        // LocalInnerClass local;  // ERROR: Not visible here
    }
    
    public static void main(String[] args) {
        MethodLocalClass obj = new MethodLocalClass();
        obj.outerMethod();
    }
}
```

### 3. Static Nested Class

```java
public class OuterClassWithStatic {
    private String instanceField = "Instance field";
    private static String staticField = "Static field";
    
    // Static nested class
    static class StaticNestedClass {
        private String nestedField = "Nested field";
        
        public void display() {
            // Can access only static members of outer class
            System.out.println("Static outer field: " + staticField);
            // System.out.println(instanceField);  // ERROR: Cannot access non-static
            
            System.out.println("Nested field: " + nestedField);
        }
        
        public static void staticDisplay() {
            System.out.println("Static method in static nested class");
        }
    }
    
    // Inner class for comparison
    class InnerClass {
        public void display() {
            System.out.println("Can access both: " + instanceField + " and " + staticField);
        }
    }
    
    public static void main(String[] args) {
        // Create static nested class without outer instance
        StaticNestedClass nested = new StaticNestedClass();
        nested.display();
        StaticNestedClass.staticDisplay();
        
        // Compare with inner class
        OuterClassWithStatic outer = new OuterClassWithStatic();
        OuterClassWithStatic.InnerClass inner = outer.new InnerClass();
        inner.display();
    }
}
```

### 4. Anonymous Inner Class

```java
interface Greeting {
    void sayHello();
    void sayGoodbye();
}

abstract class Animal {
    abstract void makeSound();
}

public class AnonymousClassExample {
    public static void main(String[] args) {
        // Anonymous class implementing interface
        Greeting greeting = new Greeting() {
            @Override
            public void sayHello() {
                System.out.println("Hello from anonymous class!");
            }
            
            @Override
            public void sayGoodbye() {
                System.out.println("Goodbye from anonymous class!");
            }
            
            // Can add additional methods (but can't call them from outside)
            public void extraMethod() {
                System.out.println("Extra method");
            }
        };
        
        greeting.sayHello();
        greeting.sayGoodbye();
        // greeting.extraMethod();  // ERROR: Not in interface
        
        // Anonymous class extending abstract class
        Animal dog = new Animal() {
            @Override
            void makeSound() {
                System.out.println("Woof woof!");
            }
            
            void wagTail() {
                System.out.println("Tail wagging");
            }
        };
        
        dog.makeSound();
        // dog.wagTail();  // ERROR: Not in Animal class
        
        // Anonymous class as method parameter
        processAnimal(new Animal() {
            @Override
            void makeSound() {
                System.out.println("Meow meow!");
            }
        });
        
        // Lambda alternative (Java 8+)
        Runnable runnable = () -> System.out.println("Running from lambda");
        runnable.run();
    }
    
    public static void processAnimal(Animal animal) {
        animal.makeSound();
    }
}
```

---

## Amaliy Misol: Bank Account System

```java
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

// Outer class
class Bank {
    private String bankName;
    private List<Account> accounts;
    
    public Bank(String bankName) {
        this.bankName = bankName;
        this.accounts = new ArrayList<>();
    }
    
    // Static nested class for transaction
    static class Transaction {
        private String transactionId;
        private BigDecimal amount;
        private String type;  // DEPOSIT, WITHDRAWAL, TRANSFER
        
        public Transaction(String transactionId, BigDecimal amount, String type) {
            this.transactionId = transactionId;
            this.amount = amount;
            this.type = type;
        }
        
        @Override
        public String toString() {
            return "Transaction[" + transactionId + "]: " + type + " $" + amount;
        }
    }
    
    // Inner class for account
    class Account {
        private String accountNumber;
        private String ownerName;
        private BigDecimal balance;
        private List<Transaction> transactions;
        
        // Local class for account summary
        class AccountSummary {
            public void printSummary() {
                System.out.println("\n=== ACCOUNT SUMMARY ===");
                System.out.println("Bank: " + bankName);
                System.out.println("Account: " + accountNumber);
                System.out.println("Owner: " + ownerName);
                System.out.println("Balance: $" + balance.setScale(2, RoundingMode.HALF_UP));
                System.out.println("Transactions: " + transactions.size());
            }
        }
        
        public Account(String accountNumber, String ownerName, BigDecimal initialBalance) {
            this.accountNumber = accountNumber;
            this.ownerName = ownerName;
            this.balance = initialBalance;
            this.transactions = new ArrayList<>();
            accounts.add(this);  // Add to bank's account list
        }
        
        public void deposit(BigDecimal amount) {
            if (amount.compareTo(BigDecimal.ZERO) > 0) {
                balance = balance.add(amount);
                transactions.add(new Transaction(
                    "TXN" + System.currentTimeMillis(),
                    amount,
                    "DEPOSIT"
                ));
                System.out.println("Deposited: $" + amount);
                
                // Method local inner class for receipt
                class Receipt {
                    public void print() {
                        System.out.println("--- RECEIPT ---");
                        System.out.println("Deposit successful");
                        System.out.println("Amount: $" + amount);
                        System.out.println("New balance: $" + balance);
                    }
                }
                
                Receipt receipt = new Receipt();
                receipt.print();
            }
        }
        
        public boolean withdraw(BigDecimal amount) {
            if (amount.compareTo(BigDecimal.ZERO) > 0 && 
                amount.compareTo(balance) <= 0) {
                balance = balance.subtract(amount);
                transactions.add(new Transaction(
                    "TXN" + System.currentTimeMillis(),
                    amount,
                    "WITHDRAWAL"
                ));
                System.out.println("Withdrawn: $" + amount);
                return true;
            }
            System.out.println("Withdrawal failed: Insufficient funds");
            return false;
        }
        
        public void printAccountSummary() {
            AccountSummary summary = new AccountSummary();
            summary.printSummary();
        }
        
        public BigDecimal getBalance() {
            return balance;
        }
    }
    
    // Anonymous class for bank report
    interface BankReport {
        void generate();
    }
    
    public void generateMonthlyReport() {
        BankReport report = new BankReport() {
            @Override
            public void generate() {
                System.out.println("\n=== MONTHLY BANK REPORT ===");
                System.out.println("Bank: " + bankName);
                System.out.println("Total Accounts: " + accounts.size());
                
                BigDecimal totalBalance = BigDecimal.ZERO;
                for (Account account : accounts) {
                    totalBalance = totalBalance.add(account.getBalance());
                }
                System.out.println("Total Assets: $" + totalBalance.setScale(2, RoundingMode.HALF_UP));
                
                // Using BigInteger for account count statistics
                java.math.BigInteger activeAccounts = java.math.BigInteger.ZERO;
                for (Account account : accounts) {
                    if (account.getBalance().compareTo(BigDecimal.ZERO) > 0) {
                        activeAccounts = activeAccounts.add(java.math.BigInteger.ONE);
                    }
                }
                System.out.println("Active Accounts: " + activeAccounts);
            }
        };
        
        report.generate();
    }
}

public class BankSystem {
    public static void main(String[] args) {
        Bank myBank = new Bank("MyBank International");
        
        // Create accounts
        Bank.Account account1 = myBank.new Account("123456", "Alice Smith", 
            new BigDecimal("1000.00"));
        Bank.Account account2 = myBank.new Account("789012", "Bob Johnson", 
            new BigDecimal("5000.00"));
        
        // Perform transactions
        System.out.println("=== TRANSACTIONS ===");
        account1.deposit(new BigDecimal("500.00"));
        account1.withdraw(new BigDecimal("200.00"));
        account2.deposit(new BigDecimal("1000.00"));
        
        // Print account summaries
        account1.printAccountSummary();
        account2.printAccountSummary();
        
        // Generate bank report
        myBank.generateMonthlyReport();
        
        // Demonstrate BigInteger factorial
        System.out.println("\n=== BIGINTEGER FACTORIAL ===");
        java.math.BigInteger factorial = calculateFactorial(30);
        System.out.println("30! = " + factorial);
        
        // Demonstrate BigDecimal precision
        System.out.println("\n=== BIGDECIMAL PRECISION ===");
        BigDecimal preciseCalculation = new BigDecimal("0.1")
            .add(new BigDecimal("0.2"));
        System.out.println("0.1 + 0.2 = " + preciseCalculation);
        System.out.println("Double: " + (0.1 + 0.2));  // Shows floating point error
    }
    
    public static java.math.BigInteger calculateFactorial(int n) {
        java.math.BigInteger result = java.math.BigInteger.ONE;
        for (int i = 2; i <= n; i++) {
            result = result.multiply(java.math.BigInteger.valueOf(i));
        }
        return result;
    }
}
```

---

## O'z-o'zini Tekshirish

### Savol 1: Quyidagi kodda xato bormi?
```java
Integer x = 100;
Integer y = 100;
System.out.println(x == y);  // Nima chiqadi?
```

### Savol 2: Qaysi inner class turi outer class'ning non-static field'lariga access qila olmaydi?

### Savol 3: BigDecimal ni equals() va compareTo() method'lari farqi nimada?

---

## Keyingi Mavzu: [07 - Memory Management (Xotira Boshqaruvi)](07_Memory_Management_1.md)
**[Mundarijaga qaytish](../README.md)**

> ⚡️ **Eslatma:** Wrapper classes primitive va object o'rtasidagi bo'shliqni to'ldiradi. Big numbers murakkab matematik hisob-kitoblar uchun, inner classes esa kodni yaxshi tashkil qilish uchun. Har bir vosita o'z o'rnida muhim!