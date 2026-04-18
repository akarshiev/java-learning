# 3-Modul: Bean Scopes, Lazy va Eager Beans

## Bean Scope nima?

**Bean Scope** - Spring IoC container tomonidan yaratiladigan bean'ning hayot aylanishi va ko'rinish doirasini belgilaydi. Boshqacha aytganda, bir bean definition'dan nechta ob'ekt yaratilishi va ular qancha vaqt yashashini aniqlaydi.

```java
// Scope'ni belgilash
@Component
@Scope("prototype")  // Har safar yangi ob'ekt
public class PrototypeBean {
    // ...
}

// yoki
@Bean
@Scope("singleton")  // Default, bitta ob'ekt
public SingletonBean singletonBean() {
    return new SingletonBean();
}
```

---

## 3.1 - Singleton Scope

### Singleton nima?

**Singleton** - Spring container'da bitta bean definition'dan faqat bitta ob'ekt yaratiladi. Bu Spring'ning default scope'i.

```java
@Component
@Scope("singleton")  // Default, yozmasa ham bo'ladi
public class ShoppingCart {
    private List<Item> items = new ArrayList<>();
    
    public void addItem(Item item) {
        items.add(item);
    }
    
    public List<Item> getItems() {
        return items;
    }
}

// Foydalanish
@Service
public class CartService {
    @Autowired
    private ShoppingCart cart1;
    
    @Autowired
    private ShoppingCart cart2;
    
    public void test() {
        System.out.println(cart1 == cart2);  // true - bir xil ob'ekt!
    }
}
```

### Singleton xususiyatlari

| Xususiyat | Tavsif |
|-----------|--------|
| **Default scope** | Agar scope belgilanmasa, singleton bo'ladi |
| **Bitta ob'ekt** | Container uchun faqat bitta instance |
| **Thread-safe emas** | State saqlasa, thread-safety haqida o'ylash kerak |
| **Startda yaratiladi** | Eager initialization (default) |

### Singleton'da state saqlash muammosi

```java
// ❌ Singleton'da state saqlash - xavfli!
@Component
public class UserSession {
    private String currentUser;  // Mutable state!
    
    public void setCurrentUser(String user) {
        this.currentUser = user;  // Barcha thread'lar bir xil userni ko'radi!
    }
    
    public String getCurrentUser() {
        return currentUser;
    }
}

// ✅ To'g'ri - state'ni saqlamaslik
@Component
public class UserService {
    // Stateless - metod parametrlari orqali ishlaydi
    public User getUser(Long id) {
        return userRepository.findById(id);
    }
}
```

### Singleton'da lazy initialization

```java
@Component
@Lazy  // Faqat kerak bo'lganda yaratiladi
public class LazySingletonBean {
    public LazySingletonBean() {
        System.out.println("Bean yaratildi!");
    }
}

@Configuration
public class AppConfig {
    
    @Bean
    @Lazy  // Lazy initialization
    public ExpensiveService expensiveService() {
        return new ExpensiveService();  // Faqat kerak bo'lganda yaratiladi
    }
}
```

---

## 3.2 - Prototype Scope

### Prototype nima?

**Prototype** - har safar bean so'ralganda yangi ob'ekt yaratiladi.

```java
@Component
@Scope("prototype")
public class Order {
    private Long id;
    private LocalDateTime createdAt;
    
    public Order() {
        this.createdAt = LocalDateTime.now();
        this.id = System.currentTimeMillis();
    }
}

@Service
public class OrderService {
    @Autowired
    private ApplicationContext context;
    
    public Order createOrder() {
        // Har safar yangi Order yaratiladi
        return context.getBean(Order.class);
    }
}
```

### Prototype xususiyatlari

| Xususiyat | Tavsif |
|-----------|--------|
| **Har safar yangi** | getBean() chaqirilganda yangi ob'ekt |
| **Lazy** | Har doim lazy initialization |
| **Lifecycle callback'lar** | @PostConstruct ishlaydi, @PreDestroy ishlamaydi |
| **State saqlash mumkin** | Har bir ob'ekt o'z state'iga ega |

### Prototype vs Singleton

```java
@Component
public class TestService {
    
    @Autowired
    private SingletonBean singletonBean;
    
    @Autowired
    private ApplicationContext context;
    
    public void testScopes() {
        // Singleton - har doim bir xil
        SingletonBean s1 = singletonBean;
        SingletonBean s2 = singletonBean;
        System.out.println(s1 == s2);  // true
        
        // Prototype - har safar yangi
        PrototypeBean p1 = context.getBean(PrototypeBean.class);
        PrototypeBean p2 = context.getBean(PrototypeBean.class);
        System.out.println(p1 == p2);  // false
    }
}
```

### Singleton ichida Prototype

```java
@Component
@Scope("singleton")
public class SingletonService {
    
    // ❌ Bu ishlamaydi - prototype har doim bir xil bo'lib qoladi!
    @Autowired
    private PrototypeBean prototypeBean;
    
    // ✅ To'g'ri usul - ApplicationContext orqali olish
    @Autowired
    private ApplicationContext context;
    
    public void process() {
        // Har safar yangi prototype bean
        PrototypeBean newBean = context.getBean(PrototypeBean.class);
        newBean.doSomething();
    }
    
    // ✅ Yana bir usul - @Lookup
    @Lookup
    public PrototypeBean getPrototypeBean() {
        return null;  // Spring implement qiladi
    }
}
```

---

## 3.3 - Web Scopes (Request, Session, Application)

### Request Scope

**Request scope** - har bir HTTP request uchun alohida bean yaratiladi.

```java
@Component
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class RequestData {
    private String requestId;
    private Map<String, String> parameters = new HashMap<>();
    
    public RequestData() {
        this.requestId = UUID.randomUUID().toString();
    }
    // getters, setters
}

@RestController
public class UserController {
    
    @Autowired
    private RequestData requestData;  // Har bir request uchun yangi
    
    @GetMapping("/user")
    public String getUser() {
        // requestData - shu request uchun alohida ob'ekt
        return "Request ID: " + requestData.getRequestId();
    }
}
```

### Session Scope

**Session scope** - HTTP session davomida bitta bean yaratiladi.

```java
@Component
@Scope(value = "session", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class UserSession {
    private String username;
    private List<String> visitedPages = new ArrayList<>();
    
    public void login(String username) {
        this.username = username;
    }
    
    public void addVisitedPage(String page) {
        visitedPages.add(page);
    }
    // getters, setters
}

@RestController
public class UserController {
    
    @Autowired
    private UserSession userSession;  // Session davomida bir xil
    
    @PostMapping("/login")
    public String login(@RequestParam String username) {
        userSession.login(username);
        return "Logged in";
    }
}
```

### Application Scope

**Application scope** - ServletContext (application) davomida bitta bean yaratiladi.

```java
@Component
@Scope(value = "application", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class ApplicationStats {
    private long requestCount = 0;
    private long errorCount = 0;
    
    public synchronized void incrementRequestCount() {
        requestCount++;
    }
    
    public synchronized void incrementErrorCount() {
        errorCount++;
    }
    // getters
}

@Component
public class RequestInterceptor {
    
    @Autowired
    private ApplicationStats stats;
    
    public void intercept() {
        stats.incrementRequestCount();
    }
}
```

### ProxyMode nima?

```java
// Web scope'larda proxyMode kerak - singleton bean ichida inject qilish uchun
@Component
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class RequestBean {
    // ...
}

// Singleton bean ichida request scope bean inject qilish
@Component
public class SingletonService {
    @Autowired
    private RequestBean requestBean;  // Proxy orqali ishlaydi
    
    public void process() {
        // Har safar shu request'ning bean'iga murojaat qiladi
        requestBean.doSomething();
    }
}
```

---

## 3.4 - Lazy vs Eager Initialization

### Eager Initialization (Default)

```java
@Configuration
public class AppConfig {
    
    @Bean  // Default - eager initialization
    public ExpensiveService expensiveService() {
        System.out.println("ExpensiveService created!");
        return new ExpensiveService();  // Application start'da yaratiladi
    }
}

// Component'lar ham eager (default)
@Component  // Start'da yaratiladi
public class MyComponent {
    public MyComponent() {
        System.out.println("MyComponent created!");
    }
}
```

### Lazy Initialization

```java
@Configuration
public class AppConfig {
    
    @Bean
    @Lazy  // Faqat kerak bo'lganda yaratiladi
    public ExpensiveService expensiveService() {
        System.out.println("ExpensiveService created!");
        return new ExpensiveService();
    }
}

@Component
@Lazy  // Faqat kerak bo'lganda yaratiladi
public class MyLazyComponent {
    public MyLazyComponent() {
        System.out.println("MyLazyComponent created!");
    }
}

@Service
public class UserService {
    @Autowired
    @Lazy  // Proxy orqali, faqat metod chaqirilganda yaratiladi
    private MyLazyComponent lazyComponent;
    
    public void doSomething() {
        // Shu nuqtada lazyComponent yaratiladi
        lazyComponent.process();
    }
}
```

### Global Lazy Initialization

```java
// application.properties
spring.main.lazy-initialization=true

// yoki JavaConfig
@Configuration
@Lazy
public class AppConfig {
    // Bu config'dagi barcha bean'lar lazy
}
```

### Eager vs Lazy solishtirish

| Xususiyat | Eager (Default) | Lazy |
|-----------|-----------------|------|
| **Yaratilish vaqti** | Application start | Birinchi murojaat |
| **Start tezligi** | Sekin | Tez |
| **Xatolik aniqlash** | Startda | Runtime'da |
| **Memory** | Startda band qiladi | Kerak bo'lganda |
| **Use case** | Muhim, tez-tez ishlatiladigan | Qimmat, kam ishlatiladigan |

---

## 3.5 - Custom Scope

### Custom Scope yaratish

```java
// 1. Custom Scope interface'ini implement qilish
public class ThreadScope implements Scope {
    
    private final ThreadLocal<Map<String, Object>> threadLocal = 
        ThreadLocal.withInitial(HashMap::new);
    
    @Override
    public Object get(String name, ObjectFactory<?> objectFactory) {
        Map<String, Object> scope = threadLocal.get();
        Object object = scope.get(name);
        
        if (object == null) {
            object = objectFactory.getObject();
            scope.put(name, object);
        }
        return object;
    }
    
    @Override
    public Object remove(String name) {
        return threadLocal.get().remove(name);
    }
    
    @Override
    public void registerDestructionCallback(String name, Runnable callback) {
        // Custom destruction logic
    }
    
    @Override
    public Object resolveContextualObject(String key) {
        return null;
    }
    
    @Override
    public String getConversationId() {
        return String.valueOf(Thread.currentThread().getId());
    }
}

// 2. Custom Scope'ni ro'yxatdan o'tkazish
@Configuration
public class AppConfig {
    
    @Bean
    public static CustomScopeConfigurer customScopeConfigurer() {
        CustomScopeConfigurer configurer = new CustomScopeConfigurer();
        configurer.addScope("thread", new ThreadScope());
        return configurer;
    }
}

// 3. Custom Scope'dan foydalanish
@Component
@Scope("thread")
public class ThreadLocalBean {
    private String value;
    // ...
}
```

---

## 3.6 - BeanFactory vs ApplicationContext

### BeanFactory

```java
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;

// Eng asosiy IoC container
BeanFactory factory = new XmlBeanFactory(new ClassPathResource("beans.xml"));

// Lazy initialization
MyBean myBean = factory.getBean(MyBean.class);  // Shu nuqtada yaratiladi
```

### ApplicationContext

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

// Ko'proq funksiyalarga ega
ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");

// Eager initialization - start'da yaratiladi
MyBean myBean = context.getBean(MyBean.class);
```

### Farqlar

| Xususiyat | BeanFactory | ApplicationContext |
|-----------|-------------|-------------------|
| **Initialization** | Lazy (getBean da) | Eager (start'da) |
| **Internationalization** | Yo'q | Ha (MessageSource) |
| **Event handling** | Yo'q | Ha (ApplicationEvent) |
| **AOP** | Cheklangan | To'liq |
| **Resource loading** | Cheklangan | To'liq |
| **Web support** | Yo'q | Ha |
| **Performance** | Tez start, sekin birinchi call | Sekin start, tez call |

### Qaysi birini ishlatish kerak?

```java
// ✅ Tavsiya - ApplicationContext
@Configuration
@ComponentScan
public class AppConfig {
    public static void main(String[] args) {
        ApplicationContext context = 
            new AnnotationConfigApplicationContext(AppConfig.class);
        
        // Yoki Spring Boot'da
        SpringApplication.run(AppConfig.class, args);
    }
}

// ❌ Kamdan kam hollarda - BeanFactory
// Faqat resurs juda cheklangan bo'lsa
BeanFactory factory = new XmlBeanFactory(new ClassPathResource("beans.xml"));
```

---

## 3.7 - Amaliy misol

### To'liq misol: Turli scope'li bean'lar

```java
// 1. Singleton Service
@Service
public class CounterService {
    private int counter = 0;
    
    public synchronized int increment() {
        return ++counter;
    }
}

// 2. Prototype Helper
@Component
@Scope("prototype")
public class RequestHelper {
    private final String id;
    
    public RequestHelper() {
        this.id = UUID.randomUUID().toString();
        System.out.println("RequestHelper created: " + id);
    }
    
    public String getId() {
        return id;
    }
}

// 3. Request Scope bean
@Component
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class RequestInfo {
    private final long startTime;
    private String requestPath;
    
    public RequestInfo() {
        this.startTime = System.currentTimeMillis();
    }
    
    public void setRequestPath(String path) {
        this.requestPath = path;
    }
    
    public long getProcessingTime() {
        return System.currentTimeMillis() - startTime;
    }
}

// 4. Controller
@RestController
public class DemoController {
    
    @Autowired
    private CounterService counterService;  // Singleton
    
    @Autowired
    private ApplicationContext context;      // Singleton ichida prototype olish
    
    @Autowired
    private RequestInfo requestInfo;         // Request scope
    
    @GetMapping("/test")
    public Map<String, Object> test() {
        // Singleton - har doim bir xil
        int count = counterService.increment();
        
        // Prototype - har safar yangi
        RequestHelper helper = context.getBean(RequestHelper.class);
        
        // Request scope - shu request uchun bir xil
        requestInfo.setRequestPath("/test");
        
        return Map.of(
            "counter", count,
            "helperId", helper.getId(),
            "processingTime", requestInfo.getProcessingTime()
        );
    }
}
```

---

## Tekshiruv Savollari

### Bean Scopes
1. **Bean scope nima va qanday turlari bor?**
2. **Singleton scope qanday ishlaydi?**
3. **Prototype scope qanday ishlaydi?**
4. **Singleton ichida prototype bean ishlatganda nima bo'ladi?**
5. **Web scopes qaysilar va ular qachon ishlatiladi?**
6. **@Scope annotation'ida proxyMode nima uchun kerak?**
7. **Request scope va Session scope farqi nima?**

### Lazy vs Eager
8. **Eager initialization nima?**
9. **Lazy initialization nima?**
10. **@Lazy annotation'ini qayerlarda ishlatish mumkin?**
11. **Global lazy initialization qanday sozlanadi?**
12. **Eager va Lazy ning afzalliklari va kamchiliklari?**

### BeanFactory vs ApplicationContext
13. **BeanFactory va ApplicationContext o'rtasidagi farq?**
14. **Qaysi birini ishlatish tavsiya etiladi va nima uchun?**
15. **ApplicationContext BeanFactory'dan qanday qo'shimcha funksiyalarga ega?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega Spring loyihasini yarating:

1. **Singleton** - CounterService (stateless)
2. **Prototype** - TransactionContext (state saqlaydi)
3. **Request Scope** - RequestLogger (har bir request uchun)
4. **Session Scope** - UserSession (login ma'lumotlari)
5. **@Lazy** bilan qimmat bean'lar
6. **Singleton ichida prototype** - ApplicationContext orqali olish
7. **Custom Scope** - ThreadScope

```java
// Tekshirish:
GET /test?user=john   -> Har bir request yangi RequestLogger
POST /login           -> Session'da user saqlanadi
GET /profile          -> Session'dan user o'qiladi
GET /counter          -> Singleton counter increment
```

---

**Keyingi mavzu:** [Spring Bean Lifecycle](./04_Spring_Bean_Lifecycle.md)  
**[Mundarijaga qaytish](../../README.md)**

> Bean scopes - Spring container'da ob'ektlarni boshqarishning asosi! 🚀
