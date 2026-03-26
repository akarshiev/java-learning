# 1-Modul: Jakarta Bean Validation

## 1.15 Jakarta Bean Validation nima?

**Jakarta Bean Validation** - Java obyektlarida ma'lumotlarni tekshirish (validation) uchun standart API. U annotation'lar yordamida field'lar, metodlar va class'larga validation constraint'lar qo'shish imkonini beradi.

**Oddiy qilib aytganda:** Bean Validation - ma'lumotlarni ma'lumotlar bazasiga yuborishdan oldin tekshirish uchun ishlatiladi. Bu xavfsizlik, ma'lumotlar yaxlitligi va format to'g'riligini ta'minlaydi.

```java
// ❌ Validationsiz - ma'lumotlar noto'g'ri bo'lishi mumkin
User user = new User();
user.setEmail("invalid-email");
user.setAge(-5);
user.setPassword("123");
// Ma'lumotlar bazasiga noto'g'ri ma'lumot yoziladi

// ✅ Validation bilan - noto'g'ri ma'lumot rad etiladi
public class User {
    @NotNull(message = "Email cannot be null")
    @Email(message = "Invalid email format")
    private String email;
    
    @Min(value = 0, message = "Age must be positive")
    @Max(value = 150, message = "Age cannot exceed 150")
    private int age;
}
```

### Nima uchun Validation kerak?

| Sabab | Tavsifi |
|-------|---------|
| **Xavfsizlik** | SQL injection, XSS, zararli ma'lumotlardan himoya |
| **Ma'lumotlar yaxlitligi** | Ma'lumotlar bazasida noto'g'ri ma'lumotlar saqlanishining oldini olish |
| **Format to'g'riligi** | Email, telefon, sana kabi ma'lumotlar to'g'ri formatda bo'lishini ta'minlash |
| **Ishlab chiqish tezligi** | Validatsiya kodini alohida yozish kerak emas, annotation'lar yordamida |

### Java EE/ Jakarta EE Versiyalari

| Versiya | Java EE | Muhim o'zgarishlar |
|---------|---------|-------------------|
| Bean Validation 1.0 | Java EE 6 | Birinchi versiya |
| Bean Validation 2.0 | Java EE 8 | Yangi constraint'lar, metod validation, CDI integration |
| Bean Validation 3.0 | Jakarta EE 9 | `javax` → `jakarta` package o'zgarishi |

---

## 1.16 Maven Dependency

```xml
<dependency>
    <groupId>jakarta.validation</groupId>
    <artifactId>jakarta.validation-api</artifactId>
    <version>3.0.2</version>
</dependency>

<!-- Reference Implementation (Hibernate Validator) -->
<dependency>
    <groupId>org.hibernate.validator</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>8.0.0.Final</version>
</dependency>

<!-- For Jakarta EE 9+ applications, these are usually provided by the server -->
```

---

## 1.17 Built-in Constraints (Tayyor Constraint'lar)

### A) Core Constraints

```java
import jakarta.validation.constraints.*;
import java.time.LocalDate;
import java.util.List;

@Entity
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // @NotNull - null bo'lmasligi kerak
    @NotNull(message = "Username is required")
    private String username;
    
    // @NotBlank - null, empty yoki faqat bo'shliq bo'lmasligi kerak
    @NotBlank(message = "Name is required")
    private String name;
    
    // @NotEmpty - null yoki bo'sh bo'lmasligi kerak (String, Collection, Map, Array uchun)
    @NotEmpty(message = "Email is required")
    private String email;
    
    // @Email - email formatini tekshiradi
    @Email(message = "Invalid email format")
    private String emailAddress;
    
    // @Size - uzunlikni tekshiradi (String, Collection, Map, Array)
    @Size(min = 8, max = 20, message = "Password must be between 8 and 20 characters")
    private String password;
    
    // @Min / @Max - minimal/maksimal qiymat
    @Min(value = 0, message = "Age must be at least 0")
    @Max(value = 150, message = "Age cannot exceed 150")
    private Integer age;
    
    // @DecimalMin / @DecimalMax - decimal qiymatlar uchun
    @DecimalMin(value = "0.0", inclusive = true, message = "Salary must be positive")
    @DecimalMax(value = "1000000.0", message = "Salary cannot exceed 1,000,000")
    private BigDecimal salary;
    
    // @Positive / @PositiveOrZero - musbat son
    @Positive(message = "Quantity must be positive")
    private Integer quantity;
    
    // @Negative / @NegativeOrZero - manfiy son
    @Negative(message = "Temperature must be negative")
    private Double temperature;
    
    // @Past / @PastOrPresent - o'tgan vaqt
    @Past(message = "Birth date must be in the past")
    private LocalDate birthDate;
    
    // @Future / @FutureOrPresent - kelajak vaqt
    @Future(message = "Expiry date must be in the future")
    private LocalDate expiryDate;
    
    // @Pattern - regex pattern bilan tekshirish
    @Pattern(regexp = "^[A-Z]{2}[0-9]{6}$", message = "Invalid passport number format")
    private String passportNumber;
    
    // @AssertTrue / @AssertFalse - boolean shart
    @AssertTrue(message = "Must accept terms and conditions")
    private boolean termsAccepted;
    
    // @Digits - butun va kasr qismi uzunligi
    @Digits(integer = 10, fraction = 2, message = "Amount must have up to 10 integer digits and 2 fraction digits")
    private BigDecimal amount;
    
    // @URL - URL formatini tekshiradi
    @URL(message = "Invalid URL format")
    private String website;
    
    // getters, setters
}
```

### B) Validation Groups (Guruhlash)

```java
import jakarta.validation.constraints.*;
import jakarta.validation.groups.Default;

// Validation groups interface'lar
public interface CreateGroup {}
public interface UpdateGroup {}
public interface DeleteGroup {}

@Entity
public class Product {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @NotNull(groups = {UpdateGroup.class, DeleteGroup.class})
    private Long id;
    
    @NotBlank(groups = {CreateGroup.class, UpdateGroup.class})
    @Size(min = 3, max = 100, groups = {CreateGroup.class, UpdateGroup.class})
    private String name;
    
    @DecimalMin(value = "0.01", groups = {CreateGroup.class, UpdateGroup.class})
    private BigDecimal price;
    
    @Min(value = 0, groups = {CreateGroup.class, UpdateGroup.class})
    private Integer stockQuantity;
    
    @NotNull(groups = {CreateGroup.class})
    private String category;
    
    // getters, setters
}

// Ishlatish
@Stateless
public class ProductService {
    
    @PersistenceContext
    private EntityManager em;
    
    @Inject
    private Validator validator;
    
    public Product createProduct(Product product) {
        // Create group validation
        Set<ConstraintViolation<Product>> violations = validator.validate(product, CreateGroup.class);
        if (!violations.isEmpty()) {
            throw new ValidationException(violations.toString());
        }
        
        em.persist(product);
        return product;
    }
    
    public Product updateProduct(Product product) {
        // Update group validation
        Set<ConstraintViolation<Product>> violations = validator.validate(product, UpdateGroup.class);
        if (!violations.isEmpty()) {
            throw new ValidationException(violations.toString());
        }
        
        return em.merge(product);
    }
}
```

### C) Group Sequence (Validatsiya tartibi)

```java
import jakarta.validation.*;
import jakarta.validation.groups.*;

// Validation order - agar birinchi group o'tsa, keyingisiga o'tadi
@GroupSequence({BasicInfo.class, AdvancedInfo.class, Default.class})
public interface ValidationSequence {}

public interface BasicInfo {}
public interface AdvancedInfo {}

@Entity
public class Employee {
    
    @NotBlank(groups = BasicInfo.class)
    private String name;
    
    @Email(groups = BasicInfo.class)
    private String email;
    
    @Min(value = 18, groups = AdvancedInfo.class)
    private Integer age;
    
    @Pattern(regexp = "^[0-9]{5}$", groups = AdvancedInfo.class)
    private String postalCode;
    
    // getters, setters
}

// Ishlatish
Set<ConstraintViolation<Employee>> violations = validator.validate(employee, ValidationSequence.class);
```

---

## 1.18 Validator Manual Ishlatish

```java
import jakarta.validation.*;
import jakarta.validation.constraints.*;
import java.util.Set;

public class ManualValidationExample {
    
    public static void main(String[] args) {
        // Validator factory yaratish
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        Validator validator = factory.getValidator();
        
        // Test obyekt yaratish
        User user = new User();
        user.setName("");  // invalid
        user.setEmail("invalid-email");  // invalid
        user.setAge(-5);  // invalid
        user.setPassword("123");  // invalid
        
        // Validatsiya qilish
        Set<ConstraintViolation<User>> violations = validator.validate(user);
        
        // Natijalarni chiqarish
        if (!violations.isEmpty()) {
            System.out.println("Validation errors:");
            for (ConstraintViolation<User> violation : violations) {
                System.out.printf("  %s: %s (value: %s)%n",
                    violation.getPropertyPath(),
                    violation.getMessage(),
                    violation.getInvalidValue()
                );
            }
        } else {
            System.out.println("User is valid!");
        }
        
        factory.close();
    }
}

class User {
    @NotBlank(message = "Name is required")
    private String name;
    
    @Email(message = "Invalid email format")
    private String email;
    
    @Min(value = 0, message = "Age must be positive")
    private int age;
    
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;
    
    // getters, setters
}
```

---

## 1.19 Custom Constraint Validator

### A) Custom Annotation yaratish

```java
import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.*;

// 1. Custom constraint annotation
@Target({ElementType.FIELD, ElementType.PARAMETER, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {UniqueUsernameValidator.class, UniqueEmailValidator.class})
@Documented
public @interface Unique {
    
    String message() default "{validation.constraints.unique.message}";
    
    Class<?>[] groups() default {};
    
    Class<? extends Payload>[] payload() default {};
    
    // Additional parameters
    String[] fields() default {};
}

// 2. Validator implementation (field level)
public class UniqueUsernameValidator implements ConstraintValidator<Unique, String> {
    
    @PersistenceContext
    private EntityManager em;
    
    @Override
    public void initialize(Unique constraintAnnotation) {
        // Initialization if needed
    }
    
    @Override
    public boolean isValid(String username, ConstraintValidatorContext context) {
        if (username == null || username.isEmpty()) {
            return true; // @NotNull or @NotBlank handles null/empty
        }
        
        try {
            Long count = em.createQuery(
                "SELECT COUNT(u) FROM User u WHERE u.username = :username",
                Long.class
            ).setParameter("username", username)
             .getSingleResult();
            
            return count == 0;
        } catch (Exception e) {
            return false;
        }
    }
}

// 3. Validator implementation (entity level - for multiple fields)
public class UniqueEmailValidator implements ConstraintValidator<Unique, User> {
    
    @PersistenceContext
    private EntityManager em;
    
    @Override
    public boolean isValid(User user, ConstraintValidatorContext context) {
        if (user == null || user.getEmail() == null) {
            return true;
        }
        
        try {
            Long count = em.createQuery(
                "SELECT COUNT(u) FROM User u WHERE u.email = :email AND u.id != :id",
                Long.class
            ).setParameter("email", user.getEmail())
             .setParameter("id", user.getId() != null ? user.getId() : -1)
             .getSingleResult();
            
            return count == 0;
        } catch (Exception e) {
            return false;
        }
    }
}

// 4. Entity class
@Entity
@Unique(fields = {"username", "email"})
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank
    @Unique  // Custom constraint for username
    private String username;
    
    @NotBlank
    @Email
    private String email;
    
    // getters, setters
}
```

### B) Pattern Validator (Phone number)

```java
import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PhoneNumberValidator.class)
@Documented
public @interface PhoneNumber {
    
    String message() default "Invalid phone number format";
    
    Class<?>[] groups() default {};
    
    Class<? extends Payload>[] payload() default {};
    
    // Optional: specify country code pattern
    String countryCode() default "UZ";
}

public class PhoneNumberValidator implements ConstraintValidator<PhoneNumber, String> {
    
    private static final Map<String, String> PATTERNS = new HashMap<>();
    
    static {
        PATTERNS.put("UZ", "^\\+998[0-9]{9}$");
        PATTERNS.put("US", "^\\+1[0-9]{10}$");
        PATTERNS.put("RU", "^\\+7[0-9]{10}$");
    }
    
    private String pattern;
    
    @Override
    public void initialize(PhoneNumber constraintAnnotation) {
        String countryCode = constraintAnnotation.countryCode();
        this.pattern = PATTERNS.getOrDefault(countryCode, PATTERNS.get("UZ"));
    }
    
    @Override
    public boolean isValid(String phone, ConstraintValidatorContext context) {
        if (phone == null || phone.isEmpty()) {
            return true;
        }
        return phone.matches(pattern);
    }
}

// Foydalanish
@Entity
public class Customer {
    @PhoneNumber(countryCode = "UZ")
    private String phone;
    
    @PhoneNumber(countryCode = "US")
    private String usPhone;
}
```

### C) Password Strength Validator

```java
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PasswordStrengthValidator.class)
@Documented
public @interface StrongPassword {
    
    String message() default "Password must contain at least one uppercase, one lowercase, one digit, and one special character";
    
    Class<?>[] groups() default {};
    
    Class<? extends Payload>[] payload() default {};
    
    int minLength() default 8;
    
    boolean requireUppercase() default true;
    
    boolean requireLowercase() default true;
    
    boolean requireDigit() default true;
    
    boolean requireSpecial() default true;
}

public class PasswordStrengthValidator implements ConstraintValidator<StrongPassword, String> {
    
    private int minLength;
    private boolean requireUppercase;
    private boolean requireLowercase;
    private boolean requireDigit;
    private boolean requireSpecial;
    
    @Override
    public void initialize(StrongPassword constraintAnnotation) {
        this.minLength = constraintAnnotation.minLength();
        this.requireUppercase = constraintAnnotation.requireUppercase();
        this.requireLowercase = constraintAnnotation.requireLowercase();
        this.requireDigit = constraintAnnotation.requireDigit();
        this.requireSpecial = constraintAnnotation.requireSpecial();
    }
    
    @Override
    public boolean isValid(String password, ConstraintValidatorContext context) {
        if (password == null) {
            return false;
        }
        
        if (password.length() < minLength) {
            return false;
        }
        
        if (requireUppercase && !password.matches(".*[A-Z].*")) {
            return false;
        }
        
        if (requireLowercase && !password.matches(".*[a-z].*")) {
            return false;
        }
        
        if (requireDigit && !password.matches(".*\\d.*")) {
            return false;
        }
        
        if (requireSpecial && !password.matches(".*[@#$%^&+=!].*")) {
            return false;
        }
        
        return true;
    }
}

// Foydalanish
@Entity
public class User {
    @StrongPassword(minLength = 8, message = "Password is too weak")
    private String password;
}
```

---

## 1.20 JPA Entity Validation

```java
import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import jakarta.validation.Valid;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orders")
public class Order {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull(message = "Order date is required")
    @PastOrPresent(message = "Order date cannot be in the future")
    private LocalDate orderDate;
    
    @NotNull
    @Future(message = "Delivery date must be in the future")
    private LocalDate deliveryDate;
    
    @Positive(message = "Total amount must be positive")
    private BigDecimal totalAmount;
    
    @Valid  // Cascade validation to associated entities
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> items = new ArrayList<>();
    
    // Custom validation with groups
    @AssertTrue(
        message = "Delivery date must be after order date",
        groups = {ValidationSequence.class}
    )
    public boolean isValidDeliveryDate() {
        if (orderDate == null || deliveryDate == null) {
            return true;
        }
        return deliveryDate.isAfter(orderDate);
    }
    
    // getters, setters
}

@Entity
@Table(name = "order_items")
public class OrderItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;
    
    @NotNull
    @Positive
    private Integer quantity;
    
    @NotNull
    @Positive
    private BigDecimal price;
    
    @AssertTrue(message = "Quantity must be at least 1")
    public boolean isValidQuantity() {
        return quantity != null && quantity > 0;
    }
    
    // getters, setters
}

// CDI bean with validation
@Stateless
public class OrderService {
    
    @PersistenceContext
    private EntityManager em;
    
    @Inject
    private Validator validator;
    
    public Order createOrder(Order order) {
        // Validate before persist
        Set<ConstraintViolation<Order>> violations = validator.validate(order);
        if (!violations.isEmpty()) {
            throw new ValidationException(formatViolations(violations));
        }
        
        em.persist(order);
        return order;
    }
    
    public Order updateOrder(Order order) {
        // Validate with specific groups
        Set<ConstraintViolation<Order>> violations = validator.validate(order, UpdateGroup.class);
        if (!violations.isEmpty()) {
            throw new ValidationException(formatViolations(violations));
        }
        
        return em.merge(order);
    }
    
    private String formatViolations(Set<ConstraintViolation<Order>> violations) {
        return violations.stream()
            .map(v -> v.getPropertyPath() + ": " + v.getMessage())
            .collect(Collectors.joining(", "));
    }
}
```

---

## 1.21 Method Validation

```java
import jakarta.validation.*;
import jakarta.validation.constraints.*;
import jakarta.validation.executable.ExecutableType;
import jakarta.validation.executable.ValidateOnExecution;

@Stateless
@ValidateOnExecution(type = ExecutableType.ALL)
public class UserService {
    
    // Method parameter validation
    public User findById(
        @NotNull(message = "ID cannot be null")
        @Positive(message = "ID must be positive")
        Long id
    ) {
        return em.find(User.class, id);
    }
    
    // Return value validation
    @NotNull(message = "Result cannot be null")
    @Size(min = 1, message = "At least one user found")
    public List<User> findActiveUsers() {
        return em.createQuery("SELECT u FROM User u WHERE u.active = true", User.class)
                 .getResultList();
    }
    
    // Constructor validation
    public UserService(
        @NotNull @Size(min = 2, max = 50) String name,
        @Email String email
    ) {
        this.name = name;
        this.email = email;
    }
    
    // Multiple parameters
    public void updateUser(
        @NotNull Long id,
        @NotBlank String name,
        @Email String email,
        @Min(18) Integer age
    ) {
        User user = em.find(User.class, id);
        if (user != null) {
            user.setName(name);
            user.setEmail(email);
            user.setAge(age);
        }
    }
}
```

---

## 1.22 Validation Message Properties

```properties
# ValidationMessages.properties (in src/main/resources)

# Default messages
jakarta.validation.constraints.NotNull.message = This field cannot be null
jakarta.validation.constraints.NotBlank.message = This field is required
jakarta.validation.constraints.NotEmpty.message = This field cannot be empty
jakarta.validation.constraints.Email.message = Invalid email address
jakarta.validation.constraints.Size.message = Length must be between {min} and {max}
jakarta.validation.constraints.Min.message = Value must be at least {value}
jakarta.validation.constraints.Max.message = Value must be at most {value}
jakarta.validation.constraints.Past.message = Date must be in the past
jakarta.validation.constraints.Future.message = Date must be in the future

# Custom messages
user.username.unique = Username already exists
user.email.unique = Email address already registered
user.password.weak = Password must contain uppercase, lowercase, digit and special character
order.delivery.after.order = Delivery date must be after order date
```

```java
// Using message properties
public class User {
    @NotNull(message = "{user.name.required}")
    @Size(min = 2, max = 50, message = "{user.name.size}")
    private String name;
    
    @Email(message = "{user.email.invalid}")
    @Unique(message = "{user.email.unique}")
    private String email;
    
    @StrongPassword(message = "{user.password.weak}")
    private String password;
}
```

---

## 1.23 To'liq Misol: User Registration

```java
// Entity with validations
@Entity
@Table(name = "users")
@UniqueEmail
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 20, message = "Username must be between 3 and 20 characters")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "Username can only contain letters, numbers, and underscore")
    @Column(unique = true)
    private String username;
    
    @NotBlank(message = "Full name is required")
    @Size(min = 2, max = 100, message = "Full name must be between 2 and 100 characters")
    private String fullName;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    @Column(unique = true)
    private String email;
    
    @NotBlank(message = "Password is required")
    @StrongPassword
    private String password;
    
    @NotNull(message = "Birth date is required")
    @Past(message = "Birth date must be in the past")
    private LocalDate birthDate;
    
    @PhoneNumber(message = "Invalid phone number format")
    private String phoneNumber;
    
    @URL(message = "Invalid website URL")
    private String website;
    
    @AssertTrue(message = "You must accept the terms and conditions")
    private boolean termsAccepted;
    
    @Column(updatable = false)
    private LocalDateTime createdAt;
    
    private boolean active = true;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    // getters, setters
}

// Custom validator for unique email
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueEmailValidator.class)
@Documented
public @interface UniqueEmail {
    String message() default "Email already registered";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

public class UniqueEmailValidator implements ConstraintValidator<UniqueEmail, User> {
    
    @PersistenceContext
    private EntityManager em;
    
    @Override
    public boolean isValid(User user, ConstraintValidatorContext context) {
        if (user == null || user.getEmail() == null) {
            return true;
        }
        
        Long count = em.createQuery(
            "SELECT COUNT(u) FROM User u WHERE u.email = :email AND u.id != :id",
            Long.class
        ).setParameter("email", user.getEmail())
         .setParameter("id", user.getId() != null ? user.getId() : -1L)
         .getSingleResult();
        
        return count == 0;
    }
}

// Service with validation
@Stateless
public class UserRegistrationService {
    
    @PersistenceContext
    private EntityManager em;
    
    @Inject
    private Validator validator;
    
    public User register(User user) {
        // Validate with groups
        Set<ConstraintViolation<User>> violations = validator.validate(user, CreateGroup.class);
        
        if (!violations.isEmpty()) {
            throw new ValidationException(formatViolations(violations));
        }
        
        // Hash password (in real application)
        user.setPassword(hashPassword(user.getPassword()));
        
        em.persist(user);
        return user;
    }
    
    public User updateProfile(User user) {
        // Validate with update group
        Set<ConstraintViolation<User>> violations = validator.validate(user, UpdateGroup.class);
        
        if (!violations.isEmpty()) {
            throw new ValidationException(formatViolations(violations));
        }
        
        return em.merge(user);
    }
    
    private String hashPassword(String password) {
        // In real application, use BCrypt or similar
        return password; // For demo only
    }
    
    private String formatViolations(Set<ConstraintViolation<User>> violations) {
        return violations.stream()
            .map(v -> v.getPropertyPath() + ": " + v.getMessage())
            .collect(Collectors.joining(", "));
    }
}

// REST endpoint
@Path("/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserResource {
    
    @Inject
    private UserRegistrationService userService;
    
    @POST
    public Response register(User user) {
        try {
            User created = userService.register(user);
            return Response.status(Response.Status.CREATED)
                          .entity(created)
                          .build();
        } catch (ValidationException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                          .entity(new ErrorResponse(e.getMessage()))
                          .build();
        }
    }
    
    @PUT
    @Path("/{id}")
    public Response update(@PathParam("id") Long id, User user) {
        user.setId(id);
        try {
            User updated = userService.updateProfile(user);
            return Response.ok(updated).build();
        } catch (ValidationException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                          .entity(new ErrorResponse(e.getMessage()))
                          .build();
        }
    }
}
```

---

## Tekshiruv Savollari

1. **Jakarta Bean Validation nima va nima uchun kerak?**
2. **Built-in constraint'lar qaysilar? Har birini tushuntiring.**
3. **@NotNull, @NotBlank, @NotEmpty o'rtasidagi farq nima?**
4. **Validation groups nima va qanday ishlatiladi?**
5. **Custom constraint validator qanday yaratiladi?**
6. **Method validation qanday amalga oshiriladi?**
7. **Validation message'larini qanday sozlash mumkin?**
8. **JPA entity'larida validation qanday ishlaydi?**
9. **@Valid annotation nima vazifani bajaradi?**
10. **ValidatorFactory va Validator qanday ishlatiladi?**

---

## Amaliy Topshiriq

Quyidagi imkoniyatlarga ega Bean Validation ilovasini yarating:

1. **Entity validation** - User, Product, Order entity'larida turli constraint'lar
2. **Custom validators** - Phone number, Strong password, Unique email/username
3. **Validation groups** - Create, Update, Delete guruhlari
4. **Method validation** - Service metodlarida validation
5. **Cross-field validation** - Ikki field o'rtasidagi munosabatni tekshirish (startDate < endDate)
6. **Message properties** - Xatolik xabarlarini external fayldan o'qish

---

**1-Modul yakunlandi!** 🎉

**[Mundarijaga qaytish](../README.md)**

> Jakarta Bean Validation - ma'lumotlar to'g'riligini ta'minlashning standart usuli. Bu bilimlar orqali xavfsiz va ishonchli ilovalar yaratishni o'zlashtirasiz. 🚀
