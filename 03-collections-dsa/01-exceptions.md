# 01 - Exceptions (Istisnolar)

## Exception nima?

**Exception** - bu dastur bajarilishi davomida sodir bo'ladigan va dasturning normal ishlashini buzadigan hodisa.

## Nima uchun Exception'lar muhim?

Tasavvur qiling: A manzildan B manzilgacha mashinada yo'lga chiqdingiz. Yo'lni yarmida g'ildirak teshilishi mumkin. Yechim: qo'shimcha g'ildirak olish.

Dastur xatolikka ikkita reaksiya bildirishi mumkin:
1. **Xatolikni log qilish** va dasturni davom ettirish
2. **Ma'lumotlarni saqlab**, dasturni to'xtatish

## Exception'lar bilan bog'liq muammolar:

1. **Device errors** - Qurilma xatolari
2. **Physical limitations** - Fizik cheklovlar
3. **User input errors** - Foydalanuvchi kiritish xatolari
4. **Code errors** - Kod xatolari

---

## Exception Hierarchy (Istisnolar Ierarxiyasi)

```
        Throwable
       /         \
     Error      Exception
                /         \
    IOException      RuntimeException
```

**Xatolik turlari:**
1. **Error** - Hardware xatolari (OutOfMemoryError, StackOverflowError)
2. **Exception** - Software xatolari

**Exception turlari:**
1. **Checked Exception** - Compile time'da tekshiriladi
2. **Unchecked Exception** - Runtime'da tekshiriladi

**Qoida:** Barcha Exception'lar checked, faqat RuntimeException va uning child'lari unchecked.

---

## Checked Exception'larni E'lon Qilish

Method nafaqat qaytaradigan qiymatni, balki qanday xatolar sodir bo'lishi mumkinligini ham aytadi.

```java
public void readFile(String filename) throws FileNotFoundException {
    if (!new File(filename).exists()) {
        throw new FileNotFoundException("File not found: " + filename);
    }
    // File o'qish
}
```

---

## Exception Yaratish va Tashlash (Throw)

```java
// 1. Mavjud Exception class'dan foydalanish
public void divide(int a, int b) {
    if (b == 0) {
        throw new ArithmeticException("Division by zero");
    }
    // Hisoblash
}

// 2. O'z Exception class'ingizni yaratish
class InsufficientFundsException extends Exception {
    public InsufficientFundsException(String message) {
        super(message);
    }
}

class BankAccount {
    private double balance;
    
    public void withdraw(double amount) throws InsufficientFundsException {
        if (amount > balance) {
            throw new InsufficientFundsException("Yetarli mablag' yo'q");
        }
        balance -= amount;
    }
}
```

---

## Exception Propagation (Istisnolar Tarqalishi)

Exception stack'da yuqoridan pastga tushadi, toki catch qilinmaguncha.

```java
public void methodA() {
    methodB();  // Exception bu yerda chiqadi
}

public void methodB() {
    methodC();  // Exception bu yerda chiqadi
}

public void methodC() {
    throw new RuntimeException("Xatolik!");  // Exception bu yerda yaratildi
}
```

---

## Exception'larni Tutish (Catch)

```java
try {
    // Xatolik yuzaga kelishi mumkin bo'lgan kod
    File file = new File("test.txt");
    Scanner scanner = new Scanner(file);
} catch (FileNotFoundException e) {
    // Xatolikni qayta ishlash
    System.out.println("File topilmadi: " + e.getMessage());
}
```

### Bir nechta Exception'larni tutish:

```java
// Java 7 dan oldin
try {
    // Kod
} catch (FileNotFoundException e) {
    // File topilmaganda
} catch (IOException e) {
    // IO xatolikda
}

// Java 7+ (bir catch'da bir nechta exception)
try {
    // Kod
} catch (FileNotFoundException | UnknownHostException e) {
    // File topilmagan yoki host nomi noto'g'ri
} catch (IOException e) {
    // Boshqa IO xatoliklar
}
```

### Qayta Tashlash (Rethrow):

```java
try {
    // Ma'lumotlar bazasi bilan ishlash
} catch (SQLException e) {
    // Subsystem uchun yangi exception yaratish
    throw new DatabaseException("Ma'lumotlar bazasi xatosi", e);
}

// Chained Exception (Java 1.4+)
try {
    // Kod
} catch (IOException original) {
    ApiException e = new ApiException("API xatosi");
    e.initCause(original);  // Asl xatoni sabab sifatida belgilash
    throw e;
}
```

---

## Finally Blok

```java
Scanner scanner = null;
try {
    scanner = new Scanner(new File("test.txt"));
    // Faylni o'qish
} catch (FileNotFoundException e) {
    System.out.println("File topilmadi");
} finally {
    // Har doim bajariladi
    if (scanner != null) {
        scanner.close();  // Resursni tozalash
    }
}
```

---

## Try-with-Resources (Java 7+)

```java
// Avtomatik ravishda resurslarni yopadi
try (Scanner scanner = new Scanner(new File("test.txt"));
     FileWriter writer = new FileWriter("output.txt")) {
    // Resurslar bilan ishlash
} catch (IOException e) {
    // Xatolikni qayta ishlash
}

// Shart: Resurs AutoCloseable interface'ni implement qilishi kerak
```

---

## Exception'lar bilan Ishlash Bo'yicha Maslahatlar

1. **Exception'lar oddiy testni almashtirmasligi kerak**
   ```java
   // Yomon:
   try {
       return array[index];
   } catch (ArrayIndexOutOfBoundsException e) {
       return -1;
   }
   
   // Yaxshi:
   if (index >= 0 && index < array.length) {
       return array[index];
   } else {
       return -1;
   }
   ```

2. **Exception'larni juda ko'p boshqarmang**

3. **Exception hierarchy'dan to'g'ri foydalaning**

4. **Exception'larni tarqatish ayb emas**

5. **Stack trace'larni foydalanuvchilarga ko'rsatmang**

---

## Stack Trace Tahlili

```java
try {
    // Kod
} catch (Exception e) {
    // Stack trace'ni chiqarish
    e.printStackTrace();
    
    // Stack trace elementlarini o'qish
    StackTraceElement[] frames = e.getStackTrace();
    for (StackTraceElement frame : frames) {
        System.out.println(frame.getClassName() + "." + 
                          frame.getMethodName() + ":" + 
                          frame.getLineNumber());
    }
}
```

---

## Exception'lar Afzalliklari

1. **Xatolarni qayta ishlash kodi oddiy koddan ajratiladi**
2. **Xatoliklar call stack orqali yuqoriga tarqaladi**
3. **Xato turlarini farqlash mumkin**
4. **Dasturning barqarorligi oshadi**

---

**Keyingi mavzu:** [02 - Generics](./02_Generics.md)  
**[Mundarijaga qaytish](../README.md)**