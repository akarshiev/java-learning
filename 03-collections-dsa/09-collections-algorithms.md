# Collections Framework Algorithms, Optional Class va SOLID Prinsiplari

## Collections Framework Algorithms

Java collections framework collection class'larini implement qilishdan tashqari, bir qator foydali algoritmlarni ham taqdim etadi. Quyida siz bu algoritmlarni qanday ishlatishni va collections framework bilan yaxshi ishlaydigan o'zingizning algoritmlaringizni qanday yozishni ko'rasiz.

## Oddiy Algoritmlar

Collections class'i bir nechta oddiy, lekin foydali algoritmlarni o'z ichiga oladi. Collection'ning maksimal qiymatini topish, elementlarni bir list'dan ikkinchisiga ko'chirish, konteynerni doimiy qiymat bilan to'ldirish va list'ni teskari aylantirish.

Nega standart kutubxonada bunday oddiy algoritmlarni taqdim etish kerak? Albatta, ko'pchilik dasturchilar ularni oddiy loop'lar bilan osongina implement qilishlari mumkin, lekin bu algoritmlar kodni o'qiydigan dasturchi uchun hayotni osonlashtiradi.

### Collections Class'ining Oddiy Algoritmlari

```java
// Elementlarni almashtirish
Collections.replaceAll(list, oldVal, newVal);

// Shartga ko'ra elementlarni o'chirish
collection.removeIf(predicate);

// Minimal va maksimal qiymatlarni topish
Collections.min(collection);
Collections.max(collection);

// Elementlarni ko'chirish
Collections.copy(dest, src);

// List'ni teskari aylantirish
Collections.reverse(list);

// Element chastotasini topish
Collections.frequency(collection, element);

// Ikkala collection'ning kesishmasligini tekshirish
Collections.disjoint(collection1, collection2);
```

### SimpleAlgorithm Test

```java
package collectionsframework.algorithms;

import java.util.*;

/**
 * Collections class'ining oddiy algoritmlari
 */
public class SimpleAlgorithm {

    public static void main(String[] args) {
        System.out.println("========== COLLECTIONS ALGORITHMS ==========");

        // 1. Random sonlar bilan list yaratish
        List<Integer> numbers = new ArrayList<>();
        Random random = new Random();

        for (int i = 0; i < 15; i++) {
            numbers.add(random.nextInt(10));  // 0-9 oralig'ida random sonlar
        }

        System.out.println("1. Original list: " + numbers);

        // 2. Min va Max topish
        Integer min = Collections.min(numbers);
        Integer max = Collections.max(numbers);
        System.out.println("\n2. Min value: " + min);
        System.out.println("   Max value: " + max);

        // 3. removeIf() - shartga ko'ra elementlarni o'chirish
        numbers.removeIf(number -> number < 3);
        System.out.println("\n3. After removing numbers < 3: " + numbers);

        // 4. reverse() - list'ni teskari aylantirish
        Collections.reverse(numbers);
        System.out.println("\n4. After reversing: " + numbers);

        // 5. frequency() - element chastotasini topish
        if (!numbers.isEmpty()) {
            int target = numbers.get(0);
            int frequency = Collections.frequency(numbers, target);
            System.out.println("\n5. Frequency of " + target + ": " + frequency);
        }

        // 6. disjoint() - kesishmaslikni tekshirish
        List<Integer> otherList = Arrays.asList(10, 11, 12, 13);
        boolean disjoint = Collections.disjoint(numbers, otherList);
        System.out.println("\n6. Are numbers and otherList disjoint? " + disjoint);

        // 7. sort() - tartiblash
        Collections.sort(numbers);
        System.out.println("\n7. After sorting ascending: " + numbers);

        // Teskari tartibda tartiblash
        Collections.sort(numbers, Comparator.reverseOrder());
        System.out.println("   After sorting descending: " + numbers);

        // 8. shuffle() - aralashtirish
        Collections.shuffle(numbers);
        System.out.println("\n8. After shuffling: " + numbers);

        // 9. fill() - barcha elementlarni bir qiymat bilan to'ldirish
        Collections.fill(numbers, 5);
        System.out.println("\n9. After filling with 5: " + numbers);

        // 10. copy() - elementlarni ko'chirish
        List<Integer> source = Arrays.asList(1, 2, 3, 4, 5);
        List<Integer> destination = new ArrayList<>(Arrays.asList(0, 0, 0, 0, 0));

        Collections.copy(destination, source);
        System.out.println("\n10. After copying source to destination:");
        System.out.println("   Source: " + source);
        System.out.println("   Destination: " + destination);

        // 11. replaceAll() - barcha mos keladigan elementlarni almashtirish
        List<String> words = new ArrayList<>(Arrays.asList("apple", "banana", "apple", "cherry"));
        Collections.replaceAll(words, "apple", "orange");
        System.out.println("\n11. After replacing 'apple' with 'orange': " + words);

        // 12. rotate() - elementlarni siljitish
        List<Integer> rotateList = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
        Collections.rotate(rotateList, 2);  // O'ngga 2 marta
        System.out.println("\n12. After rotating right by 2: " + rotateList);

        Collections.rotate(rotateList, -2);  // Chapga 2 marta
        System.out.println("    After rotating left by 2: " + rotateList);

        // 13. swap() - elementlarni almashtirish
        List<String> swapList = new ArrayList<>(Arrays.asList("A", "B", "C", "D"));
        Collections.swap(swapList, 1, 3);
        System.out.println("\n13. After swapping indices 1 and 3: " + swapList);

        // 14. nCopies() - bir xil elementning nusxalaridan iborat list
        List<String> copies = Collections.nCopies(5, "Java");
        System.out.println("\n14. nCopies of 'Java': " + copies);

        // 15. singletonList/set/map - bitta elementli immutable kolleksiyalar
        List<String> singletonList = Collections.singletonList("Single");
        Set<Integer> singletonSet = Collections.singleton(42);
        Map<String, String> singletonMap = Collections.singletonMap("key", "value");

        System.out.println("\n15. Singleton collections:");
        System.out.println("   List: " + singletonList);
        System.out.println("   Set: " + singletonSet);
        System.out.println("   Map: " + singletonMap);
    }
}
```

## Tartiblash

Hozirgi kunda tartiblash algoritmlari ko'pgina dasturlash tillarining standart kutubxonasining bir qismidir va Java dasturlash tili bundan mustasno emas.

```java
// Tabiiy tartibda tartiblash
Collections.sort(list);

// Comparator bilan tartiblash
Collections.sort(list, comparator);

// Java 8+ - List interface'idagi default method
list.sort(comparator);
```

## Aralashtirish

Collections class'ining `shuffle` algoritmi tartiblashning aksini qiladi - u list'dagi elementlarning tartibini tasodifiy o'zgartiradi.

```java
Collections.shuffle(list);
```

## Collections va Arrays o'rtasida Konvertatsiya

Java platformasi API'ining katta qismi collections framework yaratilishidan oldin ishlab chiqilgan. Natijada, siz an'anaviy array'lar va zamonaviyroq kolleksiyalar o'rtasida o'girishni amalga oshirishingiz kerak bo'ladi.

Agar sizda collection'ga aylantirish kerak bo'lgan array bo'lsa, `List.of` method'i bu maqsadga xizmat qiladi.

Ammo natija ob'ektlar array'idir. Agar siz collection'ingiz ma'lum turdagi ob'ektlarni o'z ichiga olganini bilsangiz ham, cast ishlatib bo'lmaydi.

```java
// Array'dan List ga
String[] names = {"Alice", "Bob", "Charlie"};
List<String> list = List.of(names);

// List'dan Array ga (noto'g'ri usul)
Object[] array = list.toArray();  // Object[] turida

// List'dan Array ga (to'g'ri usul - type safe)
String[] stringArray = list.toArray(new String[0]);
// Yoki
String[] stringArray = list.toArray(String[]::new);  // Java 8+
```

### ArrayAlgorithms Test

```java
package collectionsframework.algorithms;

import java.util.*;

/**
 * Collections va Arrays o'rtasida konvertatsiya
 */
public class ArrayAlgorithms {

    public static void main(String[] args) {
        System.out.println("========== ARRAYS AND COLLECTIONS CONVERSION ==========");

        // 1. Array'dan List ga aylantirish
        System.out.println("1. Converting array to list:");
        String[] languagesArray = {"Java", "GO", "Groovy", "Kotlin", "Scala"};
        System.out.println("   Original array: " + Arrays.toString(languagesArray));

        // Arrays.asList() - array asosidagi list (mutable view)
        List<String> languagesList1 = Arrays.asList(languagesArray);
        System.out.println("   List from Arrays.asList(): " + languagesList1);

        // List.of() - immutable list (Java 9+)
        List<String> languagesList2 = List.of(languagesArray);
        System.out.println("   List from List.of(): " + languagesList2);

        // 2. List'dan Array ga aylantirish
        System.out.println("\n2. Converting list to array:");

        // toArray() without parameter - returns Object[]
        Object[] objectArray = languagesList1.toArray();
        System.out.println("   Object array: " + Arrays.toString(objectArray));

        // toArray() with parameter - returns typed array
        String[] stringArray1 = languagesList1.toArray(new String[0]);
        System.out.println("   String array (new String[0]): " + Arrays.toString(stringArray1));

        // Method reference (Java 8+)
        String[] stringArray2 = languagesList1.toArray(String[]::new);
        System.out.println("   String array (String[]::new): " + Arrays.toString(stringArray2));

        // 3. Binary search
        System.out.println("\n3. Binary search algorithm:");

        // Binary search uchun list tartiblangan bo'lishi kerak
        List<String> sortedList = new ArrayList<>(languagesList2);
        Collections.sort(sortedList);
        System.out.println("   Sorted list: " + sortedList);

        // Binary search - mavjud element
        int index1 = Collections.binarySearch(sortedList, "Java");
        System.out.println("   Binary search for 'Java': index = " + index1);

        // Binary search - mavjud bo'lmagan element
        int index2 = Collections.binarySearch(sortedList, "Python");
        System.out.println("   Binary search for 'Python': index = " + index2);
        System.out.println("   Negative index means: insert at position " + (-index2 - 1));

        // 4. Arrays class'ining algoritmlari
        System.out.println("\n4. Arrays class utility methods:");

        int[] numbers = {5, 2, 8, 1, 9, 3};
        System.out.println("   Original array: " + Arrays.toString(numbers));

        // Arrays.sort()
        Arrays.sort(numbers);
        System.out.println("   After Arrays.sort(): " + Arrays.toString(numbers));

        // Arrays.binarySearch()
        int bsIndex = Arrays.binarySearch(numbers, 8);
        System.out.println("   Arrays.binarySearch() for 8: index = " + bsIndex);

        // Arrays.fill()
        int[] filledArray = new int[5];
        Arrays.fill(filledArray, 42);
        System.out.println("   Arrays.fill() with 42: " + Arrays.toString(filledArray));

        // Arrays.copyOf()
        int[] copiedArray = Arrays.copyOf(numbers, numbers.length);
        System.out.println("   Arrays.copyOf(): " + Arrays.toString(copiedArray));

        // Arrays.equals()
        boolean areEqual = Arrays.equals(numbers, copiedArray);
        System.out.println("   Arrays.equals() with copy: " + areEqual);

        // 5. Performance taqqoslash
        System.out.println("\n5. Performance comparison:");
        System.out.println("   - Arrays.sort(): Dual-Pivot Quicksort O(n log n) average");
        System.out.println("   - Collections.sort(): Arrays.sort() ni chaqiradi");
        System.out.println("   - Binary search: O(log n) - very efficient for sorted data");
        System.out.println("   - Linear search: O(n) - simple but slower for large data");
    }
}
```

## Binary Search (Ikkilik Qidiruv)

Array'da ob'ekt topish uchun odatda siz mos keladiganga yetguningizcha barcha elementlarni ko'rib chiqasiz. Biroq, agar array tartiblangan bo'lsa, siz o'rta elementni ko'rib, u siz topmoqchi bo'lgan elementdan katta yoki kichikligini tekshirishingiz mumkin. Agar katta bo'lsa, array'ning birinchi yarmida qidiramiz; aks holda, ikkinchi yarmida qidiramiz. Bu muammoni yarmiga kamaytiradi va siz xuddi shu tarzda davom etasiz. Masalan, agar array'da 1024 ta element bo'lsa, siz 10 qadamdan keyin moslikni topasiz (yoki yo'qligini tasdiqlaysiz), chiziqli qidiruv esa element mavjud bo'lsa o'rtacha 512 qadam, yo'q bo'lsa 1024 qadam oladi. Collections class'ining `binarySearch` method'i ushbu algoritmni amalga oshiradi.

```java
// Natural ordering bilan binary search
int index = Collections.binarySearch(collection, element);

// Comparator bilan binary search
int index = Collections.binarySearch(collection, element, comparator);
```

## Optional Class

**Optional** - bu null bo'lmagan qiymatni o'z ichiga olishi yoki bo'lmasligi mumkin bo'lgan konteyner ob'ekt (JDK 1.8'dan boshlab). Optional asosan "natija yo'q" ni ifodalash uchun aniq ehtiyoj bo'lgan va null ishlatish xatolarga olib kelishi mumkin bo'lgan method'ning qaytish turi sifatida ishlatish uchun mo'ljallangan. Optional turidagi o'zgaruvchi hech qachon null bo'lishi kerak emas; u har doim Optional instance'iga ishora qilishi kerak.

### Optional'ning Asosiy Xususiyatlari

1. **Null'ni oldini olish** - NullPointerException'dan himoya qiladi
2. **Aniqlik** - Method'ning qaytish qiymati bo'lishi mumkin yoki bo'lmasligini aniq ko'rsatadi
3. **Funksional dasturlash** - map(), filter(), flatMap() kabi method'lar bilan ishlash
4. **Default qiymat** - orElse(), orElseGet() method'lari bilan default qiymat belgilash

### Card Record'i

```java
package optional;

/**
 * Card record - karta ma'lumotlarini saqlash uchun
 * @param holderName karta egasi ismi
 * @param pan karta raqami
 * @param expiry amal qilish muddati
 */
public record Card(String holderName, String pan, String expiry) {

    @Override
    public String toString() {
        return String.format("Card{holder='%s', pan='%s', expiry='%s'}",
                holderName, pan, expiry);
    }
}
```

### WithoutOptional (Optional'siz)

```java
package optional;

import java.util.Optional;
import java.util.Random;

/**
 * Optional'siz dastur - an'anaviy null tekshirish
 */
public class WithoutOptional {

    public static void main(String[] args) {
        System.out.println("========== WITHOUT OPTIONAL ==========");

        // 1. An'anaviy usul - null tekshirish
        System.out.println("1. Traditional approach (with null checks):");
        Card card = findCardByPanTraditional("9860 **** **** ****");

        if (card == null) {
            System.out.println("   Card not found - UNKNOWN");
        } else {
            System.out.println("   Card found: " + card.holderName());
        }

        // 2. Optional bilan
        System.out.println("\n2. With Optional:");
        Optional<Card> cardOptional = findCardByPanOptional("9860 **** **** ****");

        if (cardOptional.isPresent()) {
            Card optionalCard = cardOptional.get();
            System.out.println("   Card found: " + optionalCard.holderName());
        } else {
            System.out.println("   Card not found - UNKNOWN");
        }

        // 3. Muammolar
        System.out.println("\n3. Problems without Optional:");
        System.out.println("   - Null checks everywhere");
        System.out.println("   - NullPointerException risk");
        System.out.println("   - Unclear intent (does method return null?)");
        System.out.println("   - Chained calls are dangerous (card.getHolder().getName())");
    }

    /**
     * An'anaviy usul - null qaytaradi
     */
    static Card findCardByPanTraditional(String pan) {
        Random random = new Random();
        if (random.nextBoolean()) {
            return new Card("Elmurodov Javohir", pan, "01/26");
        }
        return null;  // Problematik - method null qaytarishi mumkin
    }

    /**
     * Optional bilan - null emas, Optional.empty() qaytaradi
     */
    static Optional<Card> findCardByPanOptional(String pan) {
        Random random = new Random();
        if (random.nextBoolean()) {
            return Optional.of(new Card("Elmurodov Javohir", pan, "01/26"));
        }
        return Optional.empty();  // Aniq - qiymat mavjud emas
    }
}
```

### OptionalClassTest

```java
package optional;

import java.util.Optional;
import java.util.Random;
import java.util.function.Consumer;
import java.util.function.Supplier;

/**
 * Optional class'ining to'liq imkoniyatlari
 */
public class OptionalClassTest {

    public static void main(String[] args) {
        System.out.println("========== OPTIONAL CLASS FEATURES ==========");

        Card validCard = new Card("Elmurodov Javohir", "9869 **** **** ****", "01/26");
        Card unknownCard = new Card("UNKNOWN", "xxxx xxxx xxxx xxxx", "mm/yy");
        Random random = new Random();

        // 1. Optional yaratish usullari
        System.out.println("1. Creating Optional instances:");

        // Optional.empty() - bo'sh Optional
        Optional<Object> emptyOptional = Optional.empty();
        System.out.println("   Optional.empty(): " + emptyOptional);
        System.out.println("   Is empty? " + emptyOptional.isEmpty());
        System.out.println("   Is present? " + emptyOptional.isPresent());

        // Optional.of() - null bo'lmagan qiymat bilan
        Optional<String> stringOptional = Optional.of("Hello");
        System.out.println("\n   Optional.of(\"Hello\"): " + stringOptional);
        System.out.println("   Is present? " + stringOptional.isPresent());

        // Optional.ofNullable() - null yoki null bo'lmagan qiymat bilan
        String nullableString = random.nextBoolean() ? "World" : null;
        Optional<String> nullableOptional = Optional.ofNullable(nullableString);
        System.out.println("\n   Optional.ofNullable(random): " + nullableOptional);
        System.out.println("   Is present? " + nullableOptional.isPresent());

        // 2. Optional o'qish usullari
        System.out.println("\n2. Reading values from Optional:");

        Optional<Card> cardOptional = Optional.ofNullable(
                random.nextBoolean() ? validCard : null
        );

        // orElse() - default qiymat bilan
        Card card1 = cardOptional.orElse(unknownCard);
        System.out.println("   orElse(unknownCard): " + card1);

        // orElseGet() - Supplier bilan default qiymat
        Card card2 = cardOptional.orElseGet(() -> {
            System.out.println("     Creating default card...");
            return unknownCard;
        });
        System.out.println("   orElseGet(supplier): " + card2);

        // orElseThrow() - exception bilan
        try {
            Card card3 = cardOptional.orElseThrow(() ->
                    new RuntimeException("Card not found")
            );
            System.out.println("   orElseThrow(): " + card3);
        } catch (RuntimeException e) {
            System.out.println("   orElseThrow(): Exception caught - " + e.getMessage());
        }

        // 3. Conditional execution
        System.out.println("\n3. Conditional execution:");

        // ifPresent() - qiymat mavjud bo'lsa
        cardOptional.ifPresent(card ->
                System.out.println("   ifPresent(): Card holder: " + card.holderName())
        );

        // ifPresentOrElse() - qiymat mavjud yoki yo'q bo'lsa (Java 9+)
        cardOptional.ifPresentOrElse(
                card -> System.out.println("   ifPresentOrElse(): Card found: " + card.holderName()),
                () -> System.out.println("   ifPresentOrElse(): No card found")
        );

        // 4. Functional operations
        System.out.println("\n4. Functional operations:");

        Optional<Card> functionalOptional = Optional.of(validCard);

        // map() - transformatsiya
        Optional<String> holderName = functionalOptional.map(Card::holderName);
        System.out.println("   map(Card::holderName): " + holderName);

        // filter() - filtratsiya
        Optional<Card> filtered = functionalOptional.filter(
                card -> card.holderName().startsWith("Elmurodov")
        );
        System.out.println("   filter(startsWith 'Elmurodov'): " + filtered);

        // flatMap() - ichki Optional bilan ishlash
        Optional<String> flatMapped = functionalOptional.flatMap(card ->
                Optional.of("Mr. " + card.holderName())
        );
        System.out.println("   flatMap(add 'Mr.'): " + flatMapped);

        // 5. Chain operations
        System.out.println("\n5. Chaining operations:");

        Optional<String> result = Optional.of(validCard)
                .filter(card -> card.pan().contains("9860"))
                .map(Card::holderName)
                .map(String::toUpperCase)
                .filter(name -> name.length() > 5);

        System.out.println("   Chained result: " + result.orElse("No matching card"));

        // 6. Amaliy misol
        System.out.println("\n6. Practical example - service layer:");

        CardService cardService = new CardService();
        String panToFind = "9860 **** **** ****";

        // Null-safe chain
        String cardHolder = cardService.findCard(panToFind)
                .map(Card::holderName)
                .orElse("UNKNOWN");

        System.out.println("   Card holder for " + panToFind + ": " + cardHolder);

        // 7. Common pitfalls
        System.out.println("\n7. Common pitfalls with Optional:");
        System.out.println("   - Don't use Optional for fields");
        System.out.println("   - Don't use Optional in collections");
        System.out.println("   - Don't call get() without checking isPresent()");
        System.out.println("   - Optional is not serializable");
        System.out.println("   - Performance overhead (slight)");
    }
}

/**
 * CardService - Optional'ni amaliy ishlatish misoli
 */
class CardService {
    private Random random = new Random();

    /**
     * Karta qidirish - Optional qaytaradi
     */
    public Optional<Card> findCard(String pan) {
        // Simulyatsiya: ba'zida topiladi, ba'zida yo'q
        if (random.nextBoolean()) {
            return Optional.of(new Card("Elmurodov Javohir", pan, "01/26"));
        }
        return Optional.empty();
    }

    /**
     * Karta ma'lumotlarini olish - null-safe
     */
    public String getCardHolderName(String pan) {
        return findCard(pan)
                .map(Card::holderName)
                .orElse("UNKNOWN");
    }

    /**
     * Karta mavjudligini tekshirish
     */
    public boolean cardExists(String pan) {
        return findCard(pan).isPresent();
    }
}
```

## S.O.L.I.D Prinsiplari

SOLID - bu Robert C. Martin tomonidan birinchi beshta ob'ektga yo'naltirilgan dizayn (OOD) prinsiplari uchun akronim.

- **S** - Single Responsibility Principle (Yagona Mas'uliyat Prinsipi)
- **O** - Open-closed Principle (Ochiq-Yopiq Prinsipi)
- **L** - Liskov Substitution Principle (Liskov Almashtirish Prinsipi)
- **I** - Interface Segregation Principle (Interfeys Ajratish Prinsipi)
- **D** - Dependency Inversion Principle (Bog'liqlik Inversiyasi Prinsipi)

### Single Responsibility Principle (Yagona Mas'uliyat Prinsipi)

**"Class faqat bitta sababga ko'ra o'zgarishi kerak."**

Bir class faqat bitta vazifani bajarishi kerak. Agar class bir nechta vazifalarni bajaradigan bo'lsa, uni o'zgartirish uchun bir nechta sabablar bo'ladi, bu esa class'ni murakkab va qiyin boshqariladigan qiladi.

#### SRP'siz (Yomon Amaliyot)

```java
package solid.without.srp;

/**
 * Yomon amaliyot: User class'i juda ko'p vazifalarni bajaradi
 * - User ma'lumotlarini saqlaydi
 * - Database operatsiyalarini bajaradi
 * - Log yozadi
 * - Report generatsiya qiladi
 */
public class User {
    private String username;
    private String email;
    private String age;

    // getters and setters...

    public void save(User user) {
        // connect to Database
        // persist to Database
    }

    public void remove(User user) {
        // connect to Database
        // remove from Database
    }

    public User get(String username) {
        // connect to Database
        // get from Database
        return null;
    }

    public void logToExcel(User user) {
        // Excel ga log yozish
    }

    public void logToTxt(User user) {
        // Txt faylga log yozish
    }

    public Object generateAsPDF() {
        // PDF generatsiya
        return null;
    }

    public Object generateAsDoc() {
        // DOC generatsiya
        return null;
    }
}
```

#### SRP bilan (Yaxshi Amaliyot)

```java
package solid.with.srp;

/**
 * User class - faqat user ma'lumotlarini saqlaydi
 */
public class User {
    private String username;
    private String email;
    private String age;

    // Constructor, getters va setters...

    public User(String username, String email, String age) {
        this.username = username;
        this.email = email;
        this.age = age;
    }

    // Faqat user bilan bog'liq method'lar
    public boolean isValid() {
        return username != null && !username.isEmpty() &&
                email != null && email.contains("@");
    }
}
```

```java
package solid.with.srp;

/**
 * UserRepository - faqat database operatsiyalari
 */
public class UserRepository {
    public void save(User user) {
        // getConnection();
        // persist to Database
        System.out.println("Saving user to database: " + user);
    }

    public void remove(User user) {
        // getConnection();
        // remove from Database
        System.out.println("Removing user from database: " + user);
    }

    public User get(String username) {
        // getConnection();
        // get from Database
        System.out.println("Getting user from database: " + username);
        return null;
    }

    private Object getConnection() {
        // Database connection logic
        return null;
    }
}
```

```java
package solid.with.srp;

/**
 * LogService - faqat log yozish operatsiyalari
 */
public class LogService {
    public void logToExcel(User user) {
        System.out.println("Logging user to Excel: " + user);
    }

    public void logToTxt(User user) {
        System.out.println("Logging user to Txt: " + user);
    }
}
```

```java
package solid.with.srp;

/**
 * GeneratorService - faqat report generatsiya operatsiyalari
 */
public class GeneratorService {
    public Object generateAsPDF(User user) {
        System.out.println("Generating PDF for user: " + user);
        return "PDF Document";
    }

    public Object generateAsDoc(User user) {
        System.out.println("Generating DOC for user: " + user);
        return "DOC Document";
    }
}
```

### Open/Closed Principle (Ochiq-Yopiq Prinsipi)

**"Dasturiy ob'ektlar (class'lar, modullar, funksiyalar va h.k.) kengaytirish uchun ochiq, o'zgartirish uchun yopiq bo'lishi kerak."**

Class yoki modul yangi funksionalni qo'shish uchun kengaytirilishi mumkin bo'lishi kerak, lekin mavjud kodni o'zgartirmasdan.

#### OCP'siz (Yomon Amaliyot)

```java
package solid.without.ocp;

/**
 * Transfer - pul o'tkazish ma'lumotlari
 */
public record Transfer(String sender, String receiver, String transactionType, String amount) {
}

/**
 * TransferService - OCP'siz, yangi transaction type qo'shish uchun kod o'zgartirish kerak
 */
public class TransferService {
    public boolean transfer(Transfer transfer) {
        if (transfer.transactionType().equals("uzcard_humo")) {
            System.out.println("Processing Uzcard to Humo transfer");
            // Uzcard -> Humo logikasi
        } else if (transfer.transactionType().equals("humo_uzcard")) {
            System.out.println("Processing Humo to Uzcard transfer");
            // Humo -> Uzcard logikasi
        } else if (transfer.transactionType().equals("uzcard_uzcard")) {
            System.out.println("Processing Uzcard to Uzcard transfer");
            // Uzcard -> Uzcard logikasi
        }
        // Har safar yangi type qo'shish uchun bu method'ni o'zgartirish kerak
        return true;
    }
}
```

#### OCP bilan (Yaxshi Amaliyot)

```java
package solid.with.ocp;

/**
 * Transfer - pul o'tkazish ma'lumotlari
 */
public record Transfer(String sender, String receiver, String amount) {
}

/**
 * TransferService interfeysi - barcha transfer turlari uchun umumiy
 */
public interface TransferService {
    boolean transfer(Transfer transfer);
    String getTransactionType();
}

/**
 * Uzcard dan Humo ga pul o'tkazish
 */
public class UzcardHumoTransferService implements TransferService {
    @Override
    public boolean transfer(Transfer transfer) {
        System.out.println("Processing Uzcard to Humo transfer:");
        System.out.println("  Sender: " + transfer.sender());
        System.out.println("  Receiver: " + transfer.receiver());
        System.out.println("  Amount: " + transfer.amount());
        // Maxsus Uzcard->Humo logikasi
        return true;
    }

    @Override
    public String getTransactionType() {
        return "uzcard_humo";
    }
}

/**
 * Humo dan Uzcard ga pul o'tkazish
 */
public class HumoUzcardTransferService implements TransferService {
    @Override
    public boolean transfer(Transfer transfer) {
        System.out.println("Processing Humo to Uzcard transfer:");
        System.out.println("  Sender: " + transfer.sender());
        System.out.println("  Receiver: " + transfer.receiver());
        System.out.println("  Amount: " + transfer.amount());
        // Maxsus Humo->Uzcard logikasi
        return true;
    }

    @Override
    public String getTransactionType() {
        return "humo_uzcard";
    }
}

/**
 * TransferServiceFactory - transfer servicelarini yaratish
 */
public class TransferServiceFactory {
    private Map<String, TransferService> services = new HashMap<>();

    public TransferServiceFactory() {
        // Yangi transfer turi qo'shilganda faqat bu yerda registratsiya qilish kerak
        registerService(new UzcardHumoTransferService());
        registerService(new HumoUzcardTransferService());
    }

    private void registerService(TransferService service) {
        services.put(service.getTransactionType(), service);
    }

    public TransferService getService(String transactionType) {
        return services.get(transactionType);
    }
}

/**
 * Asosiy dastur
 */
public class Main {
    public static void main(String[] args) {
        TransferServiceFactory factory = new TransferServiceFactory();

        Transfer transfer1 = new Transfer("8600 1234 5678 9012", "9860 9876 5432 1098", "100000");
        TransferService service1 = factory.getService("uzcard_humo");
        if (service1 != null) {
            service1.transfer(transfer1);
        }

        // Yangi transfer turi qo'shish uchun faqat yangi class yaratish kifoya
        // TransferServiceFactory ni o'zgartirish shart emas
    }
}
```

### Liskov Substitution Principle (Liskov Almashtirish Prinsipi)

**"Superclass'ning ob'ektlari uning subclass'larining ob'ektlari bilan almashtirilishi mumkin bo'lishi kerak, ilovani buzmasdan."**

Boshqacha qilib aytganda, biz subclass'larimizning ob'ektlari superclass'ning ob'ektlari kabi xatti-harakat qilishini xohlaymiz.

#### LSP'siz (Yomon Amaliyot)

```java
package solid.without.lsp;

/**
 * Database interfeysi - barcha database'lar uchun
 */
public interface Database {
    void save();
    void delete();
    Object get();
    void createTable();  // Problem: NoSQL database'lar uchun noto'g'ri
}

/**
 * PostgreSQL - relational database
 */
class PostgresqlDatabase implements Database {
    @Override
    public void save() {
        System.out.println("Saving to PostgreSQL table");
    }
    
    @Override
    public void delete() {
        System.out.println("Deleting from PostgreSQL table");
    }
    
    @Override
    public Object get() {
        return "Data from PostgreSQL table";
    }
    
    @Override
    public void createTable() {
        System.out.println("Creating table in PostgreSQL");
    }
}

/**
 * MongoDB - NoSQL database
 */
class MongoDatabase implements Database {
    @Override
    public void save() {
        System.out.println("Saving document to MongoDB collection");
    }
    
    @Override
    public void delete() {
        System.out.println("Deleting document from MongoDB collection");
    }
    
    @Override
    public Object get() {
        return "Document from MongoDB collection";
    }
    
    @Override
    public void createTable() {
        // Problem: MongoDB'da table yo'q, collection bor
        throw new UnsupportedOperationException("MongoDB does not have tables");
    }
}
```

#### LSP bilan (Yaxshi Amaliyot)

```java
package solid.with.lsp;

/**
 * Asosiy Database interfeysi - barcha database'lar uchun umumiy method'lar
 */
public interface Database {
    void save();
    void delete();
    Object get();
}

/**
 * Relational database'lar uchun interfeys
 */
public interface RelationalDatabase extends Database {
    void createTable();
    void createIndex();
}

/**
 * NoSQL database'lar uchun interfeys
 */
public interface NoSQLDatabase extends Database {
    void createCollection();
    void createIndexOnField(String fieldName);
}

/**
 * PostgreSQL - relational database implementatsiyasi
 */
public class PostgresqlDatabase implements RelationalDatabase {
    @Override
    public void save() {
        System.out.println("Saving to PostgreSQL table");
    }
    
    @Override
    public void delete() {
        System.out.println("Deleting from PostgreSQL table");
    }
    
    @Override
    public Object get() {
        return "Data from PostgreSQL table";
    }
    
    @Override
    public void createTable() {
        System.out.println("Creating table in PostgreSQL");
    }
    
    @Override
    public void createIndex() {
        System.out.println("Creating index in PostgreSQL");
    }
}

/**
 * MongoDB - NoSQL database implementatsiyasi
 */
public class MongoDatabase implements NoSQLDatabase {
    @Override
    public void save() {
        System.out.println("Saving document to MongoDB collection");
    }
    
    @Override
    public void delete() {
        System.out.println("Deleting document from MongoDB collection");
    }
    
    @Override
    public Object get() {
        return "Document from MongoDB collection";
    }
    
    @Override
    public void createCollection() {
        System.out.println("Creating collection in MongoDB");
    }
    
    @Override
    public void createIndexOnField(String fieldName) {
        System.out.println("Creating index on field: " + fieldName + " in MongoDB");
    }
}

/**
 * Test - LSP bilan ishlash
 */
public class Test {
    public static void main(String[] args) {
        // Relational database'lar bilan ishlash
        RelationalDatabase postgres = new PostgresqlDatabase();
        useDatabase(postgres);
        
        // NoSQL database'lar bilan ishlash
        NoSQLDatabase mongo = new MongoDatabase();
        useDatabase(mongo);
        
        // Maxsus operatsiyalar
        postgres.createTable();      // Faqat relational database uchun
        mongo.createCollection();    // Faqat NoSQL database uchun
    }
    
    // Har qanday Database bilan ishlaydigan umumiy method
    static void useDatabase(Database database) {
        database.save();
        database.delete();
        System.out.println("Retrieved: " + database.get());
    }
}
```

### Interface Segregation Principle (Interfeys Ajratish Prinsipi)

**"Mijozlar o'zlari ishlatmaydigan interfeyslarga bog'liq bo'lishga majbur bo'lmasligi kerak."**

Yirik, umumiy interfeys o'rniga ko'plab maxsus interfeyslarni ishlatish yaxshiroq.

#### ISP bilan Yaxshi Amaliyot

```java
package solid.with.isp;

/**
 * Kichik, maqsadli interfeyslar
 */

// Printer funksiyalari uchun
public interface Printer {
    void print(Document document);
}

// Scanner funksiyalari uchun
public interface Scanner {
    void scan(Document document);
}

// Fax funksiyalari uchun
public interface Fax {
    void fax(Document document);
}

// Photocopier funksiyalari uchun
public interface Photocopier {
    void copy(Document document);
}

/**
 * Turli qurilmalar - faqat kerakli interfeyslarni implement qiladi
 */

// Oddiy printer
public class SimplePrinter implements Printer {
    @Override
    public void print(Document document) {
        System.out.println("Printing document: " + document);
    }
}

// Multifunksional qurilma
public class MultiFunctionMachine implements Printer, Scanner, Fax, Photocopier {
    @Override
    public void print(Document document) {
        System.out.println("Printing: " + document);
    }
    
    @Override
    public void scan(Document document) {
        System.out.println("Scanning: " + document);
    }
    
    @Override
    public void fax(Document document) {
        System.out.println("Faxing: " + document);
    }
    
    @Override
    public void copy(Document document) {
        System.out.println("Copying: " + document);
    }
}

// Faqat scan va print qiladigan qurilma
public class PrintScanDevice implements Printer, Scanner {
    @Override
    public void print(Document document) {
        System.out.println("Printing: " + document);
    }
    
    @Override
    public void scan(Document document) {
        System.out.println("Scanning: " + document);
    }
}

/**
 * Document class'i
 */
public class Document {
    private String content;
    
    public Document(String content) {
        this.content = content;
    }
    
    @Override
    public String toString() {
        return content;
    }
}

/**
 * Asosiy dastur
 */
public class Main {
    public static void main(String[] args) {
        Document doc = new Document("Important Document");
        
        // Faqat printer kerak bo'lsa
        Printer printer = new SimplePrinter();
        printer.print(doc);
        
        // Printer va scanner kerak bo'lsa
        PrintScanDevice printScan = new PrintScanDevice();
        printScan.print(doc);
        printScan.scan(doc);
        
        // Barcha funksiyalar kerak bo'lsa
        MultiFunctionMachine mfm = new MultiFunctionMachine();
        mfm.print(doc);
        mfm.scan(doc);
        mfm.fax(doc);
        mfm.copy(doc);
    }
}
```

### Dependency Inversion Principle (Bog'liqlik Inversiyasi Prinsipi)

**"Yuqori darajadagi modullar past darajadagi modullarga bog'liq bo'lmasligi kerak; ikkalasi ham abstraksiyalarga bog'liq bo'lishi kerak."**

#### DIP bilan Yaxshi Amaliyot

```java
package solid.with.dip;

/**
 * Abstraksiyalar (interfeyslar)
 */

// Notification interfeysi
public interface Notification {
    void send(String message);
}

// Logger interfeysi
public interface Logger {
    void log(String message);
}

// MessageService interfeysi
public interface MessageService {
    void sendMessage(String recipient, String message);
}

/**
 * Past darajadagi modullar - konkret implementatsiyalar
 */

// Email notification
public class EmailNotification implements Notification {
    @Override
    public void send(String message) {
        System.out.println("Sending email: " + message);
    }
}

// SMS notification
public class SMSNotification implements Notification {
    @Override
    public void send(String message) {
        System.out.println("Sending SMS: " + message);
    }
}

// Console logger
public class ConsoleLogger implements Logger {
    @Override
    public void log(String message) {
        System.out.println("LOG: " + message);
    }
}

// File logger
public class FileLogger implements Logger {
    @Override
    public void log(String message) {
        System.out.println("Writing to file: " + message);
    }
}

/**
 * Yuqori darajadagi modul - abstraksiyalarga bog'liq
 */
public class OrderService {
    private final Notification notification;
    private final Logger logger;
    
    // Dependency injection - konstruktor orqali
    public OrderService(Notification notification, Logger logger) {
        this.notification = notification;
        this.logger = logger;
    }
    
    public void placeOrder(String orderId, String customerEmail) {
        // Business logic
        logger.log("Placing order: " + orderId);
        
        // Notification
        String message = "Your order " + orderId + " has been placed successfully";
        notification.send(message);
        
        logger.log("Order placed and notification sent");
    }
}

/**
 * NotificationService - yana bir yuqori darajadagi modul
 */
public class NotificationService {
    private final MessageService messageService;
    private final Logger logger;
    
    public NotificationService(MessageService messageService, Logger logger) {
        this.messageService = messageService;
        this.logger = logger;
    }
    
    public void notifyUser(String userId, String message) {
        logger.log("Notifying user: " + userId);
        messageService.sendMessage(userId, message);
        logger.log("Notification sent to user: " + userId);
    }
}

/**
 * MessageService implementatsiyasi
 */
public class EmailMessageService implements MessageService {
    @Override
    public void sendMessage(String recipient, String message) {
        System.out.println("Sending email to " + recipient + ": " + message);
    }
}

/**
 * Factory pattern - dependency'lar yaratish
 */
public class ServiceFactory {
    public static Notification createNotification(String type) {
        switch (type.toLowerCase()) {
            case "email": return new EmailNotification();
            case "sms": return new SMSNotification();
            default: throw new IllegalArgumentException("Unknown notification type: " + type);
        }
    }
    
    public static Logger createLogger(String type) {
        switch (type.toLowerCase()) {
            case "console": return new ConsoleLogger();
            case "file": return new FileLogger();
            default: throw new IllegalArgumentException("Unknown logger type: " + type);
        }
    }
    
    public static MessageService createMessageService(String type) {
        switch (type.toLowerCase()) {
            case "email": return new EmailMessageService();
            // Boshqa message service turlari...
            default: throw new IllegalArgumentException("Unknown message service type: " + type);
        }
    }
}

/**
 * Asosiy dastur - dependency injection
 */
public class Main {
    public static void main(String[] args) {
        // Konfiguratsiya - bu yerda qaysi implementatsiyalarni ishlatishni belgilaymiz
        Notification emailNotification = ServiceFactory.createNotification("email");
        Logger consoleLogger = ServiceFactory.createLogger("console");
        
        // OrderService - abstraksiyalarga bog'liq
        OrderService orderService = new OrderService(emailNotification, consoleLogger);
        orderService.placeOrder("ORD123", "customer@example.com");
        
        // Boshqa konfiguratsiya
        Notification smsNotification = ServiceFactory.createNotification("sms");
        Logger fileLogger = ServiceFactory.createLogger("file");
        MessageService emailService = ServiceFactory.createMessageService("email");
        
        NotificationService notificationService = new NotificationService(emailService, fileLogger);
        notificationService.notifyUser("user123", "Welcome to our service!");
        
        // Unit test uchun mock object'lar
        Notification mockNotification = new Notification() {
            @Override
            public void send(String message) {
                // Test logikasi
            }
        };
        
        Logger mockLogger = new Logger() {
            @Override
            public void log(String message) {
                // Test logikasi
            }
        };
        
        // Test uchun service
        OrderService testService = new OrderService(mockNotification, mockLogger);
        // Test method'lari...
    }
}
```

## Amaliy Maslahatlar

### Collections Algorithms:
1. **Collections.sort()** - O(n log n) time complexity
2. **Collections.binarySearch()** - Faqat tartiblangan list'lar uchun, O(log n)
3. **Collections.shuffle()** - Tasodifiy tartib, Fisher-Yates algoritmi
4. **Collections.frequency()** - Linear search, O(n)

### Optional:
1. **Null o'rniga Optional ishlating** - Aniqlik va xavfsizlik uchun
2. **get() dan oldin tekshiring** - isPresent() yoki boshqa method'lar bilan
3. **Method chain qiling** - map(), filter(), flatMap() bilan
4. **Field sifatida ishlatmang** - faqat return type sifatida

### SOLID:
1. **SRP** - Har bir class faqat bitta vazifani bajarishi
2. **OCP** - Kengaytirish mumkin, o'zgartirish mumkin emas
3. **LSP** - Subclass'lar superclass'ni to'liq almashtira olishi
4. **ISP** - Kichik, maqsadli interfeyslar
5. **DIP** - Abstraksiyalarga bog'lanish, konkret implementatsiyalarga emas

---

**Keyingi mavzu:** [13_Legacy_Collections.md](./13_Legacy_Collections.md)

**Oldingi mavzu:** [11_Iterator_ListIterator.md](./11_Iterator_ListIterator.md)

**Asosiy sahifaga qaytish:** [README.md](../README.md)

---

**Muhim Atamalar:**
- **Collections Algorithms** - Standart kutubxonadagi foydali algoritmlar
- **Optional** - Null qiymat muammosini hal qilish
- **SOLID** - Ob'ektga yo'naltirilgan dizayn prinsiplari
- **Binary Search** - Ikkilik qidiruv algoritmi
- **Dependency Injection** - Bog'liqlik in'ektsiyasi
- **Immutable Collections** - O'zgarmas kolleksiyalar

> **Bolalar, o'rganishda davom etamiz!** 🚀