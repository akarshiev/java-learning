# 03 - Nazorat Oqimlari (Control Flow)

## 1. Shart Operatorlari (Conditional Statements)

### 1.1 if-else Operatori

Dasturning ma'lum bir blokini shartga qarab bajarish.

```java
// Oddiy if
if (shart) {
    // shart true bo'lsa bajariladi
}

// if-else
if (shart) {
    // shart true bo'lsa
} else {
    // shart false bo'lsa
}

// if-else if-else (zanjir)
if (shart1) {
    // shart1 true bo'lsa
} else if (shart2) {
    // shart2 true bo'lsa
} else {
    // barcha shartlar false bo'lsa
}
```

**Misol:**
```java
public class IfElseExample {
    public static void main(String[] args) {
        int ball = 85;
        
        if (ball >= 90) {
            System.out.println("A - A'lo");
        } else if (ball >= 80) {
            System.out.println("B - Yaxshi");  // Bu bajariladi
        } else if (ball >= 70) {
            System.out.println("C - Qoniqarli");
        } else if (ball >= 60) {
            System.out.println("D - Qoniqarsiz");
        } else {
            System.out.println("F - Yiqildi");
        }
    }
}
```

### 1.2 Ternary Operator (Uchlik Operator)

Qisqa if-else alternativasi.

```java
// Sintaksis: shart ? true_dagi_qiymat : false_dagi_qiymat

int yosh = 18;
String natija = (yosh >= 18) ? "Kattalar" : "Bolalar";
System.out.println(natija);  // "Kattalar"

// Yana bir misol
int a = 10, b = 20;
int katta = (a > b) ? a : b;  // 20
```

### 1.3 switch-case Operatori

Bir nechta holatlarni tekshirish uchun.

```java
switch (ifoda) {
    case qiymat1:
        // kod
        break;
    case qiymat2:
        // kod
        break;
    default:
        // barcha holatlar mos kelmasa
}
```

**Amaliy misol:**
```java
public class SwitchExample {
    public static void main(String[] args) {
        int kun = 3;
        String kunNomi;
        
        switch (kun) {
            case 1:
                kunNomi = "Dushanba";
                break;
            case 2:
                kunNomi = "Seshanba";
                break;
            case 3:
                kunNomi = "Chorshanba";  // Bu bajariladi
                break;
            case 4:
                kunNomi = "Payshanba";
                break;
            case 5:
                kunNomi = "Juma";
                break;
            case 6:
                kunNomi = "Shanba";
                break;
            case 7:
                kunNomi = "Yakshanba";
                break;
            default:
                kunNomi = "Noto'g'ri kun";
        }
        
        System.out.println(kun + "-kun: " + kunNomi);
    }
}
```

**Java 14+ Enhanced Switch:**
```java
// Arrow syntax bilan
String kunNomi = switch (kun) {
    case 1 -> "Dushanba";
    case 2 -> "Seshanba";
    case 3 -> "Chorshanba";
    default -> "Noto'g'ri kun";
};

// yield bilan qiymat qaytarish
int haftaKuni = switch (kun) {
    case 1, 2, 3, 4, 5 -> {
        System.out.println("Ish kuni");
        yield 1;  // qiymat qaytarish
    }
    case 6, 7 -> {
        System.out.println("Dam olish kuni");
        yield 2;
    }
    default -> 0;
};
```

---

## 2. Tsikllar (Loops)

### 2.1 for Tsikli

Aniqlangan sonli takrorlash uchun.

```java
for (boshlash; shart; o'zgartirish) {
    // takrorlanuvchi kod
}
```

**Misol:**
```java
// 1 dan 10 gacha sonlarni chiqarish
for (int i = 1; i <= 10; i++) {
    System.out.print(i + " ");  // 1 2 3 4 5 6 7 8 9 10
}

// Har bir elementni chiqarish
String[] mevalar = {"Olma", "Banan", "Gilos"};
for (int i = 0; i < mevalar.length; i++) {
    System.out.println(mevalar[i]);
}
```

### 2.2 Enhanced for (for-each) Tsikli

Massiv yoki kolleksiyalarni aylantirish uchun.

```java
for (tur element : kolleksiya) {
    // har bir element ustida amal
}
```

**Misol:**
```java
int[] sonlar = {1, 2, 3, 4, 5};
int yigindi = 0;

for (int son : sonlar) {
    yigindi += son;
}
System.out.println("Yig'indi: " + yigindi);  // 15

// String massivi bilan
String[] ismlar = {"Ali", "Vali", "Hasan"};
for (String ism : ismlar) {
    System.out.println("Salom, " + ism);
}
```

### 2.3 while Tsikli

Shart true bo'lguncha takrorlaydi.

```java
while (shart) {
    // kod
    // shart o'zgarishi kerak, aks holda cheksiz tsikl
}
```

**Misol:**
```java
// 1 dan 5 gacha sonlar
int i = 1;
while (i <= 5) {
    System.out.print(i + " ");  // 1 2 3 4 5
    i++;
}

// Foydalanuvchi kiritishini kutish
import java.util.Scanner;

Scanner scanner = new Scanner(System.in);
String javob = "";

while (!javob.equals("ha")) {
    System.out.print("Chiqish uchun 'ha' deb yozing: ");
    javob = scanner.nextLine().toLowerCase();
}
System.out.println("Dastur tugadi!");
```

### 2.4 do-while Tsikli

Kamida bir marta bajariladi, keyin shartni tekshiradi.

```java
do {
    // kod
} while (shart);
```

**Misol:**
```java
// Kamida bir marta bajariladi
int son = 10;
do {
    System.out.println("Son: " + son);  // Bu chiqadi
    son++;
} while (son < 5);  // Shart false, lekin kod bir marta bajarildi

// Menyu tizimi misoli
Scanner scanner = new Scanner(System.in);
int tanlov;

do {
    System.out.println("\n--- MENU ---");
    System.out.println("1. Qo'shish");
    System.out.println("2. Ayirish");
    System.out.println("3. Ko'paytirish");
    System.out.println("0. Chiqish");
    System.out.print("Tanlang: ");
    
    tanlov = scanner.nextInt();
    
    switch (tanlov) {
        case 1: System.out.println("Qo'shish tanlandi"); break;
        case 2: System.out.println("Ayirish tanlandi"); break;
        case 3: System.out.println("Ko'paytirish tanlandi"); break;
    }
} while (tanlov != 0);
System.out.println("Dastur tugadi!");
```

---

## 3. Sakrash Operatorlari (Jump Statements)

### 3.1 break Operatori

Tsikldan yoki switch-case dan chiqish.

```java
// Oddiy tsikldan chiqish
for (int i = 1; i <= 10; i++) {
    if (i == 5) {
        break;  // i=5 da tsikldan chiqadi
    }
    System.out.print(i + " ");  // 1 2 3 4
}

// Ichki tsikldan chiqish (labeled break)
tashqi: for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
        if (i == 2 && j == 2) {
            break tashqi;  // tashqi tsikldan chiqadi
        }
        System.out.println(i + "-" + j);
    }
}
// Chiqish:
// 1-1, 1-2, 1-3, 2-1
```

### 3.2 continue Operatori

Tsiklning qolgan qismini o'tkazib, keyingi iteratsiyaga o'tish.

```java
// Faqat toq sonlarni chiqarish
for (int i = 1; i <= 10; i++) {
    if (i % 2 == 0) {
        continue;  // juft sonlarni o'tkazib yuboradi
    }
    System.out.print(i + " ");  // 1 3 5 7 9
}

// Labeled continue
tashqi: for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
        if (i == 2 && j == 2) {
            continue tashqi;  // tashqi tsiklning keyingi iteratsiyasiga o'tadi
        }
        System.out.println(i + "-" + j);
    }
}
// Chiqish:
// 1-1, 1-2, 1-3, 3-1, 3-2, 3-3
// (2-1, 2-2, 2-3 chiqmaydi)
```
---

**Keyingi mavzu**: [Methods](./04_Methods.md)

**[Mundarijaga qaytish](../README.md)**

> ⚡️ O'rganishda davom etamiz!