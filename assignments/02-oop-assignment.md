# OOP Assignment (Universal CRUD Loyihasi)

## Loyiha Tavsifi

1-dastur ishga tushganda console da menu chiqsin unda:

1. **Student CRUD** (Easy)
2. **Product CRUD** (Middle)
3. **Minesweeper Game** (Hard)
4. **Interview questions answer** - ushbu modulda berilgan barcha interview questions larga javob topib yozib chiqishingiz kerak

## 1. Student CRUD

### Talablar:
Student table bo'ladi unda kamida quyidagi fieldlar bo'lsin:

```java
private String name;
private String lastName;
private int age;
private String phoneNumber;
```

### Vazifalar:
- CREATE (Yangi student yaratish)
- UPDATE (Mavjud studentni yangilash)
- DELETE (Studentni o'chirish)
- READ (Studentlarni ko'rish)

### Texnik talablar:
- Switch case operatoridan foydalanish
- Arraylar yordamida ma'lumotlarni saqlash
- Validation (to'g'ri ma'lumot kiritilishini tekshirish)

## 2. Product CRUD

### Asosiy classlar:

**Product Class:**
```java
public class Product {
    private String name;
    private double price;
    private ProductCategory category;
}
```

**ProductCategory Enum:**
```java
public enum ProductCategory {
    ELECTRONICS(new String[][]{{"Laptop", "Mobile", "Tablet"}, {"TV", "Camera", "Headphones"}}),
    CLOTHING(new String[][]{{"Shirt", "Trousers", "Dress"}, {"Shoes", "Socks", "Hat"}});
    
    private String[][] subCategories;
    
    ProductCategory(String[][] subCategories) {
        this.subCategories = subCategories;
    }
}
```

**InventoryManagementSystem Class:**
```java
public class InventoryManagementSystem {
    private Product[][] inventory;
    private int maxProducts;
    private int currentProducts;
    
    public InventoryManagementSystem(int maxProducts) {
        this.maxProducts = maxProducts;
        inventory = new Product[maxProducts][2];
        currentProducts = 0;
    }
}
```

### Vazifalar:
- Product yaratish, yangilash, o'chirish va ko'rish
- Ikki o'lchamli massivlar bilan ishlash
- Kategoriya va sub-kategoriyalar bilan ishlash

### Texnik talablar:
- Getter/Setter methodlari
- toString() methodi override qilish
- 2 o'lchamli massivlar bilan ishlash
- Switch case operatorlari

## 3. Minesweeper Game

### O'yin qoidalari:
- Minimum 8x8 o'lchamdagi table
- Barcha kataklar yashirilgan
- Kataklarda minalar va oddiy sonlar bo'ladi
- Mina bor xonani topilsa o'yin to'xtaydi
- Son topilsa rekursiv tarzda atrofidagi mina bo'lmagan xonalar ochiladi
- Barcha minalardan tashqari kataklar ochilsa o'yinchi yutadi

### Texnik talablar:
- 2 o'lchamli massiv (char yoki boolean)
- Random class yordamida minalarni joylashtirish
- Rekursiya metodlari
- While, for, ichma-ich for tsikllari
- Table'larni to'ldirish va chiqarish

### O'yin elementi:
- '*' - yopiq katak
- ' ' - ochiq katak (bo'sh)
- '1'-'8' - atrofdagi minalar soni
- 'X' - mina

## 4. Interview Questions Answer

### Talablar:
- Barcha OOP interview savollariga javob topish
- Javoblarni `.txt` faylga yozish
- Alohida package ochib, javoblarni joylash
- Menu da ushbu bo'limni tanlaganda qaysi package'da javoblar joylanganligi haqida ma'lumot chiqishi

### Tashkil etish:
1. `Answers/` package yaratish
2. Har bir mavzu bo'yicha alohida `.txt` fayllar
3. `README.txt` faylida barcha javoblar joylashuvi haqida ma'lumot
4. Menu da "Interview questions answer" tanlanganda fayl yo'li ko'rsatilishi

## Loyicha Arxitekturasi

```
src/
├── Main.java                    // Asosiy menu va dastur boshqaruvi
├── student/
│   ├── Student.java            // Student modeli
│   ├── StudentService.java     // Student CRUD logikasi
│   └── StudentCRUD.java        // Student CRUD interfeysi
├── product/
│   ├── Product.java            // Product modeli
│   ├── ProductCategory.java    // Enum kategoriyalari
│   ├── InventorySystem.java    // Inventory boshqaruvi
│   └── ProductCRUD.java        // Product CRUD interfeysi
├── game/
│   ├── Minesweeper.java        // O'yin logikasi
│   ├── GameBoard.java          // O'yin doskasi
│   └── GameController.java     // O'yin boshqaruvi
├── answers/
│   ├── README.txt              // Javoblar joylashuvi haqida
│   ├── OOP_Answers.txt         // OOP javoblari
│   ├── Basics_Answers.txt      // Basic javoblari
│   └── ... (boshqa mavzular)
└── utils/
    ├── InputUtils.java         // Input qabul qilish
    ├── DisplayUtils.java       // Chiqarish formati
    └── FileUtils.java          // Fayl operatsiyalari
```

## Ruxsat olinishi kerak bo'lgan bilimlar:

### Student CRUD uchun:
- Switch case statement
- Arraylar (bir o'lchamli)
- String va primitiv typelar
- Looplar (for, while)
- Basic validation

### Product CRUD uchun:
- Getter/Setter methodlari
- toString() method override
- 2D arraylar
- Enum classlar
- Switch case

### Minesweeper uchun:
- 2D arraylar
- Random class
- Rekursiya
- Nested loops
- Char array bilan ishlash
- Boolean flaglar

### Umumiy:
- Package tuzilishi
- Fayl I/O operatsiyalari
- Console interfeysi
- Error handling
- Code organization

## Qo'shimcha vazifalar (optionally):

1. **Faylga saqlash** - Barcha ma'lumotlarni faylga yozish va undan o'qish
2. **Logging** - Barcha operatsiyalarni log qilish
3. **Search** - Student/Product qidirish funksiyasi
4. **Sorting** - Ma'lumotlarni saralash
5. **GUI** (advanced) - JavaFX yoki Swing yordamida grafik interfeys

## Testlash uchun:

1. **Student CRUD testi:**
    - 10 ta student yaratish
    - 3-tasini update qilish
    - 5-tasini delete qilish
    - Barchasini ko'rish

2. **Product CRUD testi:**
    - Turli kategoriyadagi 5 ta product yaratish
    - Narxlarni update qilish
    - Inventory'dan product o'chirish

3. **Minesweeper testi:**
    - O'yinni boshlash
    - Bir necha yurish qilish
    - Mina ustiga tushish
    - Yutish holatini test qilish

4. **Interview answers testi:**
    - Barcha javob fayllarini tekshirish
    - Menu orqali fayllarga kirishni tekshirish

---

**Eslatma:** Bu loyiha Java OOP konsepsiyalarini amaliyotda qo'llash uchun mukammal imkoniyat. Har bir modul alohida OOP tamoyillarini o'z ichiga oladi va ularni mustahkamlaydi.
