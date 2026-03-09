# 5-Modul: Project Lombok (Java Library Tool)

## Lombok nima?

**Project Lombok** - Java kutubxonasi bo'lib, kod yozish vaqtida **boilerplate kodlarni** (takrorlanuvchi kodlarni) kamaytirish yoki butunlay olib tashlash uchun ishlatiladi. Bu annotation'lar yordamida ishlaydi va dasturchilarning vaqtini tejaydi, kodni o'qishni osonlashtiradi va joyni tejaydi.

```java
// ❌ Lombok'siz (boilerplate kod ko'p)
public class User {
    private String name;
    private int age;
    
    public User() {}
    
    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    
    @Override
    public String toString() {
        return "User{name='" + name + "', age=" + age + "}";
    }
    
    // equals, hashCode...
}

// ✅ Lombok bilan (1 qator kod)
@Data
@AllArgsConstructor
public class User {
    private String name;
    private int age;
}
```

### Lombok afzalliklari

1. **Vaqt tejaladi** - Getter/setter yozish shart emas
2. **Kod hajmi kamayadi** - 80% gacha kod qisqaradi
3. **Xatolik kamayadi** - Avtomatik generatsiya
4. **O'qish oson** - Faqat muhim qismlar qoladi

---

## 5.1 - Lombok o'rnatish va sozlash

### Maven dependency

```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.30</version>
    <scope>provided</scope>
</dependency>
```

### Gradle dependency

```groovy
dependencies {
    compileOnly 'org.projectlombok:lombok:1.18.30'
    annotationProcessor 'org.projectlombok:lombok:1.18.30'
}
```

### IDE plugin (IntelliJ IDEA)

```markdown
1. File → Settings → Plugins
2. "Lombok" qidirib, install qiling
3. Enable annotation processing:
   - Settings → Build → Compiler → Annotation Processors
   - "Enable annotation processing" ni belgilang
```

---

## 5.2 - Asosiy Lombok annotation'lari

### @Getter / @Setter

Getter va setter methodlarini avtomatik yaratadi.

```java
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Person {
    private String name;
    private int age;
    private boolean active;
    
    // Field-level annotation
    @Getter(AccessLevel.PROTECTED)
    private String password;
}

// Kompilyatsiya qilingan kod:
// public String getName() { return this.name; }
// public void setName(String name) { this.name = name; }
// public int getAge() { return this.age; }
// public void setAge(int age) { this.age = age; }
// public boolean isActive() { return this.active; }
// public void setActive(boolean active) { this.active = active; }
// protected String getPassword() { return this.password; }
```

### @ToString

`toString()` methodini yaratadi.

```java
import lombok.ToString;

@ToString
@ToString.Exclude   // field'larni exclude qilish
public class Product {
    private String name;
    private double price;
    
    @ToString.Exclude
    private String secretKey;
    
    @ToString.Include(name = "productId")
    private String id;
    
    @ToString.Include(rank = 1)
    private String category;
}

// toString() natijasi:
// Product(category=Electronics, name=Laptop, price=999.99, id=123)
```

### @EqualsAndHashCode

`equals()` va `hashCode()` methodlarini yaratadi.

```java
import lombok.EqualsAndHashCode;

@EqualsAndHashCode
@EqualsAndHashCode.Exclude
public class Employee {
    private String id;
    private String name;
    
    @EqualsAndHashCode.Exclude
    private transient String tempData;
    
    @EqualsAndHashCode.Include
    private String department;
}

// Call super class
@EqualsAndHashCode(callSuper = true)
public class Manager extends Employee {
    private int teamSize;
}
```

### @NoArgsConstructor

Parametrsiz constructor yaratadi.

```java
import lombok.NoArgsConstructor;
import lombok.NonNull;

@NoArgsConstructor
@NoArgsConstructor(force = true)  // final field'larga default qiymat
@NoArgsConstructor(access = AccessLevel.PRIVATE)  // private constructor
public class DatabaseConfig {
    private final String url = "localhost";  // final field
    @NonNull
    private String username;  // Non-null field
    private String password;
    
    // Static factory method uchun
    @NoArgsConstructor(staticName = "create")
    public static class Helper {
        private String data;
    }
}
```

### @RequiredArgsConstructor

Final va `@NonNull` field'lar uchun constructor yaratadi.

```java
import lombok.RequiredArgsConstructor;
import lombok.NonNull;

@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    @NonNull
    private String serviceName;
    private String config;  // included only if final or @NonNull
    
    // Constructor yaratiladi:
    // public UserService(UserRepository userRepository, String serviceName) {
    //     this.userRepository = userRepository;
    //     this.serviceName = serviceName;
    // }
}

// Static name bilan
@RequiredArgsConstructor(staticName = "of")
public class Point {
    private final int x;
    private final int y;
}
// Point point = Point.of(10, 20);
```

### @AllArgsConstructor

Barcha field'lar uchun constructor yaratadi.

```java
import lombok.AllArgsConstructor;

@AllArgsConstructor
@AllArgsConstructor(access = AccessLevel.PACKAGE)  // package-private
public class Book {
    private String title;
    private String author;
    private int pages;
    private double price;
}

// Book book = new Book("Java", "John", 500, 29.99);
```

### @NonNull

Null tekshiruvi qo'shadi.

```java
import lombok.NonNull;

public class ValidationExample {
    public void process(@NonNull String data) {
        // data null bo'lsa, NullPointerException tashlanadi
        System.out.println(data.length());
    }
    
    @Setter
    @NonNull
    private String required;
}

// Kompilyatsiya qilingan kod:
// public void process(@NonNull String data) {
//     if (data == null) {
//         throw new NullPointerException("data is marked non-null but is null");
//     }
//     System.out.println(data.length());
// }
```

### @Data

Barcha asosiy annotation'larni birlashtiradi:
- `@ToString`
- `@EqualsAndHashCode`
- `@Getter` / `@Setter`
- `@RequiredArgsConstructor`

```java
import lombok.Data;

@Data
public class Customer {
    private final String id;
    private String name;
    private String email;
    private int age;
}

// Quyidagilarni o'z ichiga oladi:
// - Getter/setter (non-final field'lar)
// - toString()
// - equals() & hashCode()
// - Constructor (final field'lar uchun)
```

---

## 5.3 - Lombok Part II (Advanced Annotations)

### @Value

Immutable class yaratish uchun. `@Data` ga o'xshash, lekin barcha field'lar `final` va `private` bo'ladi.

```java
import lombok.Value;
import lombok.With;

@Value
@Value.Exclude
public class ImmutablePerson {
    String name;
    int age;
    @With  // withX() method yaratadi
    String address;
    
    // Lombok yaratadi:
    // - private final fields
    // - All args constructor
    // - Getter methods
    // - toString(), equals(), hashCode()
    // - No setters!
}

// Foydalanish
ImmutablePerson person = new ImmutablePerson("John", 30, "Tashkent");
// person.setName("Jane");  // COMPILE ERROR!
ImmutablePerson updated = person.withAddress("Samarkand");
```

### @Builder

Builder pattern implementatsiyasini yaratadi.

```java
import lombok.Builder;
import lombok.Singular;
import java.util.List;

@Builder
@Builder(toBuilder = true)  // toBuilder() method
public class Pizza {
    private String size;
    private boolean cheese;
    private boolean pepperoni;
    private boolean mushrooms;
    
    @Singular  // List field'lar uchun
    private List<String> toppings;
}

// Foydalanish
Pizza pizza = Pizza.builder()
    .size("Large")
    .cheese(true)
    .pepperoni(true)
    .topping("Olives")
    .topping("Mushrooms")
    .build();

// Copy with modifications
Pizza another = pizza.toBuilder()
    .mushrooms(true)
    .build();
```

### @Builder.Default

Builder'da default qiymatlar uchun.

```java
import lombok.Builder;
import lombok.Builder.Default;

@Builder
public class Window {
    @Default
    private int width = 800;
    
    @Default
    private int height = 600;
    
    @Default
    private boolean resizable = true;
    
    @Default
    private String title = "Application";
}

// Foydalanish
Window window = Window.builder()
    .title("My App")
    .build();
// width=800, height=600, resizable=true
```

### @SneakyThrows

Checked exception'larni unchecked ga o'tkazadi.

```java
import lombok.SneakyThrows;
import java.io.FileInputStream;

public class SneakyThrowsExample {
    
    @SneakyThrows
    public void readFile() {
        // IOException throws - try-catch kerak emas!
        FileInputStream fis = new FileInputStream("test.txt");
    }
    
    @SneakyThrows(InterruptedException.class)
    public void sleep() {
        Thread.sleep(1000);  // InterruptedException
    }
    
    @SneakyThrows
    public void multipleExceptions() {
        Class.forName("com.example.Test");  // ClassNotFoundException
        Thread.sleep(100);                   // InterruptedException
    }
}

// Kompilyatsiya qilingan kod:
// public void readFile() {
//     try {
//         new FileInputStream("test.txt");
//     } catch (IOException e) {
//         throw Lombok.sneakyThrow(e);
//     }
// }
```

### @Log (va logging variantlari)

Logger field'ini avtomatik yaratadi.

```java
import lombok.extern.java.Log;
import lombok.extern.slf4j.Slf4j;
import lombok.extern.apachecommons.CommonsLog;
import lombok.extern.log4j.Log4j;
import lombok.extern.log4j.Log4j2;

@Log  // java.util.logging.Logger
@Slf4j  // SLF4J Logger
@CommonsLog  // Apache Commons Logging
@Log4j  // Log4J
@Log4j2  // Log4J2
@XSlf4j  // JBoss Logging
public class LoggingExample {
    
    public void doSomething() {
        log.info("Application started");
        log.warning("Low memory");
        log.severe("Critical error!");
        
        try {
            // some code
        } catch (Exception e) {
            log.log(Level.SEVERE, "Error occurred", e);
        }
    }
}

// @Slf4j bilan:
// private static final org.slf4j.Logger log = 
//     org.slf4j.LoggerFactory.getLogger(LoggingExample.class);
```

### @Cleanup

Resource'larni avtomatik yopish.

```java
import lombok.Cleanup;
import java.io.*;

public class CleanupExample {
    
    public void readFile() throws IOException {
        @Cleanup FileInputStream fis = new FileInputStream("input.txt");
        @Cleanup FileOutputStream fos = new FileOutputStream("output.txt");
        
        byte[] buffer = new byte[1024];
        int bytesRead;
        while ((bytesRead = fis.read(buffer)) != -1) {
            fos.write(buffer, 0, bytesRead);
        }
        // fis va fos avtomatik yopiladi (try-with-resources kabi)
    }
    
    public void multipleResources() {
        @Cleanup("dispose")  // custom cleanup method
        java.awt.Window window = new java.awt.Frame();
        
        @Cleanup
        java.sql.Connection conn = getConnection();
        // conn.close() avtomatik chaqiriladi
    }
}
```

---

## 5.4 - Lombok variable declarations

### val (immutable local variable)

`val` - final local variable'lar uchun (type inference).

```java
import lombok.val;
import java.util.ArrayList;
import java.util.HashMap;

public class ValExample {
    
    public void examples() {
        // 1. Type inference
        val name = "John";  // String
        val age = 25;       // int
        val list = new ArrayList<String>();  // ArrayList<String>
        
        // 2. Final - o'zgartirib bo'lmaydi
        // name = "Jane";  // COMPILE ERROR!
        
        // 3. Complex types
        val map = new HashMap<String, List<Integer>>();
        map.put("numbers", List.of(1, 2, 3));
        
        // 4. With generics
        val numbers = List.of(1, 2, 3, 4, 5);
        
        // 5. In loops
        val items = List.of("A", "B", "C");
        for (val item : items) {
            System.out.println(item);
        }
    }
}
```

### var (mutable local variable)

`var` - mutable local variable'lar uchun (type inference).

```java
import lombok.var;
import java.util.ArrayList;

public class VarExample {
    
    public void examples() {
        // 1. Mutable variable
        var counter = 0;  // int
        counter++;        // OK!
        
        // 2. Collection
        var list = new ArrayList<String>();  // ArrayList<String>
        list.add("Hello");
        list.add("World");
        
        // 3. Loop variable
        for (var i = 0; i < 10; i++) {
            System.out.println(i);
        }
        
        // 4. Try-with-resources
        try (var fis = new java.io.FileInputStream("test.txt")) {
            // use fis
        } catch (Exception e) {
            // handle
        }
        
        // 5. With diamond operator
        var map = new HashMap<String, List<Integer>>();
        map.put("test", List.of(1, 2, 3));
    }
}
```

### val vs var comparison

```java
public class Comparison {
    
    public void demonstrate() {
        // val - immutable
        val immutable = new ArrayList<String>();
        // immutable = new ArrayList<String>();  // ERROR!
        immutable.add("OK");  // Object o'zi o'zgarmaydi, content o'zgaradi
        
        // var - mutable
        var mutable = new ArrayList<String>();
        mutable = new ArrayList<String>();  // OK!
        
        // Type inference
        val str = "Hello";     // String
        var num = 42;           // int
        
        // With generics
        val list1 = new ArrayList<String>();  // ArrayList<String>
        var list2 = new ArrayList<String>();  // ArrayList<String>
    }
}
```

---

## 5.5 - To'liq misollar

### Misol 1: DTO (Data Transfer Object)

```java
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDTO {
    private String id;
    private String customerName;
    private String customerEmail;
    private double totalAmount;
    private LocalDateTime orderDate;
    
    @Singular
    private List<OrderItemDTO> items;
    
    @Builder.Default
    private String status = "PENDING";
    
    // Business logic methods
    public boolean isValid() {
        return totalAmount > 0 && items != null && !items.isEmpty();
    }
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
class OrderItemDTO {
    private String productId;
    private String productName;
    private int quantity;
    private double price;
    
    public double getSubtotal() {
        return quantity * price;
    }
}

// Foydalanish
OrderDTO order = OrderDTO.builder()
    .customerName("John Doe")
    .customerEmail("john@example.com")
    .totalAmount(150.00)
    .orderDate(LocalDateTime.now())
    .item(OrderItemDTO.builder()
        .productId("P001")
        .productName("Laptop")
        .quantity(1)
        .price(100.00)
        .build())
    .item(OrderItemDTO.builder()
        .productId("P002")
        .productName("Mouse")
        .quantity(2)
        .price(25.00)
        .build())
    .build();
```

### Misol 2: Entity class

```java
import lombok.*;
import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
@Data
@EqualsAndHashCode(callSuper = true, exclude = {"orders"})
@ToString(callSuper = true, exclude = {"password", "orders"})
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User extends BaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    
    @Column(unique = true, nullable = false)
    @NonNull
    private String username;
    
    @Column(unique = true, nullable = false)
    @NonNull
    private String email;
    
    @ToString.Exclude
    private String password;
    
    private String firstName;
    private String lastName;
    
    @Builder.Default
    private boolean active = true;
    
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    @Builder.Default
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private Set<Order> orders = new HashSet<>();
    
    // Business methods
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    public void addOrder(Order order) {
        orders.add(order);
        order.setUser(this);
    }
}
```

### Misol 3: Service class with logging

```java
import lombok.extern.slf4j.Slf4j;
import lombok.val;
import lombok.var;
import lombok.SneakyThrows;
import lombok.NonNull;

@Slf4j
public class UserService {
    
    private final UserRepository userRepository;
    private final EmailService emailService;
    
    public UserService(UserRepository userRepository, EmailService emailService) {
        this.userRepository = userRepository;
        this.emailService = emailService;
    }
    
    public User registerUser(@NonNull RegisterRequest request) {
        log.info("Registering new user with email: {}", request.getEmail());
        
        // Check if user exists
        if (userRepository.existsByEmail(request.getEmail())) {
            log.warn("User already exists with email: {}", request.getEmail());
            throw new UserAlreadyExistsException("Email already registered");
        }
        
        // Create user using builder
        val user = User.builder()
            .username(request.getUsername())
            .email(request.getEmail())
            .password(encodePassword(request.getPassword()))
            .firstName(request.getFirstName())
            .lastName(request.getLastName())
            .build();
        
        // Save user
        var savedUser = userRepository.save(user);
        log.debug("User saved with ID: {}", savedUser.getId());
        
        // Send welcome email
        sendWelcomeEmail(savedUser);
        
        log.info("User registered successfully: {}", savedUser.getId());
        return savedUser;
    }
    
    @SneakyThrows(InterruptedException.class)
    private void sendWelcomeEmail(User user) {
        log.info("Sending welcome email to: {}", user.getEmail());
        Thread.sleep(100); // Simulate email sending
        emailService.sendWelcomeEmail(user);
    }
    
    @SneakyThrows
    private String encodePassword(String rawPassword) {
        // Simulate password encoding
        return "ENCODED_" + rawPassword;
    }
}
```

---

## 5.6 - Lombok Best Practices

### 1. @Data ehtiyotkorlik bilan ishlating

```java
// ❌ Xavfli: @Data with JPA entities
@Data  // toString() lazy loading muammosi
@Entity
public class Order {
    @OneToMany
    private List<Item> items;  // Lazy loading
}

// ✅ Yaxshi: Manual configuration
@Entity
@Getter
@Setter
@ToString(exclude = "items")
@EqualsAndHashCode(exclude = "items")
public class Order {
    @OneToMany
    private List<Item> items;
}
```

### 2. @Builder inheritance

```java
// ❌ @Builder inheritance bilan ishlamaydi
@Builder
public class Parent {
    private String parentField;
}

@Builder  // Parent field'larini o'z ichiga olmaydi
public class Child extends Parent {
    private String childField;
}

// ✅ Yaxshi: @SuperBuilder (Lombok 1.18.2+)
import lombok.experimental.SuperBuilder;

@SuperBuilder
public class Parent {
    private String parentField;
}

@SuperBuilder
public class Child extends Parent {
    private String childField;
}

// Foydalanish
Child child = Child.builder()
    .parentField("parent")
    .childField("child")
    .build();
```

### 3. @NonNull vs validation

```java
// Lombok @NonNull - runtime exception
public void process(@NonNull String data) {
    // NullPointerException
}

// Bean Validation - checked at validation layer
public void process(@NotNull String data) {
    // ConstraintViolationException
}

// ✅ Birgalikda ishlatish
public void process(@NonNull @NotNull String data) {
    // Best of both worlds
}
```

### 4. @With vs @Builder(toBuilder = true)

```java
@Value
@With  // Har bir field uchun withX() yaratadi
public class ImmutablePerson {
    String name;
    int age;
    String address;
}

// With: person.withName("Jane").withAge(31)

@Builder(toBuilder = true)
public class PersonBuilder {
    String name;
    int age;
}

// toBuilder: person.toBuilder().name("Jane").build()
```

---

## Lombok Annotation Reference

| Annotation | Part | Purpose |
|------------|------|---------|
| `@Getter` | I | Getter methodlar |
| `@Setter` | I | Setter methodlar |
| `@ToString` | I | toString() method |
| `@EqualsAndHashCode` | I | equals() va hashCode() |
| `@NoArgsConstructor` | I | Parametrsiz constructor |
| `@RequiredArgsConstructor` | I | Required fields constructor |
| `@AllArgsConstructor` | I | Barcha fields constructor |
| `@NonNull` | I | Null tekshiruvi |
| `@Data` | I | Barcha asosiylar |
| `@Value` | II | Immutable class |
| `@Builder` | II | Builder pattern |
| `@SneakyThrows` | II | Checked exceptions |
| `@Log` (va variantlari) | II | Logger |
| `@Cleanup` | II | Resource cleanup |
| `val` | II | Immutable local variable |
| `var` | II | Mutable local variable |

---

## Tekshiruv Savollari

### Part I
1. **Lombok nima va nima uchun ishlatiladi?**
2. **@Data annotation qanday annotation'larni o'z ichiga oladi?**
3. **@NoArgsConstructor va @AllArgsConstructor farqi nima?**
4. **@RequiredArgsConstructor qachon ishlatiladi?**
5. **@NonNull qanday ishlaydi?**

### Part II
6. **@Value va @Data farqi nima?**
7. **@Builder qanday ishlaydi? Misol keltiring.**
8. **@SneakyThrows nima uchun ishlatiladi?**
9. **@Cleanup qanday ishlaydi?**
10. **val va var o'rtasidagi farq nima?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega Lombok loyihasini yarating:

1. **Entity classes** - @Data, @Builder, @NoArgsConstructor, @AllArgsConstructor
2. **DTO classes** - @Value, @Builder
3. **Service classes** - @Slf4j, @SneakyThrows
4. **Immutable objects** - @With, @Builder(toBuilder = true)
5. **Resource management** - @Cleanup
6. **Local variables** - val, var

```java
// Tekshirish:
User user = User.builder()
    .username("john")
    .email("john@example.com")
    .build();

log.info("User created: {}", user);
```

---

## Xulosa

Lombok - Java dasturchilarining vaqtini tejaydigan, kodni soddalashtiradigan kuchli vosita:

| Afzallik | Tavsif |
|----------|--------|
| **Kod hajmi kamayadi** | 50-80% kam kod |
| **Xatolik kamayadi** | Avtomatik generatsiya |
| **Vaqt tejaladi** | Boilerplate kod yozish shart emas |
| **O'qish oson** | Faqat muhim qismlar |

```bash
# Lombok bilan ishlash:
1. Dependency qo'shish
2. IDE plugin o'rnatish
3. Annotation'lardan foydalanish
```

---

**Keyingi mavzu:** [Testing (JUnit)](./06-faker.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
