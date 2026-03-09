# 01 - Java Asoslari Loyiha Topshiriqlari

## Mini Smart Project

Bu modulda o'rgangan mavzular asosida **Mini Smart Project** tayyorlang. Bu loyiha sizning bilimingizni amaliyot bilan
mustahkamlashga yordam beradi.

### Talablar:

1. **Dastur ishga tushganda console'da menu chiqsin:**
   ```
   ----- MINI SMART PROJECT -----
   1. Calculator
   2. Currency Converter
   3. Number System Converter
   4. Interview Questions Answers
   5. Chiqish
   Tanlang (1-5): 
   ```

---

## 1. Calculator (Kalkulyator)

**Talablar:**

- Kamida 5 ta amaldan foydalanish kerak
- Foydalanuvchi raqamlar va amalni kiritishi mumkin
- Natijani chiqarish

**Namuna amallar:**

- Qo'shish (+)
- Ayirish (-)
- Ko'paytirish (*)
- Bo'lish (/)
- Qoldiq (%)
- Daraja (^)
- Kvadrat ildiz (√)

**Namuna interfeys:**

```
=== KALKULYATOR ===
1. Qo'shish
2. Ayirish
3. Ko'paytirish
4. Bo'lish
5. Qoldiq
6. Daraja
7. Kvadrat ildiz
8. Ortga
Tanlang: 
```

---

## 2. Currency Converter (Valyuta Ayirboshlash)

**Talablar:**

- Kamida somdan tashqari 3 ta pul birligi
- Real vaqt kurslarini olish (API yoki fixed kurslar)
- Ikki yo'nalishda konvertatsiya

**Namuna valyutalar:**

- UZS (O'zbek so'mi) 🇺🇿
- USD (AQSH dollari) 🇺🇸
- EUR (Yevro) 🇪🇺
- RUB (Rus rubli) 🇷🇺
- CNY (Xitay yuani) 🇨🇳

**Namuna interfeys:**

```
=== VALYUTA KONVERTORI ===
1. UZS -> USD
2. UZS -> EUR
3. UZS -> RUB
4. USD -> UZS
5. EUR -> UZS
6. RUB -> UZS
7. Barcha kurslarni ko'rish
8. Ortga
Tanlang: 
```

---

## 3. Number System Converter (Sanoq Sistemasi Konvertori)

**Talablar:**

- Kamida 2, 8, 10, 16 lik sanoq sistemalari orasida konvertatsiya
- Foydalanuvchi raqam va sanoq sistemasini kiritishi mumkin
- Teskari konvertatsiya qilish imkoniyati

**Namuna interfeys:**

```
=== SANOQ SISTEMASI KONVERTORI ===
1. 10-lik -> 2-lik
2. 10-lik -> 8-lik
3. 10-lik -> 16-lik
4. 2-lik -> 10-lik
5. 8-lik -> 10-lik
6. 16-lik -> 10-lik
7. 2-lik -> 16-lik
8. 16-lik -> 2-lik
9. Ortga
Tanlang: 
```

---

## 4. Interview Questions Answers (Intervyu Savollari Javoblari)

**Talablar:**

- `InterviewAnswers` package ochish
- Barcha savollarga javoblarni `.txt` faylga yozish
- Package haqida ma'lumot chiqarish
- Javoblarni o'qish va chiqarish imkoniyati

**Fayl tuzilmasi:**

```
src/
├── InterviewAnswers/
│   ├── GeneralQuestions.txt
│   ├── OperatorsQuestions.txt
│   ├── ControlFlowQuestions.txt
│   ├── MethodsQuestions.txt
│   ├── StringsQuestions.txt
│   └── ArraysQuestions.txt
└── Main.java
```

**Namuna interfeys:**

```
=== INTERVYU SAVOLLARI JAVOBLARI ===
1. Umumiy Java savollari
2. Operatorlar savollari
3. Nazorat oqimlari savollari
4. Metodlar savollari
5. Satrlar savollari
6. Massivlar savollari
7. Barcha javoblarni ko'rish
8. Ortga
Tanlang: 
```

---

## Loyiha Tuzilmasi Tavsiyasi

```java
src/
        ├──Main.java                    // Asosiy klass va menyu
├──calculator/
        │   ├──Calculator.java          // Kalkulyator logikasi
│   ├──AdvancedCalculator.java  // Qo'shimcha funksiyalar
│   └──CalculatorTest.java      // Testlar
├──converter/
        │   ├──CurrencyConverter.java   // Valyuta konvertori
│   ├──ExchangeRates.java       // Kurslar
│   ├──NumberConverter.java     // Sanoq sistemasi konvertori
│   └──NumberValidator.java     // Raqam tekshiruvchi
├──interview/
        │   ├──InterviewReader.java     // Fayldan o'qish
│   ├──AnswerDisplay.java       // Javoblarni chiqarish
│   └──InterviewAnswers/        // Javoblar fayllari
        │       ├──GeneralQuestions.txt
│       ├──OperatorsQuestions.txt
│       ├──ControlFlowQuestions.txt
│       ├──MethodsQuestions.txt
│       ├──StringsQuestions.txt
│       └──ArraysQuestions.txt
├──utils/
        │   ├──MenuDisplay.java         // Menyu chiqarish
│   ├──InputReader.java         // Foydalanuvchi kiritishini o'qish
│   └──Validator.java           // Kiritishni tekshirish
└──models/
        ├──Currency.java            // Valyuta modeli
    └──Conversion.java          // Konvertatsiya modeli
```

---
## Maslahatlar

1. **Bosqichma-bosqich ishlang:** Avval Calculator, keyin boshqalar
2. **GitHub'da saqlang:** Har bir bosqichni commit qiling
3. **Kodni refactor qiling:** Takrorlanuvchi kodni alohida metodlarga ajrating
4. **Test qiling:** Har bir funksiyani alohida test qiling
5. **Dokumentatsiya yozing:** README.md faylida loyiha haqida yozing

---
> Kod yozish amaliyot bilan o'rganiladi. Qancha ko'p kod yozsangiz, shuncha yaxshi dasturchi bo'lasiz!

> Keep learning