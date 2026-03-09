# 12 - Objects Class, Javadoc va UUID

## Objects Class va Uning Metodlari

### Objects Class nima?
`Objects` class - obyektlar ustida operatsiyalar bajarish va ma'lum shartlarni tekshirish uchun static utility metodlar to'plami. Java 1.7 dan beri mavjud.

### Asosiy Metodlar:

```java
import java.util.Objects;
import java.util.Arrays;

public class ObjectsClassExample {
    
    public static void main(String[] args) {
        System.out.println("=== OBJECTS CLASS UTILITY METHODS ===");
        
        // equals() - null-safe comparison
        testEquals();
        
        // deepEquals() - for arrays and nested structures
        testDeepEquals();
        
        // hashCode() - null-safe hash code generation
        testHashCode();
        
        // toString() - null-safe string conversion
        testToString();
        
        // requireNonNull() - null validation
        testRequireNonNull();
        
        // compare() - null-safe comparison
        testCompare();
        
        // isNull() and nonNull() - null checking
        testNullChecking();
        
        // checkIndex() and checkFromToIndex() - index validation
        testIndexValidation();
    }
    
    private static void testEquals() {
        System.out.println("\n1. equals() method:");
        
        String str1 = "Hello";
        String str2 = "Hello";
        String str3 = null;
        String str4 = "World";
        
        System.out.println("Objects.equals(str1, str2): " + 
                         Objects.equals(str1, str2));  // true
        System.out.println("Objects.equals(str1, str3): " + 
                         Objects.equals(str1, str3));  // false
        System.out.println("Objects.equals(str3, str3): " + 
                         Objects.equals(str3, str3));  // true
        System.out.println("Objects.equals(str1, str4): " + 
                         Objects.equals(str1, str4));  // false
        
        // Compare with regular equals()
        try {
            // str1.equals(str3) would throw NullPointerException
            System.out.println("str1.equals(str3) would throw NPE");
        } catch (NullPointerException e) {
            System.out.println("Caught NPE: " + e.getMessage());
        }
    }
    
    private static void testDeepEquals() {
        System.out.println("\n2. deepEquals() method:");
        
        int[] array1 = {1, 2, 3};
        int[] array2 = {1, 2, 3};
        int[] array3 = {1, 2, 4};
        int[][] nested1 = {{1, 2}, {3, 4}};
        int[][] nested2 = {{1, 2}, {3, 4}};
        int[][] nested3 = {{1, 2}, {3, 5}};
        
        System.out.println("Arrays.equals(array1, array2): " + 
                         Arrays.equals(array1, array2));  // true
        System.out.println("Objects.deepEquals(array1, array2): " + 
                         Objects.deepEquals(array1, array2));  // true
        
        System.out.println("Arrays.equals(nested1, nested2): " + 
                         Arrays.equals(nested1, nested2));  // false (compares references)
        System.out.println("Objects.deepEquals(nested1, nested2): " + 
                         Objects.deepEquals(nested1, nested2));  // true (compares contents)
        
        System.out.println("Objects.deepEquals(nested1, nested3): " + 
                         Objects.deepEquals(nested1, nested3));  // false
    }
    
    private static void testHashCode() {
        System.out.println("\n3. hashCode() and hash() methods:");
        
        String str = "Hello";
        String nullStr = null;
        
        System.out.println("Objects.hashCode(str): " + 
                         Objects.hashCode(str));  // Same as str.hashCode()
        System.out.println("Objects.hashCode(nullStr): " + 
                         Objects.hashCode(nullStr));  // 0 (no NPE!)
        
        // Generate hash from multiple values
        int hash1 = Objects.hash("John", 25, "Developer");
        int hash2 = Objects.hash("John", 25, "Developer");
        int hash3 = Objects.hash("Jane", 30, "Manager");
        
        System.out.println("hash1: " + hash1);
        System.out.println("hash2: " + hash2);
        System.out.println("hash3: " + hash3);
        System.out.println("hash1 == hash2: " + (hash1 == hash2));  // true
        System.out.println("hash1 == hash3: " + (hash1 == hash3));  // false
        
        // Manual hash calculation vs Objects.hash()
        String name = "John";
        int age = 25;
        String job = "Developer";
        
        int manualHash = Objects.hashCode(name) ^ 
                        Integer.hashCode(age) ^ 
                        Objects.hashCode(job);
        int objectsHash = Objects.hash(name, age, job);
        
        System.out.println("Manual hash: " + manualHash);
        System.out.println("Objects.hash(): " + objectsHash);
    }
    
    private static void testToString() {
        System.out.println("\n4. toString() methods:");
        
        String str = "Hello World";
        String nullStr = null;
        Object obj = new Person("Alice", 30);
        
        System.out.println("Objects.toString(str): " + 
                         Objects.toString(str));  // "Hello World"
        System.out.println("Objects.toString(nullStr): " + 
                         Objects.toString(nullStr));  // "null"
        System.out.println("Objects.toString(nullStr, \"default\"): " + 
                         Objects.toString(nullStr, "default"));  // "default"
        System.out.println("Objects.toString(obj): " + 
                         Objects.toString(obj));  // Person toString()
        
        // Traditional null check vs Objects.toString()
        String result1 = (str == null) ? "null" : str;
        String result2 = Objects.toString(str, "null");
        System.out.println("Traditional: " + result1);
        System.out.println("Objects.toString(): " + result2);
    }
    
    private static void testRequireNonNull() {
        System.out.println("\n5. requireNonNull() methods:");
        
        String valid = "Valid string";
        String nullValue = null;
        
        try {
            // Basic check
            String checked1 = Objects.requireNonNull(valid);
            System.out.println("Checked valid: " + checked1);
            
            // With custom message
            String checked2 = Objects.requireNonNull(valid, "Value cannot be null");
            System.out.println("Checked with message: " + checked2);
            
            // With message supplier (lazy evaluation)
            String checked3 = Objects.requireNonNull(valid, 
                () -> "Custom message at runtime: " + System.currentTimeMillis());
            System.out.println("Checked with supplier: " + checked3);
            
            // This will throw NPE
            Objects.requireNonNull(nullValue, "This should throw exception");
            
        } catch (NullPointerException e) {
            System.out.println("Caught NPE: " + e.getMessage());
        }
        
        // Practical example in constructor
        try {
            Person person = new Person(null, 25);
        } catch (NullPointerException e) {
            System.out.println("Person creation failed: " + e.getMessage());
        }
    }
    
    private static void testCompare() {
        System.out.println("\n6. compare() method:");
        
        String a = "apple";
        String b = "banana";
        String c = null;
        
        Comparator<String> comparator = String::compareTo;
        
        System.out.println("Objects.compare(a, b, comparator): " + 
                         Objects.compare(a, b, comparator));  // negative
        System.out.println("Objects.compare(b, a, comparator): " + 
                         Objects.compare(b, a, comparator));  // positive
        System.out.println("Objects.compare(a, a, comparator): " + 
                         Objects.compare(a, a, comparator));  // 0
        
        // Null-safe comparison
        try {
            // This would throw NPE with regular comparator
            comparator.compare(c, a);
        } catch (NullPointerException e) {
            System.out.println("Regular comparator throws NPE with null");
        }
        
        // Objects.compare handles nulls
        System.out.println("Objects.compare(null, a, comparator): " + 
                         Objects.compare(null, a, comparator));  // specific behavior
    }
    
    private static void testNullChecking() {
        System.out.println("\n7. isNull() and nonNull() methods:");
        
        String str = "Hello";
        String nullStr = null;
        
        System.out.println("Objects.isNull(str): " + Objects.isNull(str));      // false
        System.out.println("Objects.isNull(nullStr): " + Objects.isNull(nullStr)); // true
        System.out.println("Objects.nonNull(str): " + Objects.nonNull(str));    // true
        System.out.println("Objects.nonNull(nullStr): " + Objects.nonNull(nullStr)); // false
        
        // Usage in filtering
        var list = Arrays.asList("A", null, "B", null, "C");
        System.out.println("Original list: " + list);
        
        var nonNullList = list.stream()
            .filter(Objects::nonNull)
            .toList();
        System.out.println("Filtered (non-null): " + nonNullList);
        
        var nullList = list.stream()
            .filter(Objects::isNull)
            .toList();
        System.out.println("Filtered (null): " + nullList);
    }
    
    private static void testIndexValidation() {
        System.out.println("\n8. Index validation methods:");
        
        int[] array = {1, 2, 3, 4, 5};
        int length = array.length;
        
        try {
            // checkIndex()
            int index1 = Objects.checkIndex(2, length);
            System.out.println("Index 2 is valid for length " + length);
            
            // This will throw
            int index2 = Objects.checkIndex(10, length);
            
        } catch (IndexOutOfBoundsException e) {
            System.out.println("Index check failed: " + e.getMessage());
        }
        
        try {
            // checkFromToIndex()
            Objects.checkFromToIndex(1, 3, length);
            System.out.println("Range 1-3 is valid for length " + length);
            
            // This will throw
            Objects.checkFromToIndex(3, 10, length);
            
        } catch (IndexOutOfBoundsException e) {
            System.out.println("Range check failed: " + e.getMessage());
        }
        
        try {
            // checkFromIndexSize()
            Objects.checkFromIndexSize(2, 2, length);
            System.out.println("From index 2 with size 2 is valid");
            
            // This will throw
            Objects.checkFromIndexSize(4, 3, length);
            
        } catch (IndexOutOfBoundsException e) {
            System.out.println("FromIndexSize check failed: " + e.getMessage());
        }
    }
}

// Helper class
class Person {
    private final String name;
    private final int age;
    
    public Person(String name, int age) {
        // Using requireNonNull in constructor
        this.name = Objects.requireNonNull(name, "Name cannot be null");
        this.age = age;
    }
    
    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + "}";
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Person person = (Person) o;
        return age == person.age && Objects.equals(name, person.name);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(name, age);
    }
}
```

---

## Javadoc - Hujjatlar Yaratish

### Javadoc nima?
**Javadoc** - source code'dan HTML hujjatlar yaratadigan JDK vositasi.

### Misol: To'liq Javadoc bilan Class:

```java
/**
 * Bu klass bank hisobini ifodalaydi.
 * 
 * <p>Ushbu klass quyidagi xususiyatlarga ega:</p>
 * <ul>
 *   <li>Hisob raqami</li>
 *   <li>Hisob egasi ismi</li>
 *   <li>Balans</li>
 *   <li>Hisob ochilgan sana</li>
 * </ul>
 * 
 * <p><b>Eslatma:</b> Bu klass immutable emas. Balans o'zgartirilishi mumkin.</p>
 * 
 * @author Abdukarim Karshiev
 * @version 1.0
 * @since 2024
 * @see <a href="https://example.com">Bank API</a>
 */
public class BankAccount {
    
    /**
     * Minimal balans qiymati.
     * Ushbu konstantadan hisob ochish va operatsiyalar uchun foydalaniladi.
     */
    public static final double MIN_BALANCE = 0.0;
    
    /**
     * Maximal balans qiymati.
     * Bu chegaradan oshmasligi kerak.
     */
    public static final double MAX_BALANCE = 1_000_000_000.0;
    
    private final String accountNumber;
    private final String ownerName;
    private double balance;
    private final java.time.LocalDate openedDate;
    
    /**
     * Bank hisobini yaratadi.
     * 
     * <p>Yangi hisob yaratish uchun quyidagi parametrlar kerak:</p>
     * 
     * @param accountNumber Hisob raqami (10 ta raqam)
     * @param ownerName Hisob egasi ismi
     * @param initialBalance Boshlang'ich balans
     * @throws IllegalArgumentException agar parametrlar noto'g'ri bo'lsa
     * @throws NullPointerException agar accountNumber yoki ownerName null bo'lsa
     * 
     * @see #MIN_BALANCE
     * @see #MAX_BALANCE
     */
    public BankAccount(String accountNumber, String ownerName, double initialBalance) {
        this.accountNumber = java.util.Objects.requireNonNull(accountNumber, 
            "Hisob raqami null bo'lishi mumkin emas");
        this.ownerName = java.util.Objects.requireNonNull(ownerName,
            "Egasi ismi null bo'lishi mumkin emas");
        
        if (initialBalance < MIN_BALANCE || initialBalance > MAX_BALANCE) {
            throw new IllegalArgumentException(
                String.format("Balans %.2f dan %.2f gacha bo'lishi kerak", 
                    MIN_BALANCE, MAX_BALANCE));
        }
        
        this.balance = initialBalance;
        this.openedDate = java.time.LocalDate.now();
    }
    
    /**
     * Hisob raqamini qaytaradi.
     * 
     * @return Hisob raqami
     */
    public String getAccountNumber() {
        return accountNumber;
    }
    
    /**
     * Hisob egasi ismini qaytaradi.
     * 
     * @return Hisob egasi ismi
     */
    public String getOwnerName() {
        return ownerName;
    }
    
    /**
     * Joriy balansni qaytaradi.
     * 
     * @return Joriy balans
     */
    public double getBalance() {
        return balance;
    }
    
    /**
     * Hisob ochilgan sanani qaytaradi.
     * 
     * @return Hisob ochilgan sana
     */
    public java.time.LocalDate getOpenedDate() {
        return openedDate;
    }
    
    /**
     * Pul qo'shish amalini bajaradi.
     * 
     * <p>Ushbu metod hisobga pul qo'shadi. Miqdor musbat bo'lishi kerak.</p>
     * 
     * @param amount Qo'shiladigan miqdor
     * @throws IllegalArgumentException agar amount manfiy yoki nol bo'lsa
     * @throws IllegalStateException agar yangi balans maksimal chegaradan oshsa
     * 
     * @return Yangi balans
     * 
     * @see #withdraw(double)
     * @see #transfer(BankAccount, double)
     */
    public double deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException(
                "Qo'shiladigan miqdor musbat bo'lishi kerak: " + amount);
        }
        
        double newBalance = balance + amount;
        if (newBalance > MAX_BALANCE) {
            throw new IllegalStateException(
                String.format("Yangi balans maksimal chegaradan (%.2f) oshib ketdi", 
                    MAX_BALANCE));
        }
        
        balance = newBalance;
        return balance;
    }
    
    /**
     * Pul yechish amalini bajaradi.
     * 
     * <p>Ushbu metod hisobdan pul yechadi. Miqdor musbat va 
     * mavjud balansdan oshmasligi kerak.</p>
     * 
     * @param amount Yechiladigan miqdor
     * @throws IllegalArgumentException agar amount manfiy yoki nol bo'lsa
     * @throws IllegalStateException agar balans yetarli bo'lmasa
     * 
     * @return Yangi balans
     * 
     * @see #deposit(double)
     */
    public double withdraw(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException(
                "Yechiladigan miqdor musbat bo'lishi kerak: " + amount);
        }
        
        if (amount > balance) {
            throw new IllegalStateException(
                String.format("Balans yetarli emas: %.2f > %.2f", amount, balance));
        }
        
        balance -= amount;
        return balance;
    }
    
    /**
     * Pul o'tkazma amalini bajaradi.
     * 
     * <p>Ushbu metod boshqa hisobga pul o'tkazadi.
     * O'tkazma bir vaqtning o'zida yechish va qo'shish amallarini o'z ichiga oladi.</p>
     * 
     * @param toAccount Pul o'tkaziladigan hisob
     * @param amount O'tkaziladigan miqdor
     * @throws NullPointerException agar toAccount null bo'lsa
     * @throws IllegalArgumentException agar amount noto'g'ri bo'lsa
     * 
     * @return {@code true} agar o'tkazma muvaffaqiyatli bo'lsa
     * 
     * @see #deposit(double)
     * @see #withdraw(double)
     */
    public boolean transfer(BankAccount toAccount, double amount) {
        java.util.Objects.requireNonNull(toAccount, 
            "Maqsad hisobi null bo'lishi mumkin emas");
        
        try {
            this.withdraw(amount);
            toAccount.deposit(amount);
            return true;
        } catch (IllegalArgumentException | IllegalStateException e) {
            // Log the error
            System.err.println("O'tkazma amalga oshmadi: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Hisobning umumiy ma'lumotlarini qaytaradi.
     * 
     * <p>Format: "BankAccount{accountNumber='...', ownerName='...', balance=...}"</p>
     * 
     * @return Hisobning string ko'rinishi
     */
    @Override
    public String toString() {
        return String.format("BankAccount{accountNumber='%s', ownerName='%s', balance=%.2f}",
            accountNumber, ownerName, balance);
    }
    
    /**
     * Ikki hisobning tengligini tekshiradi.
     * 
     * <p>Hisoblar faqat hisob raqami bo'yicha taqqoslanadi.</p>
     * 
     * @param obj Taqqoslanadigan obyekt
     * @return {@code true} agar hisob raqamlari bir xil bo'lsa
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        BankAccount that = (BankAccount) obj;
        return accountNumber.equals(that.accountNumber);
    }
    
    /**
     * Hisobning hash kodini qaytaradi.
     * 
     * @return Hash kodi
     */
    @Override
    public int hashCode() {
        return accountNumber.hashCode();
    }
    
    /**
     * Hisobning ochilganidan beri qancha kun o'tganini hisoblaydi.
     * 
     * @return Ochilganidan beri o'tgan kunlar soni
     */
    public long getDaysSinceOpened() {
        return java.time.temporal.ChronoUnit.DAYS.between(
            openedDate, java.time.LocalDate.now());
    }
    
    /**
     * Hisobning faollik holatini tekshiradi.
     * 
     * <p>Hisob faol hisoblanadi agar:</p>
     * <ul>
     *   <li>Balans {@link #MIN_BALANCE} dan katta bo'lsa</li>
     *   <li>Oxirgi oyda kamida bitta operatsiya bo'lgan bo'lsa</li>
     * </ul>
     * 
     * @return {@code true} agar hisob faol bo'lsa
     * 
     * @deprecated Ushbu metod keyingi versiyada olib tashlanadi.
     *             {@link #isActiveAccount()} metodidan foydalaning.
     */
    @Deprecated(since = "1.1", forRemoval = true)
    public boolean checkActivity() {
        return balance > MIN_BALANCE && getDaysSinceOpened() < 30;
    }
    
    /**
     * Hisobning faollik holatini tekshiradi.
     * 
     * @return {@code true} agar hisob faol bo'lsa
     */
    public boolean isActiveAccount() {
        return balance > MIN_BALANCE;
    }
    
    /**
     * Minimal balans bilan yangi hisob yaratadi.
     * 
     * @param accountNumber Hisob raqami
     * @param ownerName Hisob egasi ismi
     * @return Yangi bank hisobi
     */
    public static BankAccount createBasicAccount(String accountNumber, String ownerName) {
        return new BankAccount(accountNumber, ownerName, MIN_BALANCE);
    }
}
```

### package-info.java Fayli:

```java
/**
 * Bank tizimi paketi.
 * 
 * <p>Ushbu paket bank operatsiyalari uchun klasslarni o'z ichiga oladi:</p>
 * <ul>
 *   <li>{@link com.example.bank.BankAccount} - Bank hisobini ifodalovchi klass</li>
 *   <li>{@link com.example.bank.Customer} - Bank mijozini ifodalovchi klass</li>
 *   <li>{@link com.example.bank.Transaction} - Bank operatsiyasini ifodalovchi klass</li>
 * </ul>
 * 
 * <h2>Foydalanish</h2>
 * <pre>
 * // Hisob yaratish
 * BankAccount account = new BankAccount("1234567890", "John Doe", 1000.0);
 * 
 * // Pul qo'shish
 * account.deposit(500.0);
 * 
 * // Pul yechish
 * account.withdraw(200.0);
 * </pre>
 * 
 * @author Abdukarim Karshiev
 * @version 1.0
 * @since 2024
 */
package com.example.bank;
```

### Javadoc Generatsiya:

```bash
# Paket uchun hujjat yaratish
javadoc -d docs -sourcepath src -subpackages com.example.bank

# Barcha .java fayllari uchun
javadoc -d docs *.java

# Qo'shimcha opsiyalar bilan
javadoc -d docs \
  -windowtitle "Bank System Documentation" \
  -doctitle "Bank System API" \
  -header "Bank System v1.0" \
  -footer "Copyright © 2024" \
  -link https://docs.oracle.com/en/java/javase/17/docs/api \
  src/*.java
```

---

## UUID (Universally Unique Identifier)

### UUID nima?
**UUID** - deyarli barcha amaliy maqsadlar uchun noyob deb hisoblanishi mumkin bo'lgan identifikator.

### UUID Format:
```
xxxxxxxx-xxxx-Mxxx-Nxxx-xxxxxxxxxxxx
```
- **M** - version (1-5)
- **N** - variant (0-2)

### UUID Misollari:

```java
import java.util.UUID;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class UUIDExample {
    
    public static void main(String[] args) {
        System.out.println("=== UUID EXAMPLES ===");
        
        // 1. UUID version 4 (random)
        testVersion4();
        
        // 2. UUID version 3 and 5 (name-based)
        testNameBasedUUIDs();
        
        // 3. UUID from string
        testUUIDFromString();
        
        // 4. Compare UUIDs
        testUUIDComparison();
        
        // 5. Practical examples
        testPracticalExamples();
    }
    
    private static void testVersion4() {
        System.out.println("\n1. Version 4 UUIDs (Random):");
        
        // Generate random UUIDs
        UUID uuid1 = UUID.randomUUID();
        UUID uuid2 = UUID.randomUUID();
        UUID uuid3 = UUID.randomUUID();
        
        System.out.println("UUID 1: " + uuid1);
        System.out.println("UUID 2: " + uuid2);
        System.out.println("UUID 3: " + uuid3);
        
        // Extract components
        System.out.println("\nUUID 1 components:");
        System.out.println("Version: " + uuid1.version());
        System.out.println("Variant: " + uuid1.variant());
        System.out.println("Most significant bits: " + uuid1.getMostSignificantBits());
        System.out.println("Least significant bits: " + uuid1.getLeastSignificantBits());
        System.out.println("Timestamp (if version 1): " + uuid1.timestamp());
        System.out.println("Clock sequence: " + uuid1.clockSequence());
        System.out.println("Node: " + uuid1.node());
        
        // Probability of collision (extremely low)
        System.out.println("\nCollision probability:");
        System.out.println("Total possible UUIDs: 2^128 ≈ 3.4 × 10^38");
        System.out.println("To have 50% collision probability:");
        System.out.println("Need to generate: 2.71 × 10^18 UUIDs");
    }
    
    private static void testNameBasedUUIDs() {
        System.out.println("\n2. Name-based UUIDs (Version 3 & 5):");
        
        // Namespace UUIDs (defined by RFC 4122)
        UUID namespaceDNS = UUID.fromString("6ba7b810-9dad-11d1-80b4-00c04fd430c8");
        UUID namespaceURL = UUID.fromString("6ba7b811-9dad-11d1-80b4-00c04fd430c8");
        UUID namespaceOID = UUID.fromString("6ba7b812-9dad-11d1-80b4-00c04fd430c8");
        UUID namespaceX500 = UUID.fromString("6ba7b814-9dad-11d1-80b4-00c04fd430c8");
        
        String name1 = "www.example.com";
        String name2 = "https://github.com";
        String name3 = "user@example.com";
        
        // Version 3 (MD5)
        UUID v3uuid1 = UUID.nameUUIDFromBytes(name1.getBytes());
        UUID v3uuid2 = UUID.nameUUIDFromBytes((namespaceDNS.toString() + name2).getBytes());
        
        // Version 5 (SHA-1) - custom implementation
        UUID v5uuid1 = generateNameBasedUUID(namespaceURL, name3, 5);
        UUID v5uuid2 = generateNameBasedUUID(namespaceDNS, name1, 5);
        
        System.out.println("Name 1: " + name1);
        System.out.println("  V3 UUID: " + v3uuid1 + " (version: " + v3uuid1.version() + ")");
        System.out.println("  V5 UUID: " + v5uuid2 + " (version: " + v5uuid2.version() + ")");
        
        System.out.println("\nName 2: " + name2);
        System.out.println("  V3 UUID: " + v3uuid2);
        
        System.out.println("\nName 3: " + name3);
        System.out.println("  V5 UUID: " + v5uuid1);
        
        // Same name always gives same UUID
        UUID test1 = UUID.nameUUIDFromBytes("test".getBytes());
        UUID test2 = UUID.nameUUIDFromBytes("test".getBytes());
        UUID test3 = UUID.nameUUIDFromBytes("test".getBytes(StandardCharsets.UTF_8));
        
        System.out.println("\nConsistency check:");
        System.out.println("test1: " + test1);
        System.out.println("test2: " + test2);
        System.out.println("test3: " + test3);
        System.out.println("All equal? " + test1.equals(test2) + " and " + test2.equals(test3));
    }
    
    private static void testUUIDFromString() {
        System.out.println("\n3. UUID from String:");
        
        // Valid UUID strings
        String uuidStr1 = "123e4567-e89b-12d3-a456-426614174000";
        String uuidStr2 = "00000000-0000-0000-0000-000000000000";
        String uuidStr3 = "ffffffff-ffff-ffff-ffff-ffffffffffff";
        
        try {
            UUID uuid1 = UUID.fromString(uuidStr1);
            UUID uuid2 = UUID.fromString(uuidStr2);
            UUID uuid3 = UUID.fromString(uuidStr3);
            
            System.out.println("String: " + uuidStr1 + " -> UUID: " + uuid1);
            System.out.println("String: " + uuidStr2 + " -> UUID: " + uuid2);
            System.out.println("String: " + uuidStr3 + " -> UUID: " + uuid3);
            
            // Invalid strings
            System.out.println("\nInvalid UUID strings:");
            String[] invalidStrings = {
                "123e4567-e89b-12d3-a456-42661417400",  // Too short
                "123e4567-e89b-12d3-a456-4266141740000", // Too long
                "123e4567-e89b-12d3-a456-42661417400g",  // Invalid character
                "123e4567e89b12d3a456426614174000",      // No hyphens
                "",                                      // Empty
                null                                     // Null
            };
            
            for (String invalid : invalidStrings) {
                try {
                    UUID invalidUUID = UUID.fromString(invalid);
                    System.out.println("ERROR: Should have thrown exception for: " + invalid);
                } catch (IllegalArgumentException e) {
                    System.out.println("Correctly rejected: " + 
                                     (invalid == null ? "null" : "'" + invalid + "'"));
                }
            }
            
        } catch (IllegalArgumentException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
    
    private static void testUUIDComparison() {
        System.out.println("\n4. UUID Comparison:");
        
        UUID uuid1 = UUID.randomUUID();
        UUID uuid2 = UUID.randomUUID();
        UUID uuid3 = uuid1;  // Same reference
        
        System.out.println("UUID1: " + uuid1);
        System.out.println("UUID2: " + uuid2);
        System.out.println("UUID3: " + uuid3 + " (same as UUID1)");
        
        // Comparison
        System.out.println("\nuuid1.equals(uuid2): " + uuid1.equals(uuid2));
        System.out.println("uuid1.equals(uuid3): " + uuid1.equals(uuid3));
        System.out.println("uuid1 == uuid3: " + (uuid1 == uuid3));
        
        // compareTo() method
        System.out.println("\nuuid1.compareTo(uuid2): " + uuid1.compareTo(uuid2));
        System.out.println("uuid2.compareTo(uuid1): " + uuid2.compareTo(uuid1));
        System.out.println("uuid1.compareTo(uuid3): " + uuid1.compareTo(uuid3));
        
        // Sorting UUIDs
        System.out.println("\nSorting UUIDs:");
        java.util.List<UUID> uuidList = new java.util.ArrayList<>();
        for (int i = 0; i < 5; i++) {
            uuidList.add(UUID.randomUUID());
        }
        
        System.out.println("Unsorted:");
        uuidList.forEach(uuid -> System.out.println("  " + uuid));
        
        java.util.Collections.sort(uuidList);
        System.out.println("\nSorted:");
        uuidList.forEach(uuid -> System.out.println("  " + uuid));
    }
    
    private static void testPracticalExamples() {
        System.out.println("\n5. Practical UUID Examples:");
        
        // Example 1: Session ID
        String sessionId = UUID.randomUUID().toString();
        System.out.println("Session ID: " + sessionId);
        
        // Example 2: File naming
        String originalFilename = "document.pdf";
        String uniqueFilename = UUID.randomUUID() + "_" + originalFilename;
        System.out.println("Unique filename: " + uniqueFilename);
        
        // Example 3: Database primary key simulation
        System.out.println("\nDatabase records with UUID primary keys:");
        for (int i = 1; i <= 3; i++) {
            String id = UUID.randomUUID().toString();
            System.out.printf("Record %d: id=%s, name='User%d', email='user%d@example.com'%n",
                i, id, i, i);
        }
        
        // Example 4: URL shortener
        String longUrl = "https://example.com/very/long/url/with/many/parameters";
        String shortCode = UUID.randomUUID().toString().substring(0, 8);
        System.out.println("\nURL Shortener:");
        System.out.println("Original: " + longUrl);
        System.out.println("Short: https://short.ly/" + shortCode);
        
        // Example 5: Correlation ID for microservices
        String correlationId = UUID.randomUUID().toString();
        System.out.println("\nMicroservices correlation ID: " + correlationId);
    }
    
    // Helper method to generate version 5 UUID (SHA-1 based)
    private static UUID generateNameBasedUUID(UUID namespace, String name, int version) {
        try {
            String input = namespace.toString() + name;
            MessageDigest md;
            
            if (version == 3) {
                md = MessageDigest.getInstance("MD5");
            } else if (version == 5) {
                md = MessageDigest.getInstance("SHA-1");
            } else {
                throw new IllegalArgumentException("Only versions 3 and 5 are supported");
            }
            
            byte[] hash = md.digest(input.getBytes(StandardCharsets.UTF_8));
            
            // Set version bits
            hash[6] &= 0x0F;  // Clear version
            hash[6] |= (version << 4);  // Set version
            
            // Set variant bits (RFC 4122)
            hash[8] &= 0x3F;  // Clear variant
            hash[8] |= 0x80;  // Set to RFC 4122 variant
            
            long msb = 0;
            long lsb = 0;
            
            for (int i = 0; i < 8; i++) {
                msb = (msb << 8) | (hash[i] & 0xff);
            }
            for (int i = 8; i < 16; i++) {
                lsb = (lsb << 8) | (hash[i] & 0xff);
            }
            
            return new UUID(msb, lsb);
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}

// Practical UUID usage in a system
class OrderSystem {
    private static class Order {
        private final UUID orderId;
        private final String customerName;
        private final double amount;
        private final java.time.LocalDateTime orderDate;
        
        public Order(String customerName, double amount) {
            this.orderId = UUID.randomUUID();
            this.customerName = customerName;
            this.amount = amount;
            this.orderDate = java.time.LocalDateTime.now();
        }
        
        public UUID getOrderId() { return orderId; }
        public String getCustomerName() { return customerName; }
        public double getAmount() { return amount; }
        public java.time.LocalDateTime getOrderDate() { return orderDate; }
        
        @Override
        public String toString() {
            return String.format("Order[%s, Customer: %s, Amount: %.2f, Date: %s]",
                orderId, customerName, amount, orderDate);
        }
    }
    
    public static void demonstrate() {
        System.out.println("\n=== ORDER SYSTEM WITH UUID ===");
        
        java.util.Map<UUID, Order> orderDatabase = new java.util.HashMap<>();
        
        // Create orders
        Order order1 = new Order("Alice Smith", 150.75);
        Order order2 = new Order("Bob Johnson", 299.99);
        Order order3 = new Order("Charlie Brown", 45.50);
        
        // Store in database (simulated)
        orderDatabase.put(order1.getOrderId(), order1);
        orderDatabase.put(order2.getOrderId(), order2);
        orderDatabase.put(order3.getOrderId(), order3);
        
        // List all orders
        System.out.println("All orders:");
        orderDatabase.values().forEach(System.out::println);
        
        // Find order by ID
        UUID searchId = order2.getOrderId();
        System.out.println("\nSearching for order: " + searchId);
        Order foundOrder = orderDatabase.get(searchId);
        
        if (foundOrder != null) {
            System.out.println("Found: " + foundOrder);
        } else {
            System.out.println("Order not found");
        }
        
        // Generate order number (formatted)
        String orderNumber = String.format("ORD-%s", 
            order1.getOrderId().toString().substring(0, 8).toUpperCase());
        System.out.println("\nFormatted order number: " + orderNumber);
    }
}
```

---

## 🎉 Congrats! Java OOP qismi yakunlandi!

### Eslatma:
Asosiy tushunchalarni yaxshi o'zlashtirish keyingi murakkab mavzularni o'rganish uchun mustahkam poydevor bo'ladi. Har bir misolni o'zingiz yozib ko'ring va tushunmagan joylaringizni qayta ko'rib chiqing!

## KEYINGI QADAMLAR

### 1. Intervyu Savollari
O'z bilimingizni sinab ko'ring:  
[Interviews/02_OOP_interviews.md](../Interviews/02_OOP_interviews.md)

### 2. Loyiha Topshiriqlari
Amaliyot uchun:  
[Assignments/02_OOP_assignment.md](../Assignments/02_OOP_assignment.md)

### 3. Mundarijaga Qaytish
[Asosiy README.md](../README.md)

---

### Keyingi Bosqich uchun Tayyorgarlik:
- **Data Structures & Algorithms**

> "The only way to learn a new programming language is by writing programs in it." - Dennis Ritchie

**O'rganishda davom etamiz!**