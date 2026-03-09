# 11 - Type Inference, Design Patterns, Enum Classes

## Type Inference (Tur Inferensiyasi)

### Type Inference nima?
**Type inference** - kompilyator tomonidan expression turini avtomatik aniqlash qobiliyati.

### var keyword (Java 10+)
```java
import java.util.*;
import java.time.*;

public class TypeInferenceExample {
    
    public static void main(String[] args) {
        System.out.println("=== TYPE INFERENCE WITH VAR ===");
        
        // Before Java 10
        String explicitString = "Explicit type";
        List<String> explicitList = new ArrayList<>();
        Map<String, Integer> explicitMap = new HashMap<>();
        
        // With var (Java 10+)
        var inferredString = "Inferred type";  // String
        var inferredList = new ArrayList<String>();  // ArrayList<String>
        var inferredMap = new HashMap<String, Integer>();  // HashMap<String, Integer>
        var inferredNumber = 42;  // int
        var inferredDecimal = 3.14;  // double
        var inferredBoolean = true;  // boolean
        var inferredDate = LocalDate.now();  // LocalDate
        
        System.out.println("String: " + inferredString);
        System.out.println("Number: " + inferredNumber);
        System.out.println("Date: " + inferredDate);
        
        // Enhanced for-loop with var
        var names = List.of("Alice", "Bob", "Charlie");
        for (var name : names) {
            System.out.println("Name: " + name);
        }
        
        // Try-with-resources with var
        try (var scanner = new Scanner(System.in)) {
            System.out.print("Enter something: ");
            var input = scanner.nextLine();
            System.out.println("You entered: " + input);
        }
        
        // Lambda with explicit types
        Comparator<String> explicitComparator = (String a, String b) -> a.length() - b.length();
        
        // Lambda with var (Java 11+)
        Comparator<String> varComparator = (var a, var b) -> a.length() - b.length();
        
        // Demonstrate var rules
        demonstrateVarRules();
    }
    
    public static void demonstrateVarRules() {
        System.out.println("\n=== VAR RULES ===");
        
        // ✅ OK: Local variable with initialization
        var message = "Hello";
        var number = 100;
        var list = new ArrayList<String>();
        
        // ✅ OK: var in for-loop
        for (var i = 0; i < 3; i++) {
            System.out.println("i = " + i);
        }
        
        // ✅ OK: var in try-with-resources
        try (var file = new java.io.FileInputStream("test.txt")) {
            // read file
        } catch (Exception e) {
            // Handle exception
        }
        
        // ⚠️ Limitations:
        
        // ❌ ERROR: Cannot use var without initialization
        // var uninitialized;
        
        // ❌ ERROR: Cannot initialize with null (ambiguous type)
        // var nullValue = null;
        
        // ❌ ERROR: Cannot use var for method parameters
        // public void method(var param) { }
        
        // ❌ ERROR: Cannot use var for method return type
        // public var getValue() { return 42; }
        
        // ❌ ERROR: Cannot use var for instance variables
        // private var instanceVar = "test";
        
        // ❌ ERROR: Cannot use var for catch parameter
        // try { } catch (var e) { }
        
        // ✅ But can use with explicit type on right side
        var nullString = (String) null;
        var integerList = new ArrayList<Integer>();
        
        // ❌ ERROR: Cannot use var with lambda without context
        // var lambda = () -> "Hello";
        
        // ✅ OK: With explicit type context
        var runnable = (Runnable) () -> System.out.println("Running");
        
        System.out.println("All var rules demonstrated");
    }
    
    // Practical var usage examples
    public static void practicalVarExamples() {
        // 1. Complex generic types
        var complexMap = new HashMap<List<String>, Map<Integer, Set<Double>>>();
        
        // 2. Anonymous classes
        var comparator = new Comparator<String>() {
            @Override
            public int compare(String s1, String s2) {
                return s1.length() - s2.length();
            }
        };
        
        // 3. Stream operations
        var stream = Stream.of("a", "b", "c")
            .filter(s -> s.length() > 0)
            .map(String::toUpperCase);
        
        // 4. Local variable type inference with diamond operator
        var items = new ArrayList<>();  // ArrayList<Object>
        var strings = new ArrayList<String>();  // ArrayList<String>
        
        // 5. Pattern matching (Java 16+ preview)
        Object obj = "Hello";
        if (obj instanceof var s) {
            System.out.println("String length: " + s.length());
        }
    }
}
```

---

## Design Patterns (Dizayn Pattern'lar)

### Design Pattern nima?
**Design pattern** - takrorlanadigan muammolarni hal qilishning tasdiqlangan yechimlari.

### 3 Asosiy Tur:

#### 1. Creational (Yaratuvchi) Patterns - Obyekt yaratish
#### 2. Structural (Strukturaviy) Patterns - Obyektlar orasidagi bog'lanish
#### 3. Behavioral (Xatti-harakat) Patterns - Obyektlar o'rtasidagi muloqot

---

## Creational Design Patterns

### 1. Factory Method Pattern
```java
// Product interface
interface Vehicle {
    void manufacture();
    void deliver();
}

// Concrete products
class Car implements Vehicle {
    @Override
    public void manufacture() {
        System.out.println("Manufacturing Car");
        // Complex car manufacturing process
    }
    
    @Override
    public void deliver() {
        System.out.println("Delivering Car to dealership");
    }
}

class Motorcycle implements Vehicle {
    @Override
    public void manufacture() {
        System.out.println("Manufacturing Motorcycle");
        // Complex motorcycle manufacturing process
    }
    
    @Override
    public void deliver() {
        System.out.println("Delivering Motorcycle to showroom");
    }
}

class Truck implements Vehicle {
    @Override
    public void manufacture() {
        System.out.println("Manufacturing Truck");
        // Complex truck manufacturing process
    }
    
    @Override
    public void deliver() {
        System.out.println("Delivering Truck to transport company");
    }
}

// Creator (Factory) class
abstract class VehicleFactory {
    // Factory method
    public abstract Vehicle createVehicle();
    
    // Some operation that uses the product
    public void manufactureAndDeliver() {
        Vehicle vehicle = createVehicle();
        vehicle.manufacture();
        vehicle.deliver();
    }
}

// Concrete creators
class CarFactory extends VehicleFactory {
    @Override
    public Vehicle createVehicle() {
        return new Car();
    }
}

class MotorcycleFactory extends VehicleFactory {
    @Override
    public Vehicle createVehicle() {
        return new Motorcycle();
    }
}

class TruckFactory extends VehicleFactory {
    @Override
    public Vehicle createVehicle() {
        return new Truck();
    }
}

// Client code
public class FactoryMethodExample {
    public static void main(String[] args) {
        System.out.println("=== FACTORY METHOD PATTERN ===");
        
        VehicleFactory factory;
        
        // Create car
        factory = new CarFactory();
        factory.manufactureAndDeliver();
        
        // Create motorcycle
        factory = new MotorcycleFactory();
        factory.manufactureAndDeliver();
        
        // Create truck
        factory = new TruckFactory();
        factory.manufactureAndDeliver();
        
        // Using parameterized factory method
        Vehicle vehicle = createVehicle("car");
        vehicle.manufacture();
    }
    
    // Parameterized factory method (alternative approach)
    public static Vehicle createVehicle(String type) {
        return switch (type.toLowerCase()) {
            case "car" -> new Car();
            case "motorcycle" -> new Motorcycle();
            case "truck" -> new Truck();
            default -> throw new IllegalArgumentException("Unknown vehicle type: " + type);
        };
    }
}
```

### 2. Builder Pattern
```java
// Complex object to build
class Computer {
    private String CPU;
    private String RAM;
    private String storage;
    private String graphicsCard;
    private String powerSupply;
    private boolean hasSSD;
    private boolean hasWifi;
    
    private Computer(ComputerBuilder builder) {
        this.CPU = builder.CPU;
        this.RAM = builder.RAM;
        this.storage = builder.storage;
        this.graphicsCard = builder.graphicsCard;
        this.powerSupply = builder.powerSupply;
        this.hasSSD = builder.hasSSD;
        this.hasWifi = builder.hasWifi;
    }
    
    @Override
    public String toString() {
        return "Computer{" +
               "CPU='" + CPU + '\'' +
               ", RAM='" + RAM + '\'' +
               ", storage='" + storage + '\'' +
               ", graphicsCard='" + graphicsCard + '\'' +
               ", powerSupply='" + powerSupply + '\'' +
               ", hasSSD=" + hasSSD +
               ", hasWifi=" + hasWifi +
               '}';
    }
    
    // Builder class
    public static class ComputerBuilder {
        // Required parameters
        private final String CPU;
        private final String RAM;
        
        // Optional parameters
        private String storage = "1TB HDD";
        private String graphicsCard = "Integrated";
        private String powerSupply = "500W";
        private boolean hasSSD = false;
        private boolean hasWifi = false;
        
        public ComputerBuilder(String CPU, String RAM) {
            this.CPU = CPU;
            this.RAM = RAM;
        }
        
        public ComputerBuilder storage(String storage) {
            this.storage = storage;
            return this;
        }
        
        public ComputerBuilder graphicsCard(String graphicsCard) {
            this.graphicsCard = graphicsCard;
            return this;
        }
        
        public ComputerBuilder powerSupply(String powerSupply) {
            this.powerSupply = powerSupply;
            return this;
        }
        
        public ComputerBuilder hasSSD(boolean hasSSD) {
            this.hasSSD = hasSSD;
            return this;
        }
        
        public ComputerBuilder hasWifi(boolean hasWifi) {
            this.hasWifi = hasWifi;
            return this;
        }
        
        public Computer build() {
            // Validate parameters
            validate();
            return new Computer(this);
        }
        
        private void validate() {
            if (CPU == null || CPU.isEmpty()) {
                throw new IllegalArgumentException("CPU is required");
            }
            if (RAM == null || RAM.isEmpty()) {
                throw new IllegalArgumentException("RAM is required");
            }
        }
    }
}

public class BuilderPatternExample {
    public static void main(String[] args) {
        System.out.println("=== BUILDER PATTERN ===");
        
        // Build a basic computer
        Computer basicComputer = new Computer.ComputerBuilder("Intel i5", "8GB")
            .build();
        System.out.println("Basic Computer: " + basicComputer);
        
        // Build a gaming computer
        Computer gamingComputer = new Computer.ComputerBuilder("AMD Ryzen 9", "32GB")
            .storage("2TB SSD")
            .graphicsCard("NVIDIA RTX 4080")
            .powerSupply("850W Gold")
            .hasSSD(true)
            .hasWifi(true)
            .build();
        System.out.println("Gaming Computer: " + gamingComputer);
        
        // Build an office computer
        Computer officeComputer = new Computer.ComputerBuilder("Intel i3", "16GB")
            .storage("512GB SSD")
            .hasWifi(true)
            .build();
        System.out.println("Office Computer: " + officeComputer);
        
        // Fluent interface with method chaining
        Computer customComputer = new Computer.ComputerBuilder("Intel i7", "16GB")
            .storage("1TB SSD")
            .graphicsCard("NVIDIA GTX 1660")
            .powerSupply("650W")
            .hasSSD(true)
            .hasWifi(true)
            .build();
        System.out.println("Custom Computer: " + customComputer);
    }
}
```

### 3. Singleton Pattern
```java
import java.io.*;

// 1. Eager initialization
class EagerSingleton {
    private static final EagerSingleton INSTANCE = new EagerSingleton();
    
    private EagerSingleton() {
        // Private constructor to prevent instantiation
        System.out.println("EagerSingleton created");
    }
    
    public static EagerSingleton getInstance() {
        return INSTANCE;
    }
    
    public void showMessage() {
        System.out.println("Hello from EagerSingleton");
    }
}

// 2. Lazy initialization (thread-safe)
class LazySingleton {
    private static volatile LazySingleton instance;
    
    private LazySingleton() {
        System.out.println("LazySingleton created");
    }
    
    public static LazySingleton getInstance() {
        if (instance == null) {
            synchronized (LazySingleton.class) {
                if (instance == null) {
                    instance = new LazySingleton();
                }
            }
        }
        return instance;
    }
    
    public void showMessage() {
        System.out.println("Hello from LazySingleton");
    }
}

// 3. Bill Pugh Singleton (Inner static helper class)
class BillPughSingleton {
    private BillPughSingleton() {
        System.out.println("BillPughSingleton created");
    }
    
    private static class SingletonHelper {
        private static final BillPughSingleton INSTANCE = new BillPughSingleton();
    }
    
    public static BillPughSingleton getInstance() {
        return SingletonHelper.INSTANCE;
    }
    
    public void showMessage() {
        System.out.println("Hello from BillPughSingleton");
    }
}

// 4. Enum Singleton (Best approach for Java)
enum EnumSingleton {
    INSTANCE;
    
    private EnumSingleton() {
        System.out.println("EnumSingleton created");
    }
    
    public void showMessage() {
        System.out.println("Hello from EnumSingleton");
    }
    
    // Add business methods
    private String data = "Default data";
    
    public String getData() {
        return data;
    }
    
    public void setData(String data) {
        this.data = data;
    }
}

// 5. Serializable Singleton
class SerializableSingleton implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private static SerializableSingleton instance = new SerializableSingleton();
    
    private SerializableSingleton() {
        System.out.println("SerializableSingleton created");
    }
    
    public static SerializableSingleton getInstance() {
        return instance;
    }
    
    public void showMessage() {
        System.out.println("Hello from SerializableSingleton");
    }
    
    // This method is called during deserialization
    protected Object readResolve() {
        return getInstance();
    }
}

public class SingletonPatternExample {
    public static void main(String[] args) {
        System.out.println("=== SINGLETON PATTERN ===");
        
        // Test Eager Singleton
        System.out.println("\n1. Eager Singleton:");
        EagerSingleton eager1 = EagerSingleton.getInstance();
        EagerSingleton eager2 = EagerSingleton.getInstance();
        eager1.showMessage();
        System.out.println("Same instance? " + (eager1 == eager2));
        
        // Test Lazy Singleton
        System.out.println("\n2. Lazy Singleton:");
        LazySingleton lazy1 = LazySingleton.getInstance();
        LazySingleton lazy2 = LazySingleton.getInstance();
        lazy1.showMessage();
        System.out.println("Same instance? " + (lazy1 == lazy2));
        
        // Test Bill Pugh Singleton
        System.out.println("\n3. Bill Pugh Singleton:");
        BillPughSingleton billPugh1 = BillPughSingleton.getInstance();
        BillPughSingleton billPugh2 = BillPughSingleton.getInstance();
        billPugh1.showMessage();
        System.out.println("Same instance? " + (billPugh1 == billPugh2));
        
        // Test Enum Singleton
        System.out.println("\n4. Enum Singleton:");
        EnumSingleton enum1 = EnumSingleton.INSTANCE;
        EnumSingleton enum2 = EnumSingleton.INSTANCE;
        enum1.showMessage();
        System.out.println("Same instance? " + (enum1 == enum2));
        
        // Test Serializable Singleton
        System.out.println("\n5. Serializable Singleton:");
        testSerializableSingleton();
        
        // Thread safety test
        System.out.println("\n6. Thread Safety Test:");
        testThreadSafety();
    }
    
    private static void testSerializableSingleton() {
        try {
            SerializableSingleton instance1 = SerializableSingleton.getInstance();
            
            // Serialize
            ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream("singleton.ser"));
            out.writeObject(instance1);
            out.close();
            
            // Deserialize
            ObjectInputStream in = new ObjectInputStream(new FileInputStream("singleton.ser"));
            SerializableSingleton instance2 = (SerializableSingleton) in.readObject();
            in.close();
            
            System.out.println("Instance1 hashCode: " + instance1.hashCode());
            System.out.println("Instance2 hashCode: " + instance2.hashCode());
            System.out.println("Same instance after deserialization? " + (instance1 == instance2));
            
            // Clean up
            new File("singleton.ser").delete();
            
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    private static void testThreadSafety() {
        Runnable task = () -> {
            LazySingleton singleton = LazySingleton.getInstance();
            System.out.println(Thread.currentThread().getName() + 
                             " - Singleton hashCode: " + singleton.hashCode());
        };
        
        Thread[] threads = new Thread[5];
        for (int i = 0; i < threads.length; i++) {
            threads[i] = new Thread(task, "Thread-" + i);
        }
        
        for (Thread thread : threads) {
            thread.start();
        }
        
        for (Thread thread : threads) {
            try {
                thread.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
```

---

## Enum Classes

### Enum nima?
**Enum** - o'zgaruvchi uchun oldindan belgilangan konstantalar to'plami.

```java
import java.time.DayOfWeek;

// Basic enum
enum Priority {
    LOW,      // 0
    MEDIUM,   // 1
    HIGH,     // 2
    CRITICAL  // 3
}

// Enum with constructor and methods
enum HttpStatus {
    // Enum constants with values
    OK(200, "OK"),
    CREATED(201, "Created"),
    BAD_REQUEST(400, "Bad Request"),
    UNAUTHORIZED(401, "Unauthorized"),
    NOT_FOUND(404, "Not Found"),
    INTERNAL_SERVER_ERROR(500, "Internal Server Error");
    
    // Fields
    private final int code;
    private final String description;
    
    // Constructor
    HttpStatus(int code, String description) {
        this.code = code;
        this.description = description;
    }
    
    // Methods
    public int getCode() {
        return code;
    }
    
    public String getDescription() {
        return description;
    }
    
    public boolean isSuccess() {
        return code >= 200 && code < 300;
    }
    
    public boolean isError() {
        return code >= 400;
    }
    
    // Static method to get enum from code
    public static HttpStatus fromCode(int code) {
        for (HttpStatus status : values()) {
            if (status.code == code) {
                return status;
            }
        }
        throw new IllegalArgumentException("No status with code: " + code);
    }
}

// Enum with abstract method (strategy pattern)
enum Operation {
    ADD {
        @Override
        public double apply(double x, double y) {
            return x + y;
        }
    },
    SUBTRACT {
        @Override
        public double apply(double x, double y) {
            return x - y;
        }
    },
    MULTIPLY {
        @Override
        public double apply(double x, double y) {
            return x * y;
        }
    },
    DIVIDE {
        @Override
        public double apply(double x, double y) {
            if (y == 0) {
                throw new ArithmeticException("Division by zero");
            }
            return x / y;
        }
    };
    
    // Abstract method
    public abstract double apply(double x, double y);
}

// Enum implementing interface
interface Drawable {
    void draw();
}

enum Shape implements Drawable {
    CIRCLE {
        @Override
        public void draw() {
            System.out.println("Drawing a circle");
        }
    },
    SQUARE {
        @Override
        public void draw() {
            System.out.println("Drawing a square");
        }
    },
    TRIANGLE {
        @Override
        public void draw() {
            System.out.println("Drawing a triangle");
        }
    };
}

// Singleton enum
enum DatabaseConnection {
    INSTANCE;
    
    private Connection connection;
    
    DatabaseConnection() {
        // Initialize database connection
        System.out.println("Database connection created");
        // this.connection = DriverManager.getConnection(...);
    }
    
    public Connection getConnection() {
        return connection;
    }
    
    public void query(String sql) {
        System.out.println("Executing query: " + sql);
        // Execute query
    }
}

public class EnumClassesExample {
    public static void main(String[] args) {
        System.out.println("=== ENUM CLASSES ===");
        
        // Basic enum usage
        System.out.println("\n1. Basic Enum:");
        Priority priority = Priority.HIGH;
        System.out.println("Priority: " + priority);
        System.out.println("Ordinal: " + priority.ordinal());
        System.out.println("Name: " + priority.name());
        
        // Enum values and iteration
        System.out.println("\n2. All Priorities:");
        for (Priority p : Priority.values()) {
            System.out.println(p + " -> ordinal: " + p.ordinal());
        }
        
        // Enum with methods
        System.out.println("\n3. HTTP Status Enum:");
        HttpStatus status = HttpStatus.OK;
        System.out.println(status + " -> Code: " + status.getCode() + 
                         ", Description: " + status.getDescription());
        System.out.println("Is success? " + status.isSuccess());
        
        // Switch statement with enum
        System.out.println("\n4. Switch with Enum:");
        Priority currentPriority = Priority.MEDIUM;
        switch (currentPriority) {
            case LOW -> System.out.println("Low priority - process when possible");
            case MEDIUM -> System.out.println("Medium priority - process soon");
            case HIGH -> System.out.println("High priority - process immediately");
            case CRITICAL -> System.out.println("Critical priority - drop everything!");
        }
        
        // Enum with abstract method (Strategy pattern)
        System.out.println("\n5. Operation Enum (Strategy Pattern):");
        double x = 10, y = 5;
        for (Operation op : Operation.values()) {
            try {
                double result = op.apply(x, y);
                System.out.println(x + " " + op.name() + " " + y + " = " + result);
            } catch (ArithmeticException e) {
                System.out.println("Error: " + e.getMessage());
            }
        }
        
        // Enum implementing interface
        System.out.println("\n6. Shape Enum implementing Drawable:");
        for (Shape shape : Shape.values()) {
            shape.draw();
        }
        
        // Compare enums
        System.out.println("\n7. Enum Comparison:");
        Priority p1 = Priority.HIGH;
        Priority p2 = Priority.valueOf("HIGH");
        Priority p3 = Priority.LOW;
        
        System.out.println("p1 == p2: " + (p1 == p2));  // true
        System.out.println("p1.equals(p2): " + p1.equals(p2));  // true
        System.out.println("p1.compareTo(p3): " + p1.compareTo(p3));  // positive
        
        // Enum with static method
        System.out.println("\n8. Static Method in Enum:");
        try {
            HttpStatus fromCode = HttpStatus.fromCode(404);
            System.out.println("Status for code 404: " + fromCode.getDescription());
            
            HttpStatus fromCode2 = HttpStatus.fromCode(999);  // Will throw exception
        } catch (IllegalArgumentException e) {
            System.out.println("Error: " + e.getMessage());
        }
        
        // Singleton enum
        System.out.println("\n9. Singleton Enum:");
        DatabaseConnection db1 = DatabaseConnection.INSTANCE;
        DatabaseConnection db2 = DatabaseConnection.INSTANCE;
        System.out.println("Same instance? " + (db1 == db2));
        db1.query("SELECT * FROM users");
        
        // EnumSet and EnumMap
        System.out.println("\n10. EnumSet and EnumMap:");
        java.util.EnumSet<Priority> importantPriorities = 
            java.util.EnumSet.of(Priority.HIGH, Priority.CRITICAL);
        System.out.println("Important priorities: " + importantPriorities);
        
        java.util.EnumMap<Priority, String> priorityMessages = 
            new java.util.EnumMap<>(Priority.class);
        priorityMessages.put(Priority.LOW, "Take your time");
        priorityMessages.put(Priority.HIGH, "Urgent!");
        System.out.println("Priority messages: " + priorityMessages);
    }
}
```

---

## Class Design Maslahatlari

```java
// Good class design example
public final class BankAccount {
    // 1. Keep data private
    private final String accountNumber;
    private final String ownerName;
    private double balance;
    private final LocalDate createdDate;
    
    // 2. Initialize data properly
    public BankAccount(String accountNumber, String ownerName, double initialBalance) {
        this.accountNumber = validateAccountNumber(accountNumber);
        this.ownerName = validateName(ownerName);
        this.balance = validateBalance(initialBalance);
        this.createdDate = LocalDate.now();
    }
    
    // 3. Not all fields need individual accessors
    public String getAccountNumber() {
        return accountNumber;
    }
    
    public String getOwnerName() {
        return ownerName;
    }
    
    public double getBalance() {
        return balance;
    }
    
    public LocalDate getCreatedDate() {
        return createdDate;
    }
    
    // 4. Business methods instead of just getters/setters
    public void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit amount must be positive");
        }
        balance += amount;
        logTransaction("DEPOSIT", amount);
    }
    
    public void withdraw(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Withdrawal amount must be positive");
        }
        if (amount > balance) {
            throw new IllegalStateException("Insufficient funds");
        }
        balance -= amount;
        logTransaction("WITHDRAWAL", amount);
    }
    
    public void transfer(BankAccount toAccount, double amount) {
        this.withdraw(amount);
        toAccount.deposit(amount);
        logTransaction("TRANSFER_TO_" + toAccount.accountNumber, amount);
    }
    
    // 5. Helper methods
    private void logTransaction(String type, double amount) {
        System.out.printf("[%s] %s: %.2f (Balance: %.2f)%n", 
                         LocalDateTime.now(), type, amount, balance);
    }
    
    // 6. Validation methods
    private String validateAccountNumber(String accountNumber) {
        if (accountNumber == null || accountNumber.length() != 10) {
            throw new IllegalArgumentException("Invalid account number");
        }
        return accountNumber;
    }
    
    private String validateName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid owner name");
        }
        return name.trim();
    }
    
    private double validateBalance(double balance) {
        if (balance < 0) {
            throw new IllegalArgumentException("Initial balance cannot be negative");
        }
        return balance;
    }
    
    // 7. toString, equals, hashCode
    @Override
    public String toString() {
        return String.format("BankAccount[%s, Owner: %s, Balance: %.2f]", 
                           accountNumber, ownerName, balance);
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof BankAccount)) return false;
        BankAccount that = (BankAccount) o;
        return accountNumber.equals(that.accountNumber);
    }
    
    @Override
    public int hashCode() {
        return accountNumber.hashCode();
    }
    
    // 8. Static factory method
    public static BankAccount createCheckingAccount(String ownerName) {
        String accountNumber = generateAccountNumber();
        return new BankAccount(accountNumber, ownerName, 0.0);
    }
    
    private static String generateAccountNumber() {
        return "ACC" + System.currentTimeMillis() % 1000000;
    }
}
```

---

## JShell (Java REPL)

### JShell nima?
**JShell** - Java uchun interaktiv shell (Read-Evaluate-Print Loop).

```java
JShell Usage Examples:

// Start JShell
$ jshell

// Define variables
jshell> var message = "Hello, JShell!"
message ==> "Hello, JShell!"

// Define methods
jshell> int add(int a, int b) { return a + b; }
|  created method add(int,int)

// Use method
jshell> add(5, 3)
$3 ==> 8

// Define class
jshell> class Point { 
   ...>     int x, y; 
   ...>     Point(int x, int y) { this.x = x; this.y = y; }
   ...> }
|  created class Point

// Create object
jshell> var p = new Point(10, 20)
p ==> Point@5e265ba4

// Import packages
jshell> import java.util.*
jshell> import java.time.*

// List defined items
jshell> /vars
|    String message = "Hello, JShell!"
|    Point p = Point@5e265ba4

jshell> /methods
|    int add(int,int)

// Save session
jshell> /save mysession.jsh

// Load session
jshell> /open mysession.jsh

// Exit
jshell> /exit
```

---

## O'z-o'zini Tekshirish

### Savol 1: var keyword qanday holatlarda ishlatilmaydi?

### Savol 2: Factory Method va Builder pattern'lar farqi nimada?

### Savol 3: Enum Singleton nima uchun eng yaxshi usul hisoblanadi?

---

## Keyingi Mavzu: [Objects Class, Javadoc & UUID](./12_Objects_Javadoc_UUID.md)
**[Mundarijaga qaytish](../README.md)**

> ⚡️ **Eslatma:** Dizayn pattern'lar - tajribali dasturchilarning yechimlari. Ularni o'rganish va to'g'ri ishlatish sizning dasturchi sifatida rivojlanishingizga yordam beradi. "Don't reinvent the wheel - use patterns!"