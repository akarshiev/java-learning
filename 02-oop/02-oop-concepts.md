# 02 - OOP Asosiy Tushunchalari: Encapsulation va Packaging

## OOP Tushunchalari va Ustunlari

### OOP Asosiy Tushunchalari:
1. **Class** (Klass) - Ob'ektlar uchun qolip/shablon
2. **Encapsulation** (Inkapsulyatsiya) - Ma'lumotlarni yashirish
3. **Inheritance** (Meros) - Klasslardan meros olish
4. **Polymorphism** (Ko'p shakllilik) - Bir xil interfeys, turli xil amal
5. **Abstraction** (Abstraksiya) - Murakkablikni yashirish
6. **Object** (Ob'ekt) - Klassning namunasi

### OOP 4 Ustuni:
1. **Encapsulation** - Ma'lumotlar va usullarni bir joyda saqlash
2. **Inheritance** - Kodni qayta foydalanish
3. **Polymorphism** - Moslashuvchanlik
4. **Abstraction** - Murakkablikni soddalashtirish

---

## 1. Encapsulation (Inkapsulyatsiya)

### Encapsulation nima?
**Encapsulation** - ma'lumotlar (fields) va ular ustida amallar (methods) ni bitta birlik (class) ichida birlashtirish.

### Asosiy tamoyillari:
1. **Data Hiding** - Ma'lumotlarni class tashqarisidan yashirish
2. **Controlled Access** - Faqat berilgan usullar orqali kirish
3. **Bundling** - Ma'lumot va usullarni bir joyda saqlash

### Misol:
```java
public class Kitob {
    // Private fields (ma'lumotlarni yashirish)
    private String nomi;
    private String muallifi;
    private int sahifalar;
    private double narxi;
    
    // Konstruktor
    public Kitob(String nomi, String muallifi, int sahifalar, double narxi) {
        this.nomi = nomi;
        this.muallifi = muallifi;
        this.sahifalar = sahifalar;
        this.narxi = narxi;
    }
    
    // Public methods (kontrol qilingan kirish)
    public void kitobMalumotlari() {
        System.out.println("Kitob: " + nomi);
        System.out.println("Muallif: " + muallifi);
        System.out.println("Sahifalar: " + sahifalar);
        System.out.println("Narx: $" + narxi);
    }
}
```

---

## 2. Getter va Setter Methodlari

### Accessor (Getter) va Mutator (Setter)

#### Accessor (Getter) - O'qish uchun:
```java
// Accessor (Getter) - private fieldni o'qish uchun
public String getNomi() {
    return this.nomi;
}

// Yana bir misol
public String getMuallifi() {
    return this.muallifi;
}
```

#### Mutator (Setter) - O'zgartirish uchun:
```java
// Mutator (Setter) - private fieldni o'zgartirish uchun
public void setNomi(String yangiNomi) {
    this.nomi = yangiNomi;
}

// Validation bilan setter
public void setSahifalar(int sahifalar) {
    if (sahifalar > 0) {
        this.sahifalar = sahifalar;
    } else {
        System.out.println("Xato: Sahifalar soni manfiy bo'lishi mumkin emas!");
    }
}

// Narxni o'zgartirish (cheklov bilan)
public void setNarxi(double narxi) {
    if (narxi >= 0) {
        this.narxi = narxi;
    } else {
        System.out.println("Xato: Narx manfiy bo'lishi mumkin emas!");
    }
}
```

### To'liq Encapsulation Misoli:
```java
public class Hisob {
    // Private fields (ma'lumotlarni yashirish)
    private String egasi;
    private double balans;
    private String hisobRaqami;
    
    // Konstruktor
    public Hisob(String egasi, double boshlangichBalans, String hisobRaqami) {
        this.egasi = egasi;
        if (boshlangichBalans >= 0) {
            this.balans = boshlangichBalans;
        } else {
            this.balans = 0;
            System.out.println("Xato: Boshlang'ich balans manfiy bo'lishi mumkin emas!");
        }
        this.hisobRaqami = hisobRaqami;
    }
    
    // Getterlar (Accessor)
    public String getEgasi() {
        return egasi;
    }
    
    public double getBalans() {
        return balans;
    }
    
    public String getHisobRaqami() {
        return hisobRaqami;
    }
    
    // Setterlar (Mutator) - cheklovlar bilan
    public void setEgasi(String yangiEgasi) {
        if (yangiEgasi != null && !yangiEgasi.trim().isEmpty()) {
            this.egasi = yangiEgasi;
        } else {
            System.out.println("Xato: Egasi nomi bo'sh bo'lishi mumkin emas!");
        }
    }
    
    // Balansni o'zgartirish uchun maxsus usullar
    public void pulQoshish(double miqdor) {
        if (miqdor > 0) {
            this.balans += miqdor;
            System.out.println(miqdor + " sum qo'shildi. Yangi balans: " + balans);
        } else {
            System.out.println("Xato: Miqdor musbat bo'lishi kerak!");
        }
    }
    
    public void pulYechish(double miqdor) {
        if (miqdor > 0 && miqdor <= balans) {
            this.balans -= miqdor;
            System.out.println(miqdor + " sum yechildi. Yangi balans: " + balans);
        } else if (miqdor > balans) {
            System.out.println("Xato: Balans yetarli emas!");
        } else {
            System.out.println("Xato: Miqdor musbat bo'lishi kerak!");
        }
    }
    
    // Ma'lumotlarni chiqarish
    public void hisobMalumotlari() {
        System.out.println("\n=== HISOB MA'LUMOTLARI ===");
        System.out.println("Hisob egasi: " + egasi);
        System.out.println("Hisob raqami: " + hisobRaqami);
        System.out.println("Balans: " + balans + " sum");
    }
}

// Test qilish
public class HisobTest {
    public static void main(String[] args) {
        // Hisob yaratish
        Hisob meningHisobim = new Hisob("Ali Valiyev", 1000000, "8600123456789012");
        
        // Getterlar orqali o'qish
        System.out.println("Hisob egasi: " + meningHisobim.getEgasi());
        System.out.println("Balans: " + meningHisobim.getBalans());
        
        // Usullar orqali o'zgartirish
        meningHisobim.pulQoshish(500000);    // 500000 sum qo'shildi
        meningHisobim.pulYechish(200000);    // 200000 sum yechildi
        meningHisobim.pulYechish(2000000);   // Xato: Balans yetarli emas!
        
        // Setter bilan o'zgartirish
        meningHisobim.setEgasi("Ali Valiyev O'g'li");  // O'zgardi
        meningHisobim.setEgasi("");                   // Xato: Egasi nomi bo'sh bo'lishi mumkin emas!
        
        // To'liq ma'lumot
        meningHisobim.hisobMalumotlari();
    }
}
```

---

## Savol: "Nega Getter va Setter Kerak?"

### Getter va Setter ishlatmasdan (Public fields):
```java
public class TalabaPublic {
    public String ism;      // To'g'ridan-to'g'ri kirish
    public int yosh;        // Har kim o'zgartira oladi
    public double bal;      // Hech qanday cheklov yo'q
}

// Asosiy kodda
TalabaPublic talaba = new TalabaPublic();
talaba.ism = "Ali";
talaba.yosh = -5;           // Manfiy yosh! Xato, lekin yo'q qilish imkoni yo'q
talaba.bal = 1000;
```

**Muammo:**
- Ma'lumotlar **har kim tomonidan** o'zgartirilishi mumkin
- **Cheklovlar yo'q** (manfiy yosh, bo'sh ism, etc.)
- **Kod tarqalib ketadi** - har joyda to'g'rilikni tekshirish kerak

### Getter va Setter bilan (Encapsulated):
```java
public class TalabaEncapsulated {
    private String ism;
    private int yosh;
    private double bal;
    
    // Getter va Setter bilan cheklovlar
    public void setYosh(int yosh) {
        if (yosh >= 0 && yosh <= 120) {  // Validation
            this.yosh = yosh;
        } else {
            System.out.println("Xato: Yosh 0-120 oralig'ida bo'lishi kerak!");
        }
    }
    
    public void setBal(double bal) {
        if (bal >= 0) {  // Validation
            this.bal = bal;
        } else {
            System.out.println("Xato: Bal manfiy bo'lishi mumkin emas!");
        }
    }
    
    // Getterlar
    public String getIsm() { return ism; }
    public int getYosh() { return yosh; }
    public double getBal() { return bal; }
}
```

**Afzalliklar:**
1. **Validation** - Ma'lumot kiritilishida tekshirish
2. **Logging** - O'zgarishlarni kuzatish
3. **Flexibility** - Ixtiyoriy o'zgartirishlar
4. **Maintainability** - O'zgartirish bir joyda
5. **Security** - Kontrolli kirish

---

## Vizual Tasvirlash

### Encapsulation bilan (Getter/Setter):
```
     ____/  | |  \_____   
    |                  |
    |     Ma'lumot     |
    |__________________|
    
    Faqat getter va setter orqali kirish
    (bitta kirish/chiqish nuqtasi)
```

**Afzalliklari:**
- **Nazorat** - kirish bitta joyda boshqariladi
- **Xavfsizlik** - noto'g'ri ma'lumotni oldini olish
- **Moslashuvchanlik** - ichki o'zgarishlar tashqariga ta'sir qilmaydi

### Public fields bilan:
```
         \    |     /
      —>  Ma'lumot   <—
         /    |     \  
    
    Har tomondan ochiq kirish
```

**Muammolari:**
- **No control** - har kim o'zgartira oladi
- **No validation** - noto'g'ri ma'lumot kiritilishi mumkin
- **Tight coupling** - kod tarqalib ketadi

---

## 3. Package (Paketlar)

### Package nima?
**Package** - bir-biriga bog'liq klasslarni guruhlash usuli. Bu fayl tizimidagi papkalarga o'xshaydi.

### Package nomlash konvensiyalari:
```
com.ibm.pdp.online.auth

┌───┬───┬──────┬────────┬─────┐
│ 1 │ 2 │  3   │   4    │  5  │
└───┴───┴──────┴────────┴─────┘
  1. Company specification (com, org, edu, gov)
  2. Company name (ibm, google, microsoft)
  3. Client/Product name (pdp)
  4. Project name (online)
  5. Module name (auth)
```

### Misol package tuzilmalari:
```java
// Bank tizimi uchun package
package com.nbu.online.banking;

// Auth moduli
package com.nbu.online.banking.auth;

// Hisob moduli
package com.nbu.online.banking.account;

// O'tkazma moduli  
package com.nbu.online.banking.transfer;
```

### Package yaratish va ishlatish:

#### 1. Package yaratish:
```
src/
├── com/
│   └── nbu/
│       └── online/
│           └── banking/
│               ├── auth/
│               │   ├── User.java
│               │   └── LoginService.java
│               ├── account/
│               │   ├── Account.java
│               │   └── AccountService.java
│               └── Main.java
```

#### 2. Package declaration:
```java
// Account.java faylida
package com.nbu.online.banking.account;

public class Account {
    private String accountNumber;
    private double balance;
    
    // Constructor, getters, setters...
}
```

#### 3. Boshqa packagelardan foydalanish:
```java
// Main.java faylida
package com.nbu.online.banking;

// Import qilish
import com.nbu.online.banking.account.Account;
import com.nbu.online.banking.auth.User;

public class Main {
    public static void main(String[] args) {
        // Package ichidagi klasslardan foydalanish
        Account account = new Account();
        User user = new User();
    }
}
```

### Package'ning afzalliklari:

1. **Nomlar to'qnashuvini oldini olish**
```java
// Bank1 kompaniyasi
package com.bank1.finance;
class Account { /* ... */ }

// Bank2 kompaniyasi  
package com.bank2.finance;
class Account { /* ... */ }

// Ikkalasi ham bir nomda, lekin turli packagelarda
```

2. **Access Control** (kirish nazorati)
```java
package com.example.library;

public class Book {
    public String title;           // Barcha packagelardan ko'rinadi
    protected String author;       // Faqat o'z package'i va child klasslar
    String publisher;             // Faqat o'z package'i ichida (default)
    private int pageCount;        // Faqat o'z klassida
}
```

3. **Kodni tashkil etish**
```java
// Yaxshi tashkil etilgan package tuzilmasi
src/
├── model/          // Data model klasslari
├── service/        // Business logic
├── repository/     // Data access
├── controller/     // User interface
└── util/          // Utility klasslari
```

### Amaliy Misol: To'liq Package Tuzilmasi

```java
// File: com/company/bank/model/Account.java
package com.company.bank.model;

public class Account {
    private String accountNumber;
    private double balance;
    private String owner;
    
    public Account(String accountNumber, double initialBalance, String owner) {
        this.accountNumber = accountNumber;
        this.balance = initialBalance;
        this.owner = owner;
    }
    
    // Getters and setters
    public String getAccountNumber() { return accountNumber; }
    public double getBalance() { return balance; }
    public String getOwner() { return owner; }
    
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
        }
    }
    
    public boolean withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            return true;
        }
        return false;
    }
}
```

```java
// File: com/company/bank/service/AccountService.java
package com.company.bank.service;

import com.company.bank.model.Account;

public class AccountService {
    public void transfer(Account from, Account to, double amount) {
        if (from.withdraw(amount)) {
            to.deposit(amount);
            System.out.println("O'tkazma muvaffaqiyatli amalga oshirildi");
        } else {
            System.out.println("O'tkazma amalga oshirilmadi: balans yetarli emas");
        }
    }
    
    public void printAccountInfo(Account account) {
        System.out.println("Hisob raqami: " + account.getAccountNumber());
        System.out.println("Egasi: " + account.getOwner());
        System.out.println("Balans: $" + account.getBalance());
    }
}
```

```java
// File: com/company/bank/Main.java
package com.company.bank;

import com.company.bank.model.Account;
import com.company.bank.service.AccountService;

public class Main {
    public static void main(String[] args) {
        // Account yaratish
        Account aliHisobi = new Account("123456", 1000.0, "Ali Valiyev");
        Account valiHisobi = new Account("789012", 500.0, "Vali Aliyev");
        
        // Service yaratish
        AccountService service = new AccountService();
        
        // Hisob ma'lumotlari
        System.out.println("Boshida:");
        service.printAccountInfo(aliHisobi);
        service.printAccountInfo(valiHisobi);
        
        // O'tkazma
        System.out.println("\nO'tkazma amalga oshirilmoqda...");
        service.transfer(aliHisobi, valiHisobi, 300.0);
        
        // Natijalar
        System.out.println("\nO'tkazmadan keyin:");
        service.printAccountInfo(aliHisobi);
        service.printAccountInfo(valiHisobi);
    }
}
```

---

## Mavzuga doir savollar

### Savol 1: Quyidagi kodda encapsulation qayerda buzilgan?
```java
public class Car {
    public String model;
    public double price;
    
    public void drive() {
        System.out.println(model + " haydamoqda...");
    }
}
```

### Savol 2: Quyidagi package nomi to'g'rimi?
```
org.google.search.engine
```

### Savol 3: Getter va Setter nima uchun kerak?

---

## Amaliy Topshiriq

1. **Talaba klassini yarating** (Encapsulation bilan):
    - Fieldlar: ism, yosh, guruh, baholar massivi
    - Getter/Setter metodlari
    - Validation: yosh 16-60, baho 0-100

2. **Package tuzilmasi yarating**:
    - com.university.students.model
    - com.university.students.service
    - com.university.students.main

3. **Getter/Setter'ga misol**:
    - setYosh() - agar yosh noto'g'ri bo'lsa, xato chiqarsin
    - getOrtachaBaho() - baholarning o'rtachasini hisoblasin

---

## Muhim Xulosa

1. **Encapsulation** - OOP ning asosiy ustunlaridan biri
2. **Getter/Setter** - Ma'lumotlarni himoya qilish va validation qilish usuli
3. **Package** - Kodni tashkil etish va nomlar to'qnashuvini oldini olish
4. **Access Modifiers** - Kirish nazorati (public, protected, default, private)

> 💡 **Eslatma:** Encapsulation nafaqat "private field + getter/setter". Bu ma'lumot va uning ustidagi ope ratsiyalarni bitta birlikda saqlash falsafasidir. Yaxshi dasturchi yaxshi architect. Encapsulation va packaging sizning dasturingiz architecture'sini belgilaydi!
---

**Keyingi mavzu**: [03 - Inheritance (Meros olish)](./03_Inheritance.md)  
**[Mundarijaga qaytish](../README.md)**

> ⚡️ O'rganishda davom etamiz.