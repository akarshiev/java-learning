# 04 - Polymorphism (Ko'p shakllilik)

## Polymorphism nima?

**Polymorphism** - bu "ko'p shakllilik" degan ma'noni anglatadi. Bu OOP ning asosiy ustunlaridan biri bo'lib, bir xil interfeys yordamida turli xil amallarni bajarish imkonini beradi.

### Polymorphism turlari:
1. **Static/Compile-time Polymorphism** - Kompilyatsiya vaqtida aniqlanadi
2. **Dynamic/Runtime Polymorphism** - Ish vaqtida aniqlanadi

---

## 1. Static Polymorphism (Method Overloading)

### Method Overloading nima?
Bir class ichida nomi bir xil, lekin parametrlari farq qiluvchi bir nechta methodlar mavjud bo'lishi.

### Asosiy qoidalari:
1. **Method nomi** bir xil bo'lishi kerak
2. **Parametrlar** farq qilishi kerak:
    - Parametrlar soni farqli bo'lishi
    - Parametrlar turlari farqli bo'lishi
    - Parametrlar tartibi farqli bo'lishi
3. **Return type** farq qilishi yoki bir xil bo'lishi mumkin
4. **Access modifier** farq qilishi mumkin

### Method Signature (Method Imzosi):
Method signature = Method nomi + Parametrlar turi va tartibi  
**Return type va access modifier method signature'ga kirmaydi!**

### Overloading misollari:

#### 1. Parametrlar soni bilan:
```java
class Calculator {
    // Method 1: Ikkita int parametr
    public int add(int a, int b) {
        System.out.println("int add called");
        return a + b;
    }
    
    // Method 2: Uchta int parametr
    public int add(int a, int b, int c) {
        System.out.println("three int add called");
        return a + b + c;
    }
    
    // Method 3: To'rtta int parametr
    public int add(int a, int b, int c, int d) {
        System.out.println("four int add called");
        return a + b + c + d;
    }
}

public class OverloadingExample1 {
    public static void main(String[] args) {
        Calculator calc = new Calculator();
        
        System.out.println(calc.add(10, 20));       // int add called
        System.out.println(calc.add(10, 20, 30));   // three int add called
        System.out.println(calc.add(10, 20, 30, 40)); // four int add called
    }
}
```

#### 2. Parametr turlari bilan:
```java
class Display {
    // Method 1: String parametr
    public void show(String message) {
        System.out.println("String: " + message);
    }
    
    // Method 2: int parametr
    public void show(int number) {
        System.out.println("int: " + number);
    }
    
    // Method 3: double parametr
    public void show(double number) {
        System.out.println("double: " + number);
    }
    
    // Method 4: char parametr
    public void show(char character) {
        System.out.println("char: " + character);
    }
}

public class OverloadingExample2 {
    public static void main(String[] args) {
        Display display = new Display();
        
        display.show("Hello");       // String: Hello
        display.show(100);           // int: 100
        display.show(99.99);         // double: 99.99
        display.show('A');           // char: A
    }
}
```

#### 3. Parametrlar tartibi bilan:
```java
class StudentInfo {
    // Method 1: String, int
    public void display(String name, int age) {
        System.out.println("Name: " + name + ", Age: " + age);
    }
    
    // Method 2: int, String (tartib farqi)
    public void display(int age, String name) {
        System.out.println("Age: " + age + ", Name: " + name);
    }
    
    // Method 3: String, String, int
    public void display(String firstName, String lastName, int age) {
        System.out.println("Full Name: " + firstName + " " + lastName + ", Age: " + age);
    }
}

public class OverloadingExample3 {
    public static void main(String[] args) {
        StudentInfo info = new StudentInfo();
        
        info.display("Alice", 25);           // Name: Alice, Age: 25
        info.display(30, "Bob");             // Age: 30, Name: Bob
        info.display("Charlie", "Brown", 35); // Full Name: Charlie Brown, Age: 35
    }
}
```

#### 4. Return type bilan (faqat return type farqi yetmaydi):
```java
class Test {
    // BU ISHLAMAYDI! Faqat return type farqi yetmaydi
    /*
    public int process(int x) {
        return x * 2;
    }
    
    public double process(int x) {  // COMPILE ERROR!
        return x * 2.0;
    }
    */
    
    // To'g'ri: Parametrlar farq qilishi kerak
    public int process(int x) {
        return x * 2;
    }
    
    public double process(double x) {  // Parametr turi farqli
        return x * 2.0;
    }
}
```

### Automatic Type Promotion (Avtomatik Tur Oshirish):
Agar berilgan tur uchun method topilmasa, kompilyator kattaroq turga o'tkazishga harakat qiladi.

```java
class TypePromotion {
    public void show(int x) {
        System.out.println("int: " + x);
    }
    
    public void show(long x) {
        System.out.println("long: " + x);
    }
    
    public void show(float x) {
        System.out.println("float: " + x);
    }
    
    public void show(double x) {
        System.out.println("double: " + x);
    }
}

public class TypePromotionExample {
    public static void main(String[] args) {
        TypePromotion obj = new TypePromotion();
        
        obj.show(10);      // int: 10
        obj.show(10L);     // long: 10
        obj.show(10.5f);   // float: 10.5
        obj.show(10.5);    // double: 10.5
        
        // Type promotion examples:
        byte b = 10;
        obj.show(b);       // int: 10 (byte → int)
        
        short s = 20;
        obj.show(s);       // int: 20 (short → int)
        
        char c = 'A';
        obj.show(c);       // int: 65 (char → int)
        
        // Ambiguity xatosi:
        // obj.show(10.5f);  // float ga boradi
        // Agar float method bo'lmasa, double ga o'tadi
    }
}
```

### Ambiguity (Noaniqlik) Masalalari:
```java
class AmbiguityExample {
    public void display(int a, long b) {
        System.out.println("int, long");
    }
    
    public void display(long a, int b) {
        System.out.println("long, int");
    }
}

public class TestAmbiguity {
    public static void main(String[] args) {
        AmbiguityExample obj = new AmbiguityExample();
        
        obj.display(10, 20L);   // int, long
        obj.display(10L, 20);   // long, int
        
        // Bu noaniq - kompilyator qaysi methodni tanlashini bilmaydi
        // obj.display(10, 20);  // COMPILE ERROR! Ambiguous method call
    }
}
```

---

## 2. Dynamic Polymorphism (Method Overriding)

### Method Overriding nima?
Subclass da superclass'dagi methodni o'zgartirish (qayta yozish).

### Asosiy qoidalari:
1. **Method nomi** bir xil bo'lishi kerak
2. **Parametrlar** bir xil bo'lishi kerak
3. **Return type** bir xil yoki covariant (subclass) bo'lishi kerak
4. **Access modifier** bir xil yoki ko'proq ochiq bo'lishi kerak

### Access Modifier Qoidalari (Visibility must not be reduced):
```
private < default < protected < public
```

Subclass'dagi method access modifier'i parent class'dagidan kam ochiq bo'lmasligi kerak.

### Overriding misollari:

#### 1. Oddiy Overriding:
```java
// Parent class
class Animal {
    public void makeSound() {
        System.out.println("Animal makes sound");
    }
    
    public void eat() {
        System.out.println("Animal eats food");
    }
}

// Child class 1
class Dog extends Animal {
    @Override
    public void makeSound() {
        System.out.println("Dog barks: Woof woof!");
    }
    
    @Override
    public void eat() {
        System.out.println("Dog eats meat");
    }
}

// Child class 2
class Cat extends Animal {
    @Override
    public void makeSound() {
        System.out.println("Cat meows: Meow meow!");
    }
    
    @Override
    public void eat() {
        System.out.println("Cat eats fish");
    }
}

public class OverridingExample {
    public static void main(String[] args) {
        // Polymorphism in action
        Animal myAnimal;
        
        myAnimal = new Dog();
        myAnimal.makeSound();  // Dog barks: Woof woof!
        myAnimal.eat();        // Dog eats meat
        
        myAnimal = new Cat();
        myAnimal.makeSound();  // Cat meows: Meow meow!
        myAnimal.eat();        // Cat eats fish
        
        // Parent reference, child object
        Animal animal1 = new Dog();
        Animal animal2 = new Cat();
        
        animal1.makeSound();  // Runtime da aniqlanadi - Dog's method
        animal2.makeSound();  // Runtime da aniqlanadi - Cat's method
    }
}
```

#### 2. Covariant Return Type:
```java
class Parent {
    public Parent getInstance() {
        System.out.println("Parent instance");
        return new Parent();
    }
}

class Child extends Parent {
    @Override
    public Child getInstance() {  // Covariant return type
        System.out.println("Child instance");
        return new Child();
    }
}

public class CovariantExample {
    public static void main(String[] args) {
        Parent parent = new Parent();
        Parent p = parent.getInstance();  // Parent instance
        
        Child child = new Child();
        Child c = child.getInstance();    // Child instance
    }
}
```

#### 3. Access Modifier Qoidalari:
```java
class Parent {
    // Protected method
    protected void display() {
        System.out.println("Parent display");
    }
    
    // Public method
    public void show() {
        System.out.println("Parent show");
    }
}

class Child extends Parent {
    // To'g'ri: protected → public (visibility oshdi)
    @Override
    public void display() {
        System.out.println("Child display");
    }
    
    // XATO: public → protected (visibility kamaydi)
    /*
    @Override
    protected void show() {  // COMPILE ERROR!
        System.out.println("Child show");
    }
    */
}

public class AccessModifierExample {
    public static void main(String[] args) {
        Child child = new Child();
        child.display();  // Child display
        child.show();     // Parent show
    }
}
```

### Private Methodni Override qilish MUMKIN EMAS:
```java
class Parent {
    private void privateMethod() {
        System.out.println("Parent private method");
    }
    
    public void callPrivateMethod() {
        privateMethod();
    }
}

class Child extends Parent {
    // Bu override EMAS, yangi method
    private void privateMethod() {
        System.out.println("Child private method");
    }
    
    // Bu ham override EMAS
    public void privateMethod(int x) {
        System.out.println("Child overloaded method");
    }
}

public class PrivateMethodExample {
    public static void main(String[] args) {
        Child child = new Child();
        child.callPrivateMethod();  // Parent private method
    }
}
```

### `@Override` Annotation:
`@Override` annotation kompilyatorga bu method override qilinayotganligini bildiradi va xatolarni tekshirishga yordam beradi.

```java
class Parent {
    public void display(String message) {
        System.out.println(message);
    }
}

class Child extends Parent {
    @Override
    public void display(String message) {  // To'g'ri
        System.out.println("Child: " + message);
    }
    
    // XATO: @Override annotation xatoni ko'rsatadi
    /*
    @Override
    public void display(int number) {  // COMPILE ERROR!
        System.out.println(number);
    }
    */
}
```

---

## Upcasting va Downcasting

### Upcasting (Avtomatik):
```java
class Animal {
    public void makeSound() {
        System.out.println("Animal sound");
    }
}

class Dog extends Animal {
    @Override
    public void makeSound() {
        System.out.println("Dog barks");
    }
    
    public void wagTail() {
        System.out.println("Dog wags tail");
    }
}

public class CastingExample {
    public static void main(String[] args) {
        // Upcasting - avtomatik
        Animal animal = new Dog();  // Dog object, Animal reference
        
        animal.makeSound();  // Dog barks (polymorphism)
        // animal.wagTail();  // COMPILE ERROR! Animal reference bilan
        
        // Downcasting - qo'lda
        if (animal instanceof Dog) {
            Dog dog = (Dog) animal;  // Explicit cast
            dog.makeSound();   // Dog barks
            dog.wagTail();     // Dog wags tail
        }
        
        // Xavfli downcasting
        Animal cat = new Animal();
        // Dog d = (Dog) cat;  // RUNTIME ERROR! ClassCastException
    }
}
```

### `instanceof` Operator:
```java
public class InstanceOfExample {
    public static void main(String[] args) {
        Animal animal = new Dog();
        
        System.out.println(animal instanceof Animal);  // true
        System.out.println(animal instanceof Dog);     // true
        System.out.println(animal instanceof Object);  // true
        
        Animal realAnimal = new Animal();
        System.out.println(realAnimal instanceof Dog); // false
    }
}
```

---

## Method Hiding (Static Method Overriding)

Static method'lar override qilinmaydi, faqat hide (yashirish) qilinadi.

```java
class Parent {
    public static void staticMethod() {
        System.out.println("Parent static method");
    }
    
    public void instanceMethod() {
        System.out.println("Parent instance method");
    }
}

class Child extends Parent {
    // Bu override EMAS, method hiding
    public static void staticMethod() {
        System.out.println("Child static method");
    }
    
    // Bu override
    @Override
    public void instanceMethod() {
        System.out.println("Child instance method");
    }
}

public class MethodHidingExample {
    public static void main(String[] args) {
        Parent parent = new Parent();
        Child child = new Child();
        Parent poly = new Child();  // Polymorphic reference
        
        // Static methods - reference type bo'yicha chaqiriladi
        parent.staticMethod();  // Parent static method
        child.staticMethod();   // Child static method
        poly.staticMethod();    // Parent static method (NOT Child!)
        
        // Instance methods - object type bo'yicha chaqiriladi
        parent.instanceMethod();  // Parent instance method
        child.instanceMethod();   // Child instance method
        poly.instanceMethod();    // Child instance method (polymorphism)
    }
}
```

---

## Operator Overloading

Java operator overloading'ni qo'llab-quvvatlamaydi (faqat `+` operatori istisno).

### `+` Operator Overloading:
```java
public class OperatorOverloading {
    public static void main(String[] args) {
        // + operatorining turli xil ishlatilishi
        
        // 1. Raqamlar uchun - qo'shish
        int a = 10;
        int b = 20;
        System.out.println(a + b);  // 30
        
        // 2. String uchun - birlashtirish
        String s1 = "Hello";
        String s2 = " World";
        System.out.println(s1 + s2);  // Hello World
        
        // 3. Raqam va String - avtomatik conversion
        System.out.println("Number: " + 100);  // Number: 100
        
        // 4. Bir nechta birlashtirish
        System.out.println("Sum: " + 10 + 20);    // Sum: 1020 (String concatenation)
        System.out.println("Sum: " + (10 + 20));  // Sum: 30
        
        // 5. Object bilan
        Object obj = new Object();
        System.out.println("Object: " + obj);  // toString() avtomatik chaqiriladi
    }
}
```

---

## Amaliy Misol: Shape Hierarchy

```java
// Abstract base class
class Shape {
    public double getArea() {
        System.out.println("Shape area calculation");
        return 0;
    }
    
    public double getPerimeter() {
        System.out.println("Shape perimeter calculation");
        return 0;
    }
    
    public void draw() {
        System.out.println("Drawing shape");
    }
}

// Circle class
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
        System.out.println("Drawing circle with radius " + radius);
    }
}

// Rectangle class
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
        System.out.println("Drawing rectangle " + width + "x" + height);
    }
}

// Triangle class
class Triangle extends Shape {
    private double base;
    private double height;
    private double side1;
    private double side2;
    
    public Triangle(double base, double height, double side1, double side2) {
        this.base = base;
        this.height = height;
        this.side1 = side1;
        this.side2 = side2;
    }
    
    @Override
    public double getArea() {
        return 0.5 * base * height;
    }
    
    @Override
    public double getPerimeter() {
        return base + side1 + side2;
    }
    
    @Override
    public void draw() {
        System.out.println("Drawing triangle with base " + base + " and height " + height);
    }
}

// Main class with polymorphism
public class ShapeSystem {
    public static void main(String[] args) {
        // Polymorphic array
        Shape[] shapes = new Shape[4];
        
        shapes[0] = new Circle(5.0);
        shapes[1] = new Rectangle(4.0, 6.0);
        shapes[2] = new Triangle(3.0, 4.0, 5.0, 4.0);
        shapes[3] = new Circle(7.0);
        
        // Process all shapes polymorphically
        System.out.println("=== SHAPE INFORMATION ===");
        for (int i = 0; i < shapes.length; i++) {
            System.out.println("\nShape " + (i + 1) + ":");
            shapes[i].draw();
            System.out.println("Area: " + String.format("%.2f", shapes[i].getArea()));
            System.out.println("Perimeter: " + String.format("%.2f", shapes[i].getPerimeter()));
        }
        
        // Calculate total area
        double totalArea = 0;
        for (Shape shape : shapes) {
            totalArea += shape.getArea();
        }
        System.out.println("\n=== TOTAL AREA: " + String.format("%.2f", totalArea) + " ===");
        
        // Method overloading example in same class
        Calculator calculator = new Calculator();
        System.out.println("\n=== CALCULATOR OVERLOADING ===");
        System.out.println("Add two ints: " + calculator.add(10, 20));
        System.out.println("Add three ints: " + calculator.add(10, 20, 30));
        System.out.println("Add two doubles: " + calculator.add(10.5, 20.5));
        System.out.println("Add int and double: " + calculator.add(10, 20.5));
        System.out.println("Add double and int: " + calculator.add(10.5, 20));
    }
}

// Overloading demonstration
class Calculator {
    // Method 1: Add two integers
    public int add(int a, int b) {
        System.out.print("int + int: ");
        return a + b;
    }
    
    // Method 2: Add three integers
    public int add(int a, int b, int c) {
        System.out.print("int + int + int: ");
        return a + b + c;
    }
    
    // Method 3: Add two doubles
    public double add(double a, double b) {
        System.out.print("double + double: ");
        return a + b;
    }
    
    // Method 4: Add int and double
    public double add(int a, double b) {
        System.out.print("int + double: ");
        return a + b;
    }
    
    // Method 5: Add double and int
    public double add(double a, int b) {
        System.out.print("double + int: ");
        return a + b;
    }
}
```

---

## O'z-o'zini Tekshirish

### Savol 1: Quyidagi kod nimani chiqaradi?
```java
class A {
    void show() { System.out.println("A"); }
}

class B extends A {
    void show() { System.out.println("B"); }
}

class Test {
    public static void main(String[] args) {
        A obj = new B();
        obj.show();
    }
}
```

### Savol 2: Quyidagi method'lar overloadedmi?
```java
void process(int x) { }
void process(int y) { }  // Overloaded?
```

### Savol 3: Quyidagi kodda xato bormi?
```java
class Parent {
    public void display() { }
}

class Child extends Parent {
    private void display() { }  // Xato?
}
```

---

## Keyingi Mavzu: [05 - Abstraction va Interface (Abstraksiya va Interfeys)](./05_Abstraction_Interface.md)
**[Mundarijaga qaytish](../README.md)**

> ⚡️ **Eslatma:** Polymorphism - bu OOP ning eng kuchli xususiyatlaridan biri. Bu sizga moslashuvchan va kengaytirilishi oson dasturlar yaratish imkonini beradi. "Program to an interface, not an implementation" prinsipini eslang!