# 04 - Metodlar (Methods)

## Metodlar haqida tushuncha

**Metod** - bu ma'lum bir vazifani bajaruvchi kod bloki. Java-da har bir metod **class** ichida joylashgan bo'lishi kerak.

### Function vs Method
- **Function** - mustaqil kod bloki (C, Python kabi tillarda)
- **Method** - class'ga tegishli funktsiya (Java-da faqat metodlar mavjud)

Java-da function yozib bo'lmaydi, chunki Java-da **har bir kod class ichida** yozilgan bo'lishi kerak.

---

## Metod Aniqlash (Method Definition)

```java
// Metod deklaratsiyasi (header)
public int add(int a, int b) {
    // metod tanasi (body)
    int result = a + b;
    return result;
}
```

### Metod Komponentlari:
1. **Access Modifier** (`public`) - kirish ruxsati
2. **Return Type** (`int`) - qaytariladigan qiymat turi
3. **Method Name** (`add`) - metod nomi
4. **Parameters** (`int a, int b`) - kirish parametrlari
5. **Method Body** `{...}` - metod tanasi
6. **Return Statement** (`return result`) - qiymat qaytarish

---

## Metod Turlari

### 1. Qiymat Qaytaruvchi Metodlar (Value-Returning Methods)

```java
// Butun son qaytaruvchi metod
public int kvadrat(int x) {
    return x * x;
}

// Haqiqiy son qaytaruvchi metod
public double aylanaYuzi(double radius) {
    return Math.PI * radius * radius;
}

// Satr qaytaruvchi metod
public String salomBer(String ism) {
    return "Salom, " + ism + "!";
}

// Mantiqiy qiymat qaytaruvchi metod
public boolean juftSonmi(int son) {
    return son % 2 == 0;
}
```

### 2. Void Metodlar (Qiymat Qaytarmaydigan)

```java
// Hech narsa qaytarmaydigan metod
public void printHelloWorld() {
    System.out.println("Salom, dunyo!");
}

// Parametrli void metod
public void printName(String ism) {
    System.out.println("Sizning ismingiz: " + ism);
}

// Bir nechta parametrli void metod
public void printInfo(String ism, int yosh, boolean talaba) {
    System.out.println("Ism: " + ism);
    System.out.println("Yosh: " + yosh);
    System.out.println("Talaba: " + (talaba ? "Ha" : "Yo'q"));
}
```

---

## Metodlarni Chaqirish (Method Invocation)

```java
public class MetodlarMisol {
    
    // 1. Qiymat qaytaruvchi metod
    public static int add(int a, int b) {
        return a + b;
    }
    
    // 2. Void metod
    public static void printHello(String ism) {
        System.out.println("Salom, " + ism + "!");
    }
    
    // 3. Parametrsiz metod
    public static void printTime() {
        System.out.println("Hozirgi vaqt: " + java.time.LocalTime.now());
    }
    
    public static void main(String[] args) {
        // Metodlarni chaqirish
        
        // 1. Void metodni chaqirish
        printHello("Ali");  // Salom, Ali!
        
        // 2. Qiymat qaytaruvchi metodni chaqirish
        int summa = add(5, 3);
        System.out.println("Yig'indi: " + summa);  // Yig'indi: 8
        
        // 3. To'g'ridan-to'g'ri chiqishda
        System.out.println("Ko'paytma: " + multiplication(4, 5));  // Ko'paytma: 20
        
        // 4. Parametrsiz metod
        printTime();
        
        // 5. Metodni metod ichida chaqirish
        returnTwoResult(10, 2);
    }
    
    public static int multiplication(int a, int b) {
        return a * b;
    }
    
    public static void returnTwoResult(int x, int y) {
        System.out.println("Qo'shish: " + add(x, y));
        System.out.println("Ko'paytirish: " + multiplication(x, y));
    }
}
```

---

## Parametrlar va Argumentlar

```java
public class Parametrlar {
    
    // Formal parametrlar (e'lon qilinadi)
    public static void maoshniHisobla(String ism, double asosiyMaosh, double bonus) {
        double jamiMaosh = asosiyMaosh + bonus;
        System.out.println(ism + "ning oylik maoshi: $" + jamiMaosh);
    }
    
    public static void main(String[] args) {
        // Aktual argumentlar (chaqirilganda beriladi)
        maoshniHisobla("Ali", 1500.0, 300.0);  // Ali oylik maoshi: $1800.0
        maoshniHisobla("Vali", 2000.0, 500.0); // Vali oylik maoshi: $2500.0
        
        // O'zgaruvchilardan argument sifatida foydalanish
        String ism = "Hasan";
        double maosh = 1800.0;
        double bonus = 400.0;
        maoshniHisobla(ism, maosh, bonus);  // Hasan oylik maoshi: $2200.0
    }
}
```

### Parametr Turlari:

1. **Value Parameters** (Qiymat parametrlari)
```java
public void kvadrat(int x) {  // x - qiymat parametri
    x = x * x;
}

public static void main(String[] args) {
    int son = 5;
    kvadrat(son);
    System.out.println(son);  // 5 (o'zgarmaydi)
}
```

2. **Reference Parameters** (Ma'lumotnoma parametrlari)
```java
public void arrayAddNumber(int[] arr) {  // arr - ma'lumotnoma parametri
    arr[0] = 100;
}

public static void main(String[] args) {
    int[] numbers = {1, 2, 3};
    arrayAddNumber(numbers);
    System.out.println(numbers[0]);  // 100 (o'zgaradi)
}
```

---

## Rekursiya (Recursion)

**Rekursiya** - metodning o'zini o'zini chaqirishi.

### Rekursiya uchun 3 ta shart:
1. **O'zini o'zini chaqirishi kerak**
2. **Base condition (asosiy shart) bo'lishi kerak** - to'xtash sharti
3. **Metod o'zini o'zgartirishi kerak** - har chaqiruvda holat o'zgarishi kerak

### 1. Oddiy Rekursiya Misoli
```java
public class RekursiyaMisol {
    
    static void rekursiya(int n) {
        if (n > 0) {               // 1) Base condition
            System.out.println(n);  // Joriy qiymatni chiqar
            n = n - 1;              // 3) Holatni o'zgartir
            rekursiya(n);           // 2) O'zini chaqir
        }
    }
    
    public static void main(String[] args) {
        rekursiya(5);
        // Chiqish:
        // 5
        // 4
        // 3
        // 2
        // 1
    }
}
```

### 2. Faktorialni Rekursiya bilan Hisoblash
```java
public class Faktorial {
    
    // Rekursiv metod
    static int faktorial(int n) {
        if (n == 0 || n == 1) {  // Base case
            return 1;
        } else {                  // Recursive case
            return n * faktorial(n - 1);
        }
    }
    
    public static void main(String[] args) {
        int son = 5;
        int natija = faktorial(son);
        System.out.println(son + "! = " + natija);  // 5! = 120
        
        // Kichik misollar:
        System.out.println("0! = " + faktorial(0));  // 1
        System.out.println("1! = " + faktorial(1));  // 1
        System.out.println("4! = " + faktorial(4));  // 24
    }
}
```

**Faktorial ishlashi:**
```
faktorial(5) = 5 * faktorial(4)
             = 5 * (4 * faktorial(3))
             = 5 * (4 * (3 * faktorial(2)))
             = 5 * (4 * (3 * (2 * faktorial(1))))
             = 5 * (4 * (3 * (2 * 1)))
             = 120
```

### 3. Fibonacci Rekursiyasi
```java
public class Fibonacci {
    
    static int fibonacci(int n) {
        if (n <= 1) {            // Base case
            return n;
        } else {                 // Recursive case
            return fibonacci(n - 1) + fibonacci(n - 2);
        }
    }
    
    public static void main(String[] args) {
        System.out.println("Fibonacci ketma-ketligi:");
        for (int i = 0; i < 10; i++) {
            System.out.print(fibonacci(i) + " ");
        }
        // Chiqish: 0 1 1 2 3 5 8 13 21 34
    }
}
```

### 4. Rekursiyani To'g'ri Ishlatish
```java
public class RekursiyaXato {
    
    // Noto'g'ri: Base condition yo'q
    static void cheksizRekursiya(int n) {
        System.out.println(n);
        cheksizRekursiya(n + 1);  // CHEKSIZ REKURSIYA!
    }
    
    // To'g'ri: Base condition bor
    static void togriRekursiya(int n) {
        if (n <= 10) {            // Base condition
            System.out.println(n);
            togriRekursiya(n + 1);  // Holat o'zgaradi
        }
    }
    
    public static void main(String[] args) {
        // cheksizRekursiya(1);  // StackOverflowError!
        togriRekursiya(1);        // 1 dan 10 gacha chiqaradi
    }
}
```

---

## Method Overloading

Bir xil nomli, lekin parametrlari farqli metodlar.

```java
public class MethodOverloading {
    
    // 1. Parametrlar soni farqli
    public static int qoshish(int a, int b) {
        return a + b;
    }
    
    public static int qoshish(int a, int b, int c) {
        return a + b + c;
    }
    
    // 2. Parametr turlari farqli
    public static double qoshish(double a, double b) {
        return a + b;
    }
    
    public static String qoshish(String a, String b) {
        return a + b;
    }
    
    // 3. Parametrlar tartibi farqli
    public static void maqomniChiqar(String ism, int yosh) {
        System.out.println(ism + ", " + yosh + " yosh");
    }
    
    public static void maqomniChiqar(int yosh, String ism) {
        System.out.println(yosh + " yoshli " + ism);
    }
    
    public static void main(String[] args) {
        System.out.println("Ikkita int: " + qoshish(5, 3));          // 8
        System.out.println("Uchta int: " + qoshish(5, 3, 2));        // 10
        System.out.println("Ikkita double: " + qoshish(5.5, 3.2));   // 8.7
        System.out.println("Ikkita String: " + qoshish("Salom ", "Java")); // Salom Java
        
        maqomniChiqar("Ali", 25);  // Ali, 25 yosh
        maqomniChiqar(25, "Ali");  // 25 yoshli Ali
    }
}
```

---

## Static va Non-Static Metodlar

```java
public class StaticMetodlar {
    
    // Static metod - classga tegishli
    static void staticMetod() {
        System.out.println("Bu static metod");
    }
    
    // Non-static metod - objectga tegishli
    void nonStaticMetod() {
        System.out.println("Bu non-static metod");
    }
    
    public static void main(String[] args) {
        // Static metodni to'g'ridan-to'g'ri chaqirish mumkin
        staticMetod();  // Bu static metod
        
        // Non-static metodni object orqali chaqirish kerak
        StaticMetodlar obj = new StaticMetodlar();
        obj.nonStaticMetod();  // Bu non-static metod
        
        // Static metodni object orqali ham chaqirish mumkin
        obj.staticMetod();  // Bu static metod (lekin tavsiya etilmaydi)
    }
}
```

---

## Amaliy Loyiha: Kalkulyator Metodlari

```java
public class KalkulyatorMetodlari {
    
    // 1. Asosiy arifmetik amallar
    public static double qoshish(double a, double b) {
        return a + b;
    }
    
    public static double ayirish(double a, double b) {
        return a - b;
    }
    
    public static double kopaytirish(double a, double b) {
        return a * b;
    }
    
    public static double bolish(double a, double b) {
        if (b != 0) {
            return a / b;
        } else {
            System.out.println("Xato: Nolga bo'lish mumkin emas!");
            return Double.NaN;  // Not a Number
        }
    }
    
    // 2. Qo'shimcha funksiyalar
    public static double kvadrat(double x) {
        return x * x;
    }
    
    public static double kub(double x) {
        return x * x * x;
    }
    
    public static double faktorial(int n) {
        if (n < 0) return -1;  // Xato kodi
        if (n == 0) return 1;
        return n * faktorial(n - 1);
    }
    
    // 3. Rekursiyali Fibonacci
    public static int fibonacci(int n) {
        if (n <= 1) return n;
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
    
    // 4. Asosiy metod - test qilish
    public static void main(String[] args) {
        System.out.println("--- Calculator Methods");
        
        System.out.println("5 + 3 = " + qoshish(5, 3));
        System.out.println("10 - 4 = " + ayirish(10, 4));
        System.out.println("6 * 7 = " + kopaytirish(6, 7));
        System.out.println("15 / 3 = " + bolish(15, 3));
        System.out.println("5 / 0 = " + bolish(5, 0));
        
        System.out.println("\n4 kvadrati = " + kvadrat(4));
        System.out.println("3 kubi = " + kub(3));
        System.out.println("5 faktorial = " + faktorial(5));
        
        System.out.println("\nFibonacci ketma-ketligi (ilk 10 ta):");
        for (int i = 0; i < 10; i++) {
            System.out.print(fibonacci(i) + " ");
        }
    }
}
```

> **Eslatma:** Metodlar - kodni qayta ishlatish va tartibga solishning asosiy vositasi. Yaxshi tuzilgan metodlar dasturingizni o'qish va saqlashni osonlashtiradi!

---

**Keyingi mavzu**: [05 - Massivlar va Satrlar (Arrays & Strings)](./05_Arrays_Strings.md)  
**[Mundarijaga qaytish](../README.md)**

> ⚡️ O'rganishda davom etamiz!