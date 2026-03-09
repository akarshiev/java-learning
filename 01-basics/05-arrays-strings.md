# 05 - Massivlar va Satrlar (Arrays & Strings)

## SATRLAR (Strings)

### String nima?

**String** - belgilar (char) ketma-ketligi. Java-da String **class** hisoblanadi.

```java
// String yaratish usullari
String str1 = "Salom";                    // String literal
String str2 = new String("Dunyo");        // new operatori bilan
char[] chars = {'J', 'a', 'v', 'a'};
String str3 = new String(chars);          // char massividan
```

### String Literal vs new String()

```java
public class StringYaratish {
    public static void main(String[] args) {
        // 1. String Pool (Literal)
        String s1 = "Java";
        String s2 = "Java";  // Xotirada bir joyga murojaat qiladi
        System.out.println(s1 == s2);  // true (bir xil reference)

        // 2. Heap memory (new bilan)
        String s3 = new String("Java");
        String s4 = new String("Java");  // Xotirada alohida joylar
        System.out.println(s3 == s4);    // false (alohida reference)
        System.out.println(s3.equals(s4)); // true (kontent bir xil)
    }
}
```

### String Immutable (O'zgarmas) Xususiyati

String o'zgarmas - yaratilgandan keyin uning qiymatini o'zgartirib bo'lmaydi.

```java
public class ImmutableString {
    public static void main(String[] args) {
        String str = "Salom";
        str.concat(" Java");  // Yangi String yaratadi
        System.out.println(str);  // "Salom" (o'zgarmadi!)

        // To'g'ri usul
        str = str.concat(" Java");  // Yangi reference
        System.out.println(str);  // "Salom Java"
    }
}
```

### String Metodlari

```java
public class StringMetodlari {
    public static void main(String[] args) {
        String text = "Java Programming is fun!";

        // Uzunlik
        System.out.println("Uzunlik: " + text.length());  // 23

        // Belgini olish
        System.out.println("3-indeksdagi belgi: " + text.charAt(3));  // 'a'

        // Substring (qismini olish)
        System.out.println("6-16 gacha: " + text.substring(6, 16));  // "rogramming"

        // Taqqoslash
        String str1 = "Java";
        String str2 = "java";
        System.out.println("equals: " + str1.equals(str2));           // false
        System.out.println("equalsIgnoreCase: " + str1.equalsIgnoreCase(str2)); // true

        // Qidirish
        System.out.println("'Pro' indeksi: " + text.indexOf("Pro"));  // 5
        System.out.println("Oxirgi 'a': " + text.lastIndexOf('a'));   // 20

        // O'zgartirish
        System.out.println("Katta harf: " + text.toUpperCase());  // "JAVA PROGRAMMING IS FUN!"
        System.out.println("Kichik harf: " + text.toLowerCase());  // "java programming is fun!"
        System.out.println("Trim: '" + "  Java  ".trim() + "'");   // "Java"

        // Almashtirish
        System.out.println("Replace: " + text.replace('a', 'o'));  // "Jovo Progromming is fun!"

        // Bo'lish
        String[] words = text.split(" ");
        System.out.println("So'zlar soni: " + words.length);  // 4
        for (String word : words) {
            System.out.println(word);
        }
    }
}
```

### StringBuilder va StringBuffer

String ustida ko'p o'zgartirishlar kerak bo'lsa, StringBuilder/StringBuffer ishlatiladi.

```java
public class StringBuilderBuffer {
    public static void main(String[] args) {
        // StringBuilder (tezroq, thread-safe emas)
        StringBuilder sb1 = new StringBuilder();
        sb1.append("Java");
        sb1.append(" Programming");
        sb1.insert(5, "Awesome ");
        System.out.println("StringBuilder: " + sb1.toString());  // Java Awesome Programming

        // StringBuffer (sekinroq, thread-safe)
        StringBuffer sb2 = new StringBuffer();
        sb2.append("Hello");
        sb2.append(" World");
        sb2.reverse();
        System.out.println("StringBuffer: " + sb2.toString());  // dlroW olleH

        // Qiyoslash
        long startTime = System.currentTimeMillis();
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < 100000; i++) {
            builder.append(i);
        }
        long builderTime = System.currentTimeMillis() - startTime;

        startTime = System.currentTimeMillis();
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < 100000; i++) {
            buffer.append(i);
        }
        long bufferTime = System.currentTimeMillis() - startTime;

        System.out.println("StringBuilder vaqti: " + builderTime + "ms");
        System.out.println("StringBuffer vaqti: " + bufferTime + "ms");
    }
}
```

### StringTokenizer (Eski usul)

```java
import java.util.StringTokenizer;

public class StringTokenizerExample {
    public static void main(String[] args) {
        String text = "Java,Python,C++,JavaScript";

        // Eski usul (StringTokenizer)
        StringTokenizer tokenizer = new StringTokenizer(text, ",");
        System.out.println("Tokens (StringTokenizer):");
        while (tokenizer.hasMoreTokens()) {
            System.out.println(tokenizer.nextToken());
        }

        // Yangi usul (split)
        System.out.println("\nTokens (split):");
        String[] languages = text.split(",");
        for (String lang : languages) {
            System.out.println(lang);
        }
    }
}
```

---

## MASSIVLAR (Arrays)

### Massiv nima?

**Massiv** - bir xil turdagi elementlarning ketma-ketligi.

```java
public class MassivAsoslari {
    public static void main(String[] args) {
        // Massiv yaratish usullari
        int[] numbers1 = new int[5];               // 5 elementli, default 0
        int[] numbers2 = {1, 2, 3, 4, 5};          // qiymatlar bilan
        int[] numbers3 = new int[]{10, 20, 30};    // explicit

        // Elementlarga murojaat
        numbers1[0] = 100;
        numbers1[1] = 200;

        // Uzunlik
        System.out.println("numbers2 uzunligi: " + numbers2.length);  // 5

        // Aylantirish (loop)
        System.out.println("numbers2 elementlari:");
        for (int i = 0; i < numbers2.length; i++) {
            System.out.println("numbers2[" + i + "] = " + numbers2[i]);
        }

        // Enhanced for loop
        System.out.println("\nnumbers3 elementlari:");
        for (int num : numbers3) {
            System.out.println(num);
        }
    }
}
```

### Ko'p o'lchamli Massivlar

```java
public class KopOlchamliMassiv {
    public static void main(String[] args) {
        // 2D massiv (matrix)
        int[][] matrix = {
                {1, 2, 3},
                {4, 5, 6},
                {7, 8, 9}
        };

        System.out.println("2D Massiv:");
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println();
        }

        // 3D massiv
        int[][][] cube = new int[2][3][4];

        // Qiymat berish
        int value = 1;
        for (int i = 0; i < cube.length; i++) {
            for (int j = 0; j < cube[i].length; j++) {
                for (int k = 0; k < cube[i][j].length; k++) {
                    cube[i][j][k] = value++;
                }
            }
        }
    }
}
```

### Massiv Metodlari

```java
import java.util.Arrays;

public class MassivMetodlari {
    public static void main(String[] args) {
        int[] numbers = {5, 2, 8, 1, 9, 3};

        // Tartiblash
        Arrays.sort(numbers);
        System.out.println("Tartiblangan: " + Arrays.toString(numbers));  // [1, 2, 3, 5, 8, 9]

        // Qidirish (tartiblangan massivda)
        int index = Arrays.binarySearch(numbers, 5);
        System.out.println("5 ning indeksi: " + index);  // 3

        // To'ldirish
        int[] filled = new int[5];
        Arrays.fill(filled, 42);
        System.out.println("To'ldirilgan: " + Arrays.toString(filled));  // [42, 42, 42, 42, 42]

        // Nusxa olish
        int[] copy1 = Arrays.copyOf(numbers, 3);          // birinchi 3 ta
        int[] copy2 = Arrays.copyOfRange(numbers, 2, 5);  // 2-indekstdan 5-gacha

        // Taqqoslash
        int[] arr1 = {1, 2, 3};
        int[] arr2 = {1, 2, 3};
        System.out.println("Arrays.equals: " + Arrays.equals(arr1, arr2));  // true

        // Deep equals (ko'p o'lchamli)
        int[][] deep1 = {{1, 2}, {3, 4}};
        int[][] deep2 = {{1, 2}, {3, 4}};
        System.out.println("Arrays.deepEquals: " + Arrays.deepEquals(deep1, deep2));  // true
    }
}
```

---

## FORMATLASH (Formatting)

### printf Metodi

```java
public class Formatlash {
    public static void main(String[] args) {
        String ism = "Abdukarim";
        int yosh = 25;
        double maosh = 3500.75;

        // Asosiy format specifier'lar
        System.out.printf("Ism: %s%n", ism);           // Ism: Abdukarim
        System.out.printf("Yosh: %d%n", yosh);         // Yosh: 25
        System.out.printf("Maosh: %.2f%n", maosh);     // Maosh: 3500.75

        // Barchasini birga
        System.out.printf("%s %d yoshda, maoshi $%.2f%n", ism, yosh, maosh);

        // Katta/kichik harf farqi
        System.out.printf("Kichik: %s, Katta: %S%n", ism, ism);  // Abdukarim, ABDUKARIM

        // Format specifier struktura:
        // %[argument_index$][flags][width][.precision]conversion

        // Width (kenglik)
        System.out.printf("|%10s|%n", ism);     // | Abdukarim| (o'ng tomonga)
        System.out.printf("|%-10s|%n", ism);    // |Abdukarim | (chap tomonga)

        // Precision (aniqlik)
        double pi = Math.PI;
        System.out.printf("PI: %f%n", pi);        // 3.141593
        System.out.printf("PI: %.2f%n", pi);      // 3.14
        System.out.printf("PI: %.4f%n", pi);      // 3.1416

        // Flags (bayroqlar)
        int number = 123;
        System.out.printf("|%10d|%n", number);    // |       123|
        System.out.printf("|%-10d|%n", number);   // |123       |
        System.out.printf("|%010d|%n", number);   // |0000000123| (0 bilan to'ldirish)
        System.out.printf("|%+d|%n", number);     // |+123| (belgisi bilan)

        // Argument index
        System.out.printf("%2$s %1$d %2$S%n", yosh, ism);  // Abdukarim 25 ABDUKARIM
    }
}
```

### String.format()

```java
public class StringFormat {
    public static void main(String[] args) {
        // String.format() - natijani String qaytaradi
        String formatted = String.format("Ism: %s, Yosh: %d", "Ali", 30);
        System.out.println(formatted);  // Ism: Ali, Yosh: 30

        // Jadval yaratish
        String[] ismlar = {"Ali", "Vali", "Hasan"};
        int[] yoshlar = {25, 30, 35};
        double[] maoshlar = {2500.5, 3000.75, 4000.0};

        System.out.println("\n=== XODIMLAR RO'YXATI ===");
        System.out.println("+------------+------+---------+");
        System.out.println("| Ism        | Yosh | Maosh   |");
        System.out.println("+------------+------+---------+");

        for (int i = 0; i < ismlar.length; i++) {
            System.out.printf("| %-10s | %4d | $%7.2f |%n",
                    ismlar[i], yoshlar[i], maoshlar[i]);
        }

        System.out.println("+------------+------+---------+");
    }
}
```

---

## MUHIM ESDA TUTISH KERAK

1. **String immutable** - o'zgarmas, har o'zgartirish yangi String yaratadi
2. **StringBuilder vs StringBuffer**:
    - **StringBuilder**: tez, thread-safe emas
    - **StringBuffer**: sekin, thread-safe
3. **Massivlar fixed size** - yaratilgandan keyin o'lchami o'zgarmaydi
4. **Arrays.sort()** faqat tartiblangan massivda ishlaydi
5. **printf format**: `%[flags][width][.precision]type`

---

**🎉 Congrats!** Asosiy Java tushunchalari yakunlandi!

> 💡 **Eslatma:** Asosiy tushunchalarni yaxshi o'zlashtirish keyingi murakkab mavzularni o'rganish uchun mustahkam
> poydevor bo'ladi. Har bir misolni o'zingiz yozib ko'ring va tushunmagan joylaringizni qayta ko'rib chiqing!

---

## KEYINGI QADAMLAR

### 1. Intervyu Savollari

O'z bilimingizni sinab ko'ring:  
[Interviews/01_Basics_Interview.md](../Interviews/01_Basics_Interview.md)

### 2. Loyiha Topshiriqlari

Amaliyot uchun:  
[Assignments/01_Basics_assignment.md](../Assignments/01_Basics_assignment.md)

### 3. Mundarijaga Qaytish

[Mundarija](../README.md)

---

**🚀 O'qishda davom etamiz! Keyingi modulda ko'rishguncha**