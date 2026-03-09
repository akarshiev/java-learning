# Java Amaliy Mashqlar To'plami

##  Mundarija
- [Basic Java Mashqlari](#basic-java-mashqlari)
- [Pattern (Shakl) Mashqlari](#pattern-shakl-mashqlari)
- [Array (Massiv) Mashqlari](#array-massiv-mashqlari)
- [String Mashqlari](#string-mashqlari)
- [Qo'shimcha Mashqlar](#qoʻshimcha-mashqlar)

---

## Basic Java Mashqlari

<details>
<summary><b>1. Hello World Dasturi</b></summary>

**Misol:** Konsolga "Hello World!" matnini chiqarish

**Input:** `Hello World!`
**Output:** `Hello World!`

**Berilgan:** "Hello World!" matnini ekranga chiqaring.

</details>

<details>
<summary><b>2. Ikki Sonni Qo'shish</b></summary>

**Misol:** Foydalanuvchi kiritgan ikkita sonni qo'shish

**Input:** `2 3`
**Output:** `5`

**Berilgan:** Ikkita butun son berilgan. Ularning yig'indisini toping.

</details>

<details>
<summary><b>3. Ikki Sonni Almashish</b></summary>

**Misol:** Ikkita o'zgaruvchining qiymatlarini almashtirish

**Input:** `a=2, b=5`
**Output:** `a=5, b=2`

**Berilgan:** a va b o'zgaruvchilarining qiymatlarini uchinchi o'zgaruvchi ishlatmasdan almashtiring.

</details>

<details>
<summary><b>4. Sonni Binaryga O'tkazish</b></summary>

**Misol:** Butun sonni ikkilik sanoq sistemasiga o'tkazish

**Input:** `9`
**Output:** `1001`

**Berilgan:** Butun son berilgan. Uni ikkilik (binary) ko'rinishda chiqaring.

</details>

<details>
<summary><b>5. Faktorial Hisoblash</b></summary>

**Misol:** n sonining faktorialini hisoblash (n! = 1 * 2 * 3 * ... * n)

**Input:** `5`
**Output:** `120`

**Berilgan:** n butun soni berilgan. n! faktorialni hisoblang.

</details>

<details>
<summary><b>6. Kompleks Sonlarni Qo'shish</b></summary>

**Misol:** Ikki kompleks sonni qo'shish

**Input:** `1+2i` va `4+5i`
**Output:** `5+7i`

**Berilgan:** Ikkita kompleks son berilgan. Ularni qo'shing.

</details>

<details>
<summary><b>7. Oddiy Foiz Hisoblash</b></summary>

**Misol:** Simple Interest (Oddiy foiz) hisoblash formulasi: SI = (P * R * T) / 100

**Input:** `P = 10000, R = 5, T = 5`
**Output:** `2500`

**Berilgan:** P (asosiy summa), R (foiz stavkasi), T (vaqt) berilgan. Oddiy foizni hisoblang.

</details>

<details>
<summary><b>8. Fibonacci Seriyasidagi Juft Indekslar Yig'indisi</b></summary>

**Misol:** Fibonacci sonlaridagi juft indekslardagi sonlar yig'indisi

Fibonacci: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...
Juft indekslar (0,2,4,6,8): 0 + 1 + 3 + 8 + 21 = 33

**Input:** `n = 4` (4-chi indeksgacha, ya'ni 0,2,4,6,8)
**Output:** `33`

**Berilgan:** n butun soni berilgan. Fibonacci seriyasidagi juft indekslardagi sonlar yig'indisini toping.

</details>

---

## Pattern (Shakl) Mashqlari

<details>
<summary><b>9. Paskal Uchburchagi</b></summary>

**Misol:** Paskal uchburchagini chop etish

**Input:** `N = 5`
**Output:**
```
    1
   1 1
  1 2 1
 1 3 3 1
1 4 6 4 1
```

**Berilgan:** N butun soni berilgan. Paskal uchburchagini N qator qilib chop eting.

</details>

<details>
<summary><b>10. Piramida Raqam Patterni</b></summary>

**Misol:** Piramida shaklidagi raqam patterni

**Input:** `3`
**Output:**
```
  1
 2 2
3 3 3
```

**Berilgan:** N butun soni berilgan. Piramida shaklidagi raqam patternini chop eting.

</details>

<details>
<summary><b>11. Yulduzcha Patterni</b></summary>

**Misol:** Yulduzchalar bilan pattern

**Input:** `5`
**Output:**
```
*
**
***
****
*****
*****
****
***
**
*
```

**Berilgan:** N butun soni berilgan. Yuqoridagi patternni chop eting.

</details>

<details>
<summary><b>12. Rombus Patterni</b></summary>

**Misol:** Rombus (olmos) shaklidagi yulduzcha patterni

**Input:** `N = 5`
**Output:**
```
    *
   ***
  *****
 *******
*********
 *******
  *****
   ***
    *
```

**Berilgan:** N butun soni berilgan. Rombus shaklidagi patternni chop eting.

</details>

<details>
<summary><b>13. Soat Qumi Patterni</b></summary>

**Misol:** Soat qumi (hourglass) patterni

**Input:** `number = 7`
**Output:**
```
*******
 *****
  ***
   *
  ***
 *****
*******
```

**Berilgan:** N butun soni berilgan. Soat qumi shaklidagi patternni chop eting.

</details>

---

## Array (Massiv) Mashqlari

<details>
<summary><b>14. Massiv Elementlari Yig'indisi</b></summary>

**Misol:** Massivdagi barcha elementlar yig'indisini hisoblash

**Input:** `[2, 4, 6, 7, 9]`
**Output:** `28`

**Berilgan:** Butun sonlar massivi berilgan. Barcha elementlar yig'indisini toping.

</details>

<details>
<summary><b>15. Massivdagi Eng Katta Element</b></summary>

**Misol:** Massivdagi eng katta elementni topish

**Input:** `[7, 2, 5, 1, 4]`
**Output:** `7`

**Berilgan:** Butun sonlar massivi berilgan. Eng katta elementni toping.

</details>

<details>
<summary><b>16. Matritsa Transpozitsiyasi</b></summary>

**Misol:** Matritsaning transpozitsiyasini hisoblash (satr va ustunlarni almashtirish)

**Input:**
```
[ [ 1, 2, 3 ]
  [ 4, 5, 6 ]
  [ 7, 8, 9 ] ]
```
**Output:**
```
[ [ 1, 4, 7]
  [ 2, 5, 8]
  [ 3, 6, 9] ]
```

**Berilgan:** 3x3 matritsa berilgan. Uning transpozitsiyasini toping.

</details>

<details>
<summary><b>17. Massivni Aylantirish (Rotation)</b></summary>

**Misol:** Massivni d pozitsiyaga aylantirish

**Input:** `arr[] = {1, 2, 3, 4, 5, 6, 7}, d = 2`
**Output:** `[3, 4, 5, 6, 7, 1, 2]`
**Izoh:** d=2, ya'ni 2 ta element (1,2) massiv oxiriga aylantiriladi.

**Berilgan:** Massiv va d butun soni berilgan. Massivni d pozitsiyaga chapga aylantiring.

</details>

<details>
<summary><b>18. Massivdan Dublikatlarni Olib Tashlash</b></summary>

**Misol:** Massivdagi takrorlanuvchi elementlarni olib tashlash

**Input:** `[1, 2, 2, 3, 3, 3, 4, 5]`
**Output:** `[1, 2, 3, 4, 5]`

**Berilgan:** Butun sonlar massivi berilgan. Takrorlanuvchi elementlarni olib tashlab, yangi massiv yarating.

</details>

<details>
<summary><b>19. Elementning Barcha Uchrashlarini Olib Tashlash</b></summary>

**Misol:** Berilgan elementning barcha uchrashlarini massivdan olib tashlash

**Input:** `array = [1, 2, 1, 3, 5, 1], key = 1`
**Output:** `[2, 3, 5]`

**Berilgan:** Massiv va key elementi berilgan. Key elementining barcha uchrashlarini massivdan olib tashlang.

</details>

---

## String Mashqlari

<details>
<summary><b>20. Palindrom Tekshirish</b></summary>

**Misol:** Berilgan satr palindrom ekanligini tekshirish (satrni teskari o'qiganda ham bir xil)

**Input:** `"racecar"`
**Output:** `Yes`

**Berilgan:** Satr berilgan. Uning palindrom ekanligini tekshiring.

</details>

<details>
<summary><b>21. Anagramma Tekshirish</b></summary>

**Misol:** Ikki satr anagramma ekanligini tekshirish (bir satrdagi harflar yordamida ikkinchi satrni yasash mumkin)

**Input:** `str1 = "Silent", str2 = "Listen"`
**Output:** `Strings are Anagram`

**Berilgan:** Ikkita satr berilgan. Ularning anagramma ekanligini tekshiring.

</details>

<details>
<summary><b>22. Satrni Teskari Qilish</b></summary>

**Misol:** Berilgan satrni teskari tartibda chiqarish

**Input:** `str = "Geeks"`
**Output:** `"skeeG"`

**Berilgan:** Satr berilgan. Uni teskari tartibda chiqaring.

</details>

<details>
<summary><b>23. Boshidagi Nollarni Olib Tashlash</b></summary>

**Misol:** Son stringidagi boshidagi nollarni olib tashlash

**Input:** `"00000123569"`
**Output:** `"123569"`

**Berilgan:** Raqamlardan tashkil topgan satr berilgan. Boshidagi nollarni olib tashlang.

</details>

---

## Qo'shimcha Mashqlar

<details>
<summary><b>24. Son Tub ekanligini Tekshirish</b></summary>

**Misol:** Berilgan son tub son ekanligini tekshirish

**Input:** `17`
**Output:** `true`

**Berilgan:** n butun soni berilgan. Uning tub son ekanligini tekshiring.

</details>

<details>
<summary><b>25. Armstrong Sonini Tekshirish</b></summary>

**Misol:** Armstrong soni - bu raqamlarining kub(lar)i yig'indisiga teng bo'lgan son

**Input:** `153`
**Output:** `true` (1³ + 5³ + 3³ = 153)

**Berilgan:** n butun soni berilgan. Uning Armstrong soni ekanligini tekshiring.

</details>

<details>
<summary><b>26. Fibonacci Seriyasini Chiqarish</b></summary>

**Misol:** Birinchi n ta Fibonacci sonini chiqarish

**Input:** `n = 10`
**Output:** `0 1 1 2 3 5 8 13 21 34`

**Berilgan:** n butun soni berilgan. Birinchi n ta Fibonacci sonini chiqaring.

</details>

<details>
<summary><b>27. Massivni Saralash (Bubble Sort)</b></summary>

**Misol:** Massivni o'sish tartibida saralash

**Input:** `[64, 34, 25, 12, 22, 11, 90]`
**Output:** `[11, 12, 22, 25, 34, 64, 90]`

**Berilgan:** Butun sonlar massivi berilgan. Uni Bubble Sort algoritmi yordamida saralang.

</details>

<details>
<summary><b>28. Ikki Massivni Birlashtirish</b></summary>

**Misol:** Ikkita saralangan massivni birlashtirish

**Input:** `[1, 3, 5]` va `[2, 4, 6]`
**Output:** `[1, 2, 3, 4, 5, 6]`

**Berilgan:** Ikkita saralangan massiv berilgan. Ularni birlashtirib, saralangan holatda yangi massiv yarating.

</details>

<details>
<summary><b>29. Massivdagi Eng Ko'p Uchragan Element</b></summary>

**Misol:** Massivda eng ko'p takrorlangan elementni topish

**Input:** `[1, 3, 2, 1, 4, 1, 3]`
**Output:** `1`

**Berilgan:** Butun sonlar massivi berilgan. Eng ko'p takrorlangan elementni toping.

</details>

<details>
<summary><b>30. Satrdagi Unlilar Sonini Hisoblash</b></summary>

**Misol:** Satrdagi unli harflar sonini hisoblash (a, e, i, o, u)

**Input:** `"Hello World"`
**Output:** `3 (e, o, o)`

**Berilgan:** Satr berilgan. Undagi unli harflar sonini hisoblang.

</details>

<details>
<summary><b>31. Satrdagi So'zlar Sonini Hisoblash</b></summary>

**Misol:** Satrdagi so'zlar sonini hisoblash

**Input:** `"Java is a programming language"`
**Output:** `5`

**Berilgan:** Satr berilgan. Undagi so'zlar sonini hisoblang (so'zlar bo'shliq bilan ajratilgan).

</details>

<details>
<summary><b>32. Satrni CamelCase dan Snake Case ga O'tkazish</b></summary>

**Misol:** CamelCase formatidagi satrni snake_case formatiga o'tkazish

**Input:** `"camelCaseString"`
**Output:** `"camel_case_string"`

**Berilgan:** CamelCase formatidagi satr berilgan. Uni snake_case formatiga o'tkazing.

</details>

---

##  Mashqlar Statistikasi

| Bo'lim | Mashqlar soni |
|--------|---------------|
| Basic Java | 8 ta |
| Pattern | 5 ta |
| Array | 6 ta |
| String | 4 ta |
| Qo'shimcha | 9 ta |
| **Jami** | **32 ta** |

---

**[Mundarijaga qaytish](#-mundarija)**

> Har bir mashqni mustaqil bajarishga harakat qiling! 🚀
