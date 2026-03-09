# 10 - Modifiers, Record, Sealed Classes

## Non-access Modifiers (Kirish bo'lmagan modifikatorlar)

Java'da 7 ta asosiy non-access modifier mavjud:

1. **abstract** - Mavhum (body'siz)
2. **final** - Yakuniy (o'zgartirib bo'lmaydigan)
3. **static** - Statik (class'ga tegishli)
4. **native** - Mahalliy (native kod uchun)
5. **volatile** - O'zgaruvchan (thread-safe)
6. **synchronized** - Sinxronizatsiyalangan (thread-safe)
7. **transient** - Vaqtincha (serializatsiya qilinmaydigan)

---

## 1. final Modifier

### final nima?
**final** - yakuniy, o'zgartirib bo'lmaydigan degan ma'noni anglatadi.

### Qo'llanilishi:
```java
// 1. final class - extend qilib bo'lmaydi
final class ImmutableClass {
    private final int value;
    
    public ImmutableClass(int value) {
        this.value = value;
    }
    
    public int getValue() {
        return value;
    }
}

// ERROR: Cannot extend final class
// class ChildClass extends ImmutableClass { }

// 2. final method - override qilib bo'lmaydi
class Parent {
    public final void display() {
        System.out.println("This cannot be overridden");
    }
}

class Child extends Parent {
    // ERROR: Cannot override final method
    // @Override
    // public void display() { }
}

// 3. final variable - qiymatini o'zgartirib bo'lmaydi
class Example {
    // 3.1 Static final constant
    public static final double PI = 3.14159;
    
    // 3.2 Instance final variable (initialize in constructor)
    private final int id;
    
    // 3.3 Final parameter
    public void process(final String input) {
        // input = "changed";  // ERROR: Cannot change final parameter
        System.out.println(input);
    }
    
    // 3.4 Final local variable
    public void calculate() {
        final int result = 100;
        // result = 200;  // ERROR: Cannot change final variable
    }
    
    public Example(int id) {
        this.id = id;  // Must initialize final variable in constructor
    }
    
    // 3.5 Final reference (object can change, but reference cannot)
    private final List<String> items = new ArrayList<>();
    
    public void addItem(String item) {
        items.add(item);  // OK: Object can be modified
        // items = new ArrayList<>();  // ERROR: Reference cannot be changed
    }
}

// 4. Immutable class using final
public final class Student {
    private final String name;
    private final int age;
    private final List<String> courses;
    
    public Student(String name, int age, List<String> courses) {
        this.name = name;
        this.age = age;
        // Defensive copy for mutable objects
        this.courses = new ArrayList<>(courses);
    }
    
    // Getters
    public String getName() { return name; }
    public int getAge() { return age; }
    
    // Return unmodifiable collection
    public List<String> getCourses() {
        return Collections.unmodifiableList(courses);
    }
}

public class FinalExample {
    public static void main(String[] args) {
        // Final variable examples
        System.out.println("PI: " + Example.PI);
        
        Example example = new Example(100);
        example.process("Hello");
        
        // Immutable class example
        List<String> courses = new ArrayList<>();
        courses.add("Math");
        courses.add("Physics");
        
        Student student = new Student("Alice", 20, courses);
        System.out.println("Student: " + student.getName());
        
        // Cannot modify returned list
        List<String> studentCourses = student.getCourses();
        System.out.println("Courses: " + studentCourses);
        
        // studentCourses.add("Chemistry");  // ERROR: UnsupportedOperationException
        
        // Original list can still be modified (different reference)
        courses.add("Chemistry");
        System.out.println("Student courses unchanged: " + student.getCourses());
    }
}
```

### final cheklovlari:
1. **final class** extends qilib bo'lmaydi
2. **final method** override qilib bo'lmaydi
3. **final variable** ga yangi qiymat berib bo'lmaydi
4. **final field** konstruktor yoki e'lon qilinganda initialize qilinishi kerak

---

## 2. static Modifier

### static nima?
**static** - class'ga tegishli, obyekt'ga emas.

### Qo'llanilishi:
```java
class StaticExample {
    
    // 1. Static variable - class'ga tegishli
    public static int counter = 0;
    private static final String DEFAULT_NAME = "Unknown";
    
    // 2. Static block - class yuklanganda ishlaydi
    static {
        System.out.println("Static block executed. Counter: " + counter);
        // Complex initialization
        initializeStaticData();
    }
    
    // 3. Static method - class'ga tegishli
    public static void printInfo() {
        System.out.println("Counter: " + counter);
        // Cannot access non-static members
        // System.out.println(name);  // ERROR
    }
    
    // 4. Static nested class
    static class NestedClass {
        public void display() {
            System.out.println("Static nested class");
        }
    }
    
    // 5. Static import example
    public static final double TAX_RATE = 0.20;
    
    // Instance members
    private String name;
    private int id;
    
    // Constructor
    public StaticExample(String name) {
        this.name = name;
        this.id = ++counter;  // Use static counter
    }
    
    // Instance method can access static members
    public void display() {
        System.out.println("ID: " + id + ", Name: " + name + ", Total objects: " + counter);
    }
    
    private static void initializeStaticData() {
        System.out.println("Initializing static data...");
    }
}

// Static import
import static StaticExample.TAX_RATE;
import static java.lang.Math.PI;
import static java.lang.Math.sqrt;

public class StaticModifierDemo {
    
    // Static method in main class
    public static void calculateArea(double radius) {
        // Using static imports
        double area = PI * radius * radius;
        double tax = area * TAX_RATE;
        System.out.println("Area: " + area + ", Tax: " + tax);
    }
    
    public static void main(String[] args) {
        System.out.println("=== STATIC MODIFIER DEMO ===");
        
        // Access static members without creating object
        System.out.println("Initial counter: " + StaticExample.counter);
        StaticExample.printInfo();
        
        // Create objects
        StaticExample obj1 = new StaticExample("Alice");
        StaticExample obj2 = new StaticExample("Bob");
        StaticExample obj3 = new StaticExample("Charlie");
        
        // Static counter shared among all instances
        obj1.display();
        obj2.display();
        obj3.display();
        
        // Access static member through instance (not recommended)
        System.out.println("Counter via instance: " + obj1.counter);
        
        // Static nested class
        StaticExample.NestedClass nested = new StaticExample.NestedClass();
        nested.display();
        
        // Static import usage
        calculateArea(5.0);
        
        // Static vs instance memory
        demonstrateMemory();
    }
    
    public static void demonstrateMemory() {
        System.out.println("\n=== STATIC MEMORY DEMO ===");
        
        // Static variable - one copy in Metaspace
        // Instance variable - each object has its own copy in Heap
        
        class MemoryDemo {
            static int staticCount = 0;    // One copy for all instances
            int instanceCount = 0;         // Separate copy for each instance
            
            void increment() {
                staticCount++;
                instanceCount++;
            }
            
            void display() {
                System.out.println("Static: " + staticCount + 
                                 ", Instance: " + instanceCount);
            }
        }
        
        MemoryDemo obj1 = new MemoryDemo();
        MemoryDemo obj2 = new MemoryDemo();
        MemoryDemo obj3 = new MemoryDemo();
        
        obj1.increment();
        obj1.display();  // Static: 1, Instance: 1
        
        obj2.increment();
        obj2.increment();
        obj2.display();  // Static: 3, Instance: 2
        
        obj3.display();  // Static: 3, Instance: 0
    }
}
```

### static cheklovlari:
1. **static method** non-static member'larni ishlata olmaydi
2. **this** va **super** static kontekstda ishlatilmaydi
3. **Local variable** static bo'la olmaydi

---

## 3. abstract Modifier

### abstract nima?
**abstract** - mavhum, body'siz.

```java
// 1. Abstract class
abstract class Animal {
    // Abstract method (no body)
    public abstract void makeSound();
    
    // Concrete method (has body)
    public void eat() {
        System.out.println("Animal is eating");
    }
    
    // Abstract class can have constructor
    protected Animal() {
        System.out.println("Animal constructor");
    }
}

// 2. Abstract method in abstract class
abstract class Vehicle {
    private String model;
    
    public Vehicle(String model) {
        this.model = model;
    }
    
    // Abstract methods
    public abstract void start();
    public abstract void stop();
    
    // Concrete method
    public String getModel() {
        return model;
    }
}

// 3. Concrete class extending abstract class
class Dog extends Animal {
    @Override
    public void makeSound() {
        System.out.println("Woof woof!");
    }
}

class Car extends Vehicle {
    public Car(String model) {
        super(model);
    }
    
    @Override
    public void start() {
        System.out.println(getModel() + " car starting...");
    }
    
    @Override
    public void stop() {
        System.out.println(getModel() + " car stopping...");
    }
}

// 4. Interface (implicitly abstract)
interface Drawable {
    // All methods are public abstract by default
    void draw();
    
    // Default method (Java 8+)
    default void resize() {
        System.out.println("Resizing...");
    }
    
    // Static method (Java 8+)
    static void printInfo() {
        System.out.println("Drawable interface");
    }
}

// 5. Abstract class with no abstract methods
abstract class Database {
    public void connect() {
        System.out.println("Connecting to database...");
    }
    
    public void disconnect() {
        System.out.println("Disconnecting from database...");
    }
}

public class AbstractExample {
    public static void main(String[] args) {
        // Cannot instantiate abstract class
        // Animal animal = new Animal();  // ERROR
        
        Dog dog = new Dog();
        dog.makeSound();
        dog.eat();
        
        Car car = new Car("Toyota");
        car.start();
        car.stop();
        
        // Polymorphism with abstract class
        Animal myPet = new Dog();
        myPet.makeSound();
        
        Vehicle myVehicle = new Car("Honda");
        myVehicle.start();
        
        // Interface usage
        Drawable circle = new Drawable() {
            @Override
            public void draw() {
                System.out.println("Drawing circle");
            }
        };
        
        circle.draw();
        circle.resize();
        Drawable.printInfo();
    }
}
```

### abstract cheklovlari:
1. **abstract class** instantiate qilib bo'lmaydi
2. **abstract method** body'siz bo'lishi kerak
3. **abstract** final, private, native, static bilan birga ishlatilmaydi
4. **abstract method** bo'lsa, class abstract bo'lishi kerak

---

## 4. native Modifier

### native nima?
**native** - JNI (Java Native Interface) orqali native kod bilan ishlash.

```java
public class NativeExample {
    
    // Native method declaration (no body)
    public native void nativeMethod();
    
    public native int calculate(int a, int b);
    
    public native String getSystemInfo();
    
    // Load native library
    static {
        System.loadLibrary("NativeLib");
    }
    
    // Regular Java method
    public void javaMethod() {
        System.out.println("This is Java method");
    }
    
    public static void main(String[] args) {
        NativeExample example = new NativeExample();
        example.javaMethod();
        
        // Call native methods
        example.nativeMethod();
        
        int result = example.calculate(10, 20);
        System.out.println("Native calculation result: " + result);
        
        String info = example.getSystemInfo();
        System.out.println("System info: " + info);
    }
}

/* 
C++ Implementation (NativeLib.cpp):

#include <jni.h>
#include <iostream>
#include "NativeExample.h"

JNIEXPORT void JNICALL Java_NativeExample_nativeMethod(JNIEnv* env, jobject obj) {
    std::cout << "Native method called from C++" << std::endl;
}

JNIEXPORT jint JNICALL Java_NativeExample_calculate(JNIEnv* env, jobject obj, 
                                                    jint a, jint b) {
    return a + b;
}

JNIEXPORT jstring JNICALL Java_NativeExample_getSystemInfo(JNIEnv* env, jobject obj) {
    return env->NewStringUTF("Native system information");
}
*/
```

---

## 5. synchronized Modifier

### synchronized nima?
**synchronized** - thread safety (bir vaqtda faqat bitta thread kirishi).

```java
class BankAccount {
    private double balance;
    
    // Synchronized method
    public synchronized void deposit(double amount) {
        System.out.println(Thread.currentThread().getName() + 
                         " depositing: " + amount);
        balance += amount;
        System.out.println("New balance: " + balance);
    }
    
    // Synchronized block
    public void withdraw(double amount) {
        System.out.println(Thread.currentThread().getName() + 
                         " attempting to withdraw: " + amount);
        
        synchronized(this) {  // Synchronized block
            if (balance >= amount) {
                balance -= amount;
                System.out.println("Withdrawal successful. New balance: " + balance);
            } else {
                System.out.println("Insufficient funds!");
            }
        }
    }
    
    // Static synchronized method
    public static synchronized void staticMethod() {
        System.out.println("Static synchronized method called by: " +
                         Thread.currentThread().getName());
    }
}

public class SynchronizedExample {
    public static void main(String[] args) throws InterruptedException {
        BankAccount account = new BankAccount();
        
        // Create multiple threads
        Thread[] threads = new Thread[5];
        
        for (int i = 0; i < threads.length; i++) {
            threads[i] = new Thread(() -> {
                account.deposit(100);
                account.withdraw(50);
                BankAccount.staticMethod();
            }, "Thread-" + i);
        }
        
        // Start all threads
        for (Thread thread : threads) {
            thread.start();
        }
        
        // Wait for all threads to complete
        for (Thread thread : threads) {
            thread.join();
        }
        
        System.out.println("\nAll transactions completed");
    }
}
```

---

## 6. volatile Modifier

### volatile nima?
**volatile** - variable qiymati barcha thread'lar uchun bir xil ko'rinadi.

```java
class SharedResource {
    // Without volatile - may have visibility issues
    private boolean flag = false;
    
    // With volatile - guaranteed visibility
    private volatile boolean volatileFlag = false;
    
    public void setFlag() {
        flag = true;
        volatileFlag = true;
        System.out.println("Flags set to true");
    }
    
    public void checkFlag() {
        while (!flag) {
            // May loop forever without volatile
        }
        System.out.println("Flag detected as true");
    }
    
    public void checkVolatileFlag() {
        while (!volatileFlag) {
            // Will exit when volatileFlag becomes true
        }
        System.out.println("Volatile flag detected as true");
    }
}

public class VolatileExample {
    public static void main(String[] args) throws InterruptedException {
        SharedResource resource = new SharedResource();
        
        // Thread 1: Set flags after delay
        Thread writer = new Thread(() -> {
            try {
                Thread.sleep(1000);  // Wait 1 second
                resource.setFlag();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        
        // Thread 2: Check regular flag (may have issues)
        Thread reader1 = new Thread(() -> {
            System.out.println("Checking regular flag...");
            resource.checkFlag();
        });
        
        // Thread 3: Check volatile flag (guaranteed to work)
        Thread reader2 = new Thread(() -> {
            System.out.println("Checking volatile flag...");
            resource.checkVolatileFlag();
        });
        
        // Start threads
        reader1.start();
        reader2.start();
        writer.start();
        
        // Wait for completion
        reader1.join(2000);  // Timeout after 2 seconds
        reader2.join();
        writer.join();
        
        if (reader1.isAlive()) {
            System.out.println("\nReader1 is still waiting - visibility issue!");
            reader1.interrupt();
        }
    }
}
```

---

## 7. transient Modifier

### transient nima?
**transient** - serializatsiya qilinmaydigan field'lar.

```java
import java.io.*;

class User implements Serializable {
    private String username;
    private transient String password;  // Won't be serialized
    private transient int sessionId;    // Won't be serialized
    private int userId;
    
    public User(String username, String password, int sessionId, int userId) {
        this.username = username;
        this.password = password;
        this.sessionId = sessionId;
        this.userId = userId;
    }
    
    @Override
    public String toString() {
        return "User{username='" + username + "', password='" + 
               (password != null ? "[PROTECTED]" : "null") + 
               "', sessionId=" + sessionId + ", userId=" + userId + "}";
    }
}

public class TransientExample {
    public static void main(String[] args) {
        User user = new User("alice", "secret123", 999, 1001);
        System.out.println("Original user: " + user);
        
        // Serialize
        try (ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream("user.ser"))) {
            oos.writeObject(user);
            System.out.println("User serialized");
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // Deserialize
        try (ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream("user.ser"))) {
            User deserializedUser = (User) ois.readObject();
            System.out.println("Deserialized user: " + deserializedUser);
            
            // Transient fields will be null/default values
            // password = null, sessionId = 0
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
```

---

## Sealed Classes (Java 17+)

### Sealed Class nima?
**Sealed Class** - inheritance ni nazorat qilish (faqat ruxsat berilgan class'lar extends olishi mumkin).

```java
// Sealed class with permits
sealed class Shape permits Circle, Rectangle, Triangle {
    public abstract double getArea();
}

// Final subclass (cannot be extended further)
final class Circle extends Shape {
    private double radius;
    
    public Circle(double radius) {
        this.radius = radius;
    }
    
    @Override
    public double getArea() {
        return Math.PI * radius * radius;
    }
}

// Sealed subclass (can have its own permitted subclasses)
sealed class Rectangle extends Shape permits Square {
    protected double width;
    protected double height;
    
    public Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }
    
    @Override
    public double getArea() {
        return width * height;
    }
}

// Non-sealed subclass (can be freely extended)
non-sealed class Triangle extends Shape {
    private double base;
    private double height;
    
    public Triangle(double base, double height) {
        this.base = base;
        this.height = height;
    }
    
    @Override
    public double getArea() {
        return 0.5 * base * height;
    }
}

// Subclass of Rectangle
final class Square extends Rectangle {
    public Square(double side) {
        super(side, side);
    }
}

// Can extend non-sealed class
class EquilateralTriangle extends Triangle {
    public EquilateralTriangle(double side) {
        super(side, side * Math.sqrt(3) / 2);
    }
}

public class SealedClassExample {
    public static void main(String[] args) {
        Shape[] shapes = {
            new Circle(5.0),
            new Rectangle(4.0, 6.0),
            new Triangle(3.0, 4.0),
            new Square(5.0),
            new EquilateralTriangle(6.0)
        };
        
        for (Shape shape : shapes) {
            System.out.println(shape.getClass().getSimpleName() + 
                             " area: " + shape.getArea());
        }
        
        // Pattern matching with sealed classes (Java 17+)
        System.out.println("\n=== PATTERN MATCHING ===");
        for (Shape shape : shapes) {
            String description = switch (shape) {
                case Circle c -> "Circle with radius";
                case Square s -> "Square with side " + s.width;
                case Rectangle r -> "Rectangle " + r.width + "x" + r.height;
                case Triangle t -> "Triangle";
                default -> "Unknown shape";
            };
            System.out.println(description + ": " + shape.getArea());
        }
    }
}
```

---

## Record Classes (Java 16+)

### Record Class nima?
**Record Class** - ma'lumot tashuvchi class (auto-generated methods).

```java
import java.util.Objects;

// Traditional Java class for comparison
class TraditionalPerson {
    private final String name;
    private final int age;
    private final String email;
    
    public TraditionalPerson(String name, int age, String email) {
        this.name = name;
        this.age = age;
        this.email = email;
    }
    
    // Getters
    public String getName() { return name; }
    public int getAge() { return age; }
    public String getEmail() { return email; }
    
    // toString, equals, hashCode - must write manually
    @Override
    public String toString() {
        return "TraditionalPerson{name='" + name + "', age=" + age + 
               ", email='" + email + "'}";
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof TraditionalPerson)) return false;
        TraditionalPerson that = (TraditionalPerson) o;
        return age == that.age && 
               Objects.equals(name, that.name) && 
               Objects.equals(email, that.email);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(name, age, email);
    }
}

// Record class (same functionality, much less code)
record Person(String name, int age, String email) {
    // Compact constructor (validation)
    public Person {
        if (age < 0) {
            throw new IllegalArgumentException("Age cannot be negative");
        }
        if (email == null || !email.contains("@")) {
            throw new IllegalArgumentException("Invalid email");
        }
        // name, age, email are automatically assigned
    }
    
    // Custom method
    public boolean isAdult() {
        return age >= 18;
    }
    
    // Static method
    public static Person createDefault() {
        return new Person("Unknown", 0, "unknown@example.com");
    }
}

// Record with nested record
record Address(String street, String city, String zipCode) {}

// Record implementing interface
record Employee(String name, int id, Address address) implements Comparable<Employee> {
    @Override
    public int compareTo(Employee other) {
        return Integer.compare(this.id, other.id);
    }
}

public class RecordClassExample {
    public static void main(String[] args) {
        System.out.println("=== RECORD CLASS DEMO ===");
        
        // Create record instances
        Person person1 = new Person("Alice", 25, "alice@example.com");
        Person person2 = new Person("Bob", 30, "bob@example.com");
        Person person3 = new Person("Alice", 25, "alice@example.com");
        
        // Auto-generated methods work
        System.out.println("Person1: " + person1);  // toString()
        System.out.println("Name: " + person1.name());  // Getter (no 'get' prefix)
        System.out.println("Age: " + person1.age());
        System.out.println("Is adult: " + person1.isAdult());
        
        // equals() and hashCode() work
        System.out.println("\nperson1.equals(person2): " + person1.equals(person2));
        System.out.println("person1.equals(person3): " + person1.equals(person3));
        System.out.println("person1.hashCode(): " + person1.hashCode());
        System.out.println("person3.hashCode(): " + person3.hashCode());
        
        // Pattern matching with records (Java 17+)
        System.out.println("\n=== PATTERN MATCHING ===");
        Object obj = new Person("Charlie", 35, "charlie@example.com");
        
        if (obj instanceof Person p) {
            System.out.println("It's a person: " + p.name());
            System.out.println("Deconstructed: " + p.name() + ", " + p.age());
        }
        
        // Nested records
        Address address = new Address("123 Main St", "New York", "10001");
        Employee employee = new Employee("David", 1001, address);
        System.out.println("\nEmployee: " + employee);
        System.out.println("Employee address: " + employee.address());
        
        // Record limitations
        System.out.println("\n=== RECORD LIMITATIONS ===");
        
        // Records are implicitly final
        // Records cannot extend other classes (implicitly extend Record)
        // Records can implement interfaces
        // All fields are final
        // Cannot add instance fields (only static fields allowed)
        
        // Local records (Java 16+)
        record Point(int x, int y) {}
        Point p1 = new Point(10, 20);
        Point p2 = new Point(30, 40);
        System.out.println("Distance: " + distance(p1, p2));
    }
    
    public static double distance(Point p1, Point p2) {
        int dx = p1.x() - p2.x();
        int dy = p1.y() - p2.y();
        return Math.sqrt(dx * dx + dy * dy);
    }
}
```

---

## Instance Initializer Block

### Instance Initializer Block nima?
Har bir konstruktor chaqirilganda ishlaydigan kod bloki.

```java
class InstanceBlockExample {
    // Instance variables
    private int x;
    private int y;
    private String name;
    private static int counter = 0;
    
    // Instance initializer block 1
    {
        System.out.println("Instance block 1 executed");
        x = 10;
        counter++;
        System.out.println("Counter: " + counter);
    }
    
    // Instance initializer block 2
    {
        System.out.println("Instance block 2 executed");
        y = 20;
    }
    
    // Constructor 1
    public InstanceBlockExample() {
        System.out.println("Default constructor");
        name = "Default";
    }
    
    // Constructor 2
    public InstanceBlockExample(String name) {
        System.out.println("Parameterized constructor");
        this.name = name;
    }
    
    // Constructor 3
    public InstanceBlockExample(String name, int x, int y) {
        System.out.println("Full constructor");
        this.name = name;
        this.x = x;
        this.y = y;
    }
    
    public void display() {
        System.out.println("Name: " + name + ", x: " + x + ", y: " + y);
    }
}

// Parent-Child example with instance blocks
class Parent {
    // Parent instance block
    {
        System.out.println("Parent instance block");
    }
    
    // Parent constructor
    public Parent() {
        System.out.println("Parent constructor");
    }
}

class Child extends Parent {
    // Child instance block
    {
        System.out.println("Child instance block");
    }
    
    // Child constructor
    public Child() {
        System.out.println("Child constructor");
    }
}

public class InitializerBlocks {
    public static void main(String[] args) {
        System.out.println("=== INSTANCE BLOCKS ===");
        
        // Create objects - instance blocks run for each constructor
        InstanceBlockExample obj1 = new InstanceBlockExample();
        obj1.display();
        
        System.out.println("\n--- Second object ---");
        InstanceBlockExample obj2 = new InstanceBlockExample("Custom");
        obj2.display();
        
        System.out.println("\n--- Third object ---");
        InstanceBlockExample obj3 = new InstanceBlockExample("Full", 100, 200);
        obj3.display();
        
        System.out.println("\n=== INHERITANCE WITH INSTANCE BLOCKS ===");
        Child child = new Child();
        // Execution order:
        // 1. Parent instance block
        // 2. Parent constructor
        // 3. Child instance block
        // 4. Child constructor
    }
}
```

### Static vs Instance Initializer Block:

| Xususiyat | Static Block | Instance Block |
|-----------|-------------|----------------|
| **Ish vaqti** | Class yuklanganda | Har bir konstruktor chaqirilganda |
| **Chaqirilish** | Bir marta | Har bir obyekt yaratilganda |
| **Access** | Faqat static member'lar | Static va instance member'lar |
| **`this`** | Ishlatilmaydi | Ishlatilishi mumkin |
| **Superclass** | Superclass static block avval | Superclass instance block avval |

---

## Variable Shadowing va Hiding

### Variable Shadowing (O'zgaruvchi soyasi):
Local variable instance variable bilan bir nomda bo'lsa.

```java
class ShadowExample {
    private String name = "Instance variable";
    private int value = 100;
    
    public void shadowTest() {
        // Local variable shadows instance variable
        String name = "Local variable";
        int value = 200;
        
        System.out.println("Local name: " + name);  // Local variable
        System.out.println("Local value: " + value); // Local value
        
        // Access instance variable using 'this'
        System.out.println("Instance name: " + this.name);  // Instance variable
        System.out.println("Instance value: " + this.value); // Instance value
    }
    
    // Parameter shadows instance variable
    public void setValue(int value) {
        // 'value' parameter shadows instance variable
        this.value = value;  // Use 'this' to access instance variable
    }
}

public class VariableShadowing {
    public static void main(String[] args) {
        ShadowExample example = new ShadowExample();
        example.shadowTest();
        example.setValue(500);
    }
}
```

### Variable Hiding (O'zgaruvchi yashirishi):
Child class variable parent class variable bilan bir nomda bo'lsa.

```java
class Parent {
    String message = "Parent message";
    static String staticMessage = "Parent static message";
    
    public void display() {
        System.out.println("Parent: " + message);
    }
    
    public static void staticDisplay() {
        System.out.println("Parent static: " + staticMessage);
    }
}

class Child extends Parent {
    // Hides parent's instance variable
    String message = "Child message";
    
    // Hides parent's static variable
    static String staticMessage = "Child static message";
    
    @Override
    public void display() {
        System.out.println("Child: " + message);
        System.out.println("Parent from child: " + super.message);
    }
    
    // Hides parent's static method (not override)
    public static void staticDisplay() {
        System.out.println("Child static: " + staticMessage);
        System.out.println("Parent static from child: " + Parent.staticMessage);
    }
}

public class VariableHiding {
    public static void main(String[] args) {
        Parent parent = new Parent();
        Child child = new Child();
        Parent polymorphic = new Child();
        
        System.out.println("=== INSTANCE VARIABLE HIDING ===");
        System.out.println("Parent.message: " + parent.message);
        System.out.println("Child.message: " + child.message);
        System.out.println("Polymorphic.message: " + polymorphic.message); // Parent's
        
        System.out.println("\n=== STATIC VARIABLE HIDING ===");
        System.out.println("Parent.staticMessage: " + Parent.staticMessage);
        System.out.println("Child.staticMessage: " + Child.staticMessage);
        
        System.out.println("\n=== METHOD CALLS ===");
        parent.display();
        child.display();
        polymorphic.display(); // Child's overridden method
        
        System.out.println("\n=== STATIC METHOD HIDING ===");
        Parent.staticDisplay();
        Child.staticDisplay();
        polymorphic.staticDisplay(); // Parent's static method (no polymorphism)
    }
}
```

---

## O'z-o'zini Tekshirish

### Savol 1: final, abstract va static modifier'lar qaysi elementlar bilan ishlatilishi mumkin?

### Savol 2: synchronized va volatile farqi nimada?

### Savol 3: Record class'ning afzalliklari nima?

---

## Keyingi Mavzu: [Enum Classes va Design Patterns](./11_Enum_DesignPatterns.md)
**[Mundarijaga qaytish](../README.md)**

> ⚡️ **Eslatma:** Modifier'lar - Java'ning kuchli vositalari. Ularni to'g'ri ishlatish kodning sifati, xavfsizligi va samaradorligini oshiradi. "With great power comes great responsibility!"