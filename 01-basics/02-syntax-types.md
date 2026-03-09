# Oʻzgaruvchilar va Ma'lumot Turlari (Variables and Data Types)

### Java Ma'lumot Turlari Tizimi

Java qat'iy tipga ega (strongly typed) dasturlash tili hisoblanadi. Bu har bir o'zgaruvchi turi oldindan aniq
belgilanishi kerakligini anglatadi.

## Ma'lumot Turlari (Data Types)

![Data Types in Java](../Images/Data_types.png)

Java-da ikki turdagi ma'lumot turlari mavjud:

### Primitive (Oddiy) Ma'lumot Turlari

#### 1. Butun Sonlar (Integer Types)

| Tur       | Hajmi  | Qiymat Oraligi           | Misol               |
|-----------|--------|--------------------------|---------------------|
| **byte**  | 8 bit  | -128 dan 127 gacha       | `byte b = 100;`     |
| **short** | 16 bit | -32,768 dan 32,767 gacha | `short s = 1000;`   |
| **int**   | 32 bit | -2³¹ dan 2³¹-1 gacha     | `int i = 100000;`   |
| **long**  | 64 bit | -2⁶³ dan 2⁶³-1 gacha     | `long l = 100000L;` |

**Byte oralig'ini hisoblash formula:**

```
[-2^(n-1); 2^(n-1) -1]
n = bitlar soni

Misol: byte uchun (n=8)
-2^(8-1) = -128
2^(8-1) -1 = 127
```

#### 2. Haqiqiy Sonlar (Floating-Point Types)

| Tur        | Hajmi  | Aniqlik  | Misol                 |
|------------|--------|----------|-----------------------|
| **float**  | 32 bit | 6-7 xona | `float f = 3.14f;`    |
| **double** | 64 bit | 15 xona  | `double d = 3.14159;` |

**Eslatma:** `float` qiymatlar oxirida `f` qo'yish shart!

#### 3. Boshqa Primitive Turlar

| Tur         | Hajmi  | Tavsif          | Misol                  |
|-------------|--------|-----------------|------------------------|
| **boolean** | 1 bit  | Mantiqiy qiymat | `boolean flag = true;` |
| **char**    | 16 bit | Bitta belgi     | `char c = 'A';`        |

#### 2-lik (Binary) Sanoq Sistemasi

Java-da 2-lik sonlarni `0b` prefiksi bilan ifodalash mumkin:

```java
int binaryNumber = 0b11111111;  // 10-likda: 255
System.out.println(binaryNumber);  // 255 chiqadi

// Boshqa misollar:
int a = 0b1010;     // 10
int b = 0b10000;    // 16
int c = 0b1111;     // 15
```

### 2. Non-primitive Turlari

Bu obyektlarga havola (reference) bo'ladi:

- `String` - Matnlar
- `Array` - Massivlar
- `Class` - Klasslar
- `Interface` - Interfeyslar

```java
String name = "Ali";      // String obyekti
int[] numbers = {1, 2, 3}; // Massiv
Object obj = new Object(); // Klass obyekti
```

## Console-dan Ma'lumot Olish

Java-da foydalanuvchi kiritishini ikki usulda olish mumkin:

### 1. Scanner Klassi
```java
import java.util.Scanner;

public class ScannerExample {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.print("Ismingizni kiriting: ");
        String name = scanner.nextLine();
        
        System.out.print("Yoshingizni kiriting: ");
        int age = scanner.nextInt();
        
        System.out.println("Salom, " + name + "! Siz " + age + " yoshdasiz.");
        
        scanner.close();
    }
}
```

### 2. Console Klassi
```java
import java.io.Console;

public class ConsoleExample {
    public static void main(String[] args) {
        Console console = System.console();
        
        if (console != null) {
            String name = console.readLine("Ismingizni kiriting: ");
            char[] password = console.readPassword("Parolingizni kiriting: ");
            
            console.printf("Salom, %s!\n", name);
        } else {
            System.out.println("Console mavjud emas!");
        }
    }
}
```

### Farqlar:
| Xususiyat | Scanner | Console |
|-----------|---------|---------|
| **Parol o'qish** | Yo'q | `readPassword()` bilan |
| **Mavjudlik** | Har doim mavjud | Terminalda ishlamaydi |
| **Import** | `java.util.Scanner` | `java.io.Console` |
| **Oddiylik** | Oddiyroq | Murakkabroq |


## Ma'lumot Yo'qolishi (Data Loss)

Ba'zi konvertatsiyalarda ma'lumot yo'qolishi mumkin:

```java
int a = 1000;
float b = a;           // aniqligi yo'qolishi mumkin

long x = 123456789012345L;
float y = x;           // Ma'lumot yo'qolishi mumkin (float 32-bit)

long z = 123456789012345L;
double w = z;          // Yaxshi (double 64-bit)
```

## Casting (Tur O'zgartirish)

### 1. Widening Casting (Avtomatik - Kichikdan Kattaga)

Java avtomatik ravishda bajaradi:

```java
byte ->short ->char ->int ->long ->float ->double
```

**Misollar:**

```java
byte small = 10;
int medium = small;        // Avtomatik

short sh = 100;
float fl = sh;             // Avtomatik

int num = 100;
double dbl = num;          // Avtomatik (100.0)
```

### 2. Narrowing Casting (Aniq - Kattadan Kichikka)

Dasturchi aniq ko'rsatishi kerak:

```java
double ->float ->long ->int ->char ->short ->byte
```

**Misollar:**

```java
int a = 100;
byte b = (byte) a;         // Aniq cast qilish

double price = 99.99;
int intPrice = (int) price; // 99 bo'ladi (kasr qismi yo'qoladi)

short sh = 123;
byte b = (byte) sh;         // Agar sh < 128 bo'lsa, ma'lumot yo'qolmaydi
```

**Xavfli holat:**

```java
int large = 130;
byte small = (byte) large;  // -126 bo'ladi (overflow)
```

## Bitwise Operators (Bitli Operatorlar)

Bitli operatorlar raqamlarni bit darajasida taqqoslaydi:

### 1. OR (|) - YOKI

Agar bitlardan biri 1 bo'lsa, natija 1:

| x | y | x \| y |
|---|---|--------|
| 1 | 1 | 1      |
| 1 | 0 | 1      |
| 0 | 1 | 1      |
| 0 | 0 | 0      |

```java
int a = 5;    // 0101
int b = 3;    // 0011
int c = a | b; // 0111 = 7
```

### 2. AND (&) - VA

Ikkala bit ham 1 bo'lsa, natija 1:

| x | y | x & y |
|---|---|-------|
| 1 | 1 | 1     |
| 1 | 0 | 0     |
| 0 | 1 | 0     |
| 0 | 0 | 0     |

```java
int a = 5;    // 0101
int b = 3;    // 0011
int c = a & b; // 0001 = 1
```

### 3. XOR (^) - Exclusive OR

Bitlar farq qilsa, natija 1:

| x | y | x ^ y |
|---|---|-------|
| 1 | 1 | 0     |
| 1 | 0 | 1     |
| 0 | 1 | 1     |
| 0 | 0 | 0     |

```java
int a = 5;    // 0101
int b = 3;    // 0011
int c = a ^ b; // 0110 = 6
```

### 4. Complement (~) - INKOR

Har bir bitni teskariga o'zgartiradi:

```java
int a = 2;     // ...0010
int b = ~a;    // ...1101 = -3

int x = -2;    // ...1110
int y = ~x;    // ...0001 = 1
```

**Qoida:** `~n = -(n+1)`

- `~2 = -3`
- `~-2 = 1`

## Operator Precedence (Operatorlar Ustuvorligi)

Operatorlar ma'lum tartibda bajariladi:

```java
int a = 3;
int b = 5;
int c = 7;

a +=b +=c;  // O'ngdan chapga: b = b + c (12), keyin a = a + b (15)

// Natija: a=15, b=12, c=7
```

### Post-increment Murakkab Holati

```java
int x = 2;
int y = 4;

int r1 = x++ + y;  // Bu: (x++) + y

// Qadamlar:
// 1. x++ (x=2, keyin x=3 bo'ladi)
// 2. 2 + y (y=4)
// 3. Natija: 6
// 4. Endi x=3

System.out.

println(r1); // 6
System.out.

println(x);  // 3
```

**Yana bir misol:**

```java
int a = 5;
int b = a++ + ++a;
// Qadamlar:
// 1. a++ = 5 (end a=6)
// 2. ++a = 7 (a=7)
// 3. 5 + 7 = 12
// Natija: b=12, a=7
```

## Amaliy Misollar

### Misol 1: Tur O'zgartirish

```java
public class CastingExample {
    public static void main(String[] args) {
        // Widening (avtomatik)
        int num = 100;
        double dbl = num;
        System.out.println("int -> double: " + dbl);

        // Narrowing (aniq)
        double price = 99.95;
        int intPrice = (int) price;
        System.out.println("double -> int: " + intPrice);
    }
}
```

### Misol 2: Bitli Amallar

```java
public class BitwiseExample {
    public static void main(String[] args) {
        int a = 12;  // 1100
        int b = 5;   // 0101

        System.out.println("a | b = " + (a | b));  // 1101 = 13
        System.out.println("a & b = " + (a & b));  // 0100 = 4
        System.out.println("a ^ b = " + (a ^ b));  // 1001 = 9
        System.out.println("~a = " + (~a));        // -13
    }
}
```

### Misol 3: Operatorlar Ustuvorligi

```java
public class PrecedenceExample {
    public static void main(String[] args) {
        int x = 10;
        int y = 5;
        int z = 2;

        int result = x + y * z;      // 10 + (5*2) = 20
        System.out.println("x + y * z = " + result);

        result = (x + y) * z;        // (10+5)*2 = 30
        System.out.println("(x + y) * z = " + result);

        // Murakkab ifoda
        int a = 2;
        int b = a++ + ++a * a--;
        System.out.println("a = " + a + ", b = " + b);
    }
}
```

## Muhim Qoidalar

1. **Widening Casting** - avtomatik, xavfsiz
2. **Narrowing Casting** - aniq ko'rsatish kerak, ma'lumot yo'qolishi mumkin
3. **Bitli operatorlar** - faqat integer turlarida ishlaydi
4. **Operator ustuvorligi**:
    - Qavslar `()`
    - Post/Pre increment `++`, `--`
    - Ko'paytirish/bo'lish `*`, `/`, `%`
    - Qo'shish/ayirish `+`, `-`
    - Shift operatorlari
    - Taqqoslash
    - Mantiqiy operatorlar
    - Qiymat tayinlash `=`
---

**Keyingi mavzu**: [Control Flow](./03_Control_Flow.md)

**[Mundarijaga qaytish](../README.md)**

> ⚡️ O'rganishda davom etamiz!