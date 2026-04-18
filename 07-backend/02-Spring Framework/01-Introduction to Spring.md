## 01 - Spring Framework Introduction

### 0. Short Summary (TL;DR)

- Spring Framework - Jakarta EE (Java EE) ga alternativ sifatida yaratilgan yengil va modulli framework
- Inversion of Control (IoC) va Dependency Injection (DI) orqali object lar orasidagi bog‘liqlikni boshqaradi
- 3 xil wiring (bog‘lash) usuli: XML, Java Config, va Auto-wiring (component scan + @Autowired)
- ApplicationContext - BeanFactory ning to‘liq versiyasi, real proyektlarda ApplicationContext ishlatiladi
- Spring 2003 yilda Rod Johnson tomonidan yaratilgan va hozirda Java enterprise dasturlashning standarti

### 1. Concept Explanation (ELI5)

**Muammo:**
Oddiy Java dasturida bir object (masalan, UserService) boshqa object ga (masalan, UserRepository) bog‘liq bo‘lsa, siz uni qo‘lda yaratishingiz kerak:
```java
UserRepository repo = new UserRepository();
UserService service = new UserService(repo);
```
Agar loyiha katta bo‘lsa, bu bog‘liqliklarni boshqarish juda murakkablashadi. Har bir class o‘ziga kerakli object larni qayerdan olishni bilishi kerak bo‘ladi.

**Yechim (IoC/DI):**
Spring sizga shunday deydi: "Sen faqat menga qanday object lar kerakligini ayt. Qayerdan kelishini, qachon yaratilishini va qanday ishlashini men hal qilaman".

**Real-life analogy:**
Restoranda ovqat buyurtma qilish. Siz (client) qo‘lingizda un, go‘sht, sabzavot bilan oshxonaga kirmaysiz. Siz faqat "men lag'mon istayman" deysiz. Oshpaz (Spring container) sizga tayyor ovqatni olib keladi. Qanday tayyorlangani, ingredientlar qayerdan kelgani sizni qiziqtirmaydi.

### 2. Java Mechanics & Deep Dive

**Inversion of Control (IoC) Container:**

Spring da ikkita asosiy IoC container mavjud:

| Xususiyat | BeanFactory | ApplicationContext |
|-----------|-------------|--------------------|
| Lazy loading | Ha (faqat so‘ralganda yaratiladi) | Yo‘q (startup da yaratiladi) |
| Enterprise feature lar | Minimal | To‘liq (AOP, event handling, i18n) |
| Ishlatiladigan joy | Resurs cheklangan (mobile, embedded) | Barcha real proyektlar |
| Spring versiyasi | Asosiy, eski | Hozirgi standart |

**Bean lifecycle (step-by-step):**

1. Container configuration ni o‘qiydi (XML, JavaConfig, yoki annotation)
2. Bean definition larni parse qiladi
3. Constructor orqali instance yaratadi
4. Dependency larni inject qiladi (@Autowired)
5. @PostConstruct yoki init-method ni chaqiradi
6. Bean foydalanishga tayyor
7. Container yopilganda @PreDestroy yoki destroy-method ni chaqiradi

**Spring modullari (tayanch):**

- Spring Core (IoC/DI ning asosi)
- Spring MVC (web application)
- Spring Data JPA (database)
- Spring Security (authentication/authorization)
- Spring Boot (auto-configuration + starter lar)

### 3. Code Implementation & Best Practices

**1-usul: Auto-wiring (eng ko‘p ishlatiladigan usul)**

```java
// Repository - ma'lumotlar bazasi bilan ishlaydi
@Component  // Spring bu class ni skaner qilib, bean sifatida ro'yxatga oladi
public class UserRepository {
    public User findById(Long id) {
        // database logic
        return new User(id, "John");
    }
}

// Service - biznes logika
@Component
public class UserService {
    private final UserRepository repository;
    
    @Autowired  // Spring repository ni bu yerga inject qiladi
    public UserService(UserRepository repository) {
        this.repository = repository;
    }
    
    public User getUser(Long id) {
        return repository.findById(id);
    }
}

// Configuration - component scan qaysi package ni skaner qilishini aytadi
@Configuration
@ComponentScan("com.example.app")  // Bu package va uning ichidagi @Component larni top
public class AppConfig {
    // Boshqa bean larni bu yerda ham e'lon qilish mumkin
}

// Ishlatish
public class Main {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        UserService service = context.getBean(UserService.class);
        User user = service.getUser(1L);
    }
}
```

**2-usul: Java Configuration (to‘liq nazorat kerak bo‘lganda)**

```java
@Configuration
public class ManualConfig {
    
    @Bean  // Bu metod qaytargan object Spring container da bean bo‘ladi
    public UserRepository userRepository() {
        return new UserRepository();  // Murakkab initialization bo‘lishi mumkin
    }
    
    @Bean
    public UserService userService() {
        // Manual dependency injection
        return new UserService(userRepository());
    }
}
```

**3-usul: XML (eski loyihalarda uchraydi, yangi loyihalarda ishlatilmaydi)**

```xml
<!-- applicationContext.xml -->
<beans xmlns="http://www.springframework.org/schema/beans">
    <bean id="userRepository" class="com.example.UserRepository"/>
    <bean id="userService" class="com.example.UserService">
        <constructor-arg ref="userRepository"/>
    </bean>
</beans>
```

**Best Practices:**

- Constructor injection ni field injection dan afzal ko‘ring (test qilish oson, immutability)
- @Autowired ni constructor da ishlating, field da emas
- Component scan ni aniq package bilan cheklang (tezroq ishlaydi)
- Bean lar default singleton scope da, kerak bo‘lmasa prototype ishlatmang

### 4. Trade-Off Analysis

| Mezon | Spring Framework | Jakarta EE |
|-------|-----------------|------------|
| Og‘irligi | Yengil, modular | Heavyweight |
| O‘rganish qiyinligi | Oson, katta community | Murakkab, tik learning curve |
| Moslashuvchanlik | Yuqori (XML, Java, Auto) | Past, rigid arxitektura |
| Community support | Katta, aktiv (Stack Overflow 1M+) | Kichikroq |
| Tooling | Mature (Spring Boot, Spring Initializr) | Limited |
| Real-world ishlatilishi | 80%+ Java enterprise proyektlari | Legacy, banking/insurance |

**Qachon Spring ishlatish kerak:**
- Yangi microservice yoki web application
- Tez prototiplash kerak bo‘lsa (Spring Boot bilan)
- Katta community va kutubxonalar kerak bo‘lsa

**Qachon Jakarta EE ishlatish kerak:**
- Legacy loyihani saqlash
- Minimal tashqi dependency talab qiladigan muhit
- Banking kabi sohalarda ba'zi standartlar talab qilishi mumkin

### 5. Common Mistakes

**Xato 1: Field injection dan haddan tashqari ko‘p foydalanish**
```java
// XATO - test qilish qiyin
@Component
public class UserService {
    @Autowired
    private UserRepository repository;
}

// TO‘G‘RI
@Component
public class UserService {
    private final UserRepository repository;
    
    public UserService(UserRepository repository) {
        this.repository = repository;
    }
}
```

**Xato 2: Component scan ni butun root package da ishlatish**
```java
// XATO - butun classpath skaner qilinadi, sekin ishlaydi
@ComponentScan("com")

// TO‘G‘RI - faqat kerakli package
@ComponentScan("com.example.app.service", "com.example.app.repository")
```

**Xato 3: Singleton bean da mutable state saqlash**
```java
// XATO - thread-safe emas
@Component
public class Counter {
    private int count = 0;  // QIYIN XATO - multiple thread o‘zgartiradi
    public void increment() { count++; }
}

// TO‘G‘RI - stateless yoki thread-safe
@Component
public class Counter {
    private final AtomicInteger count = new AtomicInteger(0);
    public void increment() { count.incrementAndGet(); }
}
```

**Xato 4: @Autowired ni ishlatib, lekin Spring context ni ishga tushirmaslik**
```java
// XATO - NullPointerException keladi
UserService service = new UserService();  // Spring inject qilmaydi, repository = null
service.getUser(1L);
```

### 6. Daily Coding Task

**Task: Notification tizimi yarating**

Tasavvur qiling, sizda turli xil notification service lar bor (Email, SMS, Push). Spring DI orqali ularni boshqaradigan tizim yozing.

Talablar:
1. Notification interface yarating (send(String message) metodi bilan)
2. EmailNotification, SmsNotification, PushNotification class larini @Component bilan belgilang
3. NotificationManager class ini yarating, u List<Notification> ni qabul qilsin
4. @ComponentScan va @Configuration ishlatib, Spring context ni ishga tushiring
5. Barcha notification larni birma-bir chaqiradigan metod yozing

Kod tuzilmasi:
```
com.example.notification/
├── Notification.java (interface)
├── EmailNotification.java
├── SmsNotification.java
├── PushNotification.java
├── NotificationManager.java
└── AppConfig.java
```

Yechimni o‘zingiz yozib ko‘ring, so‘ng Spring context dan NotificationManager ni olib, notifyAll("Hello") metodini chaqiring.

### 7. Interview Questions

**Savol 1: Inversion of Control (IoC) va Dependency Injection (DI) o‘rtasidagi farq nima?**

Javob: IoC - bu kengroq prinsip. Siz nazoratni framework ga berasiz. DI esa IoC ning amalga oshirilishining bir usuli. DI da siz object ga uning dependency larini tashqaridan (constructor, setter, yoki field orqali) berasiz. Spring DI ni IoC container orqali amalga oshiradi. Qisqasi: IoC - WHAT (nima), DI - HOW (qanday).

**Savol 2: BeanFactory va ApplicationContext o‘rtasidagi farqni tushuntiring. Qaysi birini ishlatish kerak?**

Javob: ApplicationContext BeanFactory ning to‘liq superseti. ApplicationContext startup da barcha singleton bean larni yaratadi (eager loading), BeanFactory esa faqat so‘ralganda (lazy loading). ApplicationContext qo‘shimcha feature lar beradi: AOP, event handling, internationalization, va web application support. 99% hollarda ApplicationContext ishlatiladi. BeanFactory faqat resource cheklangan muhitlarda (masalan, mobile) ishlatiladi.

**Savol 3: Spring da bean larni bog‘lash (wiring) ning qanday usullari bor? Qaysi biri eng yaxshi?**

Javob: 3 usul bor:
1. XML configuration (eski, endi kam ishlatiladi)
2. Java configuration (@Configuration + @Bean)
3. Auto-wiring (@ComponentScan + @Autowired)

Eng yaxshi usul: Auto-wiring + constructor injection. Bu eng kam kod yozish, kam xato, va test qilish oson. Java configuration esa tashqi library lardan bean yaratishda (masalan, DataSource) yoki murakkab initialization kerak bo‘lganda ishlatiladi. XML dan yangi loyihalarda foydalanmang.
