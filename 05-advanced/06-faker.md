# 5-Modul: Java Faker - Sun'iy Ma'lumotlar Yaratish

## Java Faker nima?

**Java Faker** - Ruby tilidagi `faker` gem'ining Java porti bo'lib, sun'iy (fake) ma'lumotlar yaratish uchun ishlatiladi. Yangi loyiha ishlab chiqishda, ma'lumotlar bazasini to'ldirishda yoki demo ma'lumotlar kerak bo'lganda juda qulay vosita.

```java
// Misol: Sun'iy foydalanuvchi ma'lumotlari
Faker faker = new Faker();

String fullName = faker.name().fullName();      // "Miss Samanta Schmidt"
String address = faker.address().streetAddress(); // "60018 Sawayn Brooks Suite 449"
String phone = faker.phoneNumber().cellPhone();   // "+998901234567"
```

### Nima uchun Java Faker kerak?

1. **Ma'lumotlar bazasini to'ldirish** - Test ma'lumotlari yaratish
2. **Demo loyihalar** - Chiroyli ko'rinish uchun
3. **Unit testlar** - Turli xil ma'lumotlar bilan test qilish
4. **Prototiplar** - Tezkor prototip yaratish
5. **Yuklama testlari** - Katta hajmdagi ma'lumotlar yaratish

---

## 5.1 - O'rnatish va sozlash

### Maven dependency

```xml
<dependency>
    <groupId>com.github.javafaker</groupId>
    <artifactId>javafaker</artifactId>
    <version>1.0.2</version>
</dependency>
```

### Gradle dependency

```groovy
dependencies {
    implementation 'com.github.javafaker:javafaker:1.0.2'
}
```

### JAR fayl (Maven'siz)

Agar Maven ishlatmasangiz, JAR faylni yuklab oling:
- **[javafaker-1.0.2.jar](https://repo1.maven.org/maven2/com/github/javafaker/javafaker/1.0.2/)**

### Asosiy foydalanish

```java
import com.github.javafaker.Faker;

public class FakerExample {
    public static void main(String[] args) {
        // 1. Default locale (en) bilan
        Faker faker = new Faker();
        
        // 2. Specific locale bilan
        Faker uzFaker = new Faker(new Locale("uz")); // O'zbekcha (agar mavjud bo'lsa)
        Faker ruFaker = new Faker(new Locale("ru")); // Ruscha
        
        // 3. Random seed bilan (qayta takrorlanadigan ma'lumotlar)
        Faker seededFaker = new Faker(new Random(123));
        
        // Oddiy misollar
        System.out.println("Name: " + faker.name().fullName());
        System.out.println("Address: " + faker.address().fullAddress());
        System.out.println("Phone: " + faker.phoneNumber().phoneNumber());
    }
}
```

---

## 5.2 - Asosiy Faker'lar

### Name (Ism-familiya)

```java
public class NameExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Asosiy ism ma'lumotlari
        String fullName = faker.name().fullName();        // "Dr. John Doe"
        String firstName = faker.name().firstName();       // "John"
        String lastName = faker.name().lastName();         // "Doe"
        String nameWithMiddle = faker.name().nameWithMiddle(); // "John M. Doe"
        
        // Unvonlar
        String prefix = faker.name().prefix();             // "Mr.", "Mrs.", "Dr."
        String suffix = faker.name().suffix();             // "Jr.", "Sr.", "III"
        String title = faker.name().title();               // "Operations Director"
        
        // Username
        String username = faker.name().username();         // "john.doe"
        
        System.out.printf("Full Name: %s%n", fullName);
        System.out.printf("First Name: %s%n", firstName);
        System.out.printf("Last Name: %s%n", lastName);
        System.out.printf("Username: %s%n", username);
    }
}
```

### Address (Manzil)

```java
public class AddressExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Ko'cha manzili
        String streetName = faker.address().streetName();        // "Main Street"
        String streetAddress = faker.address().streetAddress();  // "123 Main Street"
        String secondaryAddress = faker.address().secondaryAddress(); // "Apt. 123"
        
        // Shahar va hudud
        String city = faker.address().city();                    // "New York"
        String cityName = faker.address().cityName();            // "Springfield"
        String state = faker.address().state();                  // "California"
        String stateAbbr = faker.address().stateAbbr();          // "CA"
        
        // To'liq manzil
        String fullAddress = faker.address().fullAddress();      // "123 Main Street, Apt. 123, New York, NY 10001"
        
        // ZIP va koordinatalar
        String zipCode = faker.address().zipCode();              // "10001"
        String latitude = faker.address().latitude();            // "40.7128"
        String longitude = faker.address().longitude();          // "-74.0060"
        
        System.out.println("Street: " + streetAddress);
        System.out.println("City: " + city);
        System.out.println("Full Address: " + fullAddress);
    }
}
```

### PhoneNumber (Telefon raqam)

```java
public class PhoneExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Telefon raqamlar
        String phone = faker.phoneNumber().phoneNumber();           // "123-456-7890"
        String cellPhone = faker.phoneNumber().cellPhone();         // "555-123-4567"
        
        // Formatlangan raqamlar
        String formattedPhone = faker.phoneNumber().phoneNumber();   // Random format
        
        // Subscriber number (faqat raqamlar)
        String subscriberNumber = faker.phoneNumber().subscriberNumber(7); // 7 xonali raqam
        
        System.out.println("Phone: " + phone);
        System.out.println("Cell: " + cellPhone);
    }
}
```

### Internet (Internet ma'lumotlari)

```java
public class InternetExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Email manzillar
        String email = faker.internet().emailAddress();              // "john.doe@gmail.com"
        String safeEmail = faker.internet().safeEmailAddress();     // "john.doe@example.com"
        
        // URL va domain
        String url = faker.internet().url();                         // "http://www.example.com"
        String domain = faker.internet().domainName();               // "example.com"
        
        // Parol
        String password = faker.internet().password();               // Random password
        String strongPassword = faker.internet().password(8, 16, true, true, true);
        
        // IP va MAC
        String ipv4 = faker.internet().ipV4Address();                // "192.168.1.1"
        String ipv6 = faker.internet().ipV6Address();                // IPv6 address
        String mac = faker.internet().macAddress();                  // "00:11:22:33:44:55"
        
        // User agent
        String userAgent = faker.internet().userAgentAny();          // Random user agent
        
        System.out.println("Email: " + email);
        System.out.println("Password: " + password);
        System.out.println("IP: " + ipv4);
    }
}
```

### Lorem Ipsum (Matn)

```java
public class LoremExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // So'zlar
        String word = faker.lorem().word();                           // Random so'z
        String[] words = faker.lorem().words(5);                      // 5 ta so'z
        
        // Gaplar
        String sentence = faker.lorem().sentence();                   // Random gap
        String fixedSentence = faker.lorem().sentence(5);             // 5 so'zli gap
        
        // Paragraflar
        String paragraph = faker.lorem().paragraph();                 // Random paragraf
        String fixedParagraph = faker.lorem().paragraph(3);           // 3 gapli paragraf
        
        // Matnlar
        String text = faker.lorem().text();                           // Uzun matn
        
        System.out.println("Word: " + word);
        System.out.println("Sentence: " + sentence);
        System.out.println("Paragraph: " + paragraph);
    }
}
```

### Business (Biznes ma'lumotlari)

```java
public class BusinessExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Kompaniya ma'lumotlari
        String companyName = faker.company().name();                  // "Smith Inc"
        String companyIndustry = faker.company().industry();          // "Technology"
        String companyProfession = faker.company().profession();      // "Software Engineer"
        
        // Kredit karta
        String creditCard = faker.business().creditCardNumber();      // "1234-5678-9012-3456"
        String creditCardType = faker.business().creditCardType();    // "Visa", "MasterCard"
        
        // Tovar belgisi
        String trademark = faker.company().logo();                    // "https://logo.clearbit.com/example.com"
        
        System.out.println("Company: " + companyName);
        System.out.println("Industry: " + companyIndustry);
        System.out.println("Credit Card: " + creditCard);
    }
}
```

### Finance (Moliya)

```java
public class FinanceExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Valyuta
        String currency = faker.finance().currency();                 // "USD"
        String currencyCode = faker.finance().currencyCode();         // "USD"
        String currencyName = faker.finance().currencyName();         // "US Dollar"
        
        // Bank ma'lumotlari
        String iban = faker.finance().iban();                         // Random IBAN
        String bic = faker.finance().bic();                           // Random BIC
        String creditCard = faker.finance().creditCard();             // Random credit card
        
        // Stock market
        String stockMarket = faker.finance().stockMarket();           // "NASDAQ"
        
        System.out.println("Currency: " + currency);
        System.out.println("IBAN: " + iban);
        System.out.println("BIC: " + bic);
    }
}
```

### Number (Raqamlar)

```java
public class NumberExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Butun sonlar
        int randomInt = faker.number().randomDigit();                 // 0-9
        int nonZeroDigit = faker.number().randomDigitNotZero();       // 1-9
        int numberBetween = faker.number().numberBetween(10, 20);     // 10-19
        
        // Haqiqiy sonlar
        double randomDouble = faker.number().randomDouble(2, 10, 20); // 2 decimal, 10.00-19.99
        
        System.out.println("Random digit: " + randomInt);
        System.out.println("Number between: " + numberBetween);
        System.out.println("Random double: " + randomDouble);
    }
}
```

### Date and Time (Sana va vaqt)

```java
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.concurrent.TimeUnit;

public class DateTimeExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Sana (Date object)
        Date pastDate = faker.date().past(30, TimeUnit.DAYS);         // 30 kun oldin
        Date futureDate = faker.date().future(30, TimeUnit.DAYS);     // 30 keyin
        Date birthday = faker.date().birthday();                      // Random tug'ilgan kun
        
        // Sana va vaqt
        Date between = faker.date().between(startDate, endDate);      // Ikki sana orasida
        
        // LocalDate ga o'tkazish
        LocalDate localDate = pastDate.toInstant()
            .atZone(ZoneId.systemDefault())
            .toLocalDate();
        
        System.out.println("Past: " + pastDate);
        System.out.println("Future: " + futureDate);
        System.out.println("Birthday: " + birthday);
    }
}
```

### Bool (Mantiqiy qiymatlar)

```java
public class BoolExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Random boolean
        boolean randomBool = faker.bool().bool();                     // true yoki false
        
        // O'ziga xos ehtimollik bilan
        // (To'g'ridan-to'g'ri qo'llab-quvvatlanmaydi, lekin random orqali)
        boolean weightedBool = Math.random() < 0.7;                    // 70% true
        
        System.out.println("Random boolean: " + randomBool);
    }
}
```

### Options (Tanlovlar)

```java
public class OptionsExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Berilgan ro'yxatdan random tanlash
        String[] colors = {"Red", "Green", "Blue", "Yellow"};
        String randomColor = faker.options().option(colors);          // Random color
        
        // 0-indeksdan boshlab
        int nextIndex = faker.options().nextIndex(colors, 2);         // 2 dan keyingi index
        
        System.out.println("Random color: " + randomColor);
    }
}
```

---

## 5.3 - Maxsus Faker'lar

### Anime va Kino

```java
public class AnimeExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Pokemon
        String pokemon = faker.pokemon().name();                      // "Pikachu"
        String pokemonLocation = faker.pokemon().location();          // "Pallet Town"
        
        // Dragon Ball
        String dbCharacter = faker.dragonBall().character();          // "Goku"
        
        // One Piece (agar mavjud bo'lsa)
        // String onePiece = faker.onePiece().character();
        
        // Harry Potter
        String hpCharacter = faker.harryPotter().character();         // "Harry Potter"
        String hpHouse = faker.harryPotter().house();                 // "Gryffindor"
        String hpSpell = faker.harryPotter().spell();                 // "Expelliarmus"
        
        // Game of Thrones
        String gotCharacter = faker.gameOfThrones().character();      // "Jon Snow"
        String gotHouse = faker.gameOfThrones().house();              // "Stark"
        String gotCity = faker.gameOfThrones().city();                // "Winterfell"
        
        // Star Wars
        String starWarsCharacter = faker.starWars().character();      // "Luke Skywalker"
        String starWarsPlanet = faker.starWars().planet();            // "Tatooine"
        
        System.out.println("Pokemon: " + pokemon);
        System.out.println("Harry Potter: " + hpCharacter);
        System.out.println("Game of Thrones: " + gotCharacter);
    }
}
```

### Hayvonlar

```java
public class AnimalExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Hayvonlar
        String animal = faker.animal().name();                        // "Tiger"
        
        // Itlar
        String dogName = faker.dog().name();                          // "Rex"
        String dogBreed = faker.dog().breed();                        // "Labrador"
        String dogSound = faker.dog().sound();                        // "Woof"
        
        // Mushuklar
        String catName = faker.cat().name();                          // "Whiskers"
        String catBreed = faker.cat().breed();                        // "Siamese"
        String catSound = faker.cat().sound();                        // "Meow"
        
        System.out.println("Animal: " + animal);
        System.out.println("Dog: " + dogName + " (" + dogBreed + ")");
        System.out.println("Cat: " + catName + " (" + catBreed + ")");
    }
}
```

### Food va Drink

```java
public class FoodExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Ovqatlar
        String food = faker.food().dish();                            // "Pizza"
        String ingredient = faker.food().ingredient();                // "Tomato"
        String spice = faker.food().spice();                          // "Cinnamon"
        
        // Ichimliklar
        String beer = faker.beer().name();                            // "IPA"
        String beerStyle = faker.beer().style();                      // "Lager"
        
        String wine = faker.wine().name();                            // "Chardonnay"
        
        // Mevalar
        String fruit = faker.fruit().name();                          // "Apple"
        
        System.out.println("Food: " + food);
        System.out.println("Beer: " + beer);
        System.out.println("Fruit: " + fruit);
    }
}
```

### Superqahramonlar

```java
public class SuperheroExamples {
    public static void main(String[] args) {
        Faker faker = new Faker();
        
        // Superqahramon
        String hero = faker.superhero().name();                       // "Spider-Man"
        String power = faker.superhero().power();                     // "Web-slinging"
        String prefix = faker.superhero().prefix();                   // "The Amazing"
        String suffix = faker.superhero().suffix();                   // "Man"
        
        System.out.println("Hero: " + prefix + " " + hero + " " + suffix);
        System.out.println("Power: " + power);
    }
}
```

---

## 5.4 - Locale (Til) bilan ishlash

### Qo'llab-quvvatlanadigan Locale'lar

```java
import java.util.Locale;

public class LocaleExamples {
    public static void main(String[] args) {
        
        // Ingliz tili (default)
        Faker enFaker = new Faker();
        
        // Amerika ingliz tili
        Faker usFaker = new Faker(new Locale("en-US"));
        
        // Rus tili
        Faker ruFaker = new Faker(new Locale("ru"));
        
        // Fransuz tili
        Faker frFaker = new Faker(new Locale("fr"));
        
        // Nemis tili
        Faker deFaker = new Faker(new Locale("de"));
        
        // Yapon tili
        Faker jaFaker = new Faker(new Locale("ja"));
        
        // Xitoy tili
        Faker zhFaker = new Faker(new Locale("zh-CN"));
        
        // O'zbek tili (agar mavjud bo'lsa)
        // Faker uzFaker = new Faker(new Locale("uz"));
        
        // Turli tillarda ism
        System.out.println("English: " + enFaker.name().fullName());
        System.out.println("Russian: " + ruFaker.name().fullName());
        System.out.println("French: " + frFaker.name().fullName());
        System.out.println("German: " + deFaker.name().fullName());
        System.out.println("Japanese: " + jaFaker.name().fullName());
    }
}
```

### Barcha qo'llab-quvvatlanadigan Locale'lar

```
bg, ca, ca-CAT, da-DK, de, de-AT, de-CH, en, en-AU, en-au-ocker,
en-BORK, en-CA, en-GB, en-IND, en-MS, en-NEP, en-NG, en-NZ,
en-PAK, en-SG, en-UG, en-US, en-ZA, es, es-MX, fa, fi-FI, fr,
he, hu, in-ID, it, ja, ko, nb-NO, nl, pl, pt, pt-BR, ru, sk,
sv, sv-SE, tr, uk, vi, zh-CN, zh-TW
```

---

## 5.5 - Amaliy misollar

### Misol 1: Test ma'lumotlar bazasini to'ldirish

```java
import com.github.javafaker.Faker;
import java.util.*;
import java.util.concurrent.TimeUnit;

public class TestDataGenerator {
    
    private static final Faker faker = new Faker();
    
    public static List<User> generateUsers(int count) {
        List<User> users = new ArrayList<>();
        
        for (int i = 0; i < count; i++) {
            User user = User.builder()
                .id(UUID.randomUUID().toString())
                .firstName(faker.name().firstName())
                .lastName(faker.name().lastName())
                .email(faker.internet().emailAddress())
                .password(faker.internet().password(8, 16, true, true, true))
                .phone(faker.phoneNumber().cellPhone())
                .address(faker.address().fullAddress())
                .birthDate(faker.date().birthday(18, 65))
                .registrationDate(faker.date().past(365, TimeUnit.DAYS))
                .active(faker.bool().bool())
                .build();
            
            users.add(user);
        }
        
        return users;
    }
    
    public static List<Product> generateProducts(int count) {
        List<Product> products = new ArrayList<>();
        String[] categories = {"Electronics", "Clothing", "Books", "Food", "Sports"};
        
        for (int i = 0; i < count; i++) {
            Product product = Product.builder()
                .id(UUID.randomUUID().toString())
                .name(faker.commerce().productName())
                .description(faker.lorem().paragraph())
                .price(faker.number().randomDouble(2, 10, 1000))
                .category(faker.options().option(categories))
                .brand(faker.company().name())
                .inStock(faker.bool().bool())
                .createdAt(faker.date().past(30, TimeUnit.DAYS))
                .build();
            
            products.add(product);
        }
        
        return products;
    }
    
    public static void main(String[] args) {
        System.out.println("=== Generating 10 users ===");
        List<User> users = generateUsers(10);
        users.forEach(System.out::println);
        
        System.out.println("\n=== Generating 5 products ===");
        List<Product> products = generateProducts(5);
        products.forEach(System.out::println);
    }
}

// Lombok bilan
@Data
@Builder
class User {
    private String id;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String phone;
    private String address;
    private Date birthDate;
    private Date registrationDate;
    private boolean active;
}

@Data
@Builder
class Product {
    private String id;
    private String name;
    private String description;
    private double price;
    private String category;
    private String brand;
    private boolean inStock;
    private Date createdAt;
}
```

### Misol 2: REST API test ma'lumotlari

```java
import com.github.javafaker.Faker;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.*;

public class ApiTestDataGenerator {
    
    private static final Faker faker = new Faker();
    private static final ObjectMapper mapper = new ObjectMapper();
    
    public static String generateUserJson() {
        Map<String, Object> user = new LinkedHashMap<>();
        
        user.put("id", UUID.randomUUID().toString());
        user.put("firstName", faker.name().firstName());
        user.put("lastName", faker.name().lastName());
        user.put("email", faker.internet().emailAddress());
        user.put("phone", faker.phoneNumber().cellPhone());
        
        Map<String, Object> address = new HashMap<>();
        address.put("street", faker.address().streetAddress());
        address.put("city", faker.address().city());
        address.put("state", faker.address().stateAbbr());
        address.put("zipCode", faker.address().zipCode());
        address.put("country", faker.address().country());
        
        user.put("address", address);
        
        try {
            return mapper.writerWithDefaultPrettyPrinter().writeValueAsString(user);
        } catch (Exception e) {
            e.printStackTrace();
            return "{}";
        }
    }
    
    public static String generatePostJson() {
        Map<String, Object> post = new LinkedHashMap<>();
        
        post.put("id", faker.number().numberBetween(1, 10000));
        post.put("title", faker.lorem().sentence(5));
        post.put("content", faker.lorem().paragraph(10));
        post.put("author", faker.name().fullName());
        post.put("createdAt", faker.date().past(30, java.util.concurrent.TimeUnit.DAYS));
        post.put("likes", faker.number().numberBetween(0, 1000));
        
        // Comments
        List<Map<String, Object>> comments = new ArrayList<>();
        for (int i = 0; i < faker.number().numberBetween(0, 5); i++) {
            Map<String, Object> comment = new HashMap<>();
            comment.put("user", faker.name().fullName());
            comment.put("text", faker.lorem().sentence());
            comment.put("createdAt", faker.date().past(7, java.util.concurrent.TimeUnit.DAYS));
            comments.add(comment);
        }
        post.put("comments", comments);
        
        try {
            return mapper.writerWithDefaultPrettyPrinter().writeValueAsString(post);
        } catch (Exception e) {
            e.printStackTrace();
            return "{}";
        }
    }
    
    public static void main(String[] args) {
        System.out.println("=== User JSON ===");
        System.out.println(generateUserJson());
        
        System.out.println("\n=== Post JSON ===");
        System.out.println(generatePostJson());
    }
}
```

### Misol 3: SQL INSERT script yaratish

```java
import com.github.javafaker.Faker;
import java.text.SimpleDateFormat;
import java.util.*;

public class SqlGenerator {
    
    private static final Faker faker = new Faker();
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    public static void generateUserInserts(int count) {
        System.out.println("-- Users table inserts");
        System.out.println("INSERT INTO users (id, first_name, last_name, email, phone, created_at) VALUES");
        
        for (int i = 0; i < count; i++) {
            String id = UUID.randomUUID().toString();
            String firstName = faker.name().firstName().replace("'", "''");
            String lastName = faker.name().lastName().replace("'", "''");
            String email = faker.internet().emailAddress();
            String phone = faker.phoneNumber().cellPhone();
            String createdAt = sdf.format(faker.date().past(365, TimeUnit.DAYS));
            
            String suffix = (i < count - 1) ? "," : ";";
            System.out.printf("('%s', '%s', '%s', '%s', '%s', '%s')%s%n",
                id, firstName, lastName, email, phone, createdAt, suffix);
        }
    }
    
    public static void generateProductInserts(int count) {
        System.out.println("\n-- Products table inserts");
        System.out.println("INSERT INTO products (id, name, price, category, description) VALUES");
        
        for (int i = 0; i < count; i++) {
            String id = UUID.randomUUID().toString();
            String name = faker.commerce().productName().replace("'", "''");
            double price = faker.number().randomDouble(2, 10, 999);
            String category = faker.commerce().department();
            String description = faker.lorem().paragraph(2).replace("'", "''");
            
            String suffix = (i < count - 1) ? "," : ";";
            System.out.printf("('%s', '%s', %.2f, '%s', '%s')%s%n",
                id, name, price, category, description, suffix);
        }
    }
    
    public static void main(String[] args) {
        generateUserInserts(10);
        generateProductInserts(5);
    }
}
```

### Misol 4: Test class'lar uchun

```java
import com.github.javafaker.Faker;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

public class UserServiceTest {
    
    private static final Faker faker = new Faker();
    private UserService userService;
    
    @BeforeEach
    void setUp() {
        userService = new UserService();
    }
    
    @Test
    void testCreateUser() {
        // Given - random ma'lumotlar
        String email = faker.internet().emailAddress();
        String firstName = faker.name().firstName();
        String lastName = faker.name().lastName();
        String password = faker.internet().password(8, 16, true, true);
        
        // When
        User user = userService.createUser(email, firstName, lastName, password);
        
        // Then
        assertNotNull(user.getId());
        assertEquals(email, user.getEmail());
        assertTrue(user.isActive());
    }
    
    @Test
    void testFindUsersByCity() {
        // Given - 100 ta random user yaratish
        List<User> users = generateRandomUsers(100);
        users.forEach(userService::save);
        
        String randomCity = faker.address().city();
        
        // When
        List<User> found = userService.findByCity(randomCity);
        
        // Then
        assertNotNull(found);
        found.forEach(user -> 
            assertEquals(randomCity, user.getAddress().getCity()));
    }
    
    private List<User> generateRandomUsers(int count) {
        List<User> users = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            users.add(User.builder()
                .email(faker.internet().emailAddress())
                .firstName(faker.name().firstName())
                .lastName(faker.name().lastName())
                .city(faker.address().city())
                .build());
        }
        return users;
    }
}
```

---

## 5.6 - Java Faker Reference

### Asosiy Faker'lar

| Faker | Ma'nosi | Misol |
|-------|---------|-------|
| `name()` | Ism-familiya | `faker.name().fullName()` |
| `address()` | Manzil | `faker.address().fullAddress()` |
| `phoneNumber()` | Telefon | `faker.phoneNumber().cellPhone()` |
| `internet()` | Internet | `faker.internet().emailAddress()` |
| `lorem()` | Matn | `faker.lorem().paragraph()` |
| `company()` | Kompaniya | `faker.company().name()` |
| `commerce()` | Savdo | `faker.commerce().productName()` |
| `number()` | Raqamlar | `faker.number().numberBetween(1, 100)` |
| `date()` | Sana | `faker.date().birthday()` |
| `bool()` | Mantiqiy | `faker.bool().bool()` |

### Maxsus Faker'lar

| Faker | Tavsif |
|-------|--------|
| `pokemon()` | Pokemon ma'lumotlari |
| `harryPotter()` | Harry Potter |
| `gameOfThrones()` | Game of Thrones |
| `starWars()` | Star Wars |
| `dragonBall()` | Dragon Ball |
| `animal()` | Hayvonlar |
| `dog()` | Itlar |
| `cat()` | Mushuklar |
| `food()` | Ovqatlar |
| `beer()` | Pivo |
| `superhero()` | Superqahramonlar |

---

## Tekshiruv Savollari

1. **Java Faker nima va nima uchun ishlatiladi?**
2. **Faker obyektini qanday yaratish mumkin?**
3. **Ism-familiya yaratish uchun qaysi metod ishlatiladi?**
4. **Manzil ma'lumotlarini yaratish uchun qanday faker'dan foydalaniladi?**
5. **Telefon raqam yaratish uchun qaysi faker kerak?**
6. **Email va password yaratish uchun nima ishlatiladi?**
7. **Lorem Ipsum matn yaratish uchun qaysi faker ishlatiladi?**
8. **Locale qanday o'rnatiladi va nima uchun kerak?**
9. **Test ma'lumotlari yaratishda Java Faker qanday yordam beradi?**
10. **Qanday maxsus faker'lar mavjud?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega DataGenerator class'ini yozing:

1. **100 ta user** - ism, email, phone, address, birthDate
2. **50 ta product** - nom, narx, kategoriya, description
3. **20 ta order** - user, product, quantity, orderDate
4. **Ma'lumotlarni JSON formatda saqlash**
5. **Ma'lumotlarni SQL script ko'rinishida chiqarish**

```java
// Tekshirish:
DataGenerator generator = new DataGenerator();
List<User> users = generator.generateUsers(100);
generator.exportToJson(users, "users.json");
generator.exportToSql(users, "users.sql");
```

---

## Javoblar va Resurslar

- **Javadoc**: http://dius.github.io/java-faker/apidocs/index.html
- **GitHub**: https://github.com/DiUS/java-faker
- **Maven Central**: https://mvnrepository.com/artifact/com.github.javafaker/javafaker

---

**Keyingi mavzu:** [Testing (JUnit)](./07_Testing_JUnit.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
