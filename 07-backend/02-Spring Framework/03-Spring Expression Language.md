# 4-Modul: Spring Expression Language (SpEL)

## SpEL nima?

**Spring Expression Language (SpEL)** - runtime'da ob'ektlar grafigini so'roq qilish va manipulyatsiya qilish imkonini beruvchi kuchli ifoda tili. Uning sintaksisi Unified EL ga o'xshash, lekin metod chaqiruvlari va string templating kabi qo'shimcha xususiyatlarni taklif etadi.

```java
// SpEL misoli
@Value("#{1 + 1}")  // 2
private int result;

// Ob'ekt xususiyatiga murojaat
@Value("#{user.name}")
private String userName;
```

### SpEL qayerda ishlatiladi?

| Soha | Tavsif |
|------|--------|
| **Konfiguratsiya** | Bean'lar va property'larni dinamik sozlash |
| **Xavfsizlik** | Spring Security'da access control qoidalari |
| **Ma'lumotlarga kirish** | Spring Data'da dinamik SQL query'lar |
| **Messaging** | Spring Integration'da message routing |
| **Validatsiya** | Custom validation qoidalari |

---

## 4.1 - SpEL asoslari

### ExpressionParser bilan ishlash

```java
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.Expression;

public class SpelBasicExample {
    public static void main(String[] args) {
        ExpressionParser parser = new SpelExpressionParser();
        
        // 1. Literal ifodalar
        Expression expr = parser.parseExpression("'Hello SpEL'");
        String result = expr.getValue(String.class);
        System.out.println(result);  // Hello SpEL
        
        // 2. Raqamlar
        int number = parser.parseExpression("42").getValue(Integer.class);
        double pi = parser.parseExpression("3.14159").getValue(Double.class);
        
        // 3. Boolean
        boolean isTrue = parser.parseExpression("true").getValue(Boolean.class);
        
        // 4. null
        Object nullValue = parser.parseExpression("null").getValue();
    }
}
```

### Inline List'lar

```java
@Value("#{{1,2,3,4}}")
private List<Integer> numbers;

@Value("#{{'a','b','c'}}")
private List<String> letters;

// 2 o'lchovli list
@Value("#{{{1,2},{3,4},{5,6}}}")
private List<List<Integer>> matrix;

// Methodda
ExpressionParser parser = new SpelExpressionParser();
Object numbers = parser.parseExpression("{1,2,3,4}").getValue();
Object matrix = parser.parseExpression("{{'a','b'},{'x','y'}}").getValue();
```

### Inline Map'lar

```java
@Value("#{{name:'Ali', age:25}}")
private Map<String, Object> user;

@Value("#{{'key1':'value1', 'key2':'value2'}}")
private Map<String, String> keyValues;

// Methodda
Map<String, Object> map = parser.parseExpression("{name:'Ali', age:25}").getValue(Map.class);
```

---

## 4.2 - Matematik operatorlar

```java
@Component
public class MathOperations {
    
    // Asosiy arifmetik amallar
    @Value("#{19 + 1}")      // 20
    private double add;
    
    @Value("#{20 - 1}")      // 19
    private double subtract;
    
    @Value("#{10 * 2}")      // 20
    private double multiply;
    
    @Value("#{36 / 2}")      // 18
    private double divide;
    
    @Value("#{37 % 10}")     // 7
    private double modulo;
    
    @Value("#{2 ^ 9}")       // 512
    private double powerOf;
    
    // Alphabetic operatorlar
    @Value("#{36 div 2}")    // 18
    private double divideAlphabetic;
    
    @Value("#{37 mod 10}")   // 7
    private double moduloAlphabetic;
    
    // Qavslar bilan
    @Value("#{(2 + 2) * 2 + 9}")  // 17
    private double brackets;
    
    // String concatenation
    @Value("#{'String1 ' + 'string2'}")  // "String1 string2"
    private String addString;
    
    // Murakkab ifodalar
    @Value("#{1 + 2 - 3 * 8}")  // -21
    private double complex;
}

// Method'da ishlatish
ExpressionParser parser = new SpelExpressionParser();
Object result = parser.parseExpression("1+2-3*8").getValue();
```

---

## 4.3 - Relational operatorlar

```java
@Component
public class RelationalOperations {
    
    // Asosiy operatorlar
    @Value("#{1 == 1}")      // true
    private boolean equal;
    
    @Value("#{1 != 1}")      // false
    private boolean notEqual;
    
    @Value("#{1 > 1}")       // false
    private boolean greaterThan;
    
    @Value("#{1 < 1}")       // false
    private boolean lessThan;
    
    @Value("#{1 >= 1}")      // true
    private boolean greaterThanOrEqual;
    
    @Value("#{1 <= 1}")      // true
    private boolean lessThanOrEqual;
    
    // Alphabetic operatorlar
    @Value("#{1 eq 1}")      // true
    private boolean equalAlphabetic;
    
    @Value("#{1 ne 1}")      // false
    private boolean notEqualAlphabetic;
    
    @Value("#{1 gt 1}")      // false
    private boolean greaterThanAlphabetic;
    
    @Value("#{1 lt 1}")      // false
    private boolean lessThanAlphabetic;
    
    @Value("#{1 ge 1}")      // true
    private boolean greaterThanOrEqualAlphabetic;
    
    @Value("#{1 le 1}")      // true
    private boolean lessThanOrEqualAlphabetic;
    
    // String solishtirish
    @Value("#{'white' < 'whete'}")  // true (lexicographic)
    private boolean stringCompare;
}
```

---

## 4.4 - Logical operatorlar

```java
@Component
public class LogicalOperations {
    
    // Asosiy operatorlar
    @Value("#{250 > 200 && 200 < 4000}")   // true
    private boolean and;
    
    @Value("#{400 > 300 || 150 < 100}")    // true
    private boolean or;
    
    @Value("#{!true}")                      // false
    private boolean not;
    
    // Alphabetic operatorlar
    @Value("#{250 > 200 and 200 < 4000}")  // true
    private boolean andAlphabetic;
    
    @Value("#{400 > 300 or 150 < 100}")   // true
    private boolean orAlphabetic;
    
    @Value("#{not true}")                  // false
    private boolean notAlphabetic;
    
    // Murakkab ifodalar
    @Value("#{isMember('Ali') and isMember('Vali')}")
    private boolean bothMembers;
    
    @Value("#{isMember('Ali') and !isMember('Vali')}")
    private boolean onlyAli;
}
```

---

## 4.5 - Conditional operatorlar

### Ternary Operator

```java
@Component
public class ConditionalOperations {
    
    // Ternary operator
    @Value("#{2 > 1 ? 'a' : 'b'}")  // "a"
    private String ternary;
    
    @Value("#{2 < 1 ? 'a' : 'b'}")  // "b"
    private String ternary2;
    
    // Null check with ternary
    @Value("#{someBean.someProperty != null ? someBean.someProperty : 'default'}")
    private String withNullCheck;
}

// Bean class
@Component
public class SomeBean {
    public String getSomeProperty() {
        return "actual value";
    }
}
```

### Elvis Operator (?:)

```java
@Component
public class ElvisOperator {
    
    // Elvis operator - null safe
    @Value("#{someBean.someProperty ?: 'default'}")
    private String elvis;
    
    // Elvis operator bilan ternary'ni soddalashtirish
    // Ternary: someBean.someProperty != null ? someBean.someProperty : 'default'
    // Elvis:   someBean.someProperty ?: 'default'
    
    @Value("#{user.name ?: 'Anonymous'}")
    private String displayName;
}
```

---

## 4.6 - Regex bilan ishlash

```java
@Component
public class RegexOperations {
    
    // Raqamlar tekshiruvi
    @Value("#{'100' matches '\\d+' }")
    private boolean validNumericStringResult;  // true
    
    @Value("#{'100fghdjf' matches '\\d+' }")
    private boolean invalidNumericStringResult;  // false
    
    // Harflar tekshiruvi
    @Value("#{'valid alphabetic string' matches '[a-zA-Z\\s]+' }")
    private boolean validAlphabeticStringResult;  // true
    
    @Value("#{'invalid alphabetic string #$1' matches '[a-zA-Z\\s]+' }")
    private boolean invalidAlphabeticStringResult;  // false
    
    // Email validation
    @Value("#{email matches '^[A-Za-z0-9+_.-]+@(.+)$'}")
    private boolean validEmail;
    
    // Phone validation
    @Value("#{phone matches '\\+998\\d{9}'}")
    private boolean validPhone;
    
    // Bean property regex
    @Value("#{someBean.someValue matches '\\d+'}")
    private boolean validNumericValue;
}
```

---

## 4.7 - List va Map obyektlariga kirish

### Java class

```java
@Component
public class WorkersHolder {
    
    private List<String> workers = Arrays.asList("Ali", "Vali", "Soli", "Guli");
    
    private Map<String, Integer> salaryByWorkers = new HashMap<>() {{
        put("John", 5000);
        put("George", 6000);
        put("Susie", 4500);
    }};
    
    // getters and setters
}
```

### SpEL bilan List va Map'ga kirish

```java
@Component
public class AccessCollectionExample {
    
    @Autowired
    private WorkersHolder workersHolder;
    
    // List'dan element olish
    @Value("#{workersHolder.workers[0]}")
    private String firstWorker;    // "Ali"
    
    @Value("#{workersHolder.workers[3]}")
    private String lastWorker;     // "Guli"
    
    @Value("#{workersHolder.workers.size()}")
    private Integer numberOfWorkers;  // 4
    
    // Map'dan element olish
    @Value("#{workersHolder.salaryByWorkers['John']}")
    private Integer johnSalary;    // 5000
    
    @Value("#{workersHolder.salaryByWorkers['George']}")
    private Integer georgeSalary;  // 6000
    
    @Value("#{workersHolder.salaryByWorkers['Susie']}")
    private Integer susieSalary;   // 4500
    
    // List'ning subset'i
    @Value("#{workersHolder.workers.subList(0, 2)}")
    private List<String> firstTwoWorkers;  // ["Ali", "Vali"]
    
    // Map'ning key set'i
    @Value("#{workersHolder.salaryByWorkers.keySet()}")
    private Set<String> workerNames;
}
```

---

## 4.8 - Method va constructor chaqirish

### Method chaqirish

```java
@Component
public class MethodCallExample {
    
    // String metodlari
    @Value("#{'abc'.substring(2, 3)}")  // "c"
    private String substring;
    
    @Value("#{'Hello'.toUpperCase()}")   // "HELLO"
    private String upperCase;
    
    // Custom metod chaqirish
    @Value("#{someBean.isMember('Javohir')}")
    private boolean isMember;
    
    @Value("#{someBean.calculateTotal(100, 20)}")
    private int total;
    
    // Method zanjiri
    @Value("#{user.getName().toUpperCase()}")
    private String userNameUpper;
}

@Component
class SomeBean {
    public boolean isMember(String name) {
        return "Javohir".equals(name);
    }
    
    public int calculateTotal(int price, int discount) {
        return price - discount;
    }
}
```

### Constructor chaqirish

```java
@Component
public class ConstructorExample {
    
    // Yangi ob'ekt yaratish
    @Value("#{new java.util.Date()}")
    private Date currentDate;
    
    @Value("#{new java.lang.String('Hello SpEL')}")
    private String customString;
    
    // Custom class
    @Value("#{new com.example.User('Ali', 25)}")
    private User user;
    
    // Array yaratish
    @Value("#{new int[]{1,2,3,4}}")
    private int[] numbers;
    
    // List yaratish
    @Value("#{new java.util.ArrayList()}")
    private List<String> emptyList;
}
```

---

## 4.9 - instanceOf va type tekshirish

```java
@Component
public class InstanceOfExample {
    
    @Value("#{user instanceof T(com.example.User)}")
    private boolean isUser;
    
    @Value("#{input instanceof T(Integer)}")
    private boolean isInteger;
    
    @Value("#{input instanceof T(String)}")
    private boolean isString;
    
    @Value("#{list instanceof T(java.util.ArrayList)}")
    private boolean isArrayList;
}
```

---

## 4.10 - Variables va Custom Functions

### Variables (StandardEvaluationContext)

```java
@Component
public class VariablesExample {
    
    public void evaluateWithVariables() {
        ExpressionParser parser = new SpelExpressionParser();
        StandardEvaluationContext context = new StandardEvaluationContext();
        
        // Variable o'rnatish
        context.setVariable("name", "Ali");
        context.setVariable("age", 25);
        
        // Variable'larni ishlatish
        String result = parser.parseExpression("#name").getValue(context, String.class);
        int age = parser.parseExpression("#age").getValue(context, Integer.class);
        
        // Variable bilan ifoda
        boolean isAdult = parser.parseExpression("#age > 18")
            .getValue(context, Boolean.class);
        
        // this bilan current object
        context.setVariable("this", this);
        parser.parseExpression("#this.toString()").getValue(context);
    }
}
```

### Custom Functions

```java
@Component
public class CustomFunctionExample {
    
    // Static metod yaratish
    public static String reverseString(String input) {
        return new StringBuilder(input).reverse().toString();
    }
    
    public static int multiply(int a, int b) {
        return a * b;
    }
    
    public void registerAndUse() {
        ExpressionParser parser = new SpelExpressionParser();
        StandardEvaluationContext context = new StandardEvaluationContext();
        
        // Function'ni ro'yxatdan o'tkazish
        context.registerFunction("reverse", 
            CustomFunctionExample.class.getDeclaredMethod("reverseString", String.class));
        context.registerFunction("multiply",
            CustomFunctionExample.class.getDeclaredMethod("multiply", int.class, int.class));
        
        // Function'ni ishlatish
        String reversed = parser.parseExpression("#reverse('Hello')")
            .getValue(context, String.class);  // "olleH"
        
        int product = parser.parseExpression("#multiply(5, 3)")
            .getValue(context, Integer.class);  // 15
    }
}
```

---

## 4.11 - Collection Selection (Filtering)

### Selection (filtering)

```java
@Component
public class SelectionExample {
    
    @Autowired
    private WorkersHolder workersHolder;
    
    // ?[] - selection (filtering)
    @Value("#{workersHolder.salaryByWorkers.?[value > 5000]}")
    private Map<String, Integer> highSalaries;  // salary > 5000
    
    @Value("#{workersHolder.salaryByWorkers.?[key == 'John']}")
    private Map<String, Integer> johnSalary;     // faqat John
    
    @Value("#{workersHolder.workers.?[length() > 3]}")
    private List<String> longNames;              // uzunligi 3 dan katta
    
    // ^[] - birinchi element
    @Value("#{workersHolder.salaryByWorkers.^[value > 5000]}")
    private Map<String, Integer> firstHighSalary;
    
    // $[] - oxirgi element
    @Value("#{workersHolder.salaryByWorkers.$[value > 5000]}")
    private Map<String, Integer> lastHighSalary;
}

// List'da selection
@Component
public class ListSelectionExample {
    
    @Value("#{{1,2,3,4,5,6,7,8,9,10}.?[#this > 5]}")
    private List<Integer> greaterThanFive;  // [6,7,8,9,10]
    
    @Value("#{{1,2,3,4,5,6,7,8,9,10}.?[#this % 2 == 0]}")
    private List<Integer> evenNumbers;      // [2,4,6,8,10]
    
    @Value("#{{1,2,3,4,5,6,7,8,9,10}.^[#this > 5]}")
    private Integer firstGreaterThanFive;   // 6
    
    @Value("#{{1,2,3,4,5,6,7,8,9,10}.$[#this > 5]}")
    private Integer lastGreaterThanFive;    // 10
}
```

### Collection Projection (![])

```java
@Component
public class ProjectionExample {
    
    @Autowired
    private WorkersHolder workersHolder;
    
    // ![] - projection (transformatsiya)
    @Value("#{workersHolder.workers.![#this.toUpperCase()]}")
    private List<String> upperCaseNames;  // ["ALI", "VALI", "SOLI", "GULI"]
    
    @Value("#{workersHolder.workers.![#this.length()]}")
    private List<Integer> nameLengths;    // [3,4,4,4]
    
    // Map projection
    @Value("#{workersHolder.salaryByWorkers.![key + ': ' + value]}")
    private List<String> formattedSalaries;
    
    // Murakkab projection
    @Value("#{workersHolder.workers.![#this + ' - ' + #this.length()]}")
    private List<String> nameWithLength;
}
```

---

## 4.12 - Annotation'da SpEL ishlatish

### @Value annotation

```java
@Component
public class SpelAnnotationExample {
    
    // Literal values
    @Value("Hello World")
    private String literalString;
    
    @Value("42")
    private int literalNumber;
    
    // SpEL expressions
    @Value("#{1 + 1}")
    private int addResult;
    
    @Value("#{2 > 1 ? 'true' : 'false'}")
    private String ternaryResult;
    
    // Bean property access
    @Value("#{someBean.someProperty}")
    private String beanProperty;
    
    // System property
    @Value("#{systemProperties['user.name']}")
    private String systemUserName;
    
    @Value("#{systemEnvironment['PATH']}")
    private String systemPath;
    
    // Property placeholder (${}) vs SpEL (#{})
    @Value("${app.name}")        // application.properties dan
    private String appName;
    
    @Value("#{'${app.name}'}")   // Property placeholder + SpEL
    private String appNameSpel;
    
    @Value("#{${app.timeout} * 1000}")
    private long timeoutInMillis;
}
```

### @Conditional annotation

```java
@Configuration
public class ConditionalConfig {
    
    @Bean
    @ConditionalOnExpression("#{systemProperties['os.name'].contains('Windows')}")
    public WindowsService windowsService() {
        return new WindowsService();
    }
    
    @Bean
    @ConditionalOnExpression("#{systemProperties['os.name'].contains('Linux')}")
    public LinuxService linuxService() {
        return new LinuxService();
    }
    
    @Bean
    @ConditionalOnExpression("${app.feature.enabled:false} and #{1 == 1}")
    public ConditionalBean conditionalBean() {
        return new ConditionalBean();
    }
}
```

---

## 4.13 - Spring XML da SpEL

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd">
    
    <!-- Property placeholder -->
    <context:property-placeholder location="application.properties"/>
    
    <!-- SpEL bilan property sozlash -->
    <bean id="myBean" class="com.example.MyBean">
        <property name="result" value="#{1 + 1}"/>
        <property name="message" value="#{'Hello ' + 'World'}"/>
        <property name="userName" value="#{systemProperties['user.name']}"/>
        <property name="appName" value="${app.name}"/>
    </bean>
    
    <!-- Bean reference -->
    <bean id="userService" class="com.example.UserService">
        <property name="dataSource" value="#{dataSource}"/>
        <property name="maxConnections" value="#{dataSource.maxConnections}"/>
    </bean>
    
    <!-- Conditional bean creation -->
    <bean id="conditionalBean" class="com.example.ConditionalBean">
        <property name="enabled" value="#{systemProperties['feature.enabled'] ?: false}"/>
    </bean>
</beans>
```

---

## 4.14 - Amaliy misollar

### Misol 1: Dinamik konfiguratsiya

```java
@Configuration
@PropertySource("classpath:application.properties")
public class DynamicConfig {
    
    @Value("${app.timeout:30}")
    private int timeoutSeconds;
    
    @Value("#{${app.timeout:30} * 1000}")
    private long timeoutMillis;
    
    @Value("#{'${app.cors.allowed-origins}'.split(',')}")
    private List<String> allowedOrigins;
    
    @Value("#{${app.cache.enabled:false} ? 'cache' : 'no-cache'}")
    private String cacheHeader;
    
    @Bean
    public DataSource dataSource(
            @Value("${db.url}") String url,
            @Value("${db.username}") String username,
            @Value("#{systemProperties['DB_PASSWORD']}") String password) {
        return new DataSource(url, username, password);
    }
}
```

### Misol 2: Validation

```java
@Component
public class ValidationService {
    
    @Value("#{user.email matches '^[A-Za-z0-9+_.-]+@(.+)$'}")
    private boolean validEmail;
    
    @Value("#{user.age >= 18 && user.age <= 100}")
    private boolean validAge;
    
    @Value("#{user.phone matches '\\+998\\d{9}'}")
    private boolean validPhone;
    
    public void validateUser(User user) {
        StandardEvaluationContext context = new StandardEvaluationContext(user);
        ExpressionParser parser = new SpelExpressionParser();
        
        boolean isValid = parser.parseExpression(
            "email matches '^[A-Za-z0-9+_.-]+@(.+)$' && " +
            "age >= 18 && age <= 100"
        ).getValue(context, Boolean.class);
        
        if (!isValid) {
            throw new ValidationException("User validation failed");
        }
    }
}
```

### Misol 3: Security expression'lar

```java
@Configuration
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig {
    
    // Method security
    @PreAuthorize("#userId == authentication.principal.userId")
    public void updateUser(Long userId, UserUpdateDto dto) {
        // ...
    }
    
    @PreAuthorize("hasRole('ADMIN') or #userId == authentication.principal.id")
    public User getUser(Long userId) {
        // ...
    }
    
    @PostAuthorize("returnObject.owner == authentication.principal.username")
    public Document getDocument(Long id) {
        // ...
    }
    
    // Web security
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.authorizeRequests()
            .antMatchers("/admin/**").access("hasRole('ADMIN')")
            .antMatchers("/user/**").access("hasRole('USER')")
            .antMatchers("/api/**").access("isAuthenticated()")
            .antMatchers("/public/**").permitAll();
        return http.build();
    }
}
```

### Misol 4: Batch processing

```java
@Component
public class BatchProcessingService {
    
    @Value("#{${batch.chunk-size:10}}")
    private int chunkSize;
    
    @Value("#{T(java.lang.Runtime).getRuntime().availableProcessors()}")
    private int availableProcessors;
    
    @Value("#{systemProperties['batch.threads'] ?: availableProcessors}")
    private int threadCount;
    
    public void processItems(List<Item> items) {
        StandardEvaluationContext context = new StandardEvaluationContext();
        context.setVariable("items", items);
        context.setVariable("chunkSize", chunkSize);
        
        ExpressionParser parser = new SpelExpressionParser();
        
        // Items ni chunk'larga bo'lish
        List<List<Item>> chunks = parser.parseExpression(
            "#items.?[#this.id > 0].!['partition']"
        ).getValue(context, List.class);
        
        // Parallel processing
        chunks.parallelStream().forEach(chunk -> processChunk(chunk));
    }
}
```

---

## SpEL Reference

### Operatorlar jadvali

| Tur | Operatorlar | Alphabetic |
|-----|-------------|------------|
| **Arithmetic** | +, -, *, /, %, ^ | div, mod |
| **Relational** | ==, !=, >, <, >=, <= | eq, ne, gt, lt, ge, le |
| **Logical** | &&, \|\|, ! | and, or, not |
| **Conditional** | ? : | |
| **Elvis** | ?: | |
| **Regex** | matches | |

### Collection operatorlari

| Operator | Tavsif |
|----------|--------|
| `?[]` | Selection (filtering) |
| `^[]` | Birinchi element |
| `$[]` | Oxirgi element |
| `![]` | Projection (transformatsiya) |

### @Value da ishlatish

```java
@Value("${property.name}")           // Property placeholder
@Value("#{expression}")              // SpEL expression
@Value("#{${property}}")             // SpEL + placeholder
@Value("#{bean.method()}")           // Method call
@Value("#{bean.field}")              // Field access
@Value("#{T(Class).staticMethod()}") // Static method
```

---

## Tekshiruv Savollari

1. **SpEL nima va u qayerlarda ishlatiladi?**
2. **SpEL da inline list va map qanday yoziladi?**
3. **SpEL da qanday matematik operatorlar bor?**
4. **Relational operatorlarning alphabetic variantlari qaysilar?**
5. **Elvis operatori (?:) nima va nima uchun kerak?**
6. **SpEL da regex qanday ishlatiladi?**
7. **List va Map elementlariga qanday murojaat qilinadi?**
8. **Collection selection (?[]) nima?**
9. **Collection projection (![]) nima?**
10. **@Value annotation'ida ${} va #{} farqi nima?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega Spring loyihasini yarating:

1. **@Value** bilan matematik va mantiqiy ifodalar
2. **SpEL** yordamida list va map filtrlash
3. **Custom function** yaratish va ro'yxatdan o'tkazish
4. **Property placeholder** + **SpEL** kombinatsiyasi
5. **Conditional bean** yaratish
6. **Security expression** lar bilan method protection

```java
// Tekshirish
@Value("#{user.age >= 18 ? 'Adult' : 'Minor'}")
private String ageGroup;

@Value("#{${app.timeout} * 1000}")
private long timeout;

@PreAuthorize("hasRole('ADMIN')")
public void adminOnly() { }
```

---

**Keyingi mavzu:** [Aspect Oriented Programming](./05_Aspect_Oriented_Programming.md)  
**[Mundarijaga qaytish](../../README.md)**

> SpEL - Spring'da konfiguratsiyani dinamik va moslashuvchan qilishning kaliti! 🚀
