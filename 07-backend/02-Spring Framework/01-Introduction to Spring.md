# 2-Modul: Spring Framework Introduction

## Spring Framework nima?

**Spring Framework** - Java dasturlash tilida korporativ ilovalar yaratishni soddalashtiruvchi ochiq kodli, yengil va modulli framework.

```java
// Spring'siz (Java EE) - murakkab va ko'p kod
public class UserService {
    private UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();  // Qattiq bog'liqlik
    }
}

// Spring bilan - DI orqali
@Component
public class UserService {
    @Autowired
    private UserDAO userDAO;  // Spring boshqaradi
}
```

### Spring nima uchun kerak?

1. **Kodni soddalashtirish** - Murakkab korporativ ilovalarni oddiy qilish
2. **Modullik** - Kerakli modullarni tanlab olish imkoniyati
3. **Yengillik** - Resurslarni kam iste'mol qilish
4. **Moslashuvchanlik** - Turli texnologiyalar bilan integratsiya
5. **Katta jamoatchilik** - Ko'plab dokumentatsiya va yordam

---

## 2.1 - Java EE ning kamchiliklari

### Java EE (Jakarta EE) muammolari

| Muammo | Tavsif |
|--------|--------|
| **Murakkablik** | O'rganish qiyin, tik egri chiziq |
| **Ogirlik** | Ko'p resurs talab qiladi, kichik ilovalar uchun mos emas |
| **Moslashuvchanlik yo'q** | Qattiq arxitektura, sozlash va kengaytirish qiyin |
| **Cheklangan jamoatchilik** | Spring ga nisbatan kichik va kam faol hamjamiyat |
| **Cheklangan vositalar** | Tooling va ekotizim kam rivojlangan |

```java
// Java EE usulida - EJB bilan
@Stateless
public class UserServiceBean implements UserService {
    @PersistenceContext
    private EntityManager em;  // Qattiq bog'langan
    
    public User findUser(Long id) {
        return em.find(User.class, id);
    }
}
// Ko'p konfiguratsiya, murakkab test qilish
```

---

## 2.2 - Spring afzalliklari

| Xususiyat | Tavsif |
|-----------|--------|
| **Yengil va modulli** | Boshqa frameworklar bilan oson integratsiya |
| **Dependency Injection (DI)** | Bog'liqliklarni boshqarishning kuchli mexanizmi |
| **Keng dokumentatsiya** | Katta va faol jamoatchilik, ko'plab resurslar |
| **Oson o'rganish** | Yangi dasturchilar uchun qulay |
| **Moslashuvchan arxitektura** | Ilova talablariga mos sozlash imkoniyati |

```java
// Spring usulida
@Component
public class UserService {
    private final UserRepository userRepository;
    
    // Konstruktor orqali DI
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    
    public User findUser(Long id) {
        return userRepository.findById(id);
    }
}
// Sodda, test qilish oson, moslashuvchan
```

### Spring tarixi

- **2003** - Rod Johnson tomonidan yaratilgan
- **Asosiy maqsad** - Java dasturlashni soddalashtirish
- **Ochiq kod** - Apache 2.0 litsenziyasi

---

## 2.3 - Spring modullari

```
┌─────────────────────────────────────────────────────────────┐
│                    Spring Framework                          │
├─────────────┬─────────────┬─────────────┬───────────────────┤
│ Spring Core │ Spring AOP  │ Spring JDBC │ Spring ORM        │
│ (IoC/DI)    │ (Aspect)    │ (Data)      │ (Hibernate, JPA)  │
├─────────────┼─────────────┼─────────────┼───────────────────┤
│ Spring MVC  │ Spring Web  │ Spring Test │ Spring Security   │
│ (Web)       │ (WebSocket) │ (Testing)   │ (Security)        │
└─────────────┴─────────────┴─────────────┴───────────────────┘
```

### Asosiy modullar

| Modul | Vazifasi |
|-------|----------|
| **Spring Core** | IoC container, DI asoslari |
| **Spring AOP** | Aspect-oriented programming |
| **Spring JDBC** | Ma'lumotlar bazasi bilan ishlash |
| **Spring ORM** | ORM frameworklar bilan integratsiya |
| **Spring MVC** | Web ilovalar yaratish |
| **Spring Test** | Unit va integration testlar |

---

## 2.4 - Inversion of Control (IoC)

### IoC nima?

**Inversion of Control (IoC)** - ob'ektlarning bog'liqliklarini o'zi yaratmasdan, tashqaridan (container) olish prinsipi.

```java
// ❌ Traditional - Control obyektning o'zida
public class OrderService {
    private PaymentService paymentService;
    
    public OrderService() {
        // Ob'ekt o'zi bog'liqlikni yaratadi
        this.paymentService = new PaymentService(); 
    }
}

// ✅ IoC - Control container'da
@Component
public class OrderService {
    private final PaymentService paymentService;
    
    // Container bog'liqlikni inject qiladi
    public OrderService(PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

### Bean nima?

**Bean** - Spring IoC container tomonidan boshqariladigan Java ob'ekti.

```java
// Spring container tomonidan boshqariladigan ob'ekt
@Component
public class MyBean {
    // Spring bu ob'ektni yaratadi, boshqaradi va inject qiladi
}
```

---

## 2.5 - IoC Container turlari

### 1. BeanFactory Container

```java
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;

// Eng asosiy IoC container
BeanFactory factory = new XmlBeanFactory(new ClassPathResource("beans.xml"));
MyBean myBean = factory.getBean(MyBean.class);
```

**Xususiyatlari:**
- Eng yengil container
- Lazy initialization (kerak bo'lganda yaratadi)
- Asosiy DI funksiyalari

### 2. ApplicationContext Container

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

// Ko'proq funksiyalarga ega container
ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
MyBean myBean = context.getBean(MyBean.class);
```

**Xususiyatlari:**
- BeanFactory dan kengaytirilgan
- Eager initialization (startda yaratadi)
- Message source (i18n)
- Event publishing
- AOP qo'llab-quvvatlash

### BeanFactory vs ApplicationContext

| Xususiyat | BeanFactory | ApplicationContext |
|-----------|-------------|-------------------|
| **Initialization** | Lazy (kerak bo'lganda) | Eager (startda) |
| **AOP** | Qo'llab-quvvatlamaydi | Qo'llab-quvvatlaydi |
| **Event handling** | Yo'q | Ha |
| **Internationalization** | Yo'q | Ha |
| **Resource loading** | Cheklangan | To'liq |

```java
// Tavsiya etiladi - ApplicationContext ishlatish
@Configuration
@ComponentScan("com.example")
public class AppConfig {
    public static void main(String[] args) {
        ApplicationContext context = 
            new AnnotationConfigApplicationContext(AppConfig.class);
        
        // Bean olish
        UserService userService = context.getBean(UserService.class);
    }
}
```

---

## 2.6 - Bean wiring usullari

### 1. Automatic Wiring (Avtomatik bog'lash)

Spring ikkita mexanizm orqali avtomatik bog'lashni amalga oshiradi:

#### Component Scanning - Bean'larni avtomatik topish

```java
// 1. Bean'ni belgilash
@Component
public class UserService {
    // ...
}

@Component
public class OrderService {
    // ...
}

// 2. Scanning sozlash
@Configuration
@ComponentScan(basePackages = "com.example")
public class AppConfig {
    // ComponentScan orqali barcha @Component larni topadi
}
```

#### Autowiring - Bog'liqliklarni avtomatik inject qilish

```java
@Component
public class UserService {
    private final UserRepository userRepository;
    private final EmailService emailService;
    
    // @Autowired - Spring bog'liqliklarni inject qiladi
    @Autowired
    public UserService(UserRepository userRepository, EmailService emailService) {
        this.userRepository = userRepository;
        this.emailService = emailService;
    }
}
```

### 2. Java-based Configuration (Java konfiguratsiya)

```java
@Configuration  // Konfiguratsiya class'ini belgilash
public class AppConfig {
    
    @Bean  // Bean yaratish
    public UserRepository userRepository() {
        return new UserRepository();
    }
    
    @Bean
    public UserService userService() {
        // Bog'liqliklarni qo'lda bog'lash
        return new UserService(userRepository());
    }
    
    // Yoki parametr orqali
    @Bean
    public OrderService orderService(UserRepository userRepository) {
        return new OrderService(userRepository);
    }
}
```

### 3. XML-based Configuration (XML konfiguratsiya)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd">
    
    <!-- Bean declaration -->
    <bean id="userRepository" class="com.example.UserRepository"/>
    
    <bean id="userService" class="com.example.UserService">
        <!-- Constructor injection -->
        <constructor-arg ref="userRepository"/>
    </bean>
    
    <bean id="orderService" class="com.example.OrderService">
        <!-- Setter injection -->
        <property name="userRepository" ref="userRepository"/>
    </bean>
</beans>
```

---

## 2.7 - Advanced wiring

### Wiring collections

```java
// JavaConfig - Collection wiring
@Configuration
public class AppConfig {
    
    @Bean
    public List<String> supportedCountries() {
        return Arrays.asList("UZ", "US", "UK");
    }
    
    @Bean
    public Set<String> adminEmails() {
        return Set.of("admin@example.com", "super@example.com");
    }
    
    @Bean
    public Map<String, Integer> portMapping() {
        Map<String, Integer> ports = new HashMap<>();
        ports.put("http", 80);
        ports.put("https", 443);
        return ports;
    }
}

// XML - Collection wiring
<bean id="supportedCountries" class="java.util.ArrayList">
    <constructor-arg>
        <list>
            <value>UZ</value>
            <value>US</value>
            <value>UK</value>
        </list>
    </constructor-arg>
</bean>
```

### p-namespace va c-namespace

```xml
<!-- XML namespace'lar -->
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:c="http://www.springframework.org/schema/c">

    <!-- p-namespace - property injection -->
    <bean id="user" class="com.example.User"
          p:name="John"
          p:age="30"/>

    <!-- c-namespace - constructor injection -->
    <bean id="userService" class="com.example.UserService"
          c:userRepository-ref="userRepository"
          c:emailService-ref="emailService"/>

</beans>
```

### factory-method, init-method, destroy-method

```java
// JavaConfig
@Configuration
public class AppConfig {
    
    @Bean(initMethod = "init", destroyMethod = "cleanup")
    public DataSource dataSource() {
        return new DataSource();
    }
    
    @Bean
    public static ConnectionFactory connectionFactory() {
        return ConnectionFactory.getInstance();  // factory-method
    }
}

// XML
<bean id="dataSource" 
      class="com.example.DataSource"
      init-method="init"
      destroy-method="cleanup"/>

<bean id="connectionFactory"
      class="com.example.ConnectionFactory"
      factory-method="getInstance"/>
```

### PropertySources

```java
@Configuration
@PropertySource("classpath:application.properties")
public class AppConfig {
    
    @Value("${database.url}")
    private String dbUrl;
    
    @Value("${database.username}")
    private String dbUsername;
    
    @Bean
    public DataSource dataSource() {
        return new DataSource(dbUrl, dbUsername);
    }
}
```

### Import configuration

```java
@Configuration
@Import({DatabaseConfig.class, SecurityConfig.class})
public class AppConfig {
    // Barcha konfiguratsiyalarni birlashtirish
}
```

### Conditional beans

```java
@Configuration
public class AppConfig {
    
    @Bean
    @Conditional(DevelopmentCondition.class)
    public DataSource devDataSource() {
        return new DevDataSource();  // Faqat development da
    }
    
    @Bean
    @Conditional(ProductionCondition.class)
    public DataSource prodDataSource() {
        return new ProdDataSource(); // Faqat production da
    }
}

// Custom condition
public class DevelopmentCondition implements Condition {
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        String profile = context.getEnvironment().getProperty("spring.profiles.active");
        return "dev".equals(profile);
    }
}
```

### Addressing ambiguity in autowiring

```java
@Component
public class PaymentService {
    
    // Bir nechta bean mavjud bo'lganda - @Primary
    @Autowired
    @Primary
    private PaymentProcessor primaryProcessor;
    
    // @Qualifier bilan aniq bean ni tanlash
    @Autowired
    @Qualifier("paypalProcessor")
    private PaymentProcessor paypalProcessor;
    
    // Yoki constructor parametrida
    public PaymentService(@Qualifier("stripeProcessor") PaymentProcessor processor) {
        this.processor = processor;
    }
}

// Bean'larga nom berish
@Component("paypalProcessor")
public class PayPalProcessor implements PaymentProcessor { }

@Component("stripeProcessor")
public class StripeProcessor implements PaymentProcessor { }

@Component
@Primary
public class DefaultProcessor implements PaymentProcessor { }
```

---

## 2.8 - Amaliy misol

### To'liq Spring konfiguratsiya misoli

```java
// 1. Model
public class Product {
    private Long id;
    private String name;
    private double price;
    // getters, setters, constructor
}

// 2. Repository
@Repository
public class ProductRepository {
    private List<Product> products = new ArrayList<>();
    
    public void save(Product product) {
        products.add(product);
    }
    
    public List<Product> findAll() {
        return products;
    }
}

// 3. Service
@Service
public class ProductService {
    private final ProductRepository productRepository;
    
    @Autowired
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
    
    public void createProduct(Product product) {
        productRepository.save(product);
    }
    
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
}

// 4. Configuration
@Configuration
@ComponentScan("com.example")
@PropertySource("classpath:application.properties")
public class AppConfig {
    
    @Bean
    @ConditionalOnProperty(name = "cache.enabled", havingValue = "true")
    public CacheManager cacheManager() {
        return new CacheManager();
    }
    
    @Bean
    public DataSource dataSource(
            @Value("${db.url}") String url,
            @Value("${db.username}") String username,
            @Value("${db.password}") String password) {
        return new DataSource(url, username, password);
    }
}

// 5. Main
public class Application {
    public static void main(String[] args) {
        ApplicationContext context = 
            new AnnotationConfigApplicationContext(AppConfig.class);
        
        ProductService productService = context.getBean(ProductService.class);
        
        Product product = new Product(1L, "Laptop", 1200.0);
        productService.createProduct(product);
        
        productService.getAllProducts()
            .forEach(p -> System.out.println(p.getName()));
    }
}
```

---

## Tekshiruv Savollari

1. **Java EE ning asosiy kamchiliklari nimalar?**
2. **Spring Framework qanday afzalliklarga ega?**
3. **IoC (Inversion of Control) nima? Spring qanday amalga oshiradi?**
4. **Bean nima? Spring IoC container qanday boshqaradi?**
5. **BeanFactory va ApplicationContext o'rtasidagi farq?**
6. **Spring'da bean wiring qanday amalga oshiriladi? 3 ta usulni ayting.**
7. **@Component, @Autowired, @Configuration annotatsiyalarining vazifasi?**
8. **JavaConfig va XML konfiguratsiya o'rtasidagi farq?**
9. **@ComponentScan nima va nima uchun kerak?**
10. **@Primary va @Qualifier qachon ishlatiladi?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega Spring loyihasini yarating:

1. **JavaConfig** yordamida konfiguratsiya
2. **Component scanning** orqali bean'lar topilsin
3. **Constructor injection** ishlatilsin
4. **@Value** orqali properties fayldan ma'lumot o'qilsin
5. **@Primary** va **@Qualifier** bilan bir nechta bean'lar boshqarilsin
6. **Conditional** bean yaratilsin (dev/prod)
7. **@PostConstruct** va **@PreDestroy** ishlatilsin

```java
// Tekshirish
mvn spring-boot:run
# yoki
java -jar target/myapp.jar
```

---

**Keyingi mavzu:** [Spring Bean Lifecycle](./03_Spring_Bean_Lifecycle.md)  
**[Mundarijaga qaytish](../../README.md)**

> Spring Framework - Java ekosistemasidagi eng muhim framework! 🚀
