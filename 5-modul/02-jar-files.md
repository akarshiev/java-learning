# 5-Modul: JAR Files (Java Arxiv Fayllari)

## JAR fayl nima?

**JAR (Java ARchive)** - bu ZIP formatiga asoslangan, bir nechta fayllarni bitta faylga yig'ish uchun ishlatiladigan format.

```java
// JAR fayl tarkibi misoli:
// myapp.jar
//   ├── META-INF/
//   │   └── MANIFEST.MF
//   ├── com/
//   │   └── myapp/
//   │       ├── Main.class
//   │       └── Utils.class
//   └── resources/
//       ├── config.properties
//       └── images/
//           └── logo.png
```

### JAR faylning afzalliklari

1. **Yuklab olish vaqti kamayadi** - Ko'p fayllarni bitta faylga yig'ish
2. **Extension'lar uchun qulay** - Library'larni tarqatish
3. **Portativlik** - Barcha resurslar bir joyda
4. **Kompressiya** - ZIP orqali siqish
5. **Security** - Raqamli imzo qo'yish imkoniyati

---

## 5.1 - JAR Fayllar bilan ishlash

### JAR yaratish

```bash
# Asosiy JAR yaratish komandasi
jar cf jar-fayli.jar kiruvchi-fayl(lar)

# Misollar:

# 1. Barcha .class fayllarni JAR ga yig'ish
jar cf myapp.jar *.class

# 2. Papka va fayllarni qo'shish
jar cf myapp.jar com/ resources/ config.properties

# 3. Verbose rejimda (qanday fayllar qo'shilayotganini ko'rsatadi)
jar cvf myapp.jar *.class

# 4. Specific fayllarni qo'shish
jar cf myapp.jar Main.class Utils.class
```

**Parameterlar:**
- `c` - create (yaratish)
- `f` - file (faylga yozish)
- `v` - verbose (batafsil ma'lumot)
- `m` - manifest (manifest fayl)

### JAR tarkibini ko'rish

```bash
# JAR tarkibini ko'rish
jar tf myapp.jar

# Batafsil ma'lumot bilan
jar tvf myapp.jar

# Natija misoli:
#    0 Wed Mar 01 10:30:22 UZT 2024 META-INF/
#   72 Wed Mar 01 10:30:22 UZT 2024 META-INF/MANIFEST.MF
#  1248 Wed Mar 01 10:30:22 UZT 2024 com/myapp/Main.class
#   856 Wed Mar 01 10:30:22 UZT 2024 com/myapp/Utils.class
#   123 Wed Mar 01 10:30:22 UZT 2024 config.properties
```

**Parameterlar:**
- `t` - table of contents (tarkibni ko'rish)
- `f` - file (faylni ko'rsatish)
- `v` - verbose (batafsil)

### JAR dan fayllarni chiqarish

```bash
# Barcha fayllarni chiqarish
jar xf myapp.jar

# Ma'lum fayllarni chiqarish
jar xf myapp.jar com/myapp/Main.class config.properties

# Verbose rejimda
jar xvf myapp.jar

# Papka strukturasini saqlagan holda chiqarish
jar xf myapp.jar com/
```

**Parameterlar:**
- `x` - extract (chiqarish)
- `f` - file (fayldan chiqarish)

### JAR ni yangilash

```bash
# Yangi fayllar qo'shish
jar uf myapp.jar newfile.class

# Papka qo'shish
jar uf myapp.jar resources/

# Bir nechta fayl qo'shish
jar uf myapp.jar file1.class file2.class file3.class

# Yangilangan faylni almashtirish
jar uf myapp.jar com/myapp/Main.class
```

**Parameterlar:**
- `u` - update (yangilash)
- `f` - file (faylni yangilash)

---

## 5.2 - Manifest fayl

### Manifest nima?

**Manifest** - JAR fayli haqida ma'lumot saqlovchi maxsus fayl. Har bir JAR faylida bitta manifest bo'ladi va u `META-INF/MANIFEST.MF` joylashgan.

```bash
# Default manifest (avtomatik yaratiladi)
META-INF/MANIFEST.MF tarkibi:
Manifest-Version: 1.0
Created-By: 17.0.2 (Oracle Corporation)
```

### Manifest formati

```properties
# MANIFEST.MF formati
Manifest-Version: 1.0
Created-By: 17.0.2 (Oracle Corporation)
Main-Class: com.myapp.Main
Class-Path: lib/library1.jar lib/library2.jar
Implementation-Title: My Application
Implementation-Version: 1.0.0
Implementation-Vendor: My Company

Name: com/myapp/SomeClass.class
SHA-256-Digest: hsnf87sdhf8723hf...
```

### Asosiy manifest header'lari

| Header | Vazifasi | Misol |
|--------|----------|-------|
| `Manifest-Version` | Manifest versiyasi | `Manifest-Version: 1.0` |
| `Created-By` | JAR yaratgan Java versiyasi | `Created-By: 17.0.2` |
| `Main-Class` | Boshlang'ich class | `Main-Class: com.myapp.Main` |
| `Class-Path` | Bog'liq JAR fayllar | `Class-Path: lib/db.jar lib/utils.jar` |
| `Implementation-Title` | Ilova nomi | `Implementation-Title: MyApp` |
| `Implementation-Version` | Versiya | `Implementation-Version: 2.1.3` |

### Entry point (Main-Class) o'rnatish

#### 1-usul: Manifest fayl orqali

```bash
# 1. manifest.txt fayl yaratish
echo "Main-Class: com.myapp.Main" > manifest.txt

# 2. JAR yaratish (manifest bilan)
jar cfm myapp.jar manifest.txt com/myapp/*.class

# 3. Yoki mavjud JAR ga manifest qo'shish
jar ufm myapp.jar manifest.txt
```

#### 2-usul: 'e' flag bilan (tavsiya etiladi)

```bash
# 'e' flag orqali Main-Class o'rnatish
jar cfe myapp.jar com.myapp.Main com/myapp/*.class

# Package ichidagi class uchun
jar cfe app.jar com.myapp.Main com/myapp/Main.class

# Verbose rejimda
jar cvfe myapp.jar com.myapp.Main com/myapp/*.class
```

**Parameterlar:**
- `e` - entrypoint (boshlang'ich classni belgilash)

### Manifest ni tahrirlash

```bash
# 1. Mavjud JAR dan manifest ni chiqarish
jar xf myapp.jar META-INF/MANIFEST.MF

# 2. Manifest ni tahrirlash
nano META-INF/MANIFEST.MF
# yoki
vim META-INF/MANIFEST.MF

# 3. Yangilangan manifest bilan JAR ni qayta yaratish
jar cfm myapp.jar META-INF/MANIFEST.MF com/ resources/

# 4. Yoki mavjud JAR ni yangilash
jar ufm myapp.jar META-INF/MANIFEST.MF
```

---

## 5.3 - JAR faylni ishga tushirish

### Executable JAR yaratish

```java
// Timer.java - oddiy timer ilovasi
package uz.pdp.jar;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;

public class Timer {
    public static void main(String[] args) {
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        
        System.out.println("Timer started (Ctrl+C to stop)");
        System.out.println("Current time:");
        
        try {
            while (true) {
                // Har sekundda vaqtni yangilash
                TimeUnit.SECONDS.sleep(1);
                System.out.print("\r" + sdf.format(new Date()));
            }
        } catch (InterruptedException e) {
            System.out.println("\nTimer stopped");
        }
    }
}
```

### JAR yaratish bosqichlari

```bash
# 1. Compile qilish
javac -d . Timer.java
# Natija: uz/pdp/jar/Timer.class

# 2. JAR yaratish (entrypoint bilan)
jar cfe timer.jar uz.pdp.jar.Timer uz/pdp/jar/*.class

# 3. JAR ni ishga tushirish
java -jar timer.jar
# Natija:
# Timer started (Ctrl+C to stop)
# Current time:
# 14:30:45
```

### To'liq misol: Calculator app

```java
// Calculator.java
package uz.pdp.calc;

import java.util.Scanner;

public class Calculator {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.println("=== Simple Calculator ===");
        System.out.print("Enter first number: ");
        double a = scanner.nextDouble();
        
        System.out.print("Enter second number: ");
        double b = scanner.nextDouble();
        
        System.out.print("Enter operation (+, -, *, /): ");
        String op = scanner.next();
        
        double result = 0;
        switch (op) {
            case "+" -> result = a + b;
            case "-" -> result = a - b;
            case "*" -> result = a * b;
            case "/" -> result = b != 0 ? a / b : Double.NaN;
            default -> {
                System.out.println("Invalid operation");
                return;
            }
        }
        
        System.out.printf("Result: %.2f %s %.2f = %.2f%n", a, op, b, result);
    }
}
```

```bash
# 1. Compile
javac -d . Calculator.java

# 2. JAR yaratish
jar cfe calculator.jar uz.pdp.calc.Calculator uz/pdp/calc/*.class

# 3. JAR haqida ma'lumot
jar tvf calculator.jar
#    0 Wed Mar 01 14:35:22 UZT 2024 META-INF/
#   98 Wed Mar 01 14:35:22 UZT 2024 META-INF/MANIFEST.MF
# 2048 Wed Mar 01 14:35:22 UZT 2024 uz/pdp/calc/Calculator.class

# 4. Ishga tushirish
java -jar calculator.jar
```

---

## 5.4 - JAR Command Options To'liq Ma'lumot

### Asosiy option'lar

| Option | Ma'nosi | Misol |
|--------|---------|-------|
| `c` | Create new archive | `jar cf my.jar *.class` |
| `t` | List table of contents | `jar tf my.jar` |
| `x` | Extract files | `jar xf my.jar` |
| `u` | Update existing archive | `jar uf my.jar new.class` |
| `i` | Generate index | `jar i my.jar` |

### Qo'shimcha option'lar

| Option | Ma'nosi | Misol |
|--------|---------|-------|
| `f` | Specify file name | `jar cf my.jar *.class` |
| `v` | Verbose output | `jar cvf my.jar *.class` |
| `m` | Include manifest | `jar cfm my.jar manifest.txt *.class` |
| `e` | Specify entry point | `jar cfe my.jar MainClass *.class` |
| `0` | No compression | `jar c0f my.jar *.class` |
| `M` | No manifest | `jar cMf my.jar *.class` |
| `-C` | Change directory | `jar cf my.jar -C classes .` |

### Amaliy misollar

```bash
# 1. Directory ichidagi barcha fayllarni JAR ga yig'ish
jar cf myapp.jar -C build/classes .

# 2. Manifest bilan JAR yaratish
jar cfm myapp.jar manifest.txt -C build/classes .

# 3. Verbose rejimda yaratish
jar cvf myapp.jar build/classes/*

# 4. Kompressiyasiz JAR
jar c0f myapp.jar build/classes/*

# 5. JAR indeks yaratish (tezroq yuklash uchun)
jar i myapp.jar

# 6. Manifest ko'rish
jar xf myapp.jar META-INF/MANIFEST.MF
cat META-INF/MANIFEST.MF
```

---

## 5.5 - JAR bilan ishlashning amaliy misollari

### Misol 1: Library JAR yaratish

```java
// StringUtils.java
package uz.pdp.util;

public class StringUtils {
    
    public static boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
    
    public static String reverse(String s) {
        if (s == null) return null;
        return new StringBuilder(s).reverse().toString();
    }
    
    public static int countVowels(String s) {
        if (s == null) return 0;
        return s.toLowerCase()
                .replaceAll("[^aeiou]", "")
                .length();
    }
}
```

```bash
# 1. Compile
javac -d . StringUtils.java

# 2. Library JAR yaratish
jar cf utils.jar uz/pdp/util/*.class

# 3. JAR tarkibini ko'rish
jar tvf utils.jar
#  1256 Wed Mar 01 15:20:22 UZT 2024 uz/pdp/util/StringUtils.class

# 4. JAR ni boshqa loyihada ishlatish
javac -cp utils.jar Main.java
java -cp utils.jar:. Main
```

### Misol 2: Bog'liq JAR lar bilan ishlash

```bash
# 1. Library JAR lar
lib/
├── utils.jar
├── database.jar
└── logging.jar

# 2. Manifest orqali Class-Path belgilash
echo "Main-Class: com.myapp.Main" > manifest.txt
echo "Class-Path: lib/utils.jar lib/database.jar lib/logging.jar" >> manifest.txt

# 3. JAR yaratish
jar cfm myapp.jar manifest.txt -C build/classes .

# 4. Ishga tushirish (manifest Class-Path ni avtomatik o'qiydi)
java -jar myapp.jar
```

### Misol 3: Version'langan JAR

```bash
# Version bilan JAR nomlash
jar cf myapp-1.0.0.jar -C build/classes .
jar cf myapp-1.1.0.jar -C build/classes .
jar cf myapp-2.0.0.jar -C build/classes .

# Symlink orqali versiya boshqarish
ln -s myapp-2.0.0.jar myapp-current.jar

# Version ma'lumotlarini manifestga qo'shish
echo "Implementation-Version: 2.0.0" >> manifest.txt
echo "Implementation-Title: My Application" >> manifest.txt
echo "Implementation-Vendor: PDP Academy" >> manifest.txt

jar cfm myapp-2.0.0.jar manifest.txt -C build/classes .
```

### Misol 4: JAR ichidan resurs o'qish

```java
// ResourceReader.java
package uz.pdp.util;

import java.io.*;
import java.nio.file.*;
import java.util.*;

public class ResourceReader {
    
    // JAR ichidagi faylni o'qish
    public static String readResource(String resourcePath) throws IOException {
        try (InputStream is = ResourceReader.class
                .getResourceAsStream("/" + resourcePath)) {
            
            if (is == null) {
                throw new IOException("Resource not found: " + resourcePath);
            }
            
            return new String(is.readAllBytes());
        }
    }
    
    // JAR ichidagi property faylni o'qish
    public static Properties readProperties(String resourcePath) 
            throws IOException {
        
        Properties props = new Properties();
        try (InputStream is = ResourceReader.class
                .getResourceAsStream("/" + resourcePath)) {
            
            if (is == null) {
                throw new IOException("Properties file not found: " + resourcePath);
            }
            
            props.load(is);
        }
        return props;
    }
    
    // JAR ichidagi barcha resurslarni ro'yxatlash
    public static List<String> listResources(String path) {
        // JAR ichida directory listing murakkabroq
        // Odatda manifest yoki alohida index fayl ishlatiladi
        return Collections.emptyList();
    }
}
```

```bash
# 1. Resurs fayllar yaratish
mkdir resources
echo "app.name=MyApp" > resources/config.properties
echo "app.version=2.0.0" >> resources/config.properties
echo "Hello from JAR!" > resources/welcome.txt

# 2. JAR yaratish (class + resurslar)
jar cf myapp.jar -C build/classes . -C resources .

# 3. JAR tarkibini tekshirish
jar tf myapp.jar
# META-INF/
# META-INF/MANIFEST.MF
# uz/pdp/util/ResourceReader.class
# config.properties
# welcome.txt
```

---

## 5.6 - JAR Operations Reference

### JAR operatsiyalari jadvali

| Operatsiya | Komanda | Izoh |
|------------|---------|------|
| **Yaratish** | `jar cf jar-file input-files` | Yangi JAR yaratish |
| **Ko'rish** | `jar tf jar-file` | JAR tarkibini ko'rish |
| **Chiqarish** | `jar xf jar-file` | Barcha fayllarni chiqarish |
| **Qisman chiqarish** | `jar xf jar-file file1 file2` | Faqat belgilangan fayllarni chiqarish |
| **Yangilash** | `jar uf jar-file new-files` | JAR ga fayl qo'shish/yangilash |
| **Entrypoint** | `jar cfe jar-file MainClass input-files` | Boshlang'ich class bilan JAR yaratish |
| **Manifest bilan** | `jar cfm jar-file manifest input-files` | Maxsus manifest bilan JAR yaratish |
| **Ishga tushirish** | `java -jar jar-file` | JAR ni ishga tushirish |
| **Classpath bilan** | `java -cp jar-file MainClass` | JAR ni classpath orqali ishga tushirish |

### JAR option kombinatsiyalari

```bash
# 1. Create + File + Verbose
jar cvf myapp.jar *.class

# 2. Create + File + Manifest
jar cfm myapp.jar manifest.txt *.class

# 3. Create + File + Entrypoint
jar cfe myapp.jar MainClass *.class

# 4. Create + File + Manifest + Entrypoint
jar cfme myapp.jar manifest.txt MainClass *.class
# (e va m birga ishlatilganda, m birinchi kelishi kerak)

# 5. Extract + File + Verbose
jar xvf myapp.jar

# 6. Update + File + Verbose
jar uvf myapp.jar newfile.class
```

---

## 5.7 - JAR bilan ishlash bo'yicha maslahatlar

### 1. JAR nomlash konvensiyasi

```bash
# Maven/Gradle style
myapp-1.0.0.jar
myapp-1.0.0-SNAPSHOT.jar
myapp-2.0.0.jar

# Version ma'lumotlari
utils-1.2.3.jar
database-driver-2.1.0.jar
logging-framework-3.0.0.jar
```

### 2. Manifest ga qo'shimcha ma'lumotlar

```properties
# To'liq manifest
Manifest-Version: 1.0
Created-By: 17.0.2 (Oracle Corporation)
Main-Class: com.myapp.Main
Class-Path: lib/utils.jar lib/db.jar
Implementation-Title: My Application
Implementation-Version: 2.1.3
Implementation-Vendor: PDP Academy
Implementation-Vendor-Id: com.pdp
Implementation-URL: https://pdp.uz
```

### 3. JAR faylni tekshirish

```bash
# 1. JAR tarkibini tekshirish
jar tf myapp.jar | grep Main.class

# 2. Manifest ni tekshirish
jar xf myapp.jar META-INF/MANIFEST.MF
cat META-INF/MANIFEST.MF

# 3. JAR validligini tekshirish
java -jar myapp.jar || echo "JAR is not executable"
```

### 4. JAR faylni optimize qilish

```bash
# 1. Keraksiz fayllarni olib tashlash
jar xf myapp.jar
rm -rf META-INF/*.SF META-INF/*.RSA META-INF/*.DSA
jar cf myapp-clean.jar .

# 2. Kompressiya darajasini sozlash
# 0 - kompressiyasiz (tezroq)
jar c0f myapp-fast.jar build/classes/*

# 3. Index yaratish (tezroq class loading)
jar i myapp.jar
```

---

## Tekshiruv Savollari

1. **JAR fayl nima va u qanday afzalliklarga ega?**
2. **JAR yaratish uchun qanday komanda ishlatiladi?**
3. **Manifest fayl nima va u qayerda joylashgan?**
4. **Main-Class header'ining vazifasi nima?**
5. **Executable JAR qanday yaratiladi?**
6. **JAR tarkibini ko'rish uchun qanday komanda ishlatiladi?**
7. **JAR dan fayl chiqarish uchun qanday komanda ishlatiladi?**
8. **JAR ga yangi fayl qo'shish uchun nima qilish kerak?**
9. **'e' flag nima uchun ishlatiladi?**
10. **JAR faylni ishga tushirishning ikki usulini ayting?**

---

## Amaliy Topshiriq

Quyidagi imkoniyatlarga ega executable JAR yarating:

1. **Calculator** - 4 amal bajaruvchi oddiy kalkulyator
2. **Resurs fayl** - JAR ichidan config fayl o'qish
3. **Manifest** - To'liq ma'lumotli manifest (version, vendor)
4. **Class-Path** - Tashqi library'larga bog'lanish

```bash
# Topshiriqni tekshirish:
java -jar calculator.jar --help
java -jar calculator.jar 5 + 3
# Natija: 5 + 3 = 8
```

---

## JAR Command Cheat Sheet

```bash
# ===== CREATE =====
jar cf app.jar *.class                    # Oddiy JAR
jar cvf app.jar *.class                    # Verbose
jar cfe app.jar MainClass *.class          # With entrypoint
jar cfm app.jar manifest.txt *.class       # With manifest

# ===== VIEW =====
jar tf app.jar                             # List contents
jar tvf app.jar                             # Verbose list

# ===== EXTRACT =====
jar xf app.jar                              # Extract all
jar xf app.jar Main.class                    # Extract specific
jar xvf app.jar                              # Extract verbose

# ===== UPDATE =====
jar uf app.jar newfile.class                 # Add file
jar uvf app.jar newfile.class                 # Add verbose

# ===== RUN =====
java -jar app.jar                            # Run executable
java -cp app.jar MainClass                    # Run with classpath
```

---

**Keyingi mavzu:** [Web Servisler](./06_Web_Services.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
