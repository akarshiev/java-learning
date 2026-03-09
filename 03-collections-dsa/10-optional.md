# Optional Klassi

Java 8 da kiritilgan `Optional` klassi `null` qiymatlarni xavfsiz boshqarish uchun ishlatiladi.

## Optional Yaratish

```java
Optional<String> empty = Optional.empty();
Optional<String> of = Optional.of("Hello");
Optional<String> nullable = Optional.ofNullable(null);
```

## Optional Usullari

| Usul | Tavsif |
|------|--------|
| `isPresent()` | Qiymat mavjudligini tekshirish |
| `isEmpty()` | Qiymat yo'qligini tekshirish |
| `get()` | Qiymatni olish |
| `orElse(T)` | Qiymat yo'q bo'lsa alternativ qaytarish |
| `orElseGet(Supplier)` | Supplier dan alternativ olish |
| `orElseThrow()` | Qiymat yo'q bo'lsa istisno tashlash |
| `map(Function)` | Qiymatni o'zgartirish |
| `filter(Predicate)` | Qiymatni filtrlash |
| `ifPresent(Consumer)` | Qiymat mavjud bo'lsa amal bajarish |
