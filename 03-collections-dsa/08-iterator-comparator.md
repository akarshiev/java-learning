# Views, Unmodifiable Collections va Clone

## Views (Ko'rinishlar)

**View** - bu Java Collections Framework'dagi engil vaznli ob'ekt bo'lib, Collection yoki Map interface'ini implement qiladi, lekin an'anaviy ma'noda haqiqiy kolleksiya emas. Aslida, view ob'ektlarni ichida saqlamaydi, balki boshqa kolleksiyaga, array'ga yoki bitta ob'ektga referens qiladi va foydalanuvchiga ma'lumot taqdim etish uchun undan foydalanadi.

## View Turlari

1. **View of empty object** - Bo'sh ob'ekt ko'rinishi
2. **View of a single object** - Bitta ob'ekt ko'rinishi
3. **View of an array** - Array ko'rinishi
4. **View of a portion of a collection** - Kolleksiyaning qismi ko'rinishi
5. **Unmodifiable views** - O'zgartirib bo'lmaydigan ko'rinishlar
6. **Synchronized views** - Sinxronlashtirilgan ko'rinishlar

## Empty Views (Bo'sh Ko'rinishlar)

Bu turdagi bo'sh kolleksiyalar juda qulay, agar ba'zi API kolleksiya talab qilsa, lekin qandaydir sababga ko'ra biz u erga hech qanday ob'ekt o'tkazmoqchi bo'lmasak.

Qaytarilgan instance aslida **immutable** (o'zgarmas), shuning uchun unga element qo'shish harakati exception keltirib chiqaradi.

### Bo'sh Ko'rinish Method'lari

```java
// Bo'sh list yaratish
List<T> emptyList = Collections.emptyList();

// Bo'sh set yaratish
Set<T> emptySet = Collections.emptySet();

// Bo'sh map yaratish
Map<K, V> emptyMap = Collections.emptyMap();

// Java 9+ - factory method'lar
List<String> list = List.of();
Set<Integer> set = Set.of();
Map<String, String> map = Map.of();
```

### EmptyViewTest

```java
package collectionsframework.views;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Empty views misollari - bo'sh kolleksiyalar ko'rinishlari
 */
public class EmptyViewTest {
    
    public static void main(String[] args) {
        System.out.println("========== EMPTY VIEWS ==========");
        
        // 1. Collections.emptyX() method'lari
        List<String> emptyList = Collections.emptyList();
        Set<Integer> emptySet = Collections.emptySet();
        Map<String, String> emptyMap = Collections.emptyMap();
        
        System.out.println("Empty List: " + emptyList);
        System.out.println("Empty Set: " + emptySet);
        System.out.println("Empty Map: " + emptyMap);
        
        // 2. Bo'sh ArrayList vs Collections.emptyList() farqi
        List<String> arrayListEmpty = new ArrayList<>();
        List<String> collectionsEmpty = Collections.emptyList();
        
        System.out.println("\nComparison:");
        System.out.println("ArrayList.isEmpty(): " + arrayListEmpty.isEmpty());
        System.out.println("Collections.emptyList().isEmpty(): " + collectionsEmpty.isEmpty());
        
        // 3. Amaliy foydalanish
        System.out.println("\nPractical use - method with optional list parameter:");
        registerUser("Akbar Akbarov", Collections.emptyList());
        registerUser("Asliddin Abdullayev", List.of("Programming", "Reading"));
        
        // 4. Immutable ekanligini tekshirish
        try {
            emptyList.add("Java");  // UnsupportedOperationException
        } catch (UnsupportedOperationException e) {
            System.out.println("\nCannot add to emptyList - UnsupportedOperationException");
        }
        
        // 5. Java 9+ factory method'lar
        System.out.println("\nJava 9+ factory methods:");
        List<String> modernEmptyList = List.of();
        Set<Integer> modernEmptySet = Set.of();
        Map<String, String> modernEmptyMap = Map.of();
        
        System.out.println("List.of(): " + modernEmptyList);
        System.out.println("Set.of(): " + modernEmptySet);
        System.out.println("Map.of(): " + modernEmptyMap);
    }
    
    /**
     * Foydalanuvchini ro'yxatdan o'tkazish - hobbies ixtiyoriy parameter
     * @param fullName foydalanuvchi ismi
     * @param hobbies hobbiylar ro'yxati (bo'sh bo'lishi mumkin)
     */
    static void registerUser(String fullName, List<String> hobbies) {
        System.out.printf("Registering user: %s%n", fullName);
        
        if (hobbies.isEmpty()) {
            System.out.println("  No hobbies provided");
        } else {
            System.out.println("  Hobbies: " + String.join(", ", hobbies));
        }
        System.out.println();
    }
}
```

## View of a Single Object (Bitta Ob'ekt Ko'rinishi)

Ko'pincha bizga faqat bitta elementli kolleksiya kerak bo'ladi. Buni view'lar yordamida amalga oshirish juda oson. Yaratilgan kolleksiyalar bo'sh view'larga o'xshab immutable (o'zgarmas) bo'ladi. View'lar oddiy kolleksiyalarga qaraganda kamroq xotira talab qiladi va yaratish osonroq.

### Bitta Ob'ekt Ko'rinish Method'lari

```java
// Bitta elementli list
List<T> singletonList = Collections.singletonList(element);

// Bitta elementli set
Set<T> singletonSet = Collections.singleton(element);

// Bitta elementli map
Map<K, V> singletonMap = Collections.singletonMap(key, value);

// Bir necha nusxali list
List<T> nCopies = Collections.nCopies(n, element);
```

### SingletonViewTest

```java
package collectionsframework.views;

import java.util.*;

/**
 * Singleton views - bitta elementli kolleksiyalar ko'rinishlari
 */
public class SingletonViewTest {
    
    public static void main(String[] args) {
        System.out.println("========== SINGLETON VIEWS ==========");
        
        // 1. singletonList() - bitta elementli immutable list
        List<String> singleLanguage = Collections.singletonList("Java");
        System.out.println("Singleton List: " + singleLanguage);
        System.out.println("Size: " + singleLanguage.size());
        
        // 2. singleton() - bitta elementli immutable set
        Set<String> singleSet = Collections.singleton("Java");
        System.out.println("\nSingleton Set: " + singleSet);
        
        // 3. singletonMap() - bitta elementli immutable map
        Map<String, String> singleMap = Collections.singletonMap("hello", "Assalom alekum");
        System.out.println("\nSingleton Map: " + singleMap);
        
        // 4. nCopies() - bir xil elementning n ta nusxasidan iborat list
        List<String> multipleCopies = Collections.nCopies(4, "Java");
        System.out.println("\n4 copies of 'Java': " + multipleCopies);
        
        // 5. Amaliy foydalanish
        System.out.println("\nPractical examples:");
        
        // Method'ga faqat bitta elementli kolleksiya o'tkazish
        printLanguages(Collections.singletonList("Java"));
        printLanguages(List.of("Java", "Python", "C++"));
        
        // 6. Immutable ekanligini tekshirish
        System.out.println("\nTesting immutability:");
        try {
            singleLanguage.add("Python");  // UnsupportedOperationException
        } catch (UnsupportedOperationException e) {
            System.out.println("Cannot add to singletonList - UnsupportedOperationException");
        }
        
        try {
            singleSet.add("Python");  // UnsupportedOperationException
        } catch (UnsupportedOperationException e) {
            System.out.println("Cannot add to singletonSet - UnsupportedOperationException");
        }
        
        // 7. nCopies() bilan ishlash
        System.out.println("\nWorking with nCopies:");
        List<String> students = Collections.nCopies(3, "Student");
        System.out.println("Students: " + students);
        
        // nCopies() dan ArrayList yaratish
        List<String> mutableList = new ArrayList<>(Collections.nCopies(5, "Default"));
        mutableList.add("Extra");  // Endi mutable
        System.out.println("Mutable list from nCopies: " + mutableList);
        
        // 8. Singleton vs Regular Collection farqi
        System.out.println("\nSingleton vs Regular Collection:");
        List<String> singleton = Collections.singletonList("Java");
        List<String> regular = new ArrayList<>();
        regular.add("Java");
        
        System.out.println("Singleton list: " + singleton + " (immutable)");
        System.out.println("Regular list: " + regular + " (mutable)");
        System.out.println("Singleton uses less memory and is faster to create");
    }
    
    /**
     * Tillarni chiqarish - list parameter qabul qiladi
     * @param languages tillar ro'yxati
     */
    static void printLanguages(List<String> languages) {
        System.out.println("Languages: " + String.join(", ", languages));
    }
}
```

## View of an Array (Array Ko'rinishi)

Agar siz hech qachon array'dan elementlarni list'ga o'tkazishingiz kerak bo'lmasa, `Arrays.asList()` method'ini qadrlaysiz. Bu method array asosida list view yaratadi.

Ko'rinadigan sabablarga ko'ra, qaytarilgan kolleksiya immutable (o'zgarmas), ya'ni undan element qo'shish yoki olib tashlash mumkin emas. Lekin `get()` yoki `set()` method'lari yordamida view ichidagi elementlarni o'zgartirish mumkin.

Java 5'dan boshlab `asList()` method'ida varargs'ni ishlatish mumkin.

### Array View Method'lari

```java
// Array'dan list view yaratish
List<T> arrayView = Arrays.asList(array);

// Varargs bilan
List<T> list = Arrays.asList(element1, element2, element3);

// Java 9+ List.of() - immutable list
List<T> immutableList = List.of(elements...);
```

### ArrayViewTest

```java
package collectionsframework.views;

import java.util.*;

/**
 * Array views - array asosidagi kolleksiyalar ko'rinishlari
 */
public class ArrayViewTest {
    
    public static void main(String[] args) {
        System.out.println("========== ARRAY VIEWS ==========");
        
        // 1. Array'dan List view yaratish (Arrays.asList())
        System.out.println("1. Arrays.asList() with array:");
        int[] primitiveArray = {2, 3, 4, 5, 6, 12, 324};
        
        // Not: primitive array bilan to'g'ridan-to'g'ri ishlamaydi
        // Quyidagi noto'g'ri: List<Integer> numbers = Arrays.asList(primitiveArray);
        
        // To'g'ri usul:
        Integer[] objectArray = {2, 3, 4, 5, 6, 12, 324, 5, 6, 890};
        List<Integer> numbers = Arrays.asList(objectArray);
        System.out.println("Array view: " + numbers);
        System.out.println("Size: " + numbers.size());
        
        // 2. Arrays.asList() with varargs
        System.out.println("\n2. Arrays.asList() with varargs:");
        List<String> languagesVarargs = Arrays.asList("Java", "Scala", "Groovy", "Kotlin", "GO");
        System.out.println("Languages: " + languagesVarargs);
        
        // 3. Java 9+ List.of() - immutable list
        System.out.println("\n3. Java 9+ List.of():");
        List<String> modernList = List.of("Java", "Scala", "Groovy", "Kotlin", "GO");
        System.out.println("Immutable list: " + modernList);
        
        // 4. Set.of() va Map.of()
        System.out.println("\n4. Set.of() and Map.of():");
        Set<String> languagesSet = Set.of("Java", "Scala", "Groovy");
        Map<String, String> dict = Map.of(
            "hello", "Assalom Alekum",
            "bye", "Xayr"
        );
        System.out.println("Immutable set: " + languagesSet);
        System.out.println("Immutable map: " + dict);
        
        // 5. subList() - listning qismi ko'rinishi
        System.out.println("\n5. subList() - portion view:");
        List<String> subList = languagesVarargs.subList(1, 4);
        System.out.println("Original: " + languagesVarargs);
        System.out.println("SubList (1,4): " + subList);
        
        // 6. Array view o'zgartirishlari
        System.out.println("\n6. Modifying array view:");
        System.out.println("Before modification: " + numbers);
        
        // Array view elementlarini o'zgartirish mumkin
        numbers.set(0, 100);
        System.out.println("After numbers.set(0, 100): " + numbers);
        
        // Asl array ham o'zgaradi!
        System.out.println("Original array after modification: " + Arrays.toString(objectArray));
        
        // 7. Array view cheklovlari
        System.out.println("\n7. Limitations of array view:");
        System.out.println("Arrays.asList() creates a fixed-size list backed by the array");
        
        try {
            numbers.add(999);  // UnsupportedOperationException
        } catch (UnsupportedOperationException e) {
            System.out.println("Cannot add to array-backed list - UnsupportedOperationException");
        }
        
        try {
            numbers.remove(0);  // UnsupportedOperationException
        } catch (UnsupportedOperationException e) {
            System.out.println("Cannot remove from array-backed list - UnsupportedOperationException");
        }
        
        // 8. ArrayList ga o'tkazish
        System.out.println("\n8. Converting array view to ArrayList:");
        List<Integer> mutableList = new ArrayList<>(numbers);
        mutableList.add(999);  // Endi mumkin
        System.out.println("Mutable ArrayList: " + mutableList);
        
        // 9. Performance comparison
        System.out.println("\n9. Performance considerations:");
        System.out.println("Arrays.asList() - O(1) creation time, backed by array");
        System.out.println("new ArrayList<>(Arrays.asList(...)) - O(n) creation time, independent copy");
        System.out.println("List.of() - O(n) creation time, truly immutable");
    }
}
```

## View of a Portion of a Collection (Kolleksiyaning Qismi Ko'rinishi)

Qaytarilgan qism ko'rinishi original listning berilgan index'lar oralig'idagi elementlarini o'z ichiga oladi. View mutable (o'zgartirilishi mumkin) bo'lgani uchun view'dagi har qanday o'zgarish original list'ga ham ta'sir qiladi.

### `subList()` Method'i

```java
// Listning qismini ko'rinishi
List<E> subList = list.subList(fromIndex, toIndex);
```

## Unmodifiable Views (O'zgartirib Bo'lmaydigan Ko'rinishlar)

Collections class'i ko'pgina kolleksiya turlari uchun immutable view yaratish method'larini taqdim etadi.

```java
// O'zgartirib bo'lmaydigan view'lar yaratish
List<T> unmodifiableList = Collections.unmodifiableList(list);
Map<K, V> unmodifiableMap = Collections.unmodifiableMap(map);
Set<T> unmodifiableSet = Collections.unmodifiableSet(set);

// Sorted kolleksiyalar uchun
SortedMap<K, V> unmodifiableSortedMap = Collections.unmodifiableSortedMap(sortedMap);
SortedSet<T> unmodifiableSortedSet = Collections.unmodifiableSortedSet(sortedSet);
```

Agar kimdir view'dan element qo'shish yoki olib tashlamoqchi bo'lsa, exception chiqadi. Bu xatti-harakat berilgan method kolleksiyani o'zgartirmasligini ta'minlash uchun juda foydalidir. Biroq, kolleksiya ichidagi elementlarni o'zgartirish hali ham mumkin.

O'zgartirib bo'lmaydigan view yaratish original kolleksiyani o'zgartirib bo'lmaydigan qilmaydi. Uni original referens yordamida o'zgartirish hali ham mumkin.

### UnmodifiableViewTest

```java
package collectionsframework.views;

import java.util.*;

/**
 * Unmodifiable views - o'zgartirib bo'lmaydigan kolleksiyalar ko'rinishlari
 */
public class UnmodifiableViewTest {
    
    public static void main(String[] args) {
        System.out.println("========== UNMODIFIABLE VIEWS ==========");
        
        // 1. O'zgartirib bo'lmaydigan list yaratish
        ArrayList<Student> students = new ArrayList<>();
        students.add(new Student(23, "Akbarov Akbar"));
        students.add(new Student(21, "Abdullayev Asliddin"));
        students.add(new Student(32, "Komilov NurIslom"));
        
        List<Student> unmodifiableList = Collections.unmodifiableList(students);
        
        System.out.println("Original list: " + students);
        System.out.println("Unmodifiable view: " + unmodifiableList);
        
        // 2. Unmodifiable view'ni o'zgartirishga urinish
        System.out.println("\n2. Trying to modify unmodifiable view:");
        try {
            // List strukturasini o'zgartirishga urinish
            unmodifiableList.add(new Student(25, "Elmurodov Javohir"));  // UnsupportedOperationException
        } catch (UnsupportedOperationException e) {
            System.out.println("Cannot add to unmodifiable list - UnsupportedOperationException");
        }
        
        try {
            // Elementni almashtirishga urinish
            unmodifiableList.set(0, new Student(32, "Elmurodov Javohir"));  // UnsupportedOperationException
        } catch (UnsupportedOperationException e) {
            System.out.println("Cannot set element in unmodifiable list - UnsupportedOperationException");
        }
        
        try {
            // Element o'chirishga urinish
            unmodifiableList.remove(0);  // UnsupportedOperationException
        } catch (UnsupportedOperationException e) {
            System.out.println("Cannot remove from unmodifiable list - UnsupportedOperationException");
        }
        
        // 3. Element ichidagi ma'lumotlarni o'zgartirish mumkin
        System.out.println("\n3. Modifying elements inside the view:");
        System.out.println("Before modifying student: " + unmodifiableList.get(0));
        
        // Elementning o'zini o'zgartirish mumkin (chunki Student mutable)
        unmodifiableList.get(0).fullName = "Elmurodov Javohir";
        unmodifiableList.get(0).age = 32;
        
        System.out.println("After modifying student: " + unmodifiableList.get(0));
        System.out.println("Original list also changed: " + students.get(0));
        
        // 4. Original listni o'zgartirish mumkin
        System.out.println("\n4. Modifying original list:");
        students.add(new Student(28, "Yusupov Sardor"));
        System.out.println("Added to original list - new size: " + students.size());
        System.out.println("Unmodifiable view also updated - new size: " + unmodifiableList.size());
        
        // 5. Immutable elementlar bilan ishlash
        System.out.println("\n5. Working with immutable elements:");
        List<String> mutableStrings = new ArrayList<>();
        mutableStrings.add("Java");
        mutableStrings.add("Python");
        
        List<String> unmodifiableStrings = Collections.unmodifiableList(mutableStrings);
        System.out.println("Unmodifiable strings: " + unmodifiableStrings);
        
        // String immutable bo'lgani uchun, elementlarni o'zgartirish mumkin emas
        // unmodifiableStrings.set(0, "JavaScript");  // UnsupportedOperationException
        
        // 6. Deep unmodifiable yaratish
        System.out.println("\n6. Deep unmodifiable collections:");
        List<List<String>> nestedList = new ArrayList<>();
        nestedList.add(new ArrayList<>(List.of("A", "B")));
        nestedList.add(new ArrayList<>(List.of("C", "D")));
        
        List<List<String>> shallowUnmodifiable = Collections.unmodifiableList(nestedList);
        System.out.println("Shallow unmodifiable: " + shallowUnmodifiable);
        
        // Ichki listlarni o'zgartirish mumkin
        shallowUnmodifiable.get(0).add("E");
        System.out.println("After modifying inner list: " + shallowUnmodifiable);
        
        // 7. Boshqa unmodifiable method'lar
        System.out.println("\n7. Other unmodifiable methods:");
        Set<Integer> set = new HashSet<>(Set.of(1, 2, 3));
        Map<String, Integer> map = new HashMap<>(Map.of("A", 1, "B", 2));
        
        Set<Integer> unmodifiableSet = Collections.unmodifiableSet(set);
        Map<String, Integer> unmodifiableMap = Collections.unmodifiableMap(map);
        
        System.out.println("Unmodifiable set: " + unmodifiableSet);
        System.out.println("Unmodifiable map: " + unmodifiableMap);
        
        // 8. Java 9+ immutable collections
        System.out.println("\n8. Java 9+ truly immutable collections:");
        List<String> trulyImmutable = List.of("Java", "Python", "C++");
        System.out.println("Truly immutable list: " + trulyImmutable);
        
        try {
            // Bu ham exception beradi
            ((List<String>) trulyImmutable).set(0, "JavaScript");
        } catch (Exception e) {
            System.out.println("Cannot modify List.of() result - " + e.getClass().getSimpleName());
        }
    }
    
    /**
     * Student class - mutable (o'zgartirilishi mumkin) ob'ekt
     */
    static class Student {
        int age;
        String fullName;
        
        public Student(int age, String fullName) {
            this.age = age;
            this.fullName = fullName;
        }
        
        @Override
        public String toString() {
            return String.format("Student{age=%d, fullName='%s'}", age, fullName);
        }
    }
}
```

## Synchronized Views (Sinxronlashtirilgan Ko'rinishlar)

Sinxronlashtirilgan view'ning har bir method'i synchronized bo'lib, view'ni thread-safe qiladi. Albatta, siz original kolleksiyaga referensni saqlamasligingiz yoki ishlatmasligingiz kerak, chunki bu unga sinxronlashtirilmagan kirish imkonini beradi.

### Sinxronlashtirilgan View Method'lari

```java
// Sinxronlashtirilgan kolleksiyalar yaratish
Collection<T> synchronizedCollection = Collections.synchronizedCollection(collection);
List<T> synchronizedList = Collections.synchronizedList(list);
Map<K, V> synchronizedMap = Collections.synchronizedMap(map);
Set<T> synchronizedSet = Collections.synchronizedSet(set);

// Sorted kolleksiyalar uchun
SortedMap<K, V> synchronizedSortedMap = Collections.synchronizedSortedMap(sortedMap);
SortedSet<T> synchronizedSortedSet = Collections.synchronizedSortedSet(sortedSet);
```

## Shallow Copy & Deep Copy (Yuzaki Nusxa va Chuqur Nusxa)

### Copy Object (Ob'ekt Nusxasi)

Ob'ektga yo'naltirilgan dasturlashda, ob'ekt nusxasi - bu mavjud ob'ektning nusxasini yaratish, natijada olingan ob'ekt original ob'ektning nusxasi deb ataladi. Ob'ektni nusxalashning bir necha usullari mavjud, ko'pincha copy constructor yoki cloning orqali. Biz Cloning ni "ob'ektning nusxasini yaratish" deb ta'riflashimiz mumkin.

### Shallow Copy (Yuzaki Nusxa)

Har qachon biz clone method'ining default implementatsiyasidan foydalansak, ob'ektning shallow copy (yuzaki nusxasini) olamiz, ya'ni u yangi instance yaratadi va ob'ektning barcha field'larini yangi instance'ga ko'chiradi va uni ob'ekt turi sifatida qaytaradi, biz uni original ob'ektimizga aniq cast qilishimiz kerak. Bu ob'ektning shallow copy'sidir.

Ob'ekt class'ining `clone()` method'i ob'ektning shallow copy'sini qo'llab-quvvatlaydi. Agar ob'ekt primitive hamda non-primitive yoki reference type o'zgaruvchilarni o'z ichiga olsa, shallow copy'da cloned ob'ekt ham original ob'ekt ishora qilgan bir xil ob'ektga ishora qiladi, chunki faqat ob'ekt referenslari ko'chiriladi va referens qilingan ob'ektlarning o'zlari emas.

Shuning uchun Java'da shallow copy yoki shallow cloning nomi. Agar faqat primitive type field'lar yoki Immutable ob'ektlar bo'lsa, Java'da shallow va deep copy o'rtasida farq yo'q.

### Deep Copy (Chuqur Nusxa)

Har qachon biz default implementatsiyani emas, balki o'zimizning nusxamizga ehtiyoj sezsak, biz uni deep copy deb ataymiz, har qachon biz ob'ektning deep copy'siga muhtoj bo'lsak, biz o'z ehtiyojimizga mos ravishda amalga oshirishimiz kerak.

Shuning uchun deep copy uchun biz barcha member class'lar ham Cloneable interface'ini implement qilishini va ob'ekt class'ining `clone()` method'ini override qilishini ta'minlashimiz kerak.

## Clone Amaliyotda

### Address Class'i

```java
package copy;

import java.util.ArrayList;
import java.util.List;

/**
 * Address class - Cloneable ni implement qiladi
 */
public class Address implements Cloneable {
    private String region;
    private String streetName;
    private int apartmentNumber;
    private List<Integer> postalCodes = new ArrayList<>();
    
    public Address(String region, String streetName, int apartmentNumber, List<Integer> postalCodes) {
        this.region = region;
        this.streetName = streetName;
        this.apartmentNumber = apartmentNumber;
        this.postalCodes = postalCodes;
    }
    
    // Getter va Setter method'lari
    public String getRegion() {
        return region;
    }
    
    public void setRegion(String region) {
        this.region = region;
    }
    
    public String getStreetName() {
        return streetName;
    }
    
    public void setStreetName(String streetName) {
        this.streetName = streetName;
    }
    
    public int getApartmentNumber() {
        return apartmentNumber;
    }
    
    public void setApartmentNumber(int apartmentNumber) {
        this.apartmentNumber = apartmentNumber;
    }
    
    public List<Integer> getPostalCodes() {
        return postalCodes;
    }
    
    public void setPostalCodes(List<Integer> postalCodes) {
        this.postalCodes = postalCodes;
    }
    
    /**
     * Deep clone implementatsiyasi
     */
    @Override
    public Object clone() throws CloneNotSupportedException {
        // 1. Super class'ning clone() method'ini chaqirish (shallow copy)
        Address cloned = (Address) super.clone();
        
        // 2. Mutable field'larni deep copy qilish
        List<Integer> clonedPostalCodes = new ArrayList<>(this.postalCodes);
        cloned.postalCodes = clonedPostalCodes;
        
        return cloned;
    }
    
    @Override
    public String toString() {
        return String.format("Address{region='%s', street='%s', apt=%d, postalCodes=%s}",
                           region, streetName, apartmentNumber, postalCodes);
    }
}
```

### Student Class'i

```java
package copy;

/**
 * Student class - Cloneable ni implement qiladi
 */
public class Student implements Cloneable {
    private String fullName;
    private int age;
    private Address address;  // Reference type - deep copy kerak
    
    // Copy constructor
    public Student(Student other) {
        this.fullName = other.fullName;
        this.age = other.age;
        
        // Address uchun shallow copy (muammo!)
        // this.address = other.address;
        
        // Address uchun deep copy kerak
        if (other.address != null) {
            try {
                this.address = (Address) other.address.clone();
            } catch (CloneNotSupportedException e) {
                throw new RuntimeException("Failed to clone address", e);
            }
        }
    }
    
    // Asosiy constructor
    public Student(String fullName, int age, Address address) {
        this.fullName = fullName;
        this.age = age;
        this.address = address;
    }
    
    /**
     * Deep clone implementatsiyasi
     */
    @Override
    public Object clone() throws CloneNotSupportedException {
        // 1. Super class'ning clone() method'ini chaqirish (shallow copy)
        Student cloned = (Student) super.clone();
        
        // 2. Address ni deep copy qilish
        if (this.address != null) {
            cloned.address = (Address) this.address.clone();
        }
        
        return cloned;
    }
    
    // Getter va Setter method'lari
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public int getAge() {
        return age;
    }
    
    public void setAge(int age) {
        this.age = age;
    }
    
    public Address getAddress() {
        return address;
    }
    
    public void setAddress(Address address) {
        this.address = address;
    }
    
    @Override
    public String toString() {
        return String.format("Student{name='%s', age=%d, address=%s}", 
                           fullName, age, address);
    }
}
```

### CopyConstructor Test

```java
package copy;

import java.util.ArrayList;
import java.util.List;

/**
 * Shallow copy vs Deep copy taqqoslash
 */
public class CopyConstructor {
    
    public static void main(String[] args) {
        System.out.println("========== SHALLOW COPY VS DEEP COPY ==========");
        
        // 1. Original ob'ekt yaratish
        List<Integer> postalCodes = new ArrayList<>();
        postalCodes.add(12345);
        
        Address originalAddress = new Address("Tashkent", "Muhbir", 55, postalCodes);
        Student student1 = new Student("Akbarov Akbar", 23, originalAddress);
        
        System.out.println("Original student:");
        System.out.println("  " + student1);
        
        // 2. Copy constructor bilan nusxa olish (deep copy)
        System.out.println("\n2. Using copy constructor (deep copy):");
        Student student2 = new Student(student1);
        System.out.println("Copied student (copy constructor):");
        System.out.println("  " + student2);
        
        // 3. Clone() method bilan nusxa olish
        System.out.println("\n3. Using clone() method:");
        try {
            Student student3 = (Student) student1.clone();
            System.out.println("Cloned student:");
            System.out.println("  " + student3);
            
            // 4. Originalni o'zgartirish va ta'sirni kuzatish
            System.out.println("\n4. Modifying original object:");
            
            // Primitive field'ni o'zgartirish
            student1.setAge(30);
            
            // Reference type field'ni o'zgartirish
            originalAddress.setRegion("Qashqadaryo");
            postalCodes.set(0, 54321);  // List ichidagi elementni o'zgartirish
            
            System.out.println("After modifying original:");
            System.out.println("  Original: " + student1);
            System.out.println("  Copy constructor: " + student2);
            System.out.println("  Clone: " + student3);
            
            // 5. Yangi postal code qo'shish
            System.out.println("\n5. Adding new postal code:");
            postalCodes.add(99999);
            
            System.out.println("After adding new postal code:");
            System.out.println("  Original postal codes: " + student1.getAddress().getPostalCodes());
            System.out.println("  Copy constructor postal codes: " + student2.getAddress().getPostalCodes());
            System.out.println("  Clone postal codes: " + student3.getAddress().getPostalCodes());
            
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }
        
        // 6. Shallow copy muammosi
        System.out.println("\n6. The problem with shallow copy:");
        System.out.println("In shallow copy:");
        System.out.println("  - Primitive fields are copied");
        System.out.println("  - Object references are copied (not the objects themselves)");
        System.out.println("  - Changes to referenced objects affect both original and copy");
        
        System.out.println("\nIn deep copy:");
        System.out.println("  - Primitive fields are copied");
        System.out.println("  - New objects are created for all reference fields");
        System.out.println("  - Original and copy are completely independent");
        
        // 7. Immutable ob'ektlar bilan ishlash
        System.out.println("\n7. Working with immutable objects:");
        String name = "John";
        String nameCopy = name;  // Shallow copy, lekin muammo yo'q chunki String immutable
        
        name = name + " Doe";  // Yangi String yaratiladi
        System.out.println("Original name: " + name);
        System.out.println("Copied name: " + nameCopy);  // O'zgarmadi
        
        // 8. Clone qilishning boshqa usullari
        System.out.println("\n8. Other ways to create copies:");
        
        // Serialization/Deserialization
        System.out.println("  - Serialization/Deserialization: Deep copy");
        
        // Copy factory methods
        System.out.println("  - Copy factory methods: Depends on implementation");
        
        // Libraries
        System.out.println("  - Apache Commons Lang SerializationUtils.clone()");
        System.out.println("  - Gson/Jackson serialization");
    }
}
```

## Amaliy Maslahatlar

1. **Qachon view ishlatish kerak?**
    - **Empty views**: Bo'sh kolleksiya kerak bo'lganda, null o'rniga
    - **Singleton views**: Bitta elementli kolleksiya kerak bo'lganda
    - **Array views**: Array'ni tezda list ga aylantirish kerak bo'lganda
    - **Unmodifiable views**: Kolleksiyani o'zgartirishni oldini olish kerak bo'lganda
    - **Synchronized views**: Thread-safe kolleksiya kerak bo'lganda

2. **Immutable vs Unmodifiable farqi:**
    - **Immutable**: Hech qanday o'zgartirish mumkin emas
    - **Unmodifiable**: Faqat struktura o'zgartirish mumkin emas, elementlarni o'zgartirish mumkin

3. **Shallow vs Deep copy:**
    - **Shallow copy**: Tezroq, lekin reference'lar bir xil
    - **Deep copy**: Sekinroq, lekin to'liq mustaqil
    - Agar immutable field'lar bo'lsa, shallow copy yetarli

4. **Clone() method'idan foydalanish:**
    - Cloneable interface'ini implement qilish kerak
    - clone() method'ini override qilish kerak
    - Deep copy uchun barcha reference field'lar uchun clone() chaqirish kerak

5. **Thread safety:**
    - Collections.synchronizedX() - method level synchronization
    - Concurrent collections - segment/bucket level synchronization
    - Immutable collections - eng yaxshi thread safety

---

**[Mundarijaga qaytish](../README.md)**

---

**Muhim Atamalar:**
- **View** - Kolleksiyaning engil vaznli ko'rinishi
- **Immutable** - O'zgartirib bo'lmaydigan
- **Unmodifiable** - Strukturasi o'zgartirib bo'lmaydigan
- **Shallow Copy** - Yuzaki nusxa, reference'lar bir xil
- **Deep Copy** - Chuqur nusxa, to'liq mustaqil
- **Cloneable** - Nusxa olish imkoniyatiga ega interface
- **Synchronized** - Thread-safe, sinxronlashtirilgan

> **Bolalar, o'rganishda davom etamiz!** 🚀
---

# Iterator vs ListIterator

## Iterator

**Java Iterator** - bu Java ob'ekt komponentlarining to'plamini birma-bir iteratsiya qilish uchun qo'llaniladigan interface (JDK 1.2'dan boshlab).

Iterator collection elementlarini ketma-ket o'tish uchun standart interfeysni taqdim etadi. U collection elementlarini o'qish, olib tashlash, lekin qo'shish yoki o'zgartirish imkoniyatini bermaydi.

### Iterator Method'lari

1. **hasNext()** - Keyingi element mavjudligini tekshiradi
2. **next()** - Keyingi elementni qaytaradi
3. **remove()** - Oxirgi next() chaqiruvida qaytarilgan elementni o'chiradi
4. **forEachRemaining()** (Java 8+) - Qolgan barcha elementlar uchun harakatni bajaradi

## ListIterator

**ListIterator** - Iterator kabi, ListIterator ham Java Iterator'idir, u List implementatsiya qilingan ob'ektlardan elementlarni birma-bir iteratsiya qilish uchun ishlatiladi (JDK 1.2'dan boshlab).

- Iterator interfeysini kengaytiradi
- Faqat List implementatsiya qilingan class'lar uchun foydalidir
- Iterator'dan farqli o'laroq, u to'rtta operatsiyani qo'llab-quvvatlaydi: CRUD (Create, Read, Update, Delete)
- Iterator'dan farqli o'laroq, u ham Oldinga yo'nalish, ham Orqaga yo'nalish iteratsiyalarini qo'llab-quvvatlaydi

### ListIterator Method'lari

1. **Forward direction:** hasNext(), next(), nextIndex()
2. **Backward direction:** hasPrevious(), previous(), previousIndex()
3. **Modification:** add(), set(), remove()

## Fail-Fast Iterator'lar

Java'dagi Iterator'lar Collection ob'ektlari ustida iteratsiya qilish uchun ishlatiladi. **Fail-Fast iterator'lar** agar collection'da strukturaviy o'zgarish bo'lsa, darhol ConcurrentModificationException chiqaradi. Strukturaviy o'zgarish degani, thread collection ustida iteratsiya qilayotganda collection'dan element qo'shish yoki olib tashlashdir. ArrayList, HashMap class'laridagi Iterator'lar fail-fast Iterator'larga misoldir.

## Fail-Safe Iterator'lar

**Fail-Safe iterator'lar** agar collection iteratsiya qilinayotganda strukturaviy o'zgartirilsa, hech qanday exception chiqarmaydi. Buning sababi, ular original collection emas, balki collection'ning clone'ida ishlaydi va shuning uchun ular fail-safe iterator'lar deb ataladi. CopyOnWriteArrayList, ConcurrentHashMap class'laridagi Iterator'lar fail-safe Iterator'larga misoldir.

# Iterator va ListIterator Amaliyotda

## Custom Counter Iterator

### Counter Class'i (Iterable implementatsiyasi)

```java
package collectionsframework.iterators;

import java.util.Iterator;

/**
 * Counter - Iterable interface'ini implement qilgan counter class'i
 * Berilgan oraliqdagi sonlarni qadam bo'yicha iteratsiya qilish imkonini beradi
 */
public class Counter implements Iterable<Integer> {
    private int min;
    private int max;
    private int step;
    
    /**
     * Constructor - 0 dan max gacha, qadam 1
     * @param max maksimal qiymat
     */
    public Counter(int max) {
        this(0, max, 1);
    }
    
    /**
     * Constructor - 0 dan max gacha, berilgan qadam
     * @param max maksimal qiymat
     * @param step qadam
     */
    public Counter(int max, int step) {
        this(0, max, step);
    }
    
    /**
     * To'liq constructor
     * @param min minimal qiymat
     * @param max maksimal qiymat
     * @param step qadam
     */
    public Counter(int min, int max, int step) {
        if (min >= max) {
            throw new IllegalArgumentException("Min must be less than max");
        }
        if (step <= 0) {
            throw new IllegalArgumentException("Step must be positive");
        }
        
        this.min = min;
        this.max = max;
        this.step = step;
    }
    
    /**
     * Iterator qaytarish - for-each loop uchun
     * @return CounterIterator
     */
    @Override
    public Iterator<Integer> iterator() {
        return new CounterIterator(min, max, step);
    }
    
    /**
     * Counter ma'lumotlarini string ko'rinishida qaytarish
     * @return counter ma'lumotlari
     */
    @Override
    public String toString() {
        return String.format("Counter[min=%d, max=%d, step=%d]", min, max, step);
    }
}
```

### CounterIterator Class'i

```java
package collectionsframework.iterators;

import java.util.Iterator;

/**
 * CounterIterator - Counter uchun iterator implementatsiyasi
 */
public class CounterIterator implements Iterator<Integer> {
    private int min;
    private int max;
    private int step;
    private int current;
    
    /**
     * Constructor - 0 dan max gacha, qadam 1
     * @param max maksimal qiymat
     */
    public CounterIterator(int max) {
        this(0, max, 1);
    }
    
    /**
     * Constructor - 0 dan max gacha, berilgan qadam
     * @param max maksimal qiymat
     * @param step qadam
     */
    public CounterIterator(int max, int step) {
        this(0, max, step);
    }
    
    /**
     * To'liq constructor
     * @param min minimal qiymat
     * @param max maksimal qiymat
     * @param step qadam
     */
    public CounterIterator(int min, int max, int step) {
        this.min = min;
        this.max = max;
        this.step = step;
        this.current = min;
    }
    
    /**
     * Keyingi element mavjudligini tekshirish
     * @return true - agar keyingi element mavjud bo'lsa
     */
    @Override
    public boolean hasNext() {
        return current < max;
    }
    
    /**
     * Keyingi elementni qaytarish
     * @return keyingi son
     * @throws java.util.NoSuchElementException agar element qolmasa
     */
    @Override
    public Integer next() {
        if (!hasNext()) {
            throw new java.util.NoSuchElementException("No more elements");
        }
        
        int value = current;
        current = current + step;
        return value;
    }
    
    /**
     * remove() method'ini override qilish - bu iterator uchun qo'llanilmaydi
     * @throws UnsupportedOperationException har doim
     */
    @Override
    public void remove() {
        throw new UnsupportedOperationException("Remove operation is not supported by CounterIterator");
    }
}
```

### CounterTest

```java
package collectionsframework.iterators;

/**
 * Counter test qilish
 */
public class CounterTest {
    
    public static void main(String[] args) {
        System.out.println("========== CUSTOM COUNTER ITERATOR ==========");
        
        // 1. Oddiy counter (0 dan 10 gacha, qadam 1)
        System.out.println("1. Simple counter (0 to 10, step 1):");
        Counter counter1 = new Counter(10);
        for (Integer num : counter1) {
            System.out.print(num + " ");
        }
        System.out.println("\n");
        
        // 2. Qadam bilan counter
        System.out.println("2. Counter with step 3 (0 to 20):");
        Counter counter2 = new Counter(20, 3);
        for (Integer num : counter2) {
            System.out.print(num + " ");
        }
        System.out.println("\n");
        
        // 3. Min va max bilan counter
        System.out.println("3. Counter from 5 to 50 with step 5:");
        Counter counter3 = new Counter(5, 50, 5);
        System.out.println(counter3);
        
        for (Integer num : counter3) {
            System.out.print(num + " ");
        }
        System.out.println("\n");
        
        // 4. Iterator to'g'ridan-to'g'ri ishlatish
        System.out.println("4. Using iterator directly:");
        Counter counter4 = new Counter(15, 2);
        var iterator = counter4.iterator();
        
        while (iterator.hasNext()) {
            System.out.print(iterator.next() + " ");
        }
        System.out.println("\n");
        
        // 5. forEachRemaining() method'i (Java 8+)
        System.out.println("5. Using forEachRemaining():");
        Counter counter5 = new Counter(8);
        counter5.iterator().forEachRemaining(num -> 
            System.out.print(num + " ")
        );
        System.out.println("\n");
        
        // 6. Iterator xususiyatlari
        System.out.println("6. Iterator characteristics:");
        System.out.println("- Can traverse elements only in forward direction");
        System.out.println("- Can only remove elements (not add or modify)");
        System.out.println("- Must be implemented for custom collections");
        System.out.println("- Used by enhanced for-loop (for-each)");
    }
}
```

## Java Iterator Class Test

```java
package collectionsframework.iterators;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Java standart Iterator sinfidan foydalanish
 */
public class IteratorClassTest {
    
    public static void main(String[] args) {
        System.out.println("========== JAVA STANDARD ITERATOR ==========");
        
        // 1. List yaratish
        List<String> languages = new ArrayList<>();
        languages.add("Java");
        languages.add("Scala");
        languages.add("Kotlin");
        languages.add("Go");
        languages.add("Python");
        languages.add("Groovy");
        
        System.out.println("Original list: " + languages);
        
        // 2. Iterator olish
        Iterator<String> iterator = languages.iterator();
        
        // 3. while loop bilan iteratsiya
        System.out.println("\nIterating with while loop:");
        while (iterator.hasNext()) {
            String language = iterator.next();
            System.out.println("Language: " + language);
            
            // Ma'lum shartga ko'ra elementni o'chirish
            if (language.equals("Go") || language.equals("Python")) {
                iterator.remove();  // Iterator orqali xavfsiz o'chirish
                System.out.println("  Removed: " + language);
            }
        }
        
        System.out.println("\nList after removal: " + languages);
        
        // 4. Yangi iterator yaratish (eski iterator ishlatilmaydi)
        System.out.println("\nCreating new iterator for forEachRemaining:");
        Iterator<String> newIterator = languages.iterator();
        
        // 5. forEachRemaining() method'i (Java 8+)
        System.out.println("Remaining languages:");
        newIterator.forEachRemaining(System.out::println);
        
        // 6. For-each loop bilan iteratsiya (iterator'ni yashirincha ishlatadi)
        System.out.println("\nIterating with enhanced for-loop:");
        for (String language : languages) {
            System.out.println("Language: " + language);
        }
        
        // 7. Iterator'ning cheklovlari
        System.out.println("\n7. Iterator limitations:");
        System.out.println("- Can only move forward");
        System.out.println("- Cannot add elements");
        System.out.println("- Cannot modify elements (except remove)");
        System.out.println("- Cannot get current index");
        
        // 8. ConcurrentModificationException namoyishi
        System.out.println("\n8. Demonstrating ConcurrentModificationException:");
        List<String> demoList = new ArrayList<>(List.of("A", "B", "C", "D"));
        Iterator<String> demoIterator = demoList.iterator();
        
        try {
            while (demoIterator.hasNext()) {
                String element = demoIterator.next();
                System.out.println("Processing: " + element);
                
                if (element.equals("B")) {
                    // Iterator orqali emas, to'g'ridan-to'g'ri list'dan o'chirish
                    demoList.remove(element);  // ConcurrentModificationException!
                }
            }
        } catch (Exception e) {
            System.out.println("Exception caught: " + e.getClass().getSimpleName());
            System.out.println("Message: " + e.getMessage());
        }
        
        // 9. To'g'ri usul - faqat iterator orqali o'chirish
        System.out.println("\n9. Correct way - remove only through iterator:");
        demoList = new ArrayList<>(List.of("A", "B", "C", "D"));
        demoIterator = demoList.iterator();
        
        while (demoIterator.hasNext()) {
            String element = demoIterator.next();
            if (element.equals("B")) {
                demoIterator.remove();  // To'g'ri usul
                System.out.println("Safely removed: " + element);
            }
        }
        System.out.println("List after safe removal: " + demoList);
    }
}
```

## Java ListIterator Class Test

```java
package collectionsframework.iterators;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

/**
 * ListIterator - Iterator'ning kengaytmasi, faqat List'lar uchun
 */
public class ListIteratorClassTest {
    
    public static void main(String[] args) {
        System.out.println("========== JAVA LISTITERATOR ==========");
        
        // 1. List yaratish
        List<String> languages = new ArrayList<>();
        languages.add("Java");
        languages.add("Scala");
        languages.add("Kotlin");
        languages.add("Go");
        languages.add("Python");
        languages.add("Groovy");
        
        System.out.println("Original list: " + languages);
        
        // 2. ListIterator olish (boshidan)
        System.out.println("\n1. Forward iteration from beginning:");
        ListIterator<String> listIterator = languages.listIterator();
        
        while (listIterator.hasNext()) {
            int index = listIterator.nextIndex();
            String language = listIterator.next();
            System.out.printf("Index %d: %s%n", index, language);
        }
        
        // 3. Orqaga iteratsiya
        System.out.println("\n2. Backward iteration from end:");
        while (listIterator.hasPrevious()) {
            int index = listIterator.previousIndex();
            String language = listIterator.previous();
            System.out.printf("Index %d: %s%n", index, language);
        }
        
        // 4. O'rtadan boshlash
        System.out.println("\n3. Starting from specific position (index 2):");
        listIterator = languages.listIterator(2);  // 2-indexdan boshlab
        
        System.out.println("Next element: " + listIterator.next());
        System.out.println("Previous element: " + listIterator.previous());
        
        // 5. Element qo'shish
        System.out.println("\n4. Adding elements with ListIterator:");
        listIterator = languages.listIterator();
        
        while (listIterator.hasNext()) {
            String language = listIterator.next();
            if (language.equals("Kotlin")) {
                listIterator.add("TypeScript");  // "Kotlin" dan oldin qo'shiladi
                System.out.println("Added TypeScript before Kotlin");
            }
        }
        System.out.println("List after adding: " + languages);
        
        // 6. Element o'zgartirish (set)
        System.out.println("\n5. Modifying elements with set():");
        listIterator = languages.listIterator();
        
        while (listIterator.hasNext()) {
            String language = listIterator.next();
            if (language.equals("Go")) {
                listIterator.set("GoLang");  // "Go" ni "GoLang" ga o'zgartiradi
                System.out.println("Changed Go to GoLang");
            }
        }
        System.out.println("List after modification: " + languages);
        
        // 7. Element o'chirish
        System.out.println("\n6. Removing elements:");
        listIterator = languages.listIterator();
        
        while (listIterator.hasNext()) {
            String language = listIterator.next();
            if (language.equals("Python")) {
                listIterator.remove();  // "Python" ni o'chiradi
                System.out.println("Removed Python");
                break;  // Remove'dan keyin next() yoki previous() chaqirish kerak
            }
        }
        System.out.println("List after removal: " + languages);
        
        // 8. CRUD operatsiyalari
        System.out.println("\n7. ListIterator CRUD operations:");
        System.out.println("C (Create) - add() method");
        System.out.println("R (Read) - next(), previous(), nextIndex(), previousIndex()");
        System.out.println("U (Update) - set() method");
        System.out.println("D (Delete) - remove() method");
        
        // 9. ListIterator vs Iterator farqlari
        System.out.println("\n8. ListIterator vs Iterator differences:");
        System.out.println("| Feature           | Iterator | ListIterator |");
        System.out.println("|-------------------|----------|--------------|");
        System.out.println("| Forward traverse  |    ✓     |      ✓       |");
        System.out.println("| Backward traverse |    ✗     |      ✓       |");
        System.out.println("| Add elements      |    ✗     |      ✓       |");
        System.out.println("| Modify elements   |    ✗     |      ✓       |");
        System.out.println("| Get index         |    ✗     |      ✓       |");
        System.out.println("| Works with        | All Coll |  Only List   |");
        
        // 10. Amaliy misol - palindrome tekshirish
        System.out.println("\n9. Practical example - checking palindrome:");
        List<Character> word = new ArrayList<>();
        word.add('r');
        word.add('a');
        word.add('d');
        word.add('a');
        word.add('r');
        
        System.out.println("Word: " + word);
        System.out.println("Is palindrome? " + isPalindrome(word));
    }
    
    /**
     * ListIterator yordamida palindrome tekshirish
     * @param list tekshiriladigan list
     * @return true - agar palindrome bo'lsa
     */
    private static boolean isPalindrome(List<Character> list) {
        ListIterator<Character> forward = list.listIterator();
        ListIterator<Character> backward = list.listIterator(list.size());
        
        while (forward.hasNext() && backward.hasPrevious()) {
            if (forward.nextIndex() >= backward.previousIndex()) {
                break;  // O'rtaga yetib keldik
            }
            
            char front = forward.next();
            char back = backward.previous();
            
            if (front != back) {
                return false;
            }
        }
        return true;
    }
}
```

## Fail-Fast Iterator Test

```java
package collectionsframework.iterators;

import java.util.ArrayList;
import java.util.ConcurrentModificationException;
import java.util.Iterator;
import java.util.List;

/**
 * Fail-Fast iterator - strukturaviy o'zgarishda ConcurrentModificationException
 */
public class FailFastIterator {
    
    public static void main(String[] args) {
        System.out.println("========== FAIL-FAST ITERATOR ==========");
        
        // 1. List yaratish
        List<String> languages = new ArrayList<>();
        languages.add("Java");
        languages.add("Scala");
        languages.add("Kotlin");
        languages.add("Go");
        languages.add("Python");
        languages.add("Groovy");
        
        System.out.println("Original list: " + languages);
        
        // 2. Fail-fast iterator yaratish
        Iterator<String> iterator = languages.iterator();
        
        // 3. Concurrent modification - iterator orqali emas
        System.out.println("\nTrying to modify list while iterating:");
        try {
            while (iterator.hasNext()) {
                String language = iterator.next();
                System.out.println("Processing: " + language);
                
                if (language.equals("Go")) {
                    // Noto'g'ri: iterator orqali emas, to'g'ridan-to'g'ri list'dan o'chirish
                    languages.remove(language);  // ConcurrentModificationException!
                    System.out.println("  Trying to remove directly from list...");
                }
            }
        } catch (ConcurrentModificationException e) {
            System.out.println("Exception caught: " + e.getClass().getSimpleName());
            System.out.println("Message: " + e.getMessage());
        }
        
        // 4. To'g'ri usul - iterator orqali o'chirish
        System.out.println("\nCorrect way - remove through iterator:");
        iterator = languages.iterator();  // Yangi iterator
        
        while (iterator.hasNext()) {
            String language = iterator.next();
            if (language.equals("Python")) {
                iterator.remove();  // To'g'ri usul
                System.out.println("Safely removed: " + language);
            }
        }
        System.out.println("List after safe removal: " + languages);
        
        // 5. For-each loop ham fail-fast
        System.out.println("\nEnhanced for-loop is also fail-fast:");
        languages = new ArrayList<>(List.of("A", "B", "C", "D"));
        
        try {
            for (String element : languages) {
                System.out.println("Processing: " + element);
                if (element.equals("B")) {
                    languages.remove(element);  // ConcurrentModificationException!
                }
            }
        } catch (ConcurrentModificationException e) {
            System.out.println("Enhanced for-loop also threw: " + e.getClass().getSimpleName());
        }
        
        // 6. Fail-fast collection'lar ro'yxati
        System.out.println("\n6. Common fail-fast collections in Java:");
        System.out.println("- ArrayList");
        System.out.println("- HashMap");
        System.out.println("- HashSet");
        System.out.println("- Vector");
        System.out.println("- LinkedList (except ListIterator add/set)");
        
        // 7. Nima uchun fail-fast?
        System.out.println("\n7. Why fail-fast?");
        System.out.println("- Prevents unpredictable behavior");
        System.out.println("- Makes bugs easier to detect");
        System.out.println("- Thread-safety issues in single thread");
        System.out.println("- Modification count (modCount) tracks changes");
    }
}
```

## Fail-Safe Iterator Test

```java
package collectionsframework.iterators;

import java.util.Iterator;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Fail-Safe iterator - strukturaviy o'zgarishda exception chiqarmaydi
 */
public class FailSafeIterator {
    
    public static void main(String[] args) {
        System.out.println("========== FAIL-SAFE ITERATOR ==========");
        
        // 1. CopyOnWriteArrayList yaratish (fail-safe)
        System.out.println("1. CopyOnWriteArrayList (fail-safe list):");
        CopyOnWriteArrayList<String> languages = new CopyOnWriteArrayList<>();
        languages.add("Java");
        languages.add("Scala");
        languages.add("Kotlin");
        languages.add("Go");
        languages.add("Python");
        languages.add("Groovy");
        
        System.out.println("Original list: " + languages);
        
        // 2. Fail-safe iterator yaratish
        Iterator<String> iterator = languages.iterator();
        
        // 3. Iterator davomida list'ni o'zgartirish
        System.out.println("\nModifying list while iterating (fail-safe):");
        while (iterator.hasNext()) {
            String language = iterator.next();
            System.out.println("Processing: " + language);
            
            if (language.equals("Go")) {
                // Iterator orqali emas, to'g'ridan-to'g'ri list'dan o'chirish
                languages.remove(language);  // No ConcurrentModificationException!
                System.out.println("  Removed 'Go' from list");
            }
            
            if (language.equals("Python")) {
                // Yangi element qo'shish
                languages.add("TypeScript");  // No ConcurrentModificationException!
                System.out.println("  Added 'TypeScript' to list");
            }
        }
        
        System.out.println("\nList after modifications: " + languages);
        System.out.println("Notice: Iterator didn't see the new 'TypeScript' element");
        
        // 4. Nima uchun fail-safe?
        System.out.println("\n2. Why fail-safe works:");
        System.out.println("- Iterator works on a snapshot/copy of the collection");
        System.out.println("- Original collection can be modified independently");
        System.out.println("- New iterator will see all modifications");
        
        // 5. Yangi iterator yaratish
        System.out.println("\n3. Creating new iterator after modifications:");
        Iterator<String> newIterator = languages.iterator();
        System.out.println("Elements seen by new iterator:");
        newIterator.forEachRemaining(System.out::println);
        
        // 6. ConcurrentHashMap (fail-safe map)
        System.out.println("\n4. ConcurrentHashMap (fail-safe map):");
        ConcurrentHashMap<Integer, String> concurrentMap = new ConcurrentHashMap<>();
        concurrentMap.put(1, "Java");
        concurrentMap.put(2, "Python");
        concurrentMap.put(3, "C++");
        
        Iterator<Integer> mapIterator = concurrentMap.keySet().iterator();
        
        System.out.println("Original map: " + concurrentMap);
        
        while (mapIterator.hasNext()) {
            Integer key = mapIterator.next();
            System.out.println("Processing key: " + key);
            
            if (key == 2) {
                concurrentMap.put(4, "JavaScript");  // No exception
                System.out.println("  Added new key-value pair");
            }
        }
        
        System.out.println("Map after modifications: " + concurrentMap);
        
        // 7. Fail-safe collection'lar ro'yxati
        System.out.println("\n5. Common fail-safe collections in Java:");
        System.out.println("- CopyOnWriteArrayList");
        System.out.println("- CopyOnWriteArraySet");
        System.out.println("- ConcurrentHashMap");
        System.out.println("- ConcurrentSkipListMap");
        System.out.println("- ConcurrentSkipListSet");
        
        // 8. Fail-fast vs Fail-safe taqqoslash
        System.out.println("\n6. Fail-fast vs Fail-safe comparison:");
        System.out.println("| Aspect              | Fail-Fast                | Fail-Safe                 |");
        System.out.println("|---------------------|--------------------------|---------------------------|");
        System.out.println("| Exception on mod    | Yes (ConcurrentModEx)    | No                        |");
        System.out.println("| Works on            | Original collection      | Copy/snapshot             |");
        System.out.println("| Performance         | Better (no copy)         | Worse (copy overhead)     |");
        System.out.println("| Memory usage        | Less                     | More (copy in memory)     |");
        System.out.println("| Thread safety       | No                       | Yes                       |");
        System.out.println("| Use case            | Single thread            | Concurrent access         |");
        
        // 9. Performance ta'siri
        System.out.println("\n7. Performance considerations:");
        System.out.println("- CopyOnWriteArrayList: Good for rarely modified, frequently read lists");
        System.out.println("- Not suitable for frequently modified lists (copy overhead)");
        System.out.println("- Use when thread safety is required without external synchronization");
    }
}
```

## Amaliy Maslahatlar

1. **Qachon Iterator ishlatish kerak?**
    - Collection elementlarini o'qish va o'chirish uchun
    - For-each loop ishlatilmaydigan holatlarda
    - Concurrent modification'ni boshqarish kerak bo'lganda

2. **Qachon ListIterator ishlatish kerak?**
    - Faqat List'lar bilan ishlaganda
    - Ikkala yo'nalishda harakat qilish kerak bo'lganda
    - Elementlarni qo'shish yoki o'zgartirish kerak bo'lganda
    - Elementning index'ini bilish kerak bo'lganda

3. **Fail-fast vs Fail-safe tanlash:**
    - **Fail-fast**: Single thread, tez performance kerak bo'lsa
    - **Fail-safe**: Multi-thread, thread safety kerak bo'lsa
    - **Fail-safe**: Collection tez-tez o'zgartiriladigan bo'lsa

4. **Iterator patterns:**
    - **Remove through iterator**: Xavfsiz o'chirish usuli
    - **Avoid concurrent modification**: Iterator davomida collection'ni o'zgartirmang
    - **Use new iterator**: Modification'dan keyin yangi iterator oling

5. **Performance considerations:**
    - Iterator'lar for-each loop'ga nisbatan biroz sekinroq
    - ListIterator Iterator'ga nisbatan biroz sekinroq
    - Fail-safe iterator'lar sekinroq (copy overhead)

---

**Keyingi mavzu:** [09 - Collections Algoritmlari](./09-collections-algorithms.md)

**Oldingi mavzu:** [07 - Map Interface](./07-map-interface.md)

**Asosiy sahifaga qaytish:** [README.md](../README.md)

---

**Muhim Atamalar:**
- **Iterator** - Collection elementlarini iteratsiya qilish interfeysi
- **ListIterator** - Iterator'ning List'lar uchun kengaytmasi
- **Fail-Fast** - O'zgarishda exception chiqaradigan iterator
- **Fail-Safe** - O'zgarishda exception chiqarmaydigan iterator
- **ConcurrentModificationException** - Fail-fast iterator'lar chiqaradigan exception
- **modCount** - Modification count, o'zgarishlarni kuzatish
- **Snapshot** - Fail-safe iterator'lar ishlaydigan nusxa

> **Bolalar, o'rganishda davom etamiz!** 🚀