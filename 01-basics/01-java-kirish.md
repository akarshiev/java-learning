# 01 - Java Kirish (Introduction to Java)

## Java nima?

**Java** - bu klasslarga asoslangan, yuqori darajali, obyektga yo'naltirilgan dasturlash tili.
- **Class-based** - har bir narsa klass sifatida ta'riflanadi
- **High-level** - inson tushunadigan sintaksisga ega
- **Object-oriented** - obyektlar orqali ishlaydi

Java **James Gosling** tomonidan 1995-yilda e'lon qilingan.

## Java Tarixi

| Yil | Voqea                                                        |
|-----|--------------------------------------------------------------|
| **1991** | Sun Microsystems tomonidan yaratilgan (dastlabki nomi "Oak") |
| **1995** | "Java" nomini olgan (Indonesiyadagi qahva turi)              |
| **2010** | Oracle kompaniyasi Java-ni sotib olgan                       |

**"Oak"** - uzoq yashovchi daraxt nomi edi.  
**Logo haqida**: Java Indonesiyadagi qahva turi shu sabab logosida qahva simvoli bor.

### WORA Prinsipi
Java dasturchilari **WORA** (Write Once, Run Anywhere) prinsipida ishlaydi:
- Java kodi kompilyatsiya qilinganda **byte-code** yaratiladi
- Bu byte-code har qanday operatsion tizimda ishlaydi

## Java Versiyalari (Editions)

Java dasturlash tilida 4 ta asosiy versiya mavjud:

| Versiya | Maqsadi | Qo'llanilishi |
|---------|---------|--------------|
| **Java Card** | Aqlli kartalar uchun | ID kartalar, passportlar |
| **Java Micro Edition (ME)** | Mikro qurilmalar uchun | Sensorlar, robotlar |
| **Java Standard Edition (SE)** | Standart ilovalar | Desktop, server ilovalari |
| **Java Platform, Enterprise Edition (EE)** | Korxona ilovalari | Enterprise, veb ilovalar |

## Java Versiyalari (Versions)

- Java har yili yangi versiyani chiqaradi
- **LTS** (Long-term support) - 4 yilda bir chiqariladi, uzoq muddatli qo'llab-quvvatlanadi

## JDK nima? (Java Development Kit)

**JDK** - Java Development Kit (Java Dasturlash To'plami)

JDK 3 ta asosiy komponentdan iborat:

### 1. Java Language Specifications (JLS)
- Java tilining rasmiy spetsifikatsiyalari

### 2. Java Dev Tools (Dasturlash Vositalari)
- **`java`** - Java dasturini ishga tushirish
- **`javac`** - Java kompilyatori (kodni kompilyatsiya qilish)
- **`javadoc`** - Hujjatlar yaratish
- **`jar`** - Java arxiv fayllari bilan ishlash
- **Debugger** - Xatolarni aniqlash vositasi

### 3. Java Run Time Environment (JRE)
- **JVM** (Java Virtual Machine) - Java Virtual Mashinasi
- **Java APIs** - Dasturlash interfeyslari
- **Class libraries** - Klass kutubxonalari

## Java Xususiyatlari

| Xususiyat | Tavsifi |
|-----------|---------|
| **Simple** | Oson o'rganiladi (C++ ga qaraganda) |
| **Object Oriented** | Obyektga yo'naltirilgan |
| **Portable** | Ko'chirilishi oson (platformadan mustaqil) |
| **System Independent** | Tizimdan mustaqil |
| **Robust** | Mustahkam (xatolarni boshqarish yaxshi) |
| **Secure** | Xavfsiz (viruslardan himoyalangan) |
| **Interpreted** | Interpretatsiya qilinadi |
| **High Performance** | Yuqori ishlash tezligi |
| **Multithreaded** | Ko'p oqimli |
| **Distributed** | Tarqatilgan (tarmoq ilovalari uchun) |
| **Dynamic** | Dinamik |

## Birinchi Java Dasturi: Hello World

```java
// Save this file as HelloWorld.java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!"); // Konsolga matn chiqaradi
    }
}
```

### Dasturni Ishga Tushirish

1. **Kompilyatsiya qilish** (terminalda):
```bash
javac HelloWorld.java
```

2. **Ishga tushirish**:
```bash
java HelloWorld
```

## Argumentlar bilan Ishlasih

```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        
        // Argumentlarni chiqarish
        for(String arg : args) {
            System.out.println(arg);
        }
    }
}
```

### Argumentlar bilan Ishga Tushirish:

```bash
javac HelloWorld.java
java HelloWorld C C++ Go Java Hello Args
```

### Natija:
```
Hello, World!
C
C++
Go
Java
Hello
Args
```

**Sababi**: `String[] args` - bu dasturga berilgan argumentlar massividir. Yuqoridagi misolda "C","C++", "Go", "Java", "Hello", "Args" argument sifatida uzatilgan.

## Java Token (Kalit So'z) Turlari

| Token Turi | Tavsif | Misollar |
|------------|--------|----------|
| **Keywords** | Java tomonidan belgilangan kalit so'zlar | `public`, `class`, `static`, `void` |
| **Identifiers** | Dasturchi tomonidan berilgan nomlar (o'zgaruvchilar, klasslar) | `HelloWorld`, `main`, `args` |
| **Literals** | Doimiy qiymatlar | `"Hello"`, `123`, `3.14`, `true` |
| **Operators** | Operatsiyalarni bajaruvchi belgilar | `+`, `-`, `=`, `*`, `/` |
| **Separators** | Elementlarni ajratuvchi belgilar | `.`, `;`, `,`, `()`, `{}`, `[]` |

### Misol:
```java
public class Example {  // 'public', 'class' - keywords; 'Example' - identifier
    public static void main(String[] args) {
        int number = 10;  // 'int' - keyword; 'number' - identifier; '10' - literal
        System.out.println(number + 5);  // '+' - operator; '.' - separator
    }
}
```

---

## Asosiy O'zlashtirishlar

1. **Java** - platformadan mustaqil, obyektga yo'naltirilgan dasturlash tili
2. **WORA** prinsipi - bir marta yoz, hamma joyda ishlat
3. **JDK** - Java dasturlash uchun to'liq to'plam
4. **JRE** - Java dasturlarini ishga tushirish uchun muhit
5. **Java kompilyatsiyasi**: `.java` → `.class` (bytecode)
6. **Argumentlar** - dasturga ish vaqtida beriladigan qiymatlar

**Keyingi mavzu**: [Java Sintaksisi va Dastur Tuzilishi](./02_Syntax_Types.md)
**[Mundarija qaytish](../README.md)**

> ⚡️ O'rganishda davom etamiz.