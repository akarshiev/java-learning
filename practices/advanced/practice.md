# Java Amaliy Mashqlar To'plami - 5-Modul: Advanced Java

## Mundarija
- [Mailing (Elektron pochta)](#mailing-elektron-pochta)
- [JAR Files](#jar-files)
- [Base64 Encoding/Decoding](#base64-encodingdecoding)
- [Build Tools (Maven)](#build-tools-maven)
- [Project Lombok](#project-lombok)
- [Java Faker](#java-faker)
- [Lambda Expressions](#lambda-expressions)
- [Functional Interfaces](#functional-interfaces)
- [Stream API Introduction](#stream-api-introduction)
- [Stream API Operations](#stream-api-operations)
- [Comparator va Collectors](#comparator-va-collectors)
- [HTTP Client](#http-client)
- [GSON Library](#gson-library)
- [Reflections API](#reflections-api)
- [Telegram Bot](#telegram-bot)
- [Annotations](#annotations)

---

## Mailing (Elektron pochta)

<details>
<summary><b>1. Oddiy email yuborish</b></summary>

**Misol:** JavaMail API yordamida oddiy matnli email yuboring.

**Berilgan:**
- SMTP server: smtp.gmail.com
- Port: 587 (TLS) yoki 465 (SSL)
- Email manzil va app password

**Talab:** Properties, Session, Message obyektlarini yarating. Transport.send() orqali email yuboring.

</details>

<details>
<summary><b>2. HTML email yuborish</b></summary>

**Misol:** HTML formatdagi email yuboring.

**Berilgan:**
```html
<h1 style="color: blue;">Salom!</h1>
<p>Bu <b>HTML</b> email.</p>
```

**Talab:** message.setContent(html, "text/html") dan foydalaning.

</details>

<details>
<summary><b>3. Fayl biriktirish (Attachment)</b></summary>

**Misol:** Emailga fayl biriktirib yuboring.

**Berilgan:** Multipart, MimeBodyPart, DataHandler.

**Talab:** 
- MimeMultipart yarating
- Matnli qism qo'shing
- Faylli qism qo'shing (FileDataSource bilan)
- Multipart ni message ga o'rnating

</details>

<details>
<summary><b>4. Rasm biriktirish (Inline)</b></summary>

**Misol:** Email ichida rasm ko'rsatish (inline).

**Berilgan:** HTML da `<img src='cid:image'>` bilan.

**Talab:** Rasmni MimeBodyPart ga qo'shing, Content-ID header o'rnating, HTML da shu ID ga murojaat qiling.

</details>

<details>
<summary><b>5. Mailtrap bilan test</b></summary>

**Misol:** Mailtrap.io yordamida email yuborishni test qiling.

**Berilgan:** Mailtrap SMTP sozlamalari (host, port, username, password).

**Talab:** Haqiqiy email yubormasdan, Mailtrap inboxida xabarlarni ko'ring.

</details>

<details>
<summary><b>6. Email service class</b></summary>

**Misol:** Qayta ishlatish mumkin bo'lgan EmailService class'ini yarating.

**Berilgan:**
- Builder pattern bilan konfiguratsiya
- sendSimpleEmail(), sendHtmlEmail(), sendWithAttachment() metodlari

**Talab:** Class'ni turli scenario larda ishlating.

</details>

<details>
<summary><b>7. Batch email yuborish</b></summary>

**Misol:** Bir nechta qabul qiluvchiga email yuborish.

**Berilgan:** Qabul qiluvchilar ro'yxati.

**Talab:** Har bir qabul qiluvchi uchun alohida yuboring. Rate limiting qo'shing (1 sekundda 1 ta).

</details>

<details>
<summary><b>8. Email template</b></summary>

**Misol:** Email template laridan foydalanish.

**Berilgan:** 
```html
Hello {{name}}, welcome to {{appName}}!
```

**Talab:** Template ni o'qing, placeholders larni almashtiring, HTML email sifatida yuboring.

</details>

---

## JAR Files

<details>
<summary><b>9. JAR yaratish (komanda qatori)</b></summary>

**Misol:** Bir nechta .class fayldan JAR arxiv yaratish.

**Berilgan:** com/example/Main.class, com/example/Utils.class

**Talab:** `jar cf myapp.jar com/example/*.class` komandasini ishlating. JAR tarkibini `jar tf myapp.jar` bilan ko'ring.

</details>

<details>
<summary><b>10. Executable JAR</b></summary>

**Misol:** Manifest faylga Main-Class qo'shib, executable JAR yaratish.

**Berilgan:**
```java
package com.example;
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello from JAR!");
    }
}
```

**Talab:** `jar cfe myapp.jar com.example.Main com/example/*.class` komandasini ishlating. `java -jar myapp.jar` bilan ishga tushiring.

</details>

<details>
<summary><b>11. JAR tarkibini ko'rish va chiqarish</b></summary>

**Misol:** JAR fayl tarkibini ko'rish va undan fayllarni chiqarish.

**Berilgan:** myapp.jar fayli.

**Talab:**
- `jar tf myapp.jar` - tarkibni ko'rish
- `jar xf myapp.jar` - barcha fayllarni chiqarish
- `jar xf myapp.jar META-INF/MANIFEST.MF` - faqat manifest ni chiqarish

</details>

<details>
<summary><b>12. JAR yangilash</b></summary>

**Misol:** Mavjud JAR ga yangi fayl qo'shish.

**Berilgan:** myapp.jar va yangi NewClass.class

**Talab:** `jar uf myapp.jar NewClass.class` komandasi bilan JAR ni yangilang.

</details>

<details>
<summary><b>13. Manifest fayl yaratish</b></summary>

**Misol:** Custom manifest fayl yaratish va JAR ga qo'shish.

**Berilgan:** manifest.txt fayli:
```
Manifest-Version: 1.0
Main-Class: com.example.Main
Class-Path: lib/library1.jar lib/library2.jar
```

**Talab:** `jar cfm myapp.jar manifest.txt com/example/*.class` komandasini ishlating.

</details>

<details>
<summary><b>14. Version bilan JAR nomlash</b></summary>

**Misol:** Versiya raqami bilan JAR nomlash.

**Berilgan:** myapp-1.0.0.jar, myapp-1.1.0.jar, myapp-2.0.0.jar

**Talab:** Har bir versiya uchun alohida JAR yarating. Versiya ma'lumotlarini manifest ga qo'shing.

</details>

<details>
<summary><b>15. JAR dan resurs o'qish</b></summary>

**Misol:** JAR ichidagi resurs faylni o'qish.

**Berilgan:** JAR ichida config.properties fayli.

**Talab:** `getClass().getResourceAsStream("/config.properties")` orqali faylni o'qing.

</details>

---

## Base64 Encoding/Decoding

<details>
<summary><b>16. String ni Base64 ga o'tkazish</b></summary>

**Misol:** Oddiy matnni Base64 ga encode qilish va decode qilish.

**Berilgan:** "Hello, World!"

**Talab:** 
- Base64.getEncoder().encodeToString()
- Base64.getDecoder().decode()
- Yangi String() bilan natijani ko'rsating

</details>

<details>
<summary><b>17. Faylni Base64 ga o'tkazish</b></summary>

**Misol:** Rasm faylini Base64 string ga o'tkazish.

**Berilgan:** image.png fayli.

**Talab:** Files.readAllBytes() bilan faylni o'qing, encode qiling, string ko'rinishida saqlang.

</details>

<details>
<summary><b>18. URL-safe Base64</b></summary>

**Misol:** URL parametrlarida ishlatish uchun URL-safe Base64.

**Berilgan:** "https://example.com?param=value&other=123"

**Talab:** Base64.getUrlEncoder() va Base64.getUrlDecoder() dan foydalaning.

</details>

<details>
<summary><b>19. MIME Base64</b></summary>

**Misol:** Uzoq matnni MIME formatda encode qilish.

**Berilgan:** 1000 belgili matn.

**Talab:** Base64.getMimeEncoder() har bir qator 76 belgidan oshmasligini ta'minlaydi.

</details>

<details>
<summary><b>20. Basic Authentication header</b></summary>

**Misol:** HTTP Basic Authentication header yaratish.

**Berilgan:** username: "admin", password: "secret123"

**Talab:** "username:password" ni Base64 encode qiling. "Basic " prefix qo'shing.

</details>

<details>
<summary><b>21. JWT token yaratish</b></summary>

**Misol:** Oddiy JWT token yaratish (header va payload).

**Berilgan:**
```json
header: {"alg":"HS256","typ":"JWT"}
payload: {"sub":"1234567890","name":"John Doe","iat":1516239022}
```

**Talab:** JSON larni Base64 URL-safe encode qiling. Header.payload formatida birlashtiring.

</details>

<details>
<summary><b>22. Image embedding</b></summary>

**Misol:** HTML da rasmni Base64 bilan embed qilish.

**Berilgan:** Rasm fayli.

**Talab:** `<img src="data:image/png;base64,...">` formatida HTML yarating.

</details>

---

## Build Tools (Maven)

<details>
<summary><b>23. Maven loyiha yaratish</b></summary>

**Misol:** Maven archetype yordamida yangi loyiha yaratish.

**Berilgan:** 
```
mvn archetype:generate -DgroupId=uz.pdp -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart
```

**Talab:** pom.xml, src/main/java, src/test/java strukturasini tahlil qiling.

</details>

<details>
<summary><b>24. pom.xml dependency qo'shish</b></summary>

**Misol:** pom.xml ga dependency qo'shish.

**Berilgan:** JUnit 5 va Gson dependency'lari.

**Talab:** 
```xml
<dependencies>
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter-api</artifactId>
        <version>5.9.2</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>com.google.code.gson</groupId>
        <artifactId>gson</artifactId>
        <version>2.10.1</version>
    </dependency>
</dependencies>
```

</details>

<details>
<summary><b>25. Maven komandalari</b></summary>

**Misol:** Maven build lifecycle komandalarini ishlatish.

**Berilgan:** Maven loyihasi.

**Talab:** Quyidagi komandalarni bajaring:
- `mvn clean` - target ni tozalash
- `mvn compile` - kompilyatsiya
- `mvn test` - testlarni ishga tushirish
- `mvn package` - JAR yaratish
- `mvn install` - local repository ga o'rnatish

</details>

<details>
<summary><b>26. Dependency scope</b></summary>

**Misol:** Turli dependency scope larni tushunish.

**Berilgan:** 
- compile (default)
- provided (Lombok)
- runtime (JDBC driver)
- test (JUnit)

**Talab:** Har bir scope uchun misol yozing.

</details>

<details>
<summary><b>27. Properties va build configuration</b></summary>

**Misol:** pom.xml da properties va compiler plugin sozlash.

**Berilgan:**
```xml
<properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
</properties>
```

**Talab:** maven-compiler-plugin ni konfiguratsiya qiling.

</details>

<details>
<summary><b>28. Executable JAR (maven-shade-plugin)</b></summary>

**Misol:** Maven yordamida executable JAR yaratish.

**Berilgan:** maven-shade-plugin.

**Talab:** plugin konfiguratsiyasida Main-Class ni belgilang. `mvn package` dan keyin `java -jar target/my-app.jar` bilan ishga tushiring.

</details>

<details>
<summary><b>29. Multi-module project</b></summary>

**Misol:** Bir nechta moduldan iborat Maven loyihasi yaratish.

**Berilgan:** parent, common, service, web modullari.

**Talab:** Parent pom.xml da <modules> ni belgilang. Har bir modul parent ga reference qilsin.

</details>

<details>
<summary><b>30. Dependency tree</b></summary>

**Misol:** Loyiha dependency'larini tahlil qilish.

**Berilgan:** Bir nechta dependency li loyiha.

**Talab:** `mvn dependency:tree` va `mvn dependency:analyze` komandalarini ishlating.

</details>

---

## Project Lombok

<details>
<summary><b>31. @Getter/@Setter</b></summary>

**Misol:** Lombok yordamida getter va setter yaratish.

**Berilgan:**
```java
public class Person {
    private String name;
    private int age;
    private boolean active;
}
```

**Talab:** @Getter va @Setter annotation'larini qo'shing. IDE da lombok plugin o'rnatilganligini tekshiring.

</details>

<details>
<summary><b>32. @ToString</b></summary>

**Misol:** toString() metodini avtomatik yaratish.

**Berilgan:** Yuqoridagi Person class'iga @ToString qo'shing.

**Talab:** @ToString.Exclude va @ToString.Include bilan ishlang.

</details>

<details>
<summary><b>33. @EqualsAndHashCode</b></summary>

**Misol:** equals() va hashCode() ni avtomatik yaratish.

**Berilgan:** Person class'iga @EqualsAndHashCode qo'shing.

**Talab:** callSuper = true parametrini ishlating. Exclude qilishni ko'rsating.

</details>

<details>
<summary><b>34. @NoArgsConstructor, @AllArgsConstructor, @RequiredArgsConstructor</b></summary>

**Misol:** Turli konstruktorlar yaratish.

**Berilgan:**
```java
public class User {
    private final String id;
    private String name;
    private String email;
}
```

**Talab:**
- @NoArgsConstructor (force = true bilan)
- @AllArgsConstructor
- @RequiredArgsConstructor (final fieldlar uchun)

</details>

<details>
<summary><b>35. @Data</b></summary>

**Misol:** @Data annotation'ini ishlatish.

**Berilgan:** Student class (id, name, grade, address).

**Talab:** @Data barcha kerakli metodlarni yaratishini tekshiring: getter, setter, toString, equals, hashCode.

</details>

<details>
<summary><b>36. @Builder</b></summary>

**Misol:** Builder pattern yaratish.

**Berilgan:** 
```java
@Builder
public class Pizza {
    private String size;
    private boolean cheese;
    private boolean pepperoni;
    private List<String> toppings;
}
```

**Talab:** @Singular va @Builder.Default bilan ishlang.

</details>

<details>
<summary><b>37. @Value (Immutable)</b></summary>

**Misol:** Immutable class yaratish.

**Berilgan:** @Value yordamida immutable Point class (x, y).

**Talab:** Setter yo'qligini, barcha fieldlar final ekanligini tekshiring.

</details>

<details>
<summary><b>38. @Slf4j</b></summary>

**Misol:** Logger qo'shish.

**Berilgan:** @Slf4j annotation'ini qo'shing.

**Talab:** log.info(), log.warn(), log.error() metodlarini ishlating.

</details>

<details>
<summary><b>39. @NonNull</b></summary>

**Misol:** Null tekshiruvi qo'shish.

**Berilgan:** 
```java
public void process(@NonNull String data) {
    // data null bo'lmasligi kerak
}
```

**Talab:** @NonNull qo'shib, null uzatganda NullPointerException tashlanishini tekshiring.

</details>

<details>
<summary><b>40. @Cleanup</b></summary>

**Misol:** Resurslarni avtomatik yopish.

**Berilgan:** 
```java
@Cleanup FileInputStream fis = new FileInputStream("file.txt");
```

**Talab:** @Cleanup ishlatib, try-finally blokiga ehtiyoj qolmasligini ko'rsating.

</details>

---

## Java Faker

<details>
<summary><b>41. Faker asoslari</b></summary>

**Misol:** Faker yordamida random ma'lumotlar yaratish.

**Berilgan:** Faker faker = new Faker();

**Talab:** 
- Ism: faker.name().fullName()
- Manzil: faker.address().fullAddress()
- Telefon: faker.phoneNumber().phoneNumber()
- Email: faker.internet().emailAddress()

</details>

<details>
<summary><b>42. Lorem Ipsum</b></summary>

**Misol:** Random matn yaratish.

**Berilgan:** Faker.instance().

**Talab:**
- So'z: faker.lorem().word()
- Gap: faker.lorem().sentence()
- Paragraf: faker.lorem().paragraph()

</details>

<details>
<summary><b>43. Business ma'lumotlari</b></summary>

**Misol:** Kompaniya va biznes ma'lumotlari.

**Berilgan:** 
- Kompaniya nomi: faker.company().name()
- Lavozim: faker.job().title()
- Soha: faker.company().industry()

</details>

<details>
<summary><b>44. Internet ma'lumotlari</b></summary>

**Misol:** Internet bilan bog'liq ma'lumotlar.

**Berilgan:**
- Email: faker.internet().emailAddress()
- URL: faker.internet().url()
- Parol: faker.internet().password()
- IP: faker.internet().ipV4Address()

</details>

<details>
<summary><b>45. Locale bilan ishlash</b></summary>

**Misol:** Turli locale larda ma'lumot yaratish.

**Berilgan:** 
- Faker(new Locale("ru"))
- Faker(new Locale("en-US"))
- Faker(new Locale("fr"))

**Talab:** Ism va manzillar tilga qarab o'zgarishini kuzating.

</details>

<details>
<summary><b>46. Test ma'lumotlari yaratish</b></summary>

**Misol:** 100 ta random user yaratish.

**Berilgan:** User class (id, name, email, phone, address).

**Talab:** Faker yordamida user ma'lumotlarini to'ldiring. List<User> ga yig'ing.

</details>

<details>
<summary><b>47. SQL INSERT script yaratish</b></summary>

**Misol:** Faker yordamida SQL INSERT script yaratish.

**Berilgan:** 50 ta user uchun INSERT statement.

**Talab:** Har bir user uchun UUID, random name, email, phone yarating. "INSERT INTO users VALUES (...)" formatida yozing.

</details>

<details>
<summary><b>48. Custom Faker</b></summary>

**Misol:** O'zingizning custom faker ma'lumotlaringizni yaratish.

**Berilgan:** O'zbekiston shaharlari, ko'chalari, ismlari ro'yxati.

**Talab:** options().option() yordamida ro'yxatdan random tanlang.

</details>

---

## Lambda Expressions

<details>
<summary><b>49. First Lambda</b></summary>

**Misol:** Birinchi lambda expression ni yozish.

**Berilgan:** 
```java
Runnable r = () -> System.out.println("Hello Lambda!");
```

**Talab:** Thread(r).start() bilan ishga tushiring.

</details>

<details>
<summary><b>50. Lambda with parameters</b></summary>

**Misol:** Parametrli lambda expression.

**Berilgan:** 
```java
Comparator<String> comp = (s1, s2) -> s1.length() - s2.length();
```

**Talab:** List<String> ni shu comparator bilan saralang.

</details>

<details>
<summary><b>51. Multiple statements</b></summary>

**Misol:** Bir nechta statement li lambda.

**Berilgan:**
```java
Function<Integer, Integer> func = (x) -> {
    int y = x * 2;
    int z = y + 10;
    return z;
};
```

</details>

<details>
<summary><b>52. Effectively final</b></summary>

**Misol:** Effectively final o'zgaruvchilar.

**Berilgan:**
```java
int localVar = 10;
Runnable r = () -> System.out.println(localVar);
```

**Talab:** localVar ni o'zgartirishga urinib, xatolikni ko'ring.

</details>

<details>
<summary><b>53. Lambda with collection</b></summary>

**Misol:** List ni forEach() bilan aylanish.

**Berilgan:** List<String> names.

**Talab:** names.forEach(name -> System.out.println(name));

</details>

<details>
<summary><b>54. Method reference</b></summary>

**Misol:** Lambda ni method reference ga o'tkazish.

**Berilgan:**
- s -> System.out.println(s) → System.out::println
- s -> s.length() → String::length
- () -> new ArrayList() → ArrayList::new

**Talab:** Har bir holat uchun method reference yozing.

</details>

---

## Functional Interfaces

<details>
<summary><b>55. Predicate</b></summary>

**Misol:** Predicate<T> yordamida filtrlash.

**Berilgan:** List<Integer> numbers.

**Talab:**
- Juft sonlarni filter qilish: n -> n % 2 == 0
- Musbat sonlarni filter qilish: n -> n > 0
- Predicate.and(), .or(), .negate() ishlatish

</details>

<details>
<summary><b>56. Consumer</b></summary>

**Misol:** Consumer<T> yordamida elementlarni iste'mol qilish.

**Berilgan:** List<String> names.

**Talab:** Har bir elementni katta harflarda chiqarish. Consumer.andThen() bilan zanjirlash.

</details>

<details>
<summary><b>57. Function</b></summary>

**Misol:** Function<T,R> yordamida transformatsiya.

**Berilgan:** List<String> words.

**Talab:** String ni Integer ga o'tkazish (length). Function.andThen() va .compose() ishlatish.

</details>

<details>
<summary><b>58. Supplier</b></summary>

**Misol:** Supplier<T> yordamida qiymat ta'minlash.

**Berilgan:**
- Random son: () -> Math.random()
- UUID: () -> UUID.randomUUID()
- Default value: () -> "default"

**Talab:** Lazy initialization misoli tayyorlang.

</details>

<details>
<summary><b>59. UnaryOperator</b></summary>

**Misol:** UnaryOperator<T> yordamida bir xil turdagi transformatsiya.

**Berilgan:** String ni teskari qilish, Integer ni kvadratga oshirish.

**Talab:** andThen() bilan zanjirlang.

</details>

<details>
<summary><b>60. BinaryOperator</b></summary>

**Misol:** BinaryOperator<T> yordamida ikkita qiymatni birlashtirish.

**Berilgan:** 
- Integer: (a,b) -> a + b
- String: (s1,s2) -> s1 + " " + s2

**Talab:** maxBy, minBy metodlaridan foydalaning.

</details>

<details>
<summary><b>61. Primitive Functional Interfaces</b></summary>

**Misol:** IntPredicate, IntFunction, IntConsumer.

**Berilgan:** int[] numbers.

**Talab:** Boxing/unboxing dan qochish uchun primitive interfacelarni ishlating.

</details>

<details>
<summary><b>62. Custom Functional Interface</b></summary>

**Misol:** O'zingizning functional interface'ingizni yarating.

**Berilgan:**
```java
@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);
}
```

**Talab:** Lambda bilan implement qiling: add, subtract, multiply, divide.

</details>

---

## Stream API Introduction

<details>
<summary><b>63. Stream yaratish</b></summary>

**Misol:** Stream yaratishning turli usullari.

**Berilgan:**
- Collection.stream()
- Arrays.stream()
- Stream.of()
- Stream.iterate()
- Stream.generate()

**Talab:** Har bir usul bilan stream yarating va elementlarni chiqaring.

</details>

<details>
<summary><b>64. forEach() terminal operation</b></summary>

**Misol:** Stream elementlarini chiqarish.

**Berilgan:** List<Integer> numbers = Arrays.asList(1,2,3,4,5).

**Talab:** numbers.stream().forEach(System.out::println)

</details>

<details>
<summary><b>65. filter() intermediate operation</b></summary>

**Misol:** Stream dan elementlarni filtrlash.

**Berilgan:** List<Integer> numbers = 1 dan 10 gacha.

**Talab:** Faqat juft sonlarni filter qiling. Predicate bilan ishlang.

</details>

<details>
<summary><b>66. map() intermediate operation</b></summary>

**Misol:** Stream elementlarini transformatsiya qilish.

**Berilgan:** List<String> words.

**Talab:** Har bir so'zni uzunligiga map qiling. String::length method reference ishlating.

</details>

<details>
<summary><b>67. limit() va skip()</b></summary>

**Misol:** Stream ni cheklash.

**Berilgan:** 1 dan 100 gacha sonlar.

**Talab:** Birinchi 10 ta elementni oling (limit). Keyingi 10 ta elementni oling (skip + limit).

</details>

<details>
<summary><b>68. sorted()</b></summary>

**Misol:** Stream elementlarini saralash.

**Berilgan:** List<String> names.

**Talab:**
- Natural order: sorted()
- Reverse order: sorted(Comparator.reverseOrder())
- Length bo'yicha: sorted(Comparator.comparingInt(String::length))

</details>

<details>
<summary><b>69. distinct()</b></summary>

**Misol:** Stream dan duplicate larni olib tashlash.

**Berilgan:** List<Integer> withDuplicates = Arrays.asList(1,2,2,3,3,3,4).

**Talab:** distinct() ishlatib, unique elementlarni oling.

</details>

---

## Stream API Operations

<details>
<summary><b>70. flatMap()</b></summary>

**Misol:** Stream of streams ni birlashtirish.

**Berilgan:** List<List<Integer>> listOfLists.

**Talab:** flatMap() yordamida barcha elementlarni bitta list ga yig'ing.

</details>

<details>
<summary><b>71. anyMatch(), allMatch(), noneMatch()</b></summary>

**Misol:** Shartlarni tekshirish.

**Berilgan:** List<Integer> numbers.

**Talab:**
- anyMatch: kamida bitta juft son bormi?
- allMatch: hammasi musbatmi?
- noneMatch: hech biri manfiy emasmi?

</details>

<details>
<summary><b>72. findFirst(), findAny()</b></summary>

**Misol:** Element topish.

**Berilgan:** List<Integer> numbers.

**Talab:** 
- findFirst(): birinchi juft sonni toping
- findAny(): parallel stream da ixtiyoriy elementni toping

</details>

<details>
<summary><b>73. reduce()</b></summary>

**Misol:** Stream elementlarini qisqartirish.

**Berilgan:** List<Integer> numbers.

**Talab:**
- Yig'indi: reduce(0, (a,b) -> a+b)
- Ko'paytma: reduce(1, (a,b) -> a*b)
- Max: reduce(Integer::max)

</details>

<details>
<summary><b>74. collect() toList()</b></summary>

**Misol:** Stream natijasini list ga yig'ish.

**Berilgan:** List<Integer> numbers.

**Talab:** Juft sonlarni filter qilib, yangi list yarating.

</details>

<details>
<summary><b>75. collect() toSet()</b></summary>

**Misol:** Stream natijasini set ga yig'ish.

**Berilgan:** List<Integer> withDuplicates.

**Talab:** toSet() ishlatib, duplicate larni avtomatik olib tashlang.

</details>

<details>
<summary><b>76. collect() toMap()</b></summary>

**Misol:** Stream natijasini map ga yig'ish.

**Berilgan:** List<Employee>.

**Talab:** Map<Integer, String> (id -> name) yarating. Duplicate key muammosini hal qiling.

</details>

<details>
<summary><b>77. count()</b></summary>

**Misol:** Stream elementlar sonini hisoblash.

**Berilgan:** List<Integer> numbers.

**Talab:** 50 dan katta sonlar sonini hisoblang.

</details>

<details>
<summary><b>78. min() va max()</b></summary>

**Misol:** Minimal va maksimal elementlarni topish.

**Berilgan:** List<Integer> numbers.

**Talab:** min(Comparator.naturalOrder()) va max(Comparator.naturalOrder()).

</details>

<details>
<summary><b>79. sum(), average() (primitive streams)</b></summary>

**Misol:** IntStream bilan ishlash.

**Berilgan:** int[] numbers.

**Talab:** Arrays.stream(numbers).sum(), .average(), .summaryStatistics()

</details>

---

## Comparator va Collectors

<details>
<summary><b>80. Comparator.comparing()</b></summary>

**Misol:** Comparator yordamida solishtirish.

**Berilgan:** List<Employee> employees.

**Talab:** 
- comparing(Employee::getName)
- comparingInt(Employee::getAge)
- thenComparing(Employee::getSalary)

</details>

<details>
<summary><b>81. Collectors.groupingBy()</b></summary>

**Misol:** Elementlarni guruhlash.

**Berilgan:** List<Employee> employees.

**Talab:** 
- Gender bo'yicha guruhlash
- Department bo'yicha guruhlash
- Age group bo'yicha guruhlash (young, middle, senior)

</details>

<details>
<summary><b>82. Collectors.partitioningBy()</b></summary>

**Misol:** Shart bo'yicha ikki guruhga ajratish.

**Berilgan:** List<Employee> employees.

**Talab:** Age > 30 bo'lgan va bo'lmaganlarga ajrating.

</details>

<details>
<summary><b>83. Collectors.joining()</b></summary>

**Misol:** String larni birlashtirish.

**Berilgan:** List<String> words.

**Talab:** 
- joining()
- joining(", ")
- joining(", ", "[", "]")

</details>

<details>
<summary><b>84. Collectors.summingInt(), averagingInt()</b></summary>

**Misol:** Hisoblashlar.

**Berilgan:** List<Employee> employees.

**Talab:** 
- summingInt(Employee::getSalary)
- averagingInt(Employee::getAge)
- summarizingInt(Employee::getSalary)

</details>

<details>
<summary><b>85. Collectors.mapping()</b></summary>

**Misol:** Guruhlagandan keyin mapping.

**Berilgan:** List<Employee> employees.

**Talab:** Department bo'yicha guruhlab, faqat ismlarni list ga yig'ing.

</details>

<details>
<summary><b>86. Collectors.filtering()</b></summary>

**Misol:** Guruhlagandan keyin filter.

**Berilgan:** List<Employee> employees.

**Talab:** Department bo'yicha guruhlab, age > 30 bo'lganlarni oling.

</details>

---

## HTTP Client

<details>
<summary><b>87. GET request</b></summary>

**Misol:** HttpClient yordamida GET so'rov yuborish.

**Berilgan:** https://jsonplaceholder.typicode.com/posts

**Talab:**
- HttpClient.newHttpClient()
- HttpRequest.newBuilder().uri().GET().build()
- client.send(request, BodyHandlers.ofString())
- Status code va body ni chiqaring

</details>

<details>
<summary><b>88. POST request</b></summary>

**Misol:** POST so'rov yuborish.

**Berilgan:** https://jsonplaceholder.typicode.com/posts

**Talab:**
```java
String json = "{\"title\":\"foo\",\"body\":\"bar\",\"userId\":1}";
HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create(url))
    .header("Content-Type", "application/json")
    .POST(BodyPublishers.ofString(json))
    .build();
```

</details>

<details>
<summary><b>89. Asynchronous request</b></summary>

**Misol:** sendAsync() yordamida asinxron so'rov.

**Berilgan:** API endpoint.

**Talab:** CompletableFuture<HttpResponse<String>> ni qayta ishlang. thenAccept() bilan natijani chiqaring.

</details>

<details>
<summary><b>90. Timeout</b></summary>

**Misol:** Timeout sozlash.

**Berilgan:** Uzoq javob qaytaradigan endpoint.

**Talab:** 
- connectTimeout(Duration.ofSeconds(5))
- HttpRequest.timeout(Duration.ofSeconds(5))

</details>

<details>
<summary><b>91. Headers va authentication</b></summary>

**Misol:** Headers qo'shish va Basic Auth.

**Berilgan:** 
```java
String auth = "username:password";
String encoded = Base64.getEncoder().encodeToString(auth.getBytes());
```

**Talab:** .header("Authorization", "Basic " + encoded) qo'shing.

</details>

<details>
<summary><b>92. Parallel requests</b></summary>

**Misol:** Bir nechta parallel so'rov yuborish.

**Berilgan:** Bir nechta URL.

**Talab:** CompletableFuture.allOf() bilan hamma so'rov tugashini kuting.

</details>

---

## GSON Library

<details>
<summary><b>93. Java Object to JSON</b></summary>

**Misol:** Java ob'ektini JSON ga o'tkazish.

**Berilgan:**
```java
class Person {
    private String name;
    private int age;
    private String email;
}
```

**Talab:** Gson().toJson(person) bilan JSON yarating.

</details>

<details>
<summary><b>94. JSON to Java Object</b></summary>

**Misol:** JSON ni Java ob'ektiga o'tkazish.

**Berilgan:**
```json
{"name":"John","age":30,"email":"john@example.com"}
```

**Talab:** Gson().fromJson(json, Person.class)

</details>

<details>
<summary><b>95. List to JSON</b></summary>

**Misol:** List ni JSON ga o'tkazish.

**Berilgan:** List<Person>.

**Talab:** TypeToken yordamida Type yarating.

</details>

<details>
<summary><b>96. @SerializedName</b></summary>

**Misol:** Field nomlarini o'zgartirish.

**Berilgan:** 
```java
public class User {
    @SerializedName("user_id")
    private int userId;
    
    @SerializedName("full_name")
    private String fullName;
}
```

</details>

<details>
<summary><b>97. @Expose annotation</b></summary>

**Misol:** Serializatsiyani boshqarish.

**Berilgan:** @Expose(serialize = true, deserialize = false)

**Talab:** GsonBuilder().excludeFieldsWithoutExposeAnnotation().create()

</details>

<details>
<summary><b>98. Custom serializer</b></summary>

**Misol:** LocalDate uchun custom serializer.

**Berilgan:** JsonSerializer<LocalDate>.

**Talab:** registerTypeAdapter(LocalDate.class, new LocalDateSerializer())

</details>

<details>
<summary><b>99. Pretty printing</b></summary>

**Misol:** JSON ni chiroyli formatda chiqarish.

**Berilgan:** GsonBuilder().setPrettyPrinting().create()

**Talab:** toJson() natijasini chiroyli formatda ko'rsating.

</details>

<details>
<summary><b>100. Null handling</b></summary>

**Misol:** Null field'larni boshqarish.

**Berilgan:** GsonBuilder().serializeNulls()

**Talab:** Null field'lar JSON da ko'rinishini tekshiring.

</details>

---

## Reflections API

<details>
<summary><b>101. Class ma'lumotlarini olish</b></summary>

**Misol:** Class haqida ma'lumot olish.

**Berilgan:** String.class yoki o'z class'ingiz.

**Talab:**
- getName(), getSimpleName()
- getPackage()
- getModifiers()
- getSuperclass()
- getInterfaces()

</details>

<details>
<summary><b>102. Field ma'lumotlarini olish</b></summary>

**Misol:** Class field'larini olish.

**Berilgan:** Person class (name, age, email).

**Talab:** getDeclaredFields() bilan barcha fieldlarni chiqaring. Har bir field: getName(), getType(), getModifiers().

</details>

<details>
<summary><b>103. Field qiymatlarini olish va o'zgartirish</b></summary>

**Misol:** Private field ga kirish.

**Berilgan:** Person obyekti va private String name field.

**Talab:** 
- getDeclaredField("name")
- setAccessible(true)
- get() va set() metodlari

</details>

<details>
<summary><b>104. Method ma'lumotlarini olish</b></summary>

**Misol:** Class metodlarini olish.

**Berilgan:** Person class.

**Talab:** getDeclaredMethods() bilan barcha metodlarni chiqaring. getName(), getReturnType(), getParameterTypes().

</details>

<details>
<summary><b>105. Method chaqirish</b></summary>

**Misol:** Reflection orqali metod chaqirish.

**Berilgan:** Person obyekti va setName(String) metodi.

**Talab:** 
- getDeclaredMethod("setName", String.class)
- invoke(person, "New Name")

</details>

<details>
<summary><b>106. Constructor orqali ob'ekt yaratish</b></summary>

**Misol:** Reflection orqali yangi ob'ekt yaratish.

**Berilgan:** Person class (String name, int age konstruktori).

**Talab:** 
- getDeclaredConstructor(String.class, int.class)
- newInstance("John", 30)

</details>

<details>
<summary><b>107. Private konstruktor</b></summary>

**Misol:** Private konstruktor bilan ob'ekt yaratish.

**Berilgan:** Singleton class.

**Talab:** setAccessible(true) qilib, private konstruktor orqali ob'ekt yarating.

</details>

<details>
<summary><b>108. Annotatsiyalarni o'qish</b></summary>

**Misol:** Class, field va metodlardagi annotatsiyalarni o'qish.

**Berilgan:** @Deprecated, @Override kabi annotatsiyalar.

**Talab:** isAnnotationPresent() va getAnnotation() metodlaridan foydalaning.

</details>

<details>
<summary><b>109. Array bilan ishlash</b></summary>

**Misol:** Reflection orqali massiv yaratish va to'ldirish.

**Berilgan:** int[] array.

**Talab:** Array.newInstance(int.class, 5) va Array.set(), Array.get().

</details>

---

## Telegram Bot

<details>
<summary><b>110. Bot yaratish va start</b></summary>

**Misol:** Telegram bot yaratish va /start komandasiga javob berish.

**Berilgan:** Telegram bot token (BotFather dan olingan).

**Talab:** 
- TelegramBot bot = new TelegramBot(token)
- UpdatesListener bilan xabarlarni qabul qilish
- /start ga "Assalomu alaykum!" deb javob qaytarish

</details>

<details>
<summary><b>111. Echo bot</b></summary>

**Misol:** Foydalanuvchi yozgan xabarni qaytaradigan bot.

**Berilgan:** Har qanday xabarni qabul qilib, "Siz yozdingiz: {text}" deb javob qaytaring.

**Talab:** SendMessage(chatId, "Siz yozdingiz: " + text) dan foydalaning.

</details>

<details>
<summary><b>112. Reply keyboard</b></summary>

**Misol:** Tugmali klaviatura yaratish.

**Berilgan:** 
- "🇺🇿 USD kursi"
- "🇷🇺 RUB kursi"
- "🇪🇺 EUR kursi"

**Talab:** ReplyKeyboardMarkup yarating, resizeKeyboard(true) qiling.

</details>

<details>
<summary><b>113. Inline keyboard</b></summary>

**Misol:** Inline tugmalar yaratish va callback ni qabul qilish.

**Berilgan:** Til tanlash tugmalari (O'zbek, English, Русский).

**Talab:** InlineKeyboardButton, callback_data, CallbackQuery ni qayta ishlash.

</details>

<details>
<summary><b>114. Rasm yuborish</b></summary>

**Misol:** Bot orqali rasm yuborish.

**Berilgan:** Local fayl yoki URL dan rasm.

**Talab:** SendPhoto request yarating va bot.execute() qiling.

</details>

<details>
<summary><b>115. Audio yuborish</b></summary>

**Misol:** Bot orqali audio fayl yuborish.

**Berilgan:** MP3 fayl.

**Talab:** SendAudio request, fileName va title qo'shing.

</details>

<details>
<summary><b>116. Dokument yuborish</b></summary>

**Misol:** Bot orqali dokument (PDF, DOC) yuborish.

**Berilgan:** PDF fayl.

**Talab:** SendDocument request yarating.

</details>

<details>
<summary><b>117. Contact request</b></summary>

**Misol:** Foydalanuvchidan telefon raqam so'rash.

**Berilgan:** KeyboardButton.requestContact(true).

**Talab:** Tugma bosilganda foydalanuvchi raqamini olish.

</details>

<details>
<summary><b>118. Location request</b></summary>

**Misol:** Foydalanuvchidan joylashuv so'rash.

**Berilgan:** KeyboardButton.requestLocation(true).

**Talab:** Tugma bosilganda joylashuvni olish.

</details>

<details>
<summary><b>119. Valyuta kursi boti</b></summary>

**Misol:** Markaziy bank API dan valyuta kurslarini olib ko'rsatadigan bot.

**Berilgan:** https://cbu.uz/oz/arkhiv-kursov-valyut/json/

**Talab:** 
- USD, EUR, RUB kurslarini olish
- Tugmalar orqali tanlash
- Kursni chiroyli formatda ko'rsatish

</details>

<details>
<summary><b>120. Multi-language bot</b></summary>

**Misol:** Bir nechta tilni qo'llab-quvvatlaydigan bot.

**Berilgan:** O'zbek, English, Русский.

**Talab:** 
- Til tanlash inline tugmalari
- Tanlangan tilni saqlash (userLanguage map)
- Xabarlarni shu tilda chiqarish

</details>

<details>
<summary><b>121. Quiz bot</b></summary>

**Misol:** Savol-javob boti.

**Berilgan:** 5 ta savol, 4 ta variant.

**Talab:** Inline tugmalar orqali variantlarni ko'rsating. To'g'ri javobni tekshiring. Ballarni hisoblang.

</details>

<details>
<summary><b>122. Reminder bot</b></summary>

**Misol:** Foydalanuvchiga eslatma yuboradigan bot.

**Berilgan:** Foydalanuvchi "remind me in 10 seconds" deb yozadi.

**Talab:** ScheduledExecutorService bilan vaqtni belgilang. Vaqt kelganda xabar yuboring.

</details>

---

## Annotations

<details>
<summary><b>123. @Override</b></summary>

**Misol:** @Override annotation'ini ishlatish.

**Berilgan:** Parent class (void display()) va Child class.

**Talab:** Child class da display() metodini override qiling. @Override qo'shing.

</details>

<details>
<summary><b>124. @Deprecated</b></summary>

**Misol:** @Deprecated annotation'ini ishlatish.

**Berilgan:** Eski metod.

**Talab:** @Deprecated qo'shing. Javadoc da @deprecated bilan izohlang. Ishlatganda compiler warning ni ko'ring.

</details>

<details>
<summary><b>125. @SuppressWarnings</b></summary>

**Misol:** Compiler warning larini bostirish.

**Berilgan:** Raw type list, deprecation, unchecked warnings.

**Talab:** @SuppressWarnings({"rawtypes", "deprecation", "unchecked"}) ishlating.

</details>

<details>
<summary><b>126. @SafeVarargs</b></summary>

**Misol:** Varargs bilan ishlashda heap pollution ni oldini olish.

**Berilgan:** 
```java
@SafeVarargs
public static <T> List<T> asList(T... elements) {
    return Arrays.asList(elements);
}
```

**Talab:** @SafeVarargs qo'shib, warning larni bosting.

</details>

<details>
<summary><b>127. @FunctionalInterface</b></summary>

**Misol:** Functional interface yaratish.

**Berilgan:** 
```java
@FunctionalInterface
interface MathOperation {
    int operate(int a, int b);
}
```

**Talab:** Lambda expression bilan ishlating. 2 ta abstract metod qo'shishga urinib ko'ring.

</details>

<details>
<summary><b>128. Custom annotation yaratish</b></summary>

**Misol:** O'zingizning annotatsiyangizni yarating.

**Berilgan:**
```java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface TestInfo {
    String author() default "Unknown";
    String date();
    int version() default 1;
}
```

**Talab:** Annotation ni metodga qo'llang va reflection orqali o'qing.

</details>

<details>
<summary><b>129. @Retention</b></summary>

**Misol:** Retention policy turlarini tushunish.

**Berilgan:** 
- SOURCE
- CLASS
- RUNTIME

**Talab:** Har bir retention bilan annotation yarating. Reflection orqali qaysi biri ko'rinishini tekshiring.

</details>

<details>
<summary><b>130. @Target</b></summary>

**Misol:** Annotation qayerda ishlatilishini cheklash.

**Berilgan:** 
- ElementType.METHOD
- ElementType.FIELD
- ElementType.TYPE

**Talab:** Har bir target uchun annotation yarating. Noto'g'ri joyda ishlatishga urinib ko'ring.

</details>

<details>
<summary><b>131. @Inherited</b></summary>

**Misol:** Annotation ni subclass larga meros qoldirish.

**Berilgan:** @Inherited annotation li parent class.

**Talab:** Child class da annotation mavjudligini tekshiring.

</details>

<details>
<summary><b>132. @Repeatable</b></summary>

**Misol:** Bir joyda bir nechta annotation ishlatish.

**Berilgan:** @Schedule annotation (day, time).

**Talab:** @Repeatable(Schedules.class) yarating. Bir metodga bir nechta @Schedule qo'llang.

</details>

<details>
<summary><b>133. Annotation processor</b></summary>

**Misol:** Annotation larni qayta ishlovchi oddiy processor.

**Berilgan:** @NotNull annotation.

**Talab:** Reflection orqali field larni tekshiruvchi validator yozing. @NotNull bo'lgan field null bo'lmasligi kerak.

</details>

<details>
<summary><b>134. JSON serializer</b></summary>

**Misol:** Annotation asosida JSON serializer yaratish.

**Berilgan:** @JsonField(name) annotation.

**Talab:** Annotation li field larni JSON ga o'tkazing. @JsonIgnore qo'shilganlarni tashlab keting.

</details>

---

## Mashqlar Statistikasi

| Bo'lim | Mashqlar soni |
|--------|---------------|
| Mailing | 8 ta |
| JAR Files | 7 ta |
| Base64 | 7 ta |
| Build Tools | 8 ta |
| Project Lombok | 10 ta |
| Java Faker | 8 ta |
| Lambda Expressions | 6 ta |
| Functional Interfaces | 8 ta |
| Stream API Introduction | 7 ta |
| Stream API Operations | 10 ta |
| Comparator va Collectors | 7 ta |
| HTTP Client | 6 ta |
| GSON Library | 8 ta |
| Reflections API | 9 ta |
| Telegram Bot | 13 ta |
| Annotations | 12 ta |
| **Jami** | **134 ta** |

---

**[Mundarijaga qaytish](#-mundarija)**

> 5-modul - Java ekosistemasining eng muhim va zamonaviy texnologiyalarini o'z ichiga oladi. Har bir mashqni bajarish orqali siz professional Java dasturchisi sifatida shakllanasiz! 🚀
