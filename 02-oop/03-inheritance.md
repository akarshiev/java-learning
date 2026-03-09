# 03 - Inheritance (Meros olish)

## Inheritance nima?

**Inheritance** (Meros olish) - bu bir klassning boshqa klassning xususiyatlarini va xatti-harakatlarini meros olishi. Bu OOP ning asosiy ustunlaridan biri bo'lib, **kodni qayta foydalanish** (code reusability) imkonini beradi.

### Asosiy tushunchalar:
- **Superclass** (Parent class, Base class) - meros beruvchi klass
- **Subclass** (Child class, Derived class) - meros oluvchi klass
- **Extends** kalit so'zi - meros olishni bildiradi

---

## Inheritance Turlari

### 1. Single Inheritance (Yagona meros)
Bir subclass faqat bitta superclass'dan meros oladi.

```java
// Superclass
class Animal {
    String name;

    void makeSound() {
        System.out.println("Animal makes sound");
    }
}

// Subclass
class Cat extends Animal {
    void meow() {
        System.out.println("Meow meow!");
    }
}

// Test
public class SingleInheritance {
    public static void main(String[] args) {
        Cat cat = new Cat();
        cat.name = "Whiskers";
        cat.makeSound();  // Inherited method
        cat.meow();       // Own method
    }
}
```

### 2. Multilevel Inheritance (Ko'p darajali meros)
Zanjir shaklida meros olish.

```java
// Level 1: Superclass
class Transport {
    String type;
    
    void move() {
        System.out.println("Transport is moving");
    }
}

// Level 2: Subclass
class Car extends Transport {
    String model;
    
    void honk() {
        System.out.println("Beep beep!");
    }
}

// Level 3: Sub-subclass
class Sedan extends Car {
    int seats;
    
    void useAC() {
        System.out.println("AC is running");
    }
}

// Test
public class MultilevelInheritance {
    public static void main(String[] args) {
        Sedan car = new Sedan();
        car.type = "Sedan";          // From Transport
        car.model = "Malibu";        // From Car
        car.seats = 5;               // Own field
        
        car.move();      // From Transport
        car.honk();      // From Car
        car.useAC();     // Own method
    }
}
```

### 3. Hierarchical Inheritance (Ierarxik meros)
Bir superclass'dan bir nechta subclass'lar meros oladi.

```java
// Superclass
class Person {
    String name;
    int age;
    
    void greet() {
        System.out.println("Hello, I am " + name);
    }
}

// Subclass 1
class Student extends Person {
    String university;
    String major;
    
    void study() {
        System.out.println(name + " is studying");
    }
}

// Subclass 2
class Teacher extends Person {
    String subject;
    int experience;
    
    void teach() {
        System.out.println(name + " teaches " + subject);
    }
}

// Subclass 3
class Employee extends Person {
    String position;
    double salary;
    
    void work() {
        System.out.println(name + " is working");
    }
}

// Test
public class HierarchicalInheritance {
    public static void main(String[] args) {
        Student student = new Student();
        student.name = "Alice";
        student.university = "MIT";
        student.greet();  // From Person
        student.study();  // Own method
        
        Teacher teacher = new Teacher();
        teacher.name = "Bob";
        teacher.subject = "Math";
        teacher.greet();  // From Person
        teacher.teach();  // Own method
    }
}
```

### 4. Multiple Inheritance (Ko'p meros) - Java'da MAVJUD EMAS!
Bir subclass bir nechta superclass'lardan meros olishi.

```java
// Java'da BU ISHLAMAYDI!
class A {
    void methodA() { System.out.println("A"); }
}

class B {
    void methodB() { System.out.println("B"); }
}

// ERROR: Cannot extend multiple classes
class C extends A, B {  // COMPILE ERROR!
    void methodC() { System.out.println("C"); }
}
```

### Nega Java Multiple Inheritance'ni qo'llab-quvvatlamaydi?
**Diamond Problem** (Olmos muammosi):

```
       Class A
       /      \
      /        \
  Class B    Class C
      \        /
       \      /
       Class D
```

Agar A class'da `display()` metodi bo'lsa, B va C uni override qilsa, D qaysi `display()` ni meros olishini bilmaydi.

### 5. Hybrid Inheritance (Aralash meros) - Java'da MAVJUD EMAS!
Bir nechta inheritance turlarining aralashmasi.

---

## Java'da Multiple Inheritance ning Muqobili - Interface

```java
// Interfaces
interface Predator {
    void hunt();
}

interface Flyer {
    void fly();
}

// Class can implement multiple interfaces
class Eagle implements Predator, Flyer {
    public void hunt() {
        System.out.println("Eagle is hunting");
    }
    
    public void fly() {
        System.out.println("Eagle is flying");
    }
}

public class InterfaceExample {
    public static void main(String[] args) {
        Eagle eagle = new Eagle();
        eagle.hunt();
        eagle.fly();
    }
}
```

---

## `super` Kalit So'zi

`super` kalit so'zi subclass ichida superclass ga murojaat qilish uchun ishlatiladi.

### 1. Superclass Konstruktorini Chaqirish:
```java
class Animal {
    String type;
    
    Animal(String type) {
        this.type = type;
        System.out.println("Animal constructor called");
    }
}

class Dog extends Animal {
    String breed;
    
    Dog(String type, String breed) {
        super(type);  // Call superclass constructor
        this.breed = breed;
        System.out.println("Dog constructor called");
    }
}

public class SuperExample {
    public static void main(String[] args) {
        Dog dog = new Dog("Mammal", "German Shepherd");
        System.out.println("Type: " + dog.type);
        System.out.println("Breed: " + dog.breed);
    }
}
```

### 2. Superclass Metodini Chaqirish:
```java
class Parent {
    void greet() {
        System.out.println("Parent: Hello!");
    }
}

class Child extends Parent {
    @Override
    void greet() {
        super.greet();  // Call parent class method
        System.out.println("Child: Hello to you too!");
    }
}

public class SuperMethod {
    public static void main(String[] args) {
        Child child = new Child();
        child.greet();
        // Output:
        // Parent: Hello!
        // Child: Hello to you too!
    }
}
```

### 3. Superclass Field'iga Murojaat:
```java
class Parent {
    String name = "Parent";
}

class Child extends Parent {
    String name = "Child";
    
    void printNames() {
        System.out.println("Parent name: " + super.name);  // Parent class field
        System.out.println("Child name: " + this.name);    // Child class field
    }
}

public class SuperField {
    public static void main(String[] args) {
        Child child = new Child();
        child.printNames();
    }
}
```

---

## Object Class - Barcha Class'larning Superclass'i

Java-da **har bir class** `Object` class'dan meros oladi, hatto `extends` yozilmagan bo'lsa ham.

```java
public class ObjectClassExample {
    public static void main(String[] args) {
        // Every class inherits from Object
        String str = "Hello";
        Integer num = 123;
        ObjectClassExample obj = new ObjectClassExample();
        
        // Object class methods
        System.out.println(str.toString());     // From Object
        System.out.println(str.hashCode());     // From Object
        System.out.println(str.getClass());     // From Object
        System.out.println(str.equals("Hello")); // From Object
    }
    
    @Override
    public String toString() {
        return "This is my custom toString method";
    }
    
    @Override
    public boolean equals(Object obj) {
        // Our own equals method
        return this == obj;
    }
}
```

### `equals()` vs `==`:
```java
public class EqualsExample {
    public static void main(String[] args) {
        String str1 = new String("Java");
        String str2 = new String("Java");
        
        System.out.println(str1 == str2);      // false (reference comparison)
        System.out.println(str1.equals(str2)); // true  (content comparison)
        
        Integer a = 100;
        Integer b = 100;
        
        System.out.println(a == b);           // true (Integer pool)
        
        Integer c = 1000;
        Integer d = 1000;
        
        System.out.println(c == d);           // false
        System.out.println(c.equals(d));      // true
    }
}
```

---

## Access Modifiers (Kirish Modifikatorlari)

### 1. Public
```java
package package1;

public class ClassA {
    public int publicField = 1;
    
    public void publicMethod() {
        System.out.println("Public method");
    }
}
```

```java
package package2;

import package1.ClassA;

public class ClassB {
    public static void main(String[] args) {
        ClassA obj = new ClassA();
        obj.publicField = 10;      // ✅ Allowed
        obj.publicMethod();        // ✅ Allowed
    }
}
```

### 2. Protected
```java
package package1;

public class ClassA {
    protected int protectedField = 2;
    
    protected void protectedMethod() {
        System.out.println("Protected method");
    }
}
```

```java
package package1;

public class ClassB extends ClassA {
    public void test() {
        protectedField = 20;      // ✅ Allowed (same package)
        protectedMethod();        // ✅ Allowed (same package)
    }
}
```

```java
package package2;

import package1.ClassA;

public class ClassC extends ClassA {
    public void test() {
        protectedField = 30;      // ✅ Allowed (subclass)
        protectedMethod();        // ✅ Allowed (subclass)
    }
}

public class ClassD {
    public void test() {
        ClassA obj = new ClassA();
        // obj.protectedField = 40;  // ❌ Not allowed
        // obj.protectedMethod();    // ❌ Not allowed
    }
}
```

### 3. Default (Package-private)
```java
package package1;

class ClassA {  // Default access (package-private)
    int defaultField = 3;
    
    void defaultMethod() {
        System.out.println("Default method");
    }
}

public class ClassB {
    public void test() {
        ClassA obj = new ClassA();
        obj.defaultField = 30;    // ✅ Allowed (same package)
        obj.defaultMethod();      // ✅ Allowed (same package)
    }
}
```

```java
package package2;

// import package1.ClassA;  // ❌ Cannot import, ClassA is default

public class ClassC {
    public void test() {
        // ClassA obj = new ClassA();  // ❌ Not visible
    }
}
```

### 4. Private
```java
public class ClassA {
    private int privateField = 4;
    
    private void privateMethod() {
        System.out.println("Private method");
    }
    
    public void publicMethod() {
        privateField = 40;        // ✅ Allowed (same class)
        privateMethod();          // ✅ Allowed (same class)
    }
}

public class ClassB {
    public void test() {
        ClassA obj = new ClassA();
        // obj.privateField = 50;  // ❌ Not allowed
        // obj.privateMethod();    // ❌ Not allowed
    }
}
```

---

## Relationships (O'zaro Bog'liqliklar)

### 1. IS-A Relationship (Inheritance)
```java
// Car IS-A Vehicle
class Vehicle { }
class Car extends Vehicle { }  // IS-A relationship

// Test
Car car = new Car();
System.out.println(car instanceof Vehicle);  // true
```

### 2. HAS-A Relationship (Association)
Bir class boshqa class'ning obyektiga ega.

#### a) Aggregation (Kuchsiz bog'lanish)
```java
class Department {
    String name;
    
    Department(String name) {
        this.name = name;
    }
}

class University {
    String name;
    Department department;  // HAS-A relationship (Aggregation)
    
    University(String name, Department department) {
        this.name = name;
        this.department = department;
    }
    
    void display() {
        System.out.println(name + " University, " + department.name + " Department");
    }
}

// Test
public class AggregationExample {
    public static void main(String[] args) {
        Department mathDept = new Department("Mathematics");
        University university = new University("MIT", mathDept);
        
        university.display();
        
        // University can be destroyed, but Department can still exist
        university = null;
        System.out.println(mathDept.name);  // Still exists
    }
}
```

#### b) Composition (Kuchli bog'lanish)
```java
class Heart {
    void beat() {
        System.out.println("Heart is beating...");
    }
}

class Human {
    private Heart heart;  // HAS-A relationship (Composition)
    
    Human() {
        heart = new Heart();  // Composition: Heart created when Human is created
    }
    
    void live() {
        heart.beat();
        System.out.println("Human is living...");
    }
}

// Test
public class CompositionExample {
    public static void main(String[] args) {
        Human human = new Human();
        human.live();
        
        // If Human is destroyed, Heart is also destroyed
        // Heart cannot exist independently
    }
}
```

### 3. Uses-A Relationship
Bir class boshqa class'ning metodidan foydalanadi.

```java
class Printer {
    void print(String document) {
        System.out.println("Printing: " + document);
    }
}

class Computer {
    void use(Printer printer, String document) {
        printer.print(document);  // Uses-A relationship
    }
}

// Test
public class UsesAExample {
    public static void main(String[] args) {
        Computer computer = new Computer();
        Printer printer = new Printer();
        
        computer.use(printer, "My Document");
    }
}
```

---

## Amaliy Misol: Bank Tizimi

```java
// Base class
class BankAccount {
    private String accountNumber;
    protected double balance;  // Protected: subclasses can access
    
    public BankAccount(String accountNumber, double initialBalance) {
        this.accountNumber = accountNumber;
        this.balance = initialBalance;
    }
    
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println(amount + " added. New balance: " + balance);
        }
    }
    
    public boolean withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            System.out.println(amount + " withdrawn. New balance: " + balance);
            return true;
        }
        System.out.println("Withdrawal failed!");
        return false;
    }
    
    public double getBalance() {
        return balance;
    }
    
    public String getAccountNumber() {
        return accountNumber;
    }
}

// Subclass 1: Checking account
class CheckingAccount extends BankAccount {
    private double overdraftLimit;
    
    public CheckingAccount(String accountNumber, double initialBalance, double overdraftLimit) {
        super(accountNumber, initialBalance);  // Call superclass constructor
        this.overdraftLimit = overdraftLimit;
    }
    
    @Override
    public boolean withdraw(double amount) {
        if (amount > 0 && amount <= (balance + overdraftLimit)) {
            balance -= amount;
            System.out.println(amount + " withdrawn. New balance: " + balance);
            return true;
        }
        System.out.println("Withdrawal failed! Exceeded limit.");
        return false;
    }
    
    public void displayInfo() {
        System.out.println("Account Number: " + getAccountNumber());
        System.out.println("Balance: " + balance);
        System.out.println("Overdraft Limit: " + overdraftLimit);
    }
}

// Subclass 2: Savings account
class SavingsAccount extends BankAccount {
    private double interestRate;
    
    public SavingsAccount(String accountNumber, double initialBalance, double interestRate) {
        super(accountNumber, initialBalance);
        this.interestRate = interestRate;
    }
    
    public void addInterest() {
        double interest = balance * interestRate / 100;
        balance += interest;
        System.out.println("Interest added: " + interest + ". New balance: " + balance);
    }
    
    @Override
    public void deposit(double amount) {
        super.deposit(amount);  // Call superclass method
        if (amount > 100000) {
            System.out.println("Large deposit made, bank manager will contact you.");
        }
    }
}

// Test
public class BankSystem {
    public static void main(String[] args) {
        // Checking account test
        CheckingAccount checking = new CheckingAccount("123456", 1000000, 500000);
        checking.displayInfo();
        checking.withdraw(1200000);  // Using overdraft
        checking.withdraw(1500000);  // Exceeds limit
        
        // Savings account test
        SavingsAccount savings = new SavingsAccount("789012", 5000000, 5.0);
        savings.deposit(200000);
        savings.addInterest();
        System.out.println("Savings balance: " + savings.getBalance());
        
        // Polymorphism example
        BankAccount account = new CheckingAccount("111222", 100000, 200000);
        account.deposit(50000);
        account.withdraw(250000);  // Calls overridden method from CheckingAccount
    }
}
```

---

## O'z-o'zini Tekshirish

### Savol 1: Quyidagi kod nimani chiqaradi?
```java
class A {
    A() { System.out.print("A "); }
}

class B extends A {
    B() { System.out.print("B "); }
}

class C extends B {
    C() { System.out.print("C "); }
}

public class Test {
    public static void main(String[] args) {
        new C();
    }
}
```

### Savol 2: Quyidagi kodda xato bormi?
```java
class Parent {
    private void display() {
        System.out.println("Parent");
    }
}

class Child extends Parent {
    public void display() {
        System.out.println("Child");
    }
}
```

### Savol 3: Aggregation va Composition farqi nimada?

---

## Keyingi Mavzu: [04 - Polymorphism (Ko'p shakllilik)](./04_Polymorphism.md)
**[Mundarijaga qaytish](../README.md)**

> ⚡️ **Eslatma:** Inheritance - bu kuchli vosita, lekin uni haddan tashqari ishlatmaslik kerak. "Favor composition over inheritance" - Inheritance ustidan Composition'ni afzal ko'ring.