# 05 - Abstraction va Interface

## Abstraction (Abstraksiya) nima?

**Abstraction** - bu murakkab tafsilotlarni yashirib, faqat zaruriy xususiyatlar va funksiyalarni ko'rsatish. Bu OOP ning asosiy ustunlaridan biri.

### Abstraksiyaning ikki turi Java'da:
1. **Abstract Class** (Mavhum klass) - 0% dan 100% gacha abstraksiya
2. **Interface** (Interfeys) - 100% abstraksiya (Java 8 gacha)

---

## 1. Abstract Class (Mavhum klass)

### Abstract Class nima?
**Abstract class** - obyekt yaratib bo'lmaydigan klass. U mavhum tushunchalarni ifodalash uchun ishlatiladi.

### Xususiyatlari:
1. **`abstract`** kalit so'zi bilan belgilanadi
2. **Obyekt yaratib bo'lmaydi**
3. **Abstract method'lari** bo'lishi mumkin (body'siz methodlar)
4. **Concrete method'lari** bo'lishi mumkin (body'li methodlar)
5. **Field'lar**, **konstruktorlar** bo'lishi mumkin
6. **Ikkinchi nomi**: Partially implemented class (qisman implement qilingan klass)

### Abstract Class Misollari:

#### 1. Oddiy Abstract Class:
```java
// Abstract class - cannot instantiate
abstract class Animal {
    // Field
    String name;
    
    // Constructor - abstract class can have constructors
    public Animal(String name) {
        this.name = name;
    }
    
    // Abstract method - no body
    public abstract void makeSound();
    
    // Concrete method - has body
    public void eat() {
        System.out.println(name + " is eating");
    }
    
    // Another concrete method
    public void sleep() {
        System.out.println(name + " is sleeping");
    }
}

// Concrete class that extends abstract class
class Dog extends Animal {
    public Dog(String name) {
        super(name);  // Call parent constructor
    }
    
    // Must implement abstract method
    @Override
    public void makeSound() {
        System.out.println(name + " says: Woof woof!");
    }
}

class Cat extends Animal {
    public Cat(String name) {
        super(name);
    }
    
    @Override
    public void makeSound() {
        System.out.println(name + " says: Meow meow!");
    }
}

public class AbstractClassExample {
    public static void main(String[] args) {
        // Animal animal = new Animal();  // ERROR: Cannot instantiate abstract class
        
        Dog dog = new Dog("Rex");
        dog.makeSound();  // Rex says: Woof woof!
        dog.eat();        // Rex is eating
        dog.sleep();      // Rex is sleeping
        
        Cat cat = new Cat("Whiskers");
        cat.makeSound();  // Whiskers says: Meow meow!
        cat.eat();        // Whiskers is eating
        
        // Polymorphism with abstract class
        Animal myPet = new Dog("Buddy");
        myPet.makeSound();  // Buddy says: Woof woof!
    }
}
```

#### 2. Abstract Class with Multiple Abstract Methods:
```java
abstract class Shape {
    // Abstract methods
    public abstract double getArea();
    public abstract double getPerimeter();
    public abstract void draw();
    
    // Concrete method
    public void displayInfo() {
        System.out.println("Area: " + getArea());
        System.out.println("Perimeter: " + getPerimeter());
        draw();
    }
}

class Circle extends Shape {
    private double radius;
    
    public Circle(double radius) {
        this.radius = radius;
    }
    
    @Override
    public double getArea() {
        return Math.PI * radius * radius;
    }
    
    @Override
    public double getPerimeter() {
        return 2 * Math.PI * radius;
    }
    
    @Override
    public void draw() {
        System.out.println("Drawing a circle with radius " + radius);
    }
}

class Rectangle extends Shape {
    private double width;
    private double height;
    
    public Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }
    
    @Override
    public double getArea() {
        return width * height;
    }
    
    @Override
    public double getPerimeter() {
        return 2 * (width + height);
    }
    
    @Override
    public void draw() {
        System.out.println("Drawing a rectangle " + width + "x" + height);
    }
}

public class ShapeExample {
    public static void main(String[] args) {
        Shape circle = new Circle(5.0);
        Shape rectangle = new Rectangle(4.0, 6.0);
        
        System.out.println("=== CIRCLE ===");
        circle.displayInfo();
        
        System.out.println("\n=== RECTANGLE ===");
        rectangle.displayInfo();
    }
}
```

#### 3. Abstract Class without Abstract Methods:
```java
// Abstract class can exist without any abstract methods
abstract class Database {
    // No abstract methods
    public void connect() {
        System.out.println("Connecting to database...");
    }
    
    public void disconnect() {
        System.out.println("Disconnecting from database...");
    }
    
    // But still cannot be instantiated
}

class MySQLDatabase extends Database {
    public void query(String sql) {
        System.out.println("Executing MySQL query: " + sql);
    }
}

class MongoDBDatabase extends Database {
    public void find(String collection) {
        System.out.println("Finding in MongoDB collection: " + collection);
    }
}

public class DatabaseExample {
    public static void main(String[] args) {
        // Database db = new Database();  // ERROR
        
        MySQLDatabase mysql = new MySQLDatabase();
        mysql.connect();
        mysql.query("SELECT * FROM users");
        mysql.disconnect();
    }
}
```

---

## 2. Interface (Interfeys)

### Interface nima?
**Interface** - bu faqat method signature'larni o'z ichiga olgan to'liq abstrakt konstruksiya (Java 8 gacha).

### Xususiyatlari (Java 7 va oldin):
1. Barcha method'lar **public abstract** (kalit so'zlari yozilmasa ham)
2. Barcha field'lar **public static final** (konstanta)
3. **Obyekt yaratib bo'lmaydi**
4. **Multiple inheritance** ga yo'l ochadi

### Interface Misollari:

#### 1. Basic Interface:
```java
// Interface definition
interface Animal {
    // All methods are public abstract by default
    void makeSound();
    void eat();
    
    // All fields are public static final by default
    int MAX_AGE = 20;  // public static final int MAX_AGE = 20;
}

// Class implementing interface
class Dog implements Animal {
    private String name;
    
    public Dog(String name) {
        this.name = name;
    }
    
    @Override
    public void makeSound() {
        System.out.println(name + " says: Woof woof!");
    }
    
    @Override
    public void eat() {
        System.out.println(name + " is eating meat");
    }
}

// Multiple interfaces
interface Pet {
    void play();
    void getName();
}

class Cat implements Animal, Pet {  // Multiple inheritance
    private String name;
    
    public Cat(String name) {
        this.name = name;
    }
    
    @Override
    public void makeSound() {
        System.out.println(name + " says: Meow meow!");
    }
    
    @Override
    public void eat() {
        System.out.println(name + " is eating fish");
    }
    
    @Override
    public void play() {
        System.out.println(name + " is playing with a ball");
    }
    
    @Override
    public void getName() {
        System.out.println("Cat's name is: " + name);
    }
}

public class InterfaceExample {
    public static void main(String[] args) {
        Dog dog = new Dog("Rex");
        dog.makeSound();
        dog.eat();
        
        System.out.println("\nMax animal age: " + Animal.MAX_AGE);
        
        Cat cat = new Cat("Whiskers");
        cat.makeSound();
        cat.eat();
        cat.play();
        cat.getName();
        
        // Interface reference
        Animal animal = new Dog("Buddy");
        animal.makeSound();
        // animal.play();  // ERROR: Animal interface doesn't have play()
        
        Pet pet = new Cat("Mittens");
        pet.play();
    }
}
```

#### 2. Interface Inheritance (Extends):
```java
interface Vehicle {
    void start();
    void stop();
}

interface Electric {
    void charge();
    int getBatteryLevel();
}

// Interface can extend multiple interfaces
interface ElectricVehicle extends Vehicle, Electric {
    void ecoMode();
}

class Tesla implements ElectricVehicle {
    private int batteryLevel = 100;
    
    @Override
    public void start() {
        System.out.println("Tesla started silently");
    }
    
    @Override
    public void stop() {
        System.out.println("Tesla stopped");
    }
    
    @Override
    public void charge() {
        batteryLevel = 100;
        System.out.println("Tesla fully charged");
    }
    
    @Override
    public int getBatteryLevel() {
        return batteryLevel;
    }
    
    @Override
    public void ecoMode() {
        System.out.println("Eco mode activated");
    }
}

public class InterfaceInheritance {
    public static void main(String[] args) {
        Tesla tesla = new Tesla();
        tesla.start();
        tesla.ecoMode();
        System.out.println("Battery: " + tesla.getBatteryLevel() + "%");
        tesla.stop();
    }
}
```

---

## Java 8+ Interface Improvements

### 1. Default Methods:
**Sababi:** Interface'ga yangi method qo'shilsa, barcha implement qilgan class'lar crash qiladi (compile error). Default method bu muammoni hal qiladi.

```java
interface Calculator {
    // Abstract method
    int add(int a, int b);
    
    // Default method - has implementation
    default int subtract(int a, int b) {
        return a - b;
    }
    
    // Another default method
    default void displayResult(int result) {
        System.out.println("Result: " + result);
    }
    
    // Static method (Java 8+)
    static void printMessage(String message) {
        System.out.println("Calculator says: " + message);
    }
}

class BasicCalculator implements Calculator {
    @Override
    public int add(int a, int b) {
        return a + b;
    }
    // No need to implement subtract() or displayResult()
}

class AdvancedCalculator implements Calculator {
    @Override
    public int add(int a, int b) {
        return a + b;
    }
    
    // Can override default method
    @Override
    public int subtract(int a, int b) {
        System.out.println("Using advanced subtraction");
        return a - b;
    }
}

public class DefaultMethodExample {
    public static void main(String[] args) {
        BasicCalculator basic = new BasicCalculator();
        System.out.println("5 + 3 = " + basic.add(5, 3));
        System.out.println("5 - 3 = " + basic.subtract(5, 3));  // Uses default method
        
        AdvancedCalculator advanced = new AdvancedCalculator();
        System.out.println("10 - 4 = " + advanced.subtract(10, 4));  // Uses overridden method
        
        // Static method call
        Calculator.printMessage("Hello from interface!");
    }
}
```

### 2. Static Methods in Interface:
Utility method'lar uchun ishlatiladi.

```java
interface MathOperations {
    // Abstract method
    double calculate(double x, double y);
    
    // Static utility methods
    static double add(double a, double b) {
        return a + b;
    }
    
    static double multiply(double a, double b) {
        return a * b;
    }
    
    static double power(double base, double exponent) {
        return Math.pow(base, exponent);
    }
}

class CustomCalculator implements MathOperations {
    @Override
    public double calculate(double x, double y) {
        return MathOperations.add(x, y) * MathOperations.multiply(x, y);
    }
}

public class StaticMethodInterface {
    public static void main(String[] args) {
        CustomCalculator calc = new CustomCalculator();
        double result = calc.calculate(3, 4);
        System.out.println("Result: " + result);
        
        // Direct static method calls
        System.out.println("Static add: " + MathOperations.add(10, 20));
        System.out.println("Static power: " + MathOperations.power(2, 8));
    }
}
```

### 3. Private Methods (Java 9+):
```java
interface DataProcessor {
    default void processData(String data) {
        validate(data);
        clean(data);
        analyze(data);
    }
    
    // Private method - helper method
    private void validate(String data) {
        if (data == null || data.isEmpty()) {
            throw new IllegalArgumentException("Invalid data");
        }
        System.out.println("Data validated");
    }
    
    // Private static method
    private static void clean(String data) {
        System.out.println("Data cleaned: " + data.trim());
    }
    
    // Abstract method
    void analyze(String data);
}

class TextProcessor implements DataProcessor {
    @Override
    public void analyze(String data) {
        System.out.println("Analyzing text: " + data);
    }
}
```

---

## Abstract Class vs Interface Farqlari

| Xususiyat | Abstract Class | Interface |
|-----------|--------------|-----------|
| **Keyword** | `abstract class` | `interface` |
| **Instantiation** | Obyekt yaratib bo'lmaydi | Obyekt yaratib bo'lmaydi |
| **Methods** | Abstract va concrete bo'lishi mumkin | Java 7: Faqat abstract<br>Java 8+: Default, static, private |
| **Fields** | Har qanday access modifier | Faqat `public static final` |
| **Constructors** | Bor | Yo'q |
| **Multiple Inheritance** | Bir class faqat bitta abstract class'dan extends oladi | Bir class bir nechta interface'larni implement qilishi mumkin |
| **Access Modifiers** | Har qanday (public, protected, private, default) | Faqat public (methodlar uchun) |
| **Main Method** | Bo'lishi mumkin | Bo'lishi mumkin (Java 8+) |
| **Speed** | Biroz tezroq | Biroz sekinroq |

---

## Qachon Qaysisidan Foydalanishingiz Kerak?

### Abstract Class tanlang agar:
1. **Umumiy kod** (shared code) bo'lsa
2. **Klass ierarxiyasi** kerak bo'lsa
3. **O'zgaruvchan holat** (state) saqlash kerak bo'lsa
4. **Access modifier** lar farqi kerak bo'lsa
5. **Non-static, non-final field'lar** kerak bo'lsa

```java
// Abstract class example - shared code
abstract class Employee {
    private String name;
    private double baseSalary;
    
    public Employee(String name, double baseSalary) {
        this.name = name;
        this.baseSalary = baseSalary;
    }
    
    // Shared concrete method
    public double calculateBonus() {
        return baseSalary * 0.1;
    }
    
    // Abstract method - different for each employee type
    public abstract double calculateSalary();
    
    // Getters
    public String getName() { return name; }
    public double getBaseSalary() { return baseSalary; }
}

class Developer extends Employee {
    private String programmingLanguage;
    
    public Developer(String name, double baseSalary, String language) {
        super(name, baseSalary);
        this.programmingLanguage = language;
    }
    
    @Override
    public double calculateSalary() {
        return getBaseSalary() + calculateBonus() + 500; // Developer bonus
    }
}

class Manager extends Employee {
    private int teamSize;
    
    public Manager(String name, double baseSalary, int teamSize) {
        super(name, baseSalary);
        this.teamSize = teamSize;
    }
    
    @Override
    public double calculateSalary() {
        return getBaseSalary() + calculateBonus() + (teamSize * 100);
    }
}
```

### Interface tanlang agar:
1. **Standartlashtirish** kerak bo'lsa
2. **Multiple inheritance** kerak bo'lsa
3. **Loose coupling** kerak bo'lsa
4. **API design** uchun
5. **Faqat behavior** (xatti-harakat) ta'riflash kerak bo'lsa

```java
// Interface example - standardization
interface PaymentMethod {
    boolean processPayment(double amount);
    String getProviderName();
}

interface Refundable {
    boolean processRefund(double amount);
}

// Class can implement multiple interfaces
class CreditCardPayment implements PaymentMethod, Refundable {
    private String cardNumber;
    
    public CreditCardPayment(String cardNumber) {
        this.cardNumber = cardNumber;
    }
    
    @Override
    public boolean processPayment(double amount) {
        System.out.println("Processing credit card payment: $" + amount);
        return true;
    }
    
    @Override
    public boolean processRefund(double amount) {
        System.out.println("Processing credit card refund: $" + amount);
        return true;
    }
    
    @Override
    public String getProviderName() {
        return "Visa/MasterCard";
    }
}

class PayPalPayment implements PaymentMethod {
    private String email;
    
    public PayPalPayment(String email) {
        this.email = email;
    }
    
    @Override
    public boolean processPayment(double amount) {
        System.out.println("Processing PayPal payment from " + email + ": $" + amount);
        return true;
    }
    
    @Override
    public String getProviderName() {
        return "PayPal";
    }
}
```

---

## Marker Interface (Teg interfeysi)

### Marker Interface nima?
**Marker Interface** - hech qanday method'ga ega bo'lmagan bo'sh interface. U object haqida JVM'ga qo'shimcha ma'lumot berish uchun ishlatiladi.

### Java'dagi mashhur Marker Interface'lar:
1. **Serializable** - object serializatsiya qilinishi mumkinligini bildiradi
2. **Cloneable** - object klonlanadiganligini bildiradi
3. **Remote** - RMI (Remote Method Invocation) uchun

### Custom Marker Interface:
```java
// Marker interface - no methods
interface Deletable {
    // Empty interface - just a marker
}

interface Loggable {
    // Another marker interface
}

// Class using marker interfaces
class Document implements Deletable, Loggable {
    private String content;
    
    public Document(String content) {
        this.content = content;
    }
    
    public void display() {
        System.out.println("Document: " + content);
    }
}

class Image implements Loggable {
    private String filename;
    
    public Image(String filename) {
        this.filename = filename;
    }
    
    public void show() {
        System.out.println("Image: " + filename);
    }
}

// Utility class that checks marker interfaces
class FileManager {
    public static void delete(Object obj) {
        if (obj instanceof Deletable) {
            System.out.println("Deleting object...");
            // Delete logic here
        } else {
            System.out.println("Cannot delete - object is not deletable");
        }
    }
    
    public static void log(Object obj) {
        if (obj instanceof Loggable) {
            System.out.println("Logging object...");
            // Logging logic here
        }
    }
}

public class MarkerInterfaceExample {
    public static void main(String[] args) {
        Document doc = new Document("Important document");
        Image img = new Image("photo.jpg");
        
        FileManager.delete(doc);  // Deleting object...
        FileManager.delete(img);  // Cannot delete - object is not deletable
        
        FileManager.log(doc);     // Logging object...
        FileManager.log(img);     // Logging object...
    }
}
```

---

## Amaliy Misol: Notification System

```java
// Abstraction using abstract class and interfaces

// Marker interface
interface Prioritizable {
    // Marker - no methods
}

// Interface for notification
interface Notification {
    void send(String message);
    String getType();
}

// Abstract base class for common functionality
abstract class BaseNotification implements Notification {
    protected String recipient;
    protected boolean isSent = false;
    
    public BaseNotification(String recipient) {
        this.recipient = recipient;
    }
    
    // Common method
    protected void logNotification(String type, String message) {
        System.out.println("[" + type + "] Sent to " + recipient + ": " + message);
        isSent = true;
    }
    
    public boolean isSent() {
        return isSent;
    }
}

// Concrete implementations
class EmailNotification extends BaseNotification implements Prioritizable {
    private String emailAddress;
    
    public EmailNotification(String recipient, String emailAddress) {
        super(recipient);
        this.emailAddress = emailAddress;
    }
    
    @Override
    public void send(String message) {
        System.out.println("Sending email to: " + emailAddress);
        logNotification("EMAIL", message);
    }
    
    @Override
    public String getType() {
        return "Email";
    }
}

class SMSNotification extends BaseNotification {
    private String phoneNumber;
    
    public SMSNotification(String recipient, String phoneNumber) {
        super(recipient);
        this.phoneNumber = phoneNumber;
    }
    
    @Override
    public void send(String message) {
        System.out.println("Sending SMS to: " + phoneNumber);
        logNotification("SMS", message);
    }
    
    @Override
    public String getType() {
        return "SMS";
    }
}

class PushNotification extends BaseNotification {
    private String deviceId;
    
    public PushNotification(String recipient, String deviceId) {
        super(recipient);
        this.deviceId = deviceId;
    }
    
    @Override
    public void send(String message) {
        System.out.println("Sending push notification to device: " + deviceId);
        logNotification("PUSH", message);
    }
    
    @Override
    public String getType() {
        return "Push";
    }
}

// Notification service using polymorphism
class NotificationService {
    public void sendNotifications(Notification[] notifications, String message) {
        for (Notification notification : notifications) {
            notification.send(message);
        }
    }
    
    // Method specific to prioritizable notifications
    public void sendPriorityNotifications(Notification[] notifications, String message) {
        for (Notification notification : notifications) {
            if (notification instanceof Prioritizable) {
                System.out.println("Sending priority " + notification.getType() + " notification");
                notification.send("URGENT: " + message);
            }
        }
    }
}

public class NotificationSystem {
    public static void main(String[] args) {
        // Create notifications
        Notification[] notifications = {
            new EmailNotification("Alice", "alice@example.com"),
            new SMSNotification("Bob", "+1234567890"),
            new PushNotification("Charlie", "device-123"),
            new EmailNotification("David", "david@example.com")
        };
        
        // Create service
        NotificationService service = new NotificationService();
        
        // Send all notifications
        System.out.println("=== SENDING ALL NOTIFICATIONS ===");
        service.sendNotifications(notifications, "System maintenance at 2 AM");
        
        // Send only priority notifications
        System.out.println("\n=== SENDING PRIORITY NOTIFICATIONS ===");
        service.sendPriorityNotifications(notifications, "Critical security update");
    }
}
```

---

## O'z-o'zini Tekshirish

### Savol 1: Quyidagi kodda xato bormi?
```java
abstract class A {
    abstract void display();
}

class B extends A {
    // Missing display() implementation
}
```

### Savol 2: Interface va Abstract class farqlarini 3 ta nuqtada tushuntiring.

### Savol 3: Nega Java 8 da default method'lar qo'shildi?

---

## Keyingi Mavzu: [06 - Wrapper Classes, Big Numbers, Inner Classes](./06_Wrapper_BigNumbers_Inner.md)
**[Mundarijaga qaytish](../README.md)**

> ⚡️ **Eslatma:** Abstraction - bu haqiqiy dasturchilik mahorati. Muvaffaqiyatli abstraction - bu muammoning murakkabligini yashirib, oddiy va foydalaniladigan interfeys yaratish. "Simple things should be simple, complex things should be possible" prinsipini eslang!