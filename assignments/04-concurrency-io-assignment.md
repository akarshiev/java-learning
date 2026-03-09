# 4-Modul Assignment: Ucell Boshqaruv Tizimi

## Loyiha Tavsifi

Ucell kompaniyasiga o'xshash mobil operator boshqaruv tizimini yaratish. Tizimda foydalanuvchilar rollar asosida turli imkoniyatlarga ega bo'ladi.

## Texnik Talablar

### 1. Ma'lumotlarni Saqlash

Barcha ma'lumotlar fayllarda saqlanishi kerak. Har bir entity uchun alohida fayl:

- `users.dat` - foydalanuvchilar
- `numbers.dat` - telefon raqamlar
- `tariffs.dat` - tariflar
- `ussd_codes.dat` - USSD kodlar
- `transactions.log` - barcha harakatlar logi

### 2. Authorization Tizimi

- Registratsiya: Faqat email orqali
- Login: Email orqali
- Regex yordamida ma'lumotlarni tekshirish:
  - Email formati
  - Parol mustahkamligi
  - Telefon raqam formati

### 3. Logging

- Barcha muvaffaqiyatli operatsiyalar log fayliga yoziladi
- Log format: `[TIMESTAMP] [LEVEL] [USER] [ACTION] - [DETAILS]`
- Java Logging API dan foydalanish

### 4. Time API

- Registratsiya vaqti `LocalDateTime` bilan saqlanadi
- Har bir harakat vaqti bilan birga saqlanadi
- Fayldan o'qiganda `LocalDateTime.parse()` bilan parse qilinadi

### 5. Rollar

| Rol        | Huquqlar                                              |
|------------|-------------------------------------------------------|
| SuperAdmin | Admin, Manager, User CRUD                             |
| Admin      | Nomer CRUD, Tarif CRUD                                |
| Manager    | Raqamlarni muzlatish/faollashtirish, USSD menu boshqarish |
| User       | Nomerlarni ko'rish, Tariflarni ko'rish, USSD menu dan foydalanish |

## Loyiha Strukturasi

```plaintext
src/
├── Main.java
├── model/
│   ├── User.java
│   ├── Role.java
│   ├── PhoneNumber.java
│   ├── Tariff.java
│   ├── USSDCode.java
│   └── Transaction.java
├── service/
│   ├── AuthService.java
│   ├── SuperAdminService.java
│   ├── AdminService.java
│   ├── ManagerService.java
│   └── UserService.java
├── repository/
│   ├── FileRepository.java
│   ├── UserRepository.java
│   ├── NumberRepository.java
│   ├── TariffRepository.java
│   └── USSDRepository.java
├── util/
│   ├── Validator.java
│   ├── LoggerUtil.java
│   └── FileUtil.java
└── exception/
    └── CustomException.java
```
