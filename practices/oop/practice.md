# Java Amaliy Mashqlar To'plami - 2-Modul: OOP

## Mundarija
- [OOP Asoslari](#oop-asoslari)
- [Encapsulation](#encapsulation)
- [Package](#package)
- [Inheritance](#inheritance)
- [Polymorphism](#polymorphism)
- [Abstraction](#abstraction)
- [Interface](#interface)
- [Wrapper Classes](#wrapper-classes)
- [Big Numbers](#big-numbers)
- [Inner Classes](#inner-classes)
- [Memory Management](#memory-management)
- [Record and Sealed Classes](#record-and-sealed-classes)
- [Static and Instance Block Initializer](#static-and-instance-block-initializer)
- [Enum Class](#enum-class)
- [Design Patterns](#design-patterns)
- [Objects Class and Javadoc](#objects-class-and-javadoc)

---

## OOP Asoslari

<details>
<summary><b>1. Class va Object yaratish</b></summary>

**Misol:** `Car` nomli class yarating. Uning `brand`, `model`, `year` fieldlari va `displayInfo()` metodi bo'lsin. 3 ta obyekt yaratib, ma'lumotlarini chiqaring.

**Berilgan:** 
- Class nomi: `Car`
- Fieldlar: `String brand`, `String model`, `int year`
- Metod: `void displayInfo()`

**Talab:** 3 ta car obyekti yarating: Toyota Camry 2020, BMW X5 2022, Hyundai Elantra 2021

</details>

<details>
<summary><b>2. Constructor turlari</b></summary>

**Misol:** `Book` nomli class yarating. Unda 3 xil constructor bo'lsin:
- Default constructor
- Parametrli constructor (title, author)
- Copy constructor

**Berilgan:** 
- Fieldlar: `String title`, `String author`, `double price`
- Constructorlar:
  - `Book()` - default qiymatlar
  - `Book(String title, String author)` - price = 0.0
  - `Book(Book other)` - copy constructor

**Talab:** Har bir constructor orqali obyekt yarating va ma'lumotlarni chiqaring.

</details>

<details>
<summary><b>3. Method Overloading</b></summary>

**Misol:** `Calculator` nomli class yarating. Unda `add()` metodini overloading qiling:
- Ikkita int qabul qiladigan
- Uchta int qabul qiladigan
- Ikkita double qabul qiladigan
- String qabul qiladigan (sonlarni string sifatida qabul qilib, yig'indisini qaytaradi)

**Berilgan:** Turli xil parametrlar bilan metodlarni chaqirib ko'ring.

</details>

<details>
<summary><b>4. this keyword</b></summary>

**Misol:** `Employee` nomli class yarating. `this` keywordidan foydalanib:
- Constructor ichida fieldlarni initialize qiling
- Bir constructordan boshqa constructorni chaqiring (constructor chaining)
- Metod ichida fieldlarga murojaat qiling

**Berilgan:** 
- Fieldlar: `int id`, `String name`, `double salary`
- 2 ta constructor: faqat id bilan, hamma fieldlar bilan

</details>

<details>
<summary><b>5. static members</b></summary>

**Misol:** `University` nomli class yarating. Unda:
- `static int totalStudents` - barcha talabalar soni
- `static String universityName` - universitet nomi
- `static void displayUniversityInfo()` - static metod
- `String studentName` - instance field
- `int studentId` - instance field

**Berilgan:** 5 ta student obyekti yarating. Har bir yaratilganda totalStudents oshsin. Barcha static ma'lumotlarni chiqaring.

</details>

---

## Encapsulation

<details>
<summary><b>6. Getter va Setter metodlari</b></summary>

**Misol:** `BankAccount` nomli class yarating. Barcha fieldlarni `private` qilib, getter va setter metodlarini yarating.

**Berilgan:**
```java
public class BankAccount {
    private String accountNumber;
    private String ownerName;
    private double balance;
    private String pinCode;
}
```

**Talab:**
- `accountNumber` faqat getter, setter yo'q (faqat konstruktorda o'rnatiladi)
- `ownerName` getter va setter (setter da name bo'sh emasligini tekshiring)
- `balance` faqat getter (setter yo'q, faqat deposit/withdraw metodlari)
- `pinCode` getter yo'q, faqat setter va `verifyPin()` metodi

</details>

<details>
<summary><b>7. Data Validation</b></summary>

**Misol:** `Student` nomli class yarating. Setter metodlarida ma'lumotlarni tekshirishni amalga oshiring.

**Berilgan:**
- `name` - bo'sh bo'lmasligi kerak
- `age` - 0 dan katta va 150 dan kichik
- `grade` - 0 dan 100 gacha
- `email` - @ belgisi bo'lishi kerak

**Talab:** Noto'g'ri ma'lumot kiritilganda exception tashlang yoki false qaytaring.

</details>

<details>
<summary><b>8. Immutable Class</b></summary>

**Misol:** `ImmutablePerson` nomli immutable class yarating.

**Berilgan:**
- Fieldlar: `String name`, `int age`, `List<String> hobbies`
- Barcha fieldlar `private final`
- Faqat getter metodlari (setterlar yo'q)
- Constructor orqali barcha fieldlarni initialize qiling

**Talab:** Immutable class qoidalariga rioya qiling (deep copy, final class, etc.)

</details>

---

## Package

<details>
<summary><b>9. Package yaratish</b></summary>

**Misol:** Quyidagi package strukturasi yarating:
- `uz.pdp.model` - Entity classlar
- `uz.pdp.service` - Service classlar
- `uz.pdp.util` - Utility classlar
- `uz.pdp.test` - Test classlar

**Berilgan:**
- `model` package'ida: `User`, `Product`
- `service` package'ida: `UserService`, `ProductService`
- `util` package'ida: `Validator`, `FileUtil`
- `test` package'ida: `Main` (barchasini test qilish)

**Talab:** Package'larni to'g'ri nomlang va import qiling.

</details>

<details>
<summary><b>10. Access Modifiers</b></summary>

**Misol:** Turli package'lardan access modifier'larni tekshirish uchun dastur yozing.

**Berilgan:**
```java
package uz.pdp.a;
public class A {
    public int publicVar = 1;
    protected int protectedVar = 2;
    int defaultVar = 3;
    private int privateVar = 4;
    
    public void display() {
        // Barcha o'zgaruvchilarni chiqarish
    }
}
```

**Talab:** Turli package'lardan (uz.pdp.b, uz.pdp.a.child) bu class'ga murojaat qilib, qaysi o'zgaruvchilarga kirish mumkinligini tekshiring.

</details>

---

## Inheritance

<details>
<summary><b>11. Single Inheritance</b></summary>

**Misol:** `Animal` -> `Mammal` -> `Dog` vorislik zanjirini yarating.

**Berilgan:**
- `Animal`: `String name`, `int age`, `void eat()`, `void sleep()`
- `Mammal`: `boolean hasFur`, `void giveBirth()`
- `Dog`: `String breed`, `void bark()`

**Talab:** Har bir class'da konstruktor va metodlarni yarating. Dog obyekti yaratib, barcha metodlarni chaqiring.

</details>

<details>
<summary><b>12. super keyword</b></summary>

**Misol:** `Vehicle` -> `Car` vorisligida `super` keywordini ishlatish.

**Berilgan:**
```java
class Vehicle {
    String brand;
    int speed;
    
    Vehicle(String brand) { ... }
    void display() { ... }
}

class Car extends Vehicle {
    String model;
    
    Car(String brand, String model) {
        // super orqali brand ni o'rnating
    }
    
    @Override
    void display() {
        // super.display() ni chaqirib, keyin model ni chiqaring
    }
}
```

</details>

<details>
<summary><b>13. Method Overriding</b></summary>

**Misol:** `Shape` abstract class'idan `Circle`, `Rectangle`, `Triangle` class'larini yarating.

**Berilgan:**
```java
abstract class Shape {
    abstract double getArea();
    abstract double getPerimeter();
    
    void display() {
        System.out.println("This is a shape");
    }
}
```

**Talab:** Har bir subclass'da metodlarni override qiling. Polymorphism orqali barcha shakllarning yuzalarini hisoblang.

</details>

<details>
<summary><b>14. Multiple Inheritance (Interface orqali)</b></summary>

**Misol:** `Flyable`, `Swimmable` interfacelarini yarating. `Duck` class'i ikkalasini ham implement qilsin.

**Berilgan:**
- `Flyable`: `void fly()`
- `Swimmable`: `void swim()`
- `Duck`: `void quack()`

**Talab:** Duck obyekti yaratib, barcha metodlarni chaqiring.

</details>

<details>
<summary><b>15. Cosmic Class (Object class)</b></summary>

**Misol:** `Person` class'ida Object class'ining metodlarini override qiling.

**Berilgan:**
- `toString()` - Person ma'lumotlarini chiroyli qilib chiqaring
- `equals()` - ikki Person bir xil ma'lumotlarga ega bo'lsa true qaytaring
- `hashCode()` - name va age asosida hash code yarating

**Talab:** Bir nechta Person obyektlari yaratib, ularni solishtiring.

</details>

---

## Polymorphism

<details>
<summary><b>16. Compile-time Polymorphism (Method Overloading)</b></summary>

**Misol:** `Printer` class'ida `print()` metodini overloading qiling.

**Berilgan:**
- `print(String s)` - string ni chiqaradi
- `print(int i)` - int ni chiqaradi
- `print(String s, int times)` - string ni times marta chiqaradi
- `print(int[] arr)` - massiv elementlarini chiqaradi
- `print(Object obj)` - objectni chiqaradi

</details>

<details>
<summary><b>17. Runtime Polymorphism (Method Overriding)</b></summary>

**Misol:** `Payment` class'idan `CreditCardPayment`, `PayPalPayment`, `CashPayment` class'larini yarating.

**Berilgan:**
```java
class Payment {
    void pay(double amount) {
        System.out.println("Paying: " + amount);
    }
}
```

**Talab:** Har bir subclass'da `pay()` metodini override qiling. Array of Payment orqali barcha to'lov turlarini bajaring.

</details>

<details>
<summary><b>18. Polymorphic Array</b></summary>

**Misol:** `Employee` class'idan `Manager`, `Developer`, `Intern` class'larini yarating.

**Berilgan:**
- `Employee`: `String name`, `double baseSalary`, `double calculateSalary()`
- `Manager`: bonus qo'shadi
- `Developer`: soatlik stavka bo'yicha
- `Intern`: fixed stipendiya

**Talab:** Employee[] massivi yaratib, barcha xodimlarning maoshlarini hisoblang.

</details>

---

## Abstraction

<details>
<summary><b>19. Abstract Class</b></summary>

**Misol:** `Database` abstract class'ini yarating. Undan `MySQLDatabase`, `PostgreSQLDatabase`, `MongoDBDatabase` class'larini yarating.

**Berilgan:**
```java
abstract class Database {
    protected String url;
    protected String username;
    
    abstract void connect();
    abstract void disconnect();
    abstract void execute(String query);
    
    void log(String message) {
        System.out.println("LOG: " + message);
    }
}
```

**Talab:** Har bir subclass'da abstract metodlarni implement qiling.

</details>

<details>
<summary><b>20. Abstract vs Concrete</b></summary>

**Misol:** `MediaPlayer` abstract class'ini yarating. Undan `AudioPlayer`, `VideoPlayer` class'larini yarating.

**Berilgan:**
- `play()` - abstract
- `pause()` - abstract
- `stop()` - abstract
- `setVolume(int volume)` - concrete

**Talab:** Har bir player o'ziga xos tarzda metodlarni implement qilsin.

</details>

---

## Interface

<details>
<summary><b>21. Interface yaratish</b></summary>

**Misol:** `Drawable`, `Resizable`, `Colorable` interfacelarini yarating.

**Berilgan:**
- `Drawable`: `void draw()`
- `Resizable`: `void resize(int percent)`
- `Colorable`: `void setColor(String color)`

**Talab:** `Circle` va `Rectangle` class'lari bu interfacelarni implement qilsin.

</details>

<details>
<summary><b>22. Default Methods</b></summary>

**Misol:** `Logger` interface'ida default metod yarating.

**Berilgan:**
```java
interface Logger {
    void log(String message);
    
    default void logInfo(String message) {
        log("[INFO] " + message);
    }
    
    default void logError(String message) {
        log("[ERROR] " + message);
    }
}
```

**Talab:** `FileLogger` va `ConsoleLogger` class'larida `log()` metodini implement qiling.

</details>

<details>
<summary><b>23. Static Methods in Interface</b></summary>

**Misol:** `MathOperations` interface'ida static metodlar yarating.

**Berilgan:**
- `static int add(int a, int b)`
- `static int subtract(int a, int b)`
- `static int multiply(int a, int b)`
- `static double divide(int a, int b)`

**Talab:** Bu metodlarni interface nomi orqali chaqiring.

</details>

<details>
<summary><b>24. Marker Interface</b></summary>

**Misol:** `Auditable` marker interface'ini yarating. Bu interface bilan belgilangan class'lar audit qilinishi kerak.

**Berilgan:**
- `Auditable` interface - bo'sh
- `Transaction` class - Auditable ni implement qiladi
- `AuditService` - faqat Auditable objectlarni qabul qiladi

</details>

---

## Wrapper Classes

<details>
<summary><b>25. Primitive vs Wrapper</b></summary>

**Misol:** Barcha primitive tiplarni (int, double, boolean, char, etc.) wrapper class'larga o'tkazish va aksincha.

**Berilgan:**
- int → Integer
- double → Double
- boolean → Boolean
- char → Character
- long → Long

**Talab:** Autoboxing va unboxing ni ko'rsating. Null qiymatlar bilan ishlang.

</details>

<details>
<summary><b>26. Wrapper Class Methods</b></summary>

**Misol:** Wrapper class'larning metodlaridan foydalanish.

**Berilgan:**
- `Integer.parseInt()`, `Integer.toString()`
- `Double.parseDouble()`, `Double.isNaN()`
- `Character.isDigit()`, `Character.isLetter()`
- `Boolean.parseBoolean()`

**Talab:** String dan raqamlarga o'tkazish va turli tekshirishlar.

</details>

---

## Big Numbers

<details>
<summary><b>27. BigInteger bilan ishlash</b></summary>

**Misol:** Katta sonlar ustida amallar bajarish (faktorial 100, Fibonacci 100).

**Berilgan:**
- 100! ni hisoblash
- 100-chi Fibonacci sonini topish
- 2^1000 ni hisoblash

**Talab:** `BigInteger` dan foydalaning. Oddiy int bilan solishtiring.

</details>

<details>
<summary><b>28. BigDecimal bilan ishlash</b></summary>

**Misol:** Pul hisob-kitoblari (double bilan muammolarni ko'rsatish).

**Berilgan:**
```java
double a = 0.1;
double b = 0.2;
double c = a + b; // 0.30000000000000004 ?!
```

**Talab:** `BigDecimal` yordamida aniq hisob-kitob qiling. 0.1 + 0.2 = 0.3 ekanligini isbotlang.

</details>

---

## Inner Classes

<details>
<summary><b>29. Member Inner Class</b></summary>

**Misol:** `University` class'ida `Department` inner class'ini yarating.

**Berilgan:**
```java
class University {
    private String name;
    private List<Department> departments;
    
    class Department {
        private String deptName;
        private int studentCount;
        
        void display() {
            // University name va Department name ni chiqarish
        }
    }
}
```

</details>

<details>
<summary><b>30. Static Inner Class</b></summary>

**Misol:** `Computer` class'ida `CPU` static inner class'ini yarating.

**Berilgan:**
- `Computer`: `String brand`, `int ram`
- `CPU`: `String model`, `double speed`, `void process()`

**Talab:** Static inner class outer classning instance fieldlariga murojaat qila oladimi?

</details>

<details>
<summary><b>31. Anonymous Inner Class</b></summary>

**Misol:** `Button` class'ida `OnClickListener` interface'ini anonymous inner class orqali implement qiling.

**Berilgan:**
```java
interface OnClickListener {
    void onClick();
}

class Button {
    private String text;
    
    void setOnClickListener(OnClickListener listener) { ... }
}
```

</details>

<details>
<summary><b>32. Local Inner Class</b></summary>

**Misol:** Metod ichida local inner class yarating.

**Berilgan:**
```java
public void processData() {
    class DataProcessor {
        void process() {
            // method implementation
        }
    }
    
    DataProcessor dp = new DataProcessor();
    dp.process();
}
```

</details>

---

## Memory Management

<details>
<summary><b>33. Stack vs Heap</b></summary>

**Misol:** Stack va Heap xotira tushunchalarini tushuntiruvchi dastur yozing.

**Berilgan:**
- Local o'zgaruvchilar (stack)
- Object'lar (heap)
- Method chaqiruvlari (stack frame)

**Talab:** Har bir o'zgaruvchining qayerda saqlanishini comment orqali ko'rsating.

</details>

<details>
<summary><b>34. Garbage Collection</b></summary>

**Misol:** Object'larni GC uchun "eligible" qilish.

**Berilgan:**
- Object'ni null qilish
- Object'ni scope'dan chiqarish
- System.gc() chaqirish (faqat maslahat)

**Talab:** finalize() metodini override qilib, object qachon o'chirilganini ko'rsating.

</details>

---

## Record and Sealed Classes

<details>
<summary><b>35. Record Class</b></summary>

**Misol:** `Point` record class'ini yarating (x, y koordinatalari).

**Berilgan:**
```java
record Point(int x, int y) {}
```

**Talab:** Record class'ining avtomatik yaratilgan metodlarini (toString, equals, hashCode, getter) ishlating.

</details>

<details>
<summary><b>36. Sealed Classes</b></summary>

**Misol:** `Shape` sealed class'ini yarating. Faqat `Circle`, `Rectangle`, `Triangle` class'lari voris ola olsin.

**Berilgan:**
```java
sealed class Shape permits Circle, Rectangle, Triangle { ... }
final class Circle extends Shape { ... }
final class Rectangle extends Shape { ... }
final class Triangle extends Shape { ... }
```

</details>

---

## Static and Instance Block Initializer

<details>
<summary><b>37. Static Initializer Block</b></summary>

**Misol:** Static initializer block yordamida static ma'lumotlarni initialize qiling.

**Berilgan:**
- `static Map<String, String> countryCodes`
- Static block ichida map'ni to'ldirish
- Static block qachon ishlashini ko'rsatish

</details>

<details>
<summary><b>38. Instance Initializer Block</b></summary>

**Misol:** Instance initializer block yordamida object yaratilganda log yozish.

**Berilgan:**
- Har bir object yaratilganda "Object created" deb chiqarish
- Constructor'dan oldin ishlashini ko'rsatish

</details>

---

## Enum Class

<details>
<summary><b>39. Simple Enum</b></summary>

**Misol:** `DayOfWeek` enum'ini yarating (MONDAY dan SUNDAY gacha).

**Berilgan:**
- Har bir enum constantasini chiqarish
- values() va valueOf() metodlarini ishlatish
- ordinal() va name() metodlarini ishlatish

</details>

<details>
<summary><b>40. Enum with Fields and Methods</b></summary>

**Misol:** `Planet` enum'ini yarating (MERCURY, VENUS, EARTH, etc.).

**Berilgan:**
- Har bir planetaning massasi va radiusi bo'lsin
- `double surfaceGravity()` metodi
- `double surfaceWeight(double otherMass)` metodi

</details>

---

## Design Patterns

<details>
<summary><b>41. Singleton Pattern</b></summary>

**Misol:** Singleton patternni implement qilish (5 xil usulda).

**Berilgan:**
- Eager initialization
- Lazy initialization
- Thread-safe (synchronized)
- Double-checked locking
- Bill Pugh (static inner class)
- Enum singleton

</details>

<details>
<summary><b>42. Factory Pattern</b></summary>

**Misol:** `ShapeFactory` orqali turli shape'lar yaratish.

**Berilgan:**
- `Shape` interface
- `Circle`, `Rectangle`, `Triangle` implementatsiyalari
- `ShapeFactory.getShape(String type)` metodi

</details>

<details>
<summary><b>43. Builder Pattern</b></summary>

**Misol:** `Computer` class'ida Builder patternni implement qilish.

**Berilgan:**
```java
Computer comp = new Computer.Builder()
    .setCPU("Intel i7")
    .setRAM("16GB")
    .setStorage("512GB SSD")
    .setGraphicsCard("NVIDIA RTX 3060")
    .build();
```

</details>

---

## Objects Class and Javadoc

<details>
<summary><b>44. Objects Utility Methods</b></summary>

**Misol:** `java.util.Objects` class'ining metodlaridan foydalanish.

**Berilgan:**
- `Objects.equals()`, `Objects.deepEquals()`
- `Objects.hash()`, `Objects.hashCode()`
- `Objects.requireNonNull()`
- `Objects.toString()`

**Talab:** Null-safe kod yozish uchun Objects metodlaridan foydalaning.

</details>

<details>
<summary><b>45. Javadoc yozish</b></summary>

**Misol:** `MathUtils` class'iga to'liq Javadoc yozing.

**Berilgan:**
```java
/**
 * This class provides utility methods for mathematical operations.
 * @author YourName
 * @version 1.0
 * @since 2024
 */
public class MathUtils {
    // methods with Javadoc
}
```

**Talab:** Har bir metod, parametr, return value va exception uchun Javadoc yozing.

</details>

---

## Mashqlar Statistikasi

| Bo'lim | Mashqlar soni |
|--------|---------------|
| OOP Asoslari | 5 ta |
| Encapsulation | 3 ta |
| Package | 2 ta |
| Inheritance | 5 ta |
| Polymorphism | 3 ta |
| Abstraction | 2 ta |
| Interface | 4 ta |
| Wrapper Classes | 2 ta |
| Big Numbers | 2 ta |
| Inner Classes | 4 ta |
| Memory Management | 2 ta |
| Record and Sealed Classes | 2 ta |
| Static and Instance Block | 2 ta |
| Enum Class | 2 ta |
| Design Patterns | 3 ta |
| Objects Class and Javadoc | 2 ta |
| **Jami** | **45 ta** |

---

**[Mundarijaga qaytish](#-mundarija)**

> Har bir mashqni mustaqil bajarishga harakat qiling! OOP prinsiplarini amaliyotda qo'llash orqali mustahkamlang. 🚀
