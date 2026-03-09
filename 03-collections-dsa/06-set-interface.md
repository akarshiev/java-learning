# Set Interface va HashSet

## Set Nima?

**Set** - bu Java'da noyob elementlar yoki ob'ektlarning tartibsiz to'plami. Boshqacha qilib aytganda, Set - bu maxsus tartibda saqlanmaydigan elementlar to'plami. Elementlar Set'ga qo'shilganda ular qayerga joylashishi ustida hech qanday nazorat yo'q.

### Set'ning Asosiy Xususiyatlari

1. **Tartibsiz kolleksiya** - Elementlar saqlanganda tartib saqlanmaydi
2. **Noyob elementlar** - Faqat takrorlanmas elementlarni saqlaydi
3. **Map-based struktura** - Map strukturasiga asoslangan
4. **Iterator bilan iteratsiya** - Faqat Iterator yordamida iteratsiya qilish mumkin, ListIterator emas
5. **Null element** - Ko'pchilik Set implementatsiyalari faqat bitta null element qo'shishga ruxsat beradi
6. **Index-based emas** - Elementlarga index orqali murojaat qilib bo'lmaydi
7. **Get methodi yo'q** - List'dan farqli o'laroq get() methodi mavjud emas

## Set Interface Ierarxiyasi

```
Iterable
   |
Collection
   |
  Set
   ├── HashSet
   ├── LinkedHashSet
   └── TreeSet
```

## Java'da Set Ob'ektini Yaratish Usullari

```java
// Generic usulda yaratish
Set<T> set = new HashSet<T>();
Set<T> set = new LinkedHashSet<T>();
Set<T> set = new TreeSet<T>();

// Diamond operator bilan (Java 7+)
Set<String> set1 = new HashSet<>();
Set<Integer> set2 = new LinkedHashSet<>();
Set<Double> set3 = new TreeSet<>();

// Factory method'lar bilan (Java 9+)
Set<String> immutableSet = Set.of("A", "B", "C");
Set<Integer> numbersSet = Set.of(1, 2, 3, 4, 5);
```

## equals() va hashCode() Method'lari

### equals() Method'i

`equals()` va `hashCode()` - bu Object class tomonidan taqdim etilgan ob'ektlarni solishtirish uchun muhim ikkita method.

**equals() method'ining shartlari:**

1. **Refleksivlik (Reflexive):** Har qanday null bo'lmagan x ob'ekti uchun `x.equals(x)` true qaytarishi kerak
2. **Simmetriklik (Symmetric):** Har qanday null bo'lmagan x va y ob'ektlari uchun, agar `x.equals(y)` true bo'lsa, `y.equals(x)` ham true bo'lishi kerak
3. **Tranzitivlik (Transitive):** Har qanday null bo'lmagan x, y, z ob'ektlari uchun, agar `x.equals(y)` true va `y.equals(z)` true bo'lsa, `x.equals(z)` ham true bo'lishi kerak
4. **Izchillik (Consistent):** Har qanday null bo'lmagan x va y ob'ektlari uchun, bir necha marta `x.equals(y)` chaqirilganda har doim true yoki har doim false qaytarishi kerak
5. **Null bilan solishtirish:** Har qanday null bo'lmagan x ob'ekti uchun `x.equals(null)` har doim false qaytarishi kerak

### hashCode() Method'i

HashMap va HashSet ma'lumotlarni boshqarish uchun hashing'dan foydalanadi. Ular hash qiymatlarini tekshirish uchun `hashCode()` method'idan foydalanadi.

**hashCode() method'ining shartlari:**

1. **Ichki izchillik (Internal consistency):** Bir xil ob'ekt bir necha marta `hashCode()` chaqirilganda bir xil qiymat qaytarishi kerak
2. **equals bilan muvofiqlik (equals consistency):** Agar `x.equals(y)` true bo'lsa, `x.hashCode() == y.hashCode()` ham true bo'lishi kerak
3. **To'qnashuv (Collisions):** Agar `x.equals(y)` false bo'lsa, `x.hashCode() == y.hashCode()` bo'lishi shart emas, lekin yaxshi hash funksiya kam to'qnashuv yaratadi

```java
/**
 * Student class - equals() va hashCode() method'larini override qilish misoli
 */
class Student {
    private String name;
    private int id;
    
    public Student(String name, int id) {
        this.name = name;
        this.id = id;
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;  // Refleksivlik
        if (o == null || getClass() != o.getClass()) return false;
        
        Student student = (Student) o;
        return id == student.id && Objects.equals(name, student.name);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(name, id);  // equals bilan muvofiqlik
    }
    
    // Getter va Setter method'lari
    public String getName() { return name; }
    public int getId() { return id; }
}
```

**Muhim Eslatma:** Agar siz `equals()` method'ini override qilsangiz, `hashCode()` method'ini ham override qilishingiz **SHART**. Aks holda, Object class uchun umumiy shart buziladi va hash-based kolleksiyalarda kutilmagan natijalar kelib chiqadi.

## HashSet Class'i

**HashSet** class'i Set interface'ini implement qiladi (JDK 1.2'dan boshlab). U iteration tartibi haqida hech qanday kafolat bermaydi.

### HashSet'ning Asosiy Xususiyatlari

1. **Takrorlanmas elementlar** - Duplicate elementlarni saqlamaydi
2. **Duplikatlarni olib tashlash** - List'dan duplicate elementlarni olib tashlash uchun qo'llaniladi
3. **Bitta null element** - Faqat bitta null element qo'shishga ruxsat beradi
4. **get amallariga qaraganda add/remove amallari tez** - HashSet get amallariga qaraganda add va remove amallari uchun yaxshiroq
5. **Thread-safe emas** - Collections.synchronizeSet() yordamida thread-safe qilish mumkin
6. **Default boshlang'ich capacity** - 16
7. **Default load factor** - 0.75 (75% to'lganda avtomatik o'sadi)

### HashSet Misollari

```java
package collectionsframework.set;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

/**
 * HashSet class'idan foydalanish misollari
 */
public class HashSetExample {
    
    public static void main(String[] args) {
        // 1. HashSet yaratish
        Set<String> programmingLanguages = new HashSet<>();
        
        // 2. Element qo'shish
        programmingLanguages.add("Java");
        programmingLanguages.add("Python");
        programmingLanguages.add("JavaScript");
        programmingLanguages.add("C++");
        programmingLanguages.add("Java");  // Duplicate - qo'shilmaydi
        
        System.out.println("Programming Languages: " + programmingLanguages);
        System.out.println("Size: " + programmingLanguages.size());
        
        // 3. Null element qo'shish
        programmingLanguages.add(null);
        programmingLanguages.add(null);  // Faqat bitta null saqlanadi
        System.out.println("With null: " + programmingLanguages);
        
        // 4. Element mavjudligini tekshirish
        System.out.println("Contains Java? " + programmingLanguages.contains("Java"));
        System.out.println("Contains Ruby? " + programmingLanguages.contains("Ruby"));
        
        // 5. Element o'chirish
        programmingLanguages.remove("C++");
        System.out.println("After removing C++: " + programmingLanguages);
        
        // 6. Iterator yordamida iteratsiya
        System.out.println("\nIterating with Iterator:");
        Iterator<String> iterator = programmingLanguages.iterator();
        while (iterator.hasNext()) {
            String language = iterator.next();
            System.out.println(language);
        }
        
        // 7. For-each loop bilan iteratsiya
        System.out.println("\nIterating with for-each:");
        for (String language : programmingLanguages) {
            System.out.println(language);
        }
        
        // 8. Boshqa Set yaratish va birlashtirish
        Set<String> backendLanguages = new HashSet<>();
        backendLanguages.add("Java");
        backendLanguages.add("Python");
        backendLanguages.add("Go");
        backendLanguages.add("Rust");
        
        System.out.println("\nBackend Languages: " + backendLanguages);
        
        // 9. Union - ikkala Set'ni birlashtirish
        Set<String> allLanguages = new HashSet<>(programmingLanguages);
        allLanguages.addAll(backendLanguages);
        System.out.println("Union (All Languages): " + allLanguages);
        
        // 10. Intersection - umumiy elementlar
        Set<String> intersection = new HashSet<>(programmingLanguages);
        intersection.retainAll(backendLanguages);
        System.out.println("Intersection (Common Languages): " + intersection);
        
        // 11. Difference - farq
        Set<String> difference = new HashSet<>(programmingLanguages);
        difference.removeAll(backendLanguages);
        System.out.println("Difference (Only in programmingLanguages): " + difference);
        
        // 12. Tozalash
        programmingLanguages.clear();
        System.out.println("\nAfter clear, isEmpty? " + programmingLanguages.isEmpty());
    }
}
```

### equals() va hashCode() bilan HashSet

```java
package collectionsframework.set;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

/**
 * equals() va hashCode() method'larini to'g'ri override qilishning ahamiyati
 */
class Employee {
    private int id;
    private String name;
    private String department;
    
    public Employee(int id, String name, String department) {
        this.id = id;
        this.name = name;
        this.department = department;
    }
    
    // Noto'g'ri: equals() override qilingan, lekin hashCode() emas
    // Bu HashSet'da muammo yaratadi
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        Employee employee = (Employee) o;
        return id == employee.id;
    }
    
    // To'g'ri: equals() va hashCode() ikkalasi ham override qilingan
    /*
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        Employee employee = (Employee) o;
        return id == employee.id && 
               Objects.equals(name, employee.name) && 
               Objects.equals(department, employee.department);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id, name, department);
    }
    */
    
    // Getters
    public int getId() { return id; }
    public String getName() { return name; }
    public String getDepartment() { return department; }
    
    @Override
    public String toString() {
        return "Employee{id=" + id + ", name='" + name + "', department='" + department + "'}";
    }
}

public class HashSetWithEqualsHashCode {
    
    public static void main(String[] args) {
        // 1. HashSet yaratish
        Set<Employee> employees = new HashSet<>();
        
        // 2. Employee ob'ektlarini yaratish
        Employee emp1 = new Employee(101, "Ali", "IT");
        Employee emp2 = new Employee(102, "Vali", "HR");
        Employee emp3 = new Employee(101, "Ali", "IT");  // emp1 bilan bir xil
        
        // 3. Employee'larni HashSet'ga qo'shish
        employees.add(emp1);
        employees.add(emp2);
        employees.add(emp3);  // Duplicate bo'lishi kerak, lekin...
        
        System.out.println("Employees in HashSet: " + employees.size());
        System.out.println("Contains emp1? " + employees.contains(emp1));
        System.out.println("Contains emp3? " + employees.contains(emp3));
        
        // 4. Har bir employee'ni chiqarish
        System.out.println("\nAll Employees:");
        for (Employee emp : employees) {
            System.out.println(emp);
        }
        
        // 5. equals() va hashCode() to'g'ri override qilinmagan ta'siri
        System.out.println("\nemp1.equals(emp3): " + emp1.equals(emp3));
        System.out.println("emp1.hashCode() == emp3.hashCode(): " + 
                          (emp1.hashCode() == emp3.hashCode()));
    }
}
```

### HashSet Performance Misoli

```java
package collectionsframework.set;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;

/**
 * HashSet performance va duplicate'larni olib tashlash misoli
 */
public class HashSetPerformanceExample {
    
    public static void main(String[] args) {
        // 1. Random sonlar bilan list yaratish
        List<Integer> numbers = new ArrayList<>();
        Random random = new Random();
        
        // 100000 ta random son qo'shish (ba'zilari duplicate)
        for (int i = 0; i < 100000; i++) {
            numbers.add(random.nextInt(50000));  // 0-49999 oralig'ida
        }
        
        System.out.println("Original list size: " + numbers.size());
        
        // 2. Duplicate'larni HashSet yordamida olib tashlash
        long startTime = System.currentTimeMillis();
        
        Set<Integer> uniqueNumbers = new HashSet<>(numbers);
        List<Integer> uniqueList = new ArrayList<>(uniqueNumbers);
        
        long endTime = System.currentTimeMillis();
        
        System.out.println("Unique list size: " + uniqueList.size());
        System.out.println("Time taken to remove duplicates: " + (endTime - startTime) + "ms");
        
        // 3. Tezlikni solishtirish
        System.out.println("\nPerformance Comparison:");
        
        // ArrayList bilan contains() tezligi
        List<Integer> arrayList = new ArrayList<>();
        startTime = System.currentTimeMillis();
        for (int i = 0; i < 10000; i++) {
            if (!arrayList.contains(i)) {
                arrayList.add(i);
            }
        }
        endTime = System.currentTimeMillis();
        System.out.println("ArrayList with contains() - Time: " + (endTime - startTime) + "ms");
        
        // HashSet bilan contains() tezligi
        Set<Integer> hashSet = new HashSet<>();
        startTime = System.currentTimeMillis();
        for (int i = 0; i < 10000; i++) {
            if (!hashSet.contains(i)) {
                hashSet.add(i);
            }
        }
        endTime = System.currentTimeMillis();
        System.out.println("HashSet with contains() - Time: " + (endTime - startTime) + "ms");
    }
}
```

### HashSet Constructor'lari

```java
package collectionsframework.set;

import java.util.HashSet;
import java.util.Set;

/**
 * HashSet constructor'laridan foydalanish
 */
public class HashSetConstructors {
    
    public static void main(String[] args) {
        // 1. Default constructor - initial capacity: 16, load factor: 0.75
        Set<String> set1 = new HashSet<>();
        System.out.println("Default HashSet created");
        
        // 2. Initial capacity bilan constructor
        Set<String> set2 = new HashSet<>(50);  // Initial capacity: 50
        System.out.println("HashSet with initial capacity 50 created");
        
        // 3. Initial capacity va load factor bilan constructor
        Set<String> set3 = new HashSet<>(100, 0.8f);  // Capacity: 100, Load factor: 0.8
        System.out.println("HashSet with capacity 100 and load factor 0.8 created");
        
        // 4. Collection bilan constructor - boshqa collection'dan elementlarni o'zgartiradi
        Set<String> initialSet = new HashSet<>();
        initialSet.add("Apple");
        initialSet.add("Banana");
        initialSet.add("Orange");
        
        Set<String> set4 = new HashSet<>(initialSet);
        System.out.println("HashSet created from another collection: " + set4);
        
        // 5. Load factor tushunchasi
        System.out.println("\nUnderstanding Load Factor:");
        System.out.println("Load factor - bu HashSet to'lish darajasi");
        System.out.println("Default load factor: 0.75");
        System.out.println("Load factor 0.75 degani - 75% to'lganda avtomatik ravishda o'lcham 2 marta oshadi");
        System.out.println("Yuqori load factor -> kamroq xotira, lekin sekinroq kirish");
        System.out.println("Past load factor -> ko'proq xotira, lekin tezroq kirish");
    }
}
```

## Set Method'lari

### Set Interface'ining Asosiy Method'lari

```java
package collectionsframework.set;

import java.util.HashSet;
import java.util.Set;

/**
 * Set interface'ining asosiy method'lari
 */
public class SetMethodsExample {
    
    public static void main(String[] args) {
        Set<String> setA = new HashSet<>();
        Set<String> setB = new HashSet<>();
        
        // 1. add() - element qo'shish
        setA.add("A");
        setA.add("B");
        setA.add("C");
        setA.add("D");
        
        setB.add("C");
        setB.add("D");
        setB.add("E");
        setB.add("F");
        
        System.out.println("Set A: " + setA);
        System.out.println("Set B: " + setB);
        
        // 2. addAll() - boshqa to'plamni qo'shish (Union)
        Set<String> union = new HashSet<>(setA);
        union.addAll(setB);
        System.out.println("Union (A ∪ B): " + union);
        
        // 3. retainAll() - faqat umumiy elementlarni saqlash (Intersection)
        Set<String> intersection = new HashSet<>(setA);
        intersection.retainAll(setB);
        System.out.println("Intersection (A ∩ B): " + intersection);
        
        // 4. removeAll() - boshqa to'plamdagi elementlarni o'chirish (Difference)
        Set<String> difference = new HashSet<>(setA);
        difference.removeAll(setB);
        System.out.println("Difference (A - B): " + difference);
        
        // 5. containsAll() - barcha elementlar mavjudligini tekshirish (Subset)
        System.out.println("Is {C, D} subset of A? " + setA.containsAll(Set.of("C", "D")));
        
        // 6. toArray() - array'ga o'tkazish
        Object[] array = setA.toArray();
        System.out.println("Array from Set A: ");
        for (Object obj : array) {
            System.out.print(obj + " ");
        }
        
        // 7. toArray(T[] a) - specific type'dagi array'ga o'tkazish
        String[] stringArray = setA.toArray(new String[0]);
        System.out.println("\nString array from Set A: ");
        for (String str : stringArray) {
            System.out.print(str + " ");
        }
    }
}
```

## Amaliy Maslahatlar

1. **HashSet qachon ishlatish kerak?**
    - Takrorlanmas elementlar saqlash uchun
    - Tez add/remove/contains amallari uchun
    - Elementlar tartibi muhim bo'lmaganda

2. **Performance diqqatga olinishi kerak:**
    - Initial capacity va load factor'ni vazifaga qarab sozlash
    - Agar elementlar soni oldindan ma'lum bo'lsa, initial capacity belgilash
    - Yuqori performance uchun past load factor (0.5-0.75)

3. **equals() va hashCode() muhimligi:**
    - HashSet ishlatganda har doim ikkala method'ni ham override qiling
    - equals() uchun ishlatilgan field'lar hashCode() uchun ham ishlatilishi kerak

4. **Null qiymat bilan ishlash:**
    - HashSet bitta null qiymat saqlay oladi
    - NullPointerException'dan saqlanish uchun ehtiyot bo'ling

---

**Keyingi mavzu:** [07_LinkedHashSet.md](./07_LinkedHashSet.md)

**Oldingi mavzu:** [05_LinkedList_Data_Structure.md](./05_LinkedList_Data_Structure.md)

**Asosiy sahifaga qaytish:** [README.md](../README.md)

---

**Muhim Atamalar:**
- **Set** - Noyob elementlar to'plami
- **HashSet** - Hash table asosidagi Set implementatsiyasi
- **equals()** - Ob'ektlarning tengligini tekshirish method'i
- **hashCode()** - Ob'ekt uchun hash code yaratish method'i
- **Load Factor** - HashSet to'lish darajasi
- **Initial Capacity** - Boshlang'ich o'lcham
- **Union** - Ikkala to'plamning birlashmasi
- **Intersection** - Ikkala to'plamning kesishmasi
- **Difference** - Ikki to'plamning farqi

> **Bolalar, o'rganishda davom etamiz!** 🚀
---

# Comparator, Comparable va TreeSet

## Comparable Interface

**Comparable** interface'i uni implement qilgan har bir class ob'ektlari uchun umumiy tartibni belgilaydi. Bu tartib class'ning **natural ordering** (tabiiy tartibi) deb ataladi va class'ning `compareTo()` method'i uning natural comparison method'i hisoblanadi (JDK 1.2'dan boshlab).

### compareTo() Method'i

`compareTo()` method'i ikki ob'ektni solishtirish uchun ishlatiladi va 3 xil qiymat qaytaradi:
- **Manfiy son** - agar joriy ob'ekt parametrdan kichik bo'lsa
- **Nol** - agar ikkala ob'ekt teng bo'lsa
- **Musbat son** - agar joriy ob'ekt parametrdan katta bo'lsa

## Comparator Interface

**Comparator** - bu taqqoslash funksiyasi bo'lib, ob'ektlar to'plami uchun umumiy tartibni belgilaydi. Comparator'lar sort method'lariga (`Collections.sort()` yoki `Arrays.sort()`) o'tkazilishi mumkin, bu esa tartiblash ustida aniq nazoratni ta'minlaydi. Comparator'lar shuningdek, ba'zi data structure'lar (masalan, sorted set yoki sorted map) tartibini boshqarish yoki natural ordering'ga ega bo'lmagan ob'ektlar to'plami uchun tartib ta'minlash uchun ishlatilishi mumkin (JDK 1.2'dan boshlab).

## TreeSet Class'i

**TreeSet** class'i TreeMap asosida qurilgan NavigableSet implementatsiyasidir. Elementlar ularning natural ordering'i yoki set yaratilish vaqtida berilgan Comparator yordamida tartiblanadi (qaysi constructor ishlatilishiga qarab).

### TreeSet'ning Asosiy Xususiyatlari

1. **Noyob elementlar** - HashSet kabi faqat noyob elementlarni saqlaydi
2. **Null element yo'q** - Null element qo'shishga ruxsat bermaydi
3. **Synchronized emas** - `Collections.synchronizedSortedSet(new TreeSet(...))` yordamida synchronized qilish mumkin
4. **O'sish tartibida** - Elementlar har qanday tartibda qo'shilganda ham avtomatik ravishda o'sish tartibida joylashtiriladi
5. **TreeMap ichki qatlami** - Java TreeSet ichki qatlamda TreeMap'dan foydalanadi

### TreeSet Class'i Ierarxiyasi

```
                   Collection
                       |
                      Set
                          \
Cloneable-------|       SortedSet
                |           |             
Serializable ---|      NavigableSet
                |     /
AbstractSet     |    /
           \    |   /
            TreeSet
```

## TreeSet Amaliyotda

### JavaTreeSetTest - TreeSet Misollari

```java
package collectionsframework.set;

import java.util.Comparator;
import java.util.TreeSet;

/**
 * TreeSet class'idan foydalanish misollari
 */
public class JavaTreeSetTest {
    
    public static void main(String[] args) {
        // 1. TreeSet yaratish (natural ordering bilan)
        var treeSet = new TreeSet<Integer>();
        treeSet.add(12);
        treeSet.add(2);
        treeSet.add(1);
        treeSet.add(90);
        treeSet.add(4);
        treeSet.add(6);
        treeSet.add(-12);
        
        System.out.println("TreeSet (auto-sorted): " + treeSet);
        
        // 2. NavigableSet method'lari
        System.out.println("\nNavigableSet Methods:");
        System.out.println("floor(5) - eng katta element ≤ 5: " + treeSet.floor(5));
        System.out.println("ceiling(6) - eng kichik element ≥ 6: " + treeSet.ceiling(6));
        System.out.println("lower(4) - eng katta element < 4: " + treeSet.lower(4));
        System.out.println("higher(6) - eng kichik element > 6: " + treeSet.higher(6));
        
        // 3. SubSet method'lari
        System.out.println("\nSubSet Methods:");
        System.out.println("subSet(6, 12) - 6 ≤ element < 12: " + treeSet.subSet(6, 12));
        System.out.println("subSet(6, true, 12, true) - 6 ≤ element ≤ 12: " + 
                          treeSet.subSet(6, true, 12, true));
        System.out.println("tailSet(6) - element ≥ 6: " + treeSet.tailSet(6));
        System.out.println("tailSet(6, false) - element > 6: " + treeSet.tailSet(6, false));
        System.out.println("headSet(6) - element < 6: " + treeSet.headSet(6));
        
        // 4. Comparator bilan TreeSet yaratish
        var treeSet2 = new TreeSet<Employee>(Comparator.comparing(Employee::getFullName));
        treeSet2.add(new Employee("Akbar Akbarov"));
        treeSet2.add(new Employee("Zafar Zafarov"));
        treeSet2.add(new Employee("Bahrom Bahromov"));
        
        System.out.println("\nEmployees sorted by name: " + treeSet2);
        
        // 5. Descending tartib
        System.out.println("\nDescending order:");
        System.out.println("Descending Set: " + treeSet.descendingSet());
        
        // 6. PollFirst va PollLast
        System.out.println("\nFirst and Last elements:");
        System.out.println("First element: " + treeSet.first());
        System.out.println("Last element: " + treeSet.last());
        
        Integer removedFirst = treeSet.pollFirst();  // Birinchi elementni olib tashlaydi
        Integer removedLast = treeSet.pollLast();    // Oxirgi elementni olib tashlaydi
        System.out.println("Removed first: " + removedFirst);
        System.out.println("Removed last: " + removedLast);
        System.out.println("TreeSet after poll: " + treeSet);
    }
}

/**
 * Employee class - TreeSet uchun misol
 */
class Employee {
    private String fullName;
    
    public Employee(String fullName) {
        this.fullName = fullName;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    @Override
    public String toString() {
        return fullName;
    }
}
```

## Comparable Amaliyotda

### Student Class'i (Comparable bilan)

```java
package collectionsframework.comparable;

/**
 * Student class - Comparable interface'ini implement qilish misoli
 */
public class Student implements Comparable<Student> {
    public String firstName;
    public String lastName;
    public int age;
    
    public Student(String firstName, String lastName, int age) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.age = age;
    }
    
    /**
     * Natural ordering: Avval lastName, keyin firstName, keyin age bo'yicha
     */
    @Override
    public int compareTo(Student student) {
        // 1. Avval lastName bo'yicha solishtirish
        int lastNameCompare = this.lastName.compareTo(student.lastName);
        if (lastNameCompare != 0) {
            return lastNameCompare;
        }
        
        // 2. Agar lastName bir xil bo'lsa, firstName bo'yicha
        int firstNameCompare = this.firstName.compareTo(student.firstName);
        if (firstNameCompare != 0) {
            return firstNameCompare;
        }
        
        // 3. Agar firstName ham bir xil bo'lsa, age bo'yicha
        return Integer.compare(this.age, student.age);
    }
    
    @Override
    public String toString() {
        return String.format("%s %s (%d yosh)", lastName, firstName, age);
    }
}
```

### MockData Class'i

```java
package collectionsframework.comparable;

import com.github.javafaker.Faker;
import java.util.ArrayList;
import java.util.Random;

/**
 * Test ma'lumotlari yaratish uchun utility class
 */
public class MockData {
    
    /**
     * Tasodifiy student'lar ro'yxatini yaratish
     */
    public static ArrayList<Student> generateStudents() {
        var students = new ArrayList<Student>();
        var faker = new Faker();
        var random = new Random();
        
        // 20 ta tasodifiy student
        for (int i = 0; i < 20; i++) {
            String firstName = faker.name().firstName();
            String lastName = faker.name().lastName();
            int age = random.nextInt(18, 22);  // 18-21 yosh oralig'ida
            students.add(new Student(firstName, lastName, age));
        }
        
        // Qo'shimcha student'lar (test uchun)
        students.add(new Student("Akbar", "Akbarov", 20));
        students.add(new Student("Asliddin", "Akbarov", 19));
        students.add(new Student("Asliddin", "Akbarov", 18));
        
        return students;
    }
}
```

### StudentSort Class'i

```java
package collectionsframework.comparable;

import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * Student'lar sort qilishning turli usullari
 */
public class StudentSort {
    
    public static void main(String[] args) {
        // Test ma'lumotlarni yaratish
        List<Student> students = MockData.generateStudents();
        
        System.out.println("Tartiblanmagan student'lar:");
        System.out.println("=".repeat(50));
        students.forEach(System.out::println);
        
        System.out.println("\n" + "=".repeat(50));
        System.out.println("Tartiblangan student'lar (Comparable - natural ordering):");
        System.out.println("=".repeat(50));
        
        // 1. Comparable yordamida tartiblash (natural ordering)
        Collections.sort(students);
        students.forEach(System.out::println);
        
        // 2. Comparator yordamida turli tartiblash usullari
        System.out.println("\n" + "=".repeat(50));
        System.out.println("Tartiblangan student'lar (Comparator - yosh bo'yicha):");
        System.out.println("=".repeat(50));
        
        // Yosh bo'yicha tartiblash
        Collections.sort(students, Comparator.comparingInt(s -> s.age));
        students.forEach(System.out::println);
        
        System.out.println("\n" + "=".repeat(50));
        System.out.println("Tartiblangan student'lar (Comparator - firstName bo'yicha):");
        System.out.println("=".repeat(50));
        
        // firstName bo'yicha tartiblash
        Collections.sort(students, Comparator.comparing(s -> s.firstName));
        students.forEach(System.out::println);
        
        // 3. Ko'p qavatli tartiblash
        System.out.println("\n" + "=".repeat(50));
        System.out.println("Tartiblangan student'lar (Comparator - lastName, keyin firstName):");
        System.out.println("=".repeat(50));
        
        Comparator<Student> multiLevelComparator = Comparator
            .comparing((Student s) -> s.lastName)
            .thenComparing(s -> s.firstName)
            .thenComparingInt(s -> s.age);
        
        Collections.sort(students, multiLevelComparator);
        students.forEach(System.out::println);
        
        // 4. Teskari tartiblash
        System.out.println("\n" + "=".repeat(50));
        System.out.println("Tartiblangan student'lar (Teskari tartib - yosh bo'yicha):");
        System.out.println("=".repeat(50));
        
        Comparator<Student> reverseAgeComparator = Comparator
            .comparingInt((Student s) -> s.age)
            .reversed();
        
        Collections.sort(students, reverseAgeComparator);
        students.forEach(System.out::println);
    }
}
```

## Comparator va Comparable Farqlari

### Comparable vs Comparator

| Xususiyat | Comparable | Comparator |
|-----------|------------|------------|
| **Package** | `java.lang` | `java.util` |
| **Method** | `compareTo()` | `compare()` |
| **Tartiblash** | Natural ordering (tabiiy tartib) | Custom ordering (maxsus tartib) |
| **Class o'zgartirish** | Class'ni o'zgartirish kerak | Class'ni o'zgartirish shart emas |
| **Bitta tartib** | Bir class uchun bitta natural tartib | Bir nechta turli tartiblash usullari |
| **Collections.sort()** | `Collections.sort(list)` | `Collections.sort(list, comparator)` |
| **TreeSet/TreeMap** | Constructor'siz | Constructor bilan berilishi mumkin |

### Comparable Misoli (Class ichida)

```java
class Product implements Comparable<Product> {
    private String name;
    private double price;
    
    public Product(String name, double price) {
        this.name = name;
        this.price = price;
    }
    
    @Override
    public int compareTo(Product other) {
        // Avval price bo'yicha, keyin name bo'yicha
        int priceCompare = Double.compare(this.price, other.price);
        if (priceCompare != 0) {
            return priceCompare;
        }
        return this.name.compareTo(other.name);
    }
    
    // Getters va toString...
}
```

### Comparator Misoli (Alohida class)

```java
// 1. Alohida Comparator class
class PriceComparator implements Comparator<Product> {
    @Override
    public int compare(Product p1, Product p2) {
        return Double.compare(p1.getPrice(), p2.getPrice());
    }
}

// 2. NameComparator
class NameComparator implements Comparator<Product> {
    @Override
    public int compare(Product p1, Product p2) {
        return p1.getName().compareTo(p2.getName());
    }
}

// 3. Anonymous inner class bilan
Comparator<Product> priceComparator = new Comparator<Product>() {
    @Override
    public int compare(Product p1, Product p2) {
        return Double.compare(p1.getPrice(), p2.getPrice());
    }
};

// 4. Lambda expression bilan (Java 8+)
Comparator<Product> lambdaComparator = (p1, p2) -> 
    Double.compare(p1.getPrice(), p2.getPrice());

// 5. Method reference bilan (Java 8+)
Comparator<Product> methodRefComparator = 
    Comparator.comparing(Product::getPrice);
```

## TreeSet Performance va Xususiyatlari

```java
package collectionsframework.set;

import java.util.HashSet;
import java.util.TreeSet;
import java.util.Set;

/**
 * TreeSet vs HashSet performance taqqoslash
 */
public class TreeSetPerformance {
    
    public static void main(String[] args) {
        final int elementCount = 100000;
        
        // HashSet performance
        Set<Integer> hashSet = new HashSet<>();
        long startTime = System.currentTimeMillis();
        
        for (int i = 0; i < elementCount; i++) {
            hashSet.add((int) (Math.random() * elementCount));
        }
        
        long endTime = System.currentTimeMillis();
        System.out.println("HashSet add time: " + (endTime - startTime) + "ms");
        System.out.println("HashSet size: " + hashSet.size());
        
        // TreeSet performance
        Set<Integer> treeSet = new TreeSet<>();
        startTime = System.currentTimeMillis();
        
        for (int i = 0; i < elementCount; i++) {
            treeSet.add((int) (Math.random() * elementCount));
        }
        
        endTime = System.currentTimeMillis();
        System.out.println("TreeSet add time: " + (endTime - startTime) + "ms");
        System.out.println("TreeSet size: " + treeSet.size());
        
        // Contains operation performance
        startTime = System.currentTimeMillis();
        hashSet.contains(50000);
        endTime = System.currentTimeMillis();
        System.out.println("\nHashSet contains time: " + (endTime - startTime) + "ms");
        
        startTime = System.currentTimeMillis();
        treeSet.contains(50000);
        endTime = System.currentTimeMillis();
        System.out.println("TreeSet contains time: " + (endTime - startTime) + "ms");
        
        // First/last operations
        startTime = System.currentTimeMillis();
        ((TreeSet<Integer>) treeSet).first();
        ((TreeSet<Integer>) treeSet).last();
        endTime = System.currentTimeMillis();
        System.out.println("TreeSet first/last time: " + (endTime - startTime) + "ms");
    }
}
```

## TreeSet Method'lari

### TreeSet'ning NavigableSet Method'lari

```java
package collectionsframework.set;

import java.util.TreeSet;
import java.util.SortedSet;

/**
 * TreeSet navigatsiya method'lari
 */
public class TreeSetNavigation {
    
    public static void main(String[] args) {
        TreeSet<Integer> numbers = new TreeSet<>();
        
        // Elementlar qo'shish
        numbers.add(10);
        numbers.add(20);
        numbers.add(30);
        numbers.add(40);
        numbers.add(50);
        numbers.add(60);
        numbers.add(70);
        
        System.out.println("Original TreeSet: " + numbers);
        
        // 1. Ceiling, floor, higher, lower
        System.out.println("\nCeiling, Floor, Higher, Lower:");
        System.out.println("ceiling(25) - smallest ≥ 25: " + numbers.ceiling(25));
        System.out.println("floor(25) - largest ≤ 25: " + numbers.floor(25));
        System.out.println("higher(30) - smallest > 30: " + numbers.higher(30));
        System.out.println("lower(30) - largest < 30: " + numbers.lower(30));
        
        // 2. HeadSet, TailSet, SubSet
        System.out.println("\nHeadSet, TailSet, SubSet:");
        SortedSet<Integer> headSet = numbers.headSet(40);  // < 40
        System.out.println("headSet(40): " + headSet);
        
        SortedSet<Integer> tailSet = numbers.tailSet(40);  // ≥ 40
        System.out.println("tailSet(40): " + tailSet);
        
        SortedSet<Integer> subSet = numbers.subSet(20, 60);  // 20 ≤ element < 60
        System.out.println("subSet(20, 60): " + subSet);
        
        // 3. NavigableSet variantlari
        System.out.println("\nNavigableSet variants:");
        System.out.println("headSet(40, true): " + numbers.headSet(40, true));  // ≤ 40
        System.out.println("tailSet(40, false): " + numbers.tailSet(40, false));  // > 40
        System.out.println("subSet(20, false, 60, true): " + 
                          numbers.subSet(20, false, 60, true));  // 20 < element ≤ 60
        
        // 4. Descending operations
        System.out.println("\nDescending operations:");
        System.out.println("descendingSet(): " + numbers.descendingSet());
        System.out.println("descendingIterator(): ");
        numbers.descendingIterator().forEachRemaining(n -> System.out.print(n + " "));
        
        // 5. Poll operations
        System.out.println("\n\nPoll operations:");
        System.out.println("Original: " + numbers);
        System.out.println("pollFirst(): " + numbers.pollFirst());
        System.out.println("After pollFirst: " + numbers);
        System.out.println("pollLast(): " + numbers.pollLast());
        System.out.println("After pollLast: " + numbers);
    }
}
```

## Amaliy Maslahatlar

1. **Qachon TreeSet ishlatish kerak?**
    - Elementlarni tartiblangan holatda saqlash kerak bo'lsa
    - Range query (oralik so'rovlari) kerak bo'lsa
    - Natural ordering yoki custom ordering kerak bo'lsa

2. **Qachon Comparable vs Comparator?**
    - **Comparable** - class'ning default/natural tartibi bo'lsa
    - **Comparator** - bir nechta turli tartiblash usullari kerak bo'lsa
    - **Comparator** - class'ni o'zgartirish mumkin bo'lmasa

3. **Performance diqqatga olinishi kerak:**
    - **TreeSet**: O(log n) add/remove/contains operations
    - **HashSet**: O(1) average case, O(n) worst case
    - Agar tartiblash kerak bo'lmasa, HashSet tezroq

4. **Null qiymat bilan ishlash:**
    - TreeSet null qiymat qabul qilmaydi
    - NullPointerException beradi

5. **Thread safety:**
    - TreeSet synchronized emas
    - `Collections.synchronizedSortedSet()` yordamida thread-safe qilish mumkin

---

**Keyingi mavzu:** [08_Queue_Data_Structure.md](./08_Queue_Data_Structure.md)

**Oldingi mavzu:** [06_Set_Interface.md](./06_Set_Interface.md)

**Asosiy sahifaga qaytish:** [README.md](../README.md)

---

**Muhim Atamalar:**
- **Comparable** - Tabiiy tartib interface'i
- **Comparator** - Maxsus tartib interface'i
- **TreeSet** - Tartiblangan Set implementatsiyasi
- **Natural Ordering** - Class'ning default tartibi
- **compareTo()** - Comparable interface'ining asosiy method'i
- **compare()** - Comparator interface'ining asosiy method'i
- **NavigableSet** - Navigatsiya qilish imkoniyatiga ega Set
- **SortedSet** - Tartiblangan Set

> **Bolalar, o'rganishda davom etamiz!** 🚀