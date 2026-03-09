# 01 - Dasturlash Paradigmalari (Programming Paradigms)

**Dasturlash paradigmasi** - bu dasturlash uslubi yoki stilidir. Har bir paradigm dastur tuzilishiga va muammolarni hal qilishga o'ziga xos yondashuvni taqdim etadi.

---

## 1. Protsedural (Protseduraviy) Dasturlash

- **Funksiyalar** yordamida muammolarni hal qilish
- Kod **top-down** (yuqoridan pastga) yo'nalishda tashkil etiladi
- Ma'lumotlar va funksiyalar bir-biridan alohida

![](../Images/Procedural_programming.png)

### Misol (C tilida):
```c
#include <stdio.h>

// Protsedural funksiyalar
float tomonliUchburchakYuzasi(float a, float b, float c) {
    float p = (a + b + c) / 2;
    return sqrt(p * (p - a) * (p - b) * (p - c));
}

float kvadratYuzasi(float tomon) {
    return tomon * tomon;
}

// Asosiy funksiya
int main() {
    float uchburchakYuzasi = tomonliUchburchakYuzasi(3, 4, 5);
    float kvadratYuzasi = kvadratYuzasi(5);
    
    printf("Uchburchak yuzasi: %.2f\n", uchburchakYuzasi);
    printf("Kvadrat yuzasi: %.2f\n", kvadratYuzasi);
    
    return 0;
}
```

### Afzalliklari:
- **Oddiy** va tushunarli
- **Kichik loyihalar** uchun yaxshi
- **Tartibli** kod tuzilishi

### Kamchiliklari:
- **Katta loyihalarda** funksiyalar ko'payib ketadi
- **"Spaghetti code"** muammosi (funktsiyalar o'rgimchak to'ri kabi chigalashib ketadi)
- **Kodni qayta foydalanish** qiyin
- **Ma'lumotlar va funksiyalar** alohida, bu ular o'rtasidagi bog'liqlikni murakkablashtiradi

---

## 2. OOP (Ob'ektga Yo'naltirilgan Dasturlash)

- **Ob'ektlar** orqali ishlash
- **Ma'lumotlar + Methodlar** = Ob'ekt

![](../Images/OOP.png)

### Asosiy Tamoyillari (4 ta ustun):
1. **Encapsulation** (Inkapsulyatsiya) - Ma'lumotlarni yashirish
2. **Inheritance** (Meros) - Klasslardan meros olish
3. **Polymorphism** (Ko'p shakllilik) - Bir xil interfeys, turli xil amal
4. **Abstraction** (Abstraksiya) - Murakkablikni yashirish

### Misol (Java-da):
```java
// Klass aniqlash
class Uchburchak {
    // Ma'lumotlar (fields) - Encapsulation
    private float a, b, c;
    
    // Konstruktor
    public Uchburchak(float a, float b, float c) {
        this.a = a;
        this.b = b;
        this.c = c;
    }
    
    // Usullar (methods)
    public float yuzaniHisobla() {
        float p = (a + b + c) / 2;
        return (float) Math.sqrt(p * (p - a) * (p - b) * (p - c));
    }
    
    public void tomonlarniChiroyliChiqar() {
        System.out.printf("Uchburchak tomonlari: a=%.2f, b=%.2f, c=%.2f\n", a, b, c);
    }
}

class Kvadrat {
    private float tomon;
    
    public Kvadrat(float tomon) {
        this.tomon = tomon;
    }
    
    public float yuzaniHisobla() {
        return tomon * tomon;
    }
}

// Asosiy klass
public class Main {
    public static void main(String[] args) {
        // Ob'ektlar yaratish
        Uchburchak uchburchak = new Uchburchak(3, 4, 5);
        Kvadrat kvadrat = new Kvadrat(5);
        
        // Ob'ekt usullarini chaqirish
        uchburchak.tomonlarniChiroyliChiqar();
        System.out.println("Uchburchak yuzasi: " + uchburchak.yuzaniHisobla());
        System.out.println("Kvadrat yuzasi: " + kvadrat.yuzaniHisobla());
    }
}
```

### Afzalliklari:
- **Kodni qayta foydalanish** oson
- **Katta loyihalar** uchun yaxshi

### Kamchiliklari:
- **O'rganish** qiyinroq
- **Kichik loyihalar** uchun ortiqcha murakkablik

---

## 3. Functional (Funksional) Dasturlash

- **"Nimani hal qilish"** ga e'tibor (nima uchun emas, nima)
- **Immutability** (o'zgarmaslik) - ma'lumotlar o'zgarmaydi
- **No side-effects** - funksiyalar tashqi holatni o'zgartirmaydi

### Xususiyatlari:
- **First-class functions** - funksiyalar argument sifatida uzatilishi mumkin
- **Pure functions** - bir xil kiritish har doim bir xil chiqish
- **Recursion** - tsikllar o'rniga rekursiya
- **Higher-order functions** - funksiyalarni qaytaradigan funksiyalar

### Afzalliklari:
- **Parallel execution** - parallel bajarish oson
- **Xatolarni kamaytirish** - side-effect yo'q
- **Test qilish oson** - pure funksiyalar
- **Kod qisqa va aniq**

### Kamchiliklari:
- **O'rganish** qiyin
- **Performance** - ba'zi hollarda sekin
---

## 4. Reactive Programming

- **Data streams** va **propagation of change** ga asoslangan
- **Asinxron** va **event-driven**
- Ma'lumotlar **oqim** sifatida

### Asosiy tushunchalar:
- **Observables** - kuzatiladigan ma'lumotlar oqimi
- **Observers** - kuzatuvchilar
- **Operators** - oqimni o'zgartirish
- **Schedulers** - bajarish konteksti

### Misol (RxJava da):
```java
// Observable yaratish
Observable<String> observable = Observable.just("Salom", "Java", "Dunyosi");

// Observer yaratish
observable.subscribe(
    // onNext
    item -> System.out.println("Qabul qilindi: " + item),
    // onError
    error -> System.out.println("Xato: " + error),
    // onComplete
    () -> System.out.println("Tugadi!")
);
```

---

## Paradigmalarni Qiyoslash

| Paradigma | Yondashuv | Asosiy Birlik | Mutability | Misol Tillari |
|-----------|-----------|---------------|------------|-------------|
| **Protsedural** | "Qanday" | Funksiya | O'zgaruvchan | C, Pascal |
| **OOP** | "Kim/Nima" | Ob'ekt | O'zgaruvchan | Java, C++, Python |
| **Functional** | "Nima" | Funksiya | O'zgarmas |  |
| **Reactive** | "Va keyin" | Oqim | O'zgarmas | |

---

## Qaysi Paradigmani Tanlash?

### 1. **Protsedural** tanlang agar:
- Kichik va oddiy loyiha
- Tezkor prototip yaratish kerak
- Performance juda muhim

### 2. **OOP** tanlang agar:
- Katta va murakkab tizim
- Kodni qayta foydalanish kerak
- Haqiqiy dunyoni modellashtirish kerak

### 3. **Functional** tanlang agar:
- Parallel va concurrent kod
- Ma'lumotlarni qayta ishlash
- Matematik hisob-kitoblar

### 4. **Reactive** tanlang agar:
- Real-time dasturlar
- Event-driven architecture
- Ko'p ma'lumot oqimlari

---

## Java-da Paradigmalar

Java asosan **OOP** tilidir, lekin:

- **Java 1-7**: Asosan OOP + biroz protsedural
- **Java 8+**: OOP + Functional (Lambda, Stream API)
- **Modern Java**: Multi-paradigm (OOP + Functional + Reactive)

---
## Muhim Xulosa

1. **Har bir paradigm o'ziga xos** yondashuvga ega
2. **Ko'p tillar multi-paradigm** (Java, Python, JavaScript)
3. **Yaxshi dasturchi** turli paradigmalarni biladi va ularni aralashtira oladi
4. **Loyiha talablariga** qarab paradigm tanlash kerak

> **Maslahat:** O'rganishda barcha paradigmalarni o'rganing. Har biri muayyan muammolar uchun yaxshi yechimdir.

---

**Keyingi mavzu**: [02 - OOP Asosiy Tushunchalari: Encapsulation, Packaging](./02_OOP_Concepts.md)  
**[Mundarijaga qaytish](../README.md)**

> ⚡ O'rganishda davom etamiz.