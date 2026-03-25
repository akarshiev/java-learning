# 1-Modul: Jakarta EE - Korxona Dasturlash Platformasi

## 1.1 Jakarta EE (Java Platform, Enterprise Edition) Nima?

**Jakarta EE** (eski nomi Java Platform, Enterprise Edition - Java EE, undan ham eskisi Java 2 Platform Enterprise Edition - J2EE) - bu Java SE (Standard Edition) ni korxona darajasidagi imkoniyatlar bilan kengaytiruvchi **spetsifikatsiyalar to'plamidir**. Bu spetsifikatsiyalar distributed computing (tarqoq hisoblash) va web services kabi korxona dasturlash uchun zarur bo'lgan texnologiyalarni standartlashtiradi.

**Oddiy qilib aytganda:** Agar Java SE oddiy dasturlar (kalkulyator, o'yin, ofis dasturi) yozish uchun vositalar bersa, Jakarta EE katta, murakkab, tarmoq orqali ishlaydigan, ko'p foydalanuvchiga xizmat ko'rsatadigan korxona ilovalarini (bank tizimi, onlayn do'kon, aviakassa) yaratish uchun kerakli qo'shimcha spetsifikatsiyalarni taqdim etadi.

---

## 1.2 Tarixi: J2EE dan Jakarta EE gacha bo'lgan yo'l

Java Enterprise texnologiyasining rivojlanish bosqichlari:

| Yil | Versiya | Muhim O'zgarishlar |
|-----|---------|-------------------|
| 1999 | J2EE 1.2 | Birinchi versiya, korxona dasturlash asoslari |
| 2001 | J2EE 1.3 | **JSTL** (JSP Standard Tag Library) va **JAAS** (Java Authentication and Authorization Service) qo'shildi. Servlets texnologiyasi takomillashtirildi. |
| 2003 | J2EE 1.4 | **Web Services** qo'llab-quvvatlandi. **JSF** (Java Server Faces), **JAXP**, **JAXR** qo'shildi. Lekin platforma "o'rganish qiyin", "murakkab", "unumli emas" deb topildi. |
| 2006 | Java EE 5 | Nom J2EE dan Java EE ga o'zgardi. **Annotation**'lar qo'shildi, bu XML konfiguratsiyani sezilarli darajada kamaytirdi va platformani osonlashtirdi. |
| 2009 | Java EE 6 | **CDI** (Contexts and Dependency Injection) va **Bean Validation** qo'shildi, konfiguratsiya yanada soddalashtirildi. |
| 2013 | Java EE 7 | **WebSockets** va **JSON-P** (JSON Processing) spetsifikatsiyalari qo'shildi, platforma modernizatsiya qilindi. |
| 2017 | Oracle, Java EE ni ochiq manba qilishni e'lon qildi, EE4J (Eclipse Enterprise for Java) loyihasi tuzildi. |
| 2019 | Jakarta EE 8 | Java EE 8 ni ochiq manba versiyasi. |
| 2020 | Jakarta EE 9 | Eng muhim o'zgarish: barcha API'lar `javax.*` namespace'idan `jakarta.*` namespace'iga o'tkazildi (trademark cheklovlari tufayli). |
| 2021 | Jakarta EE 9.1 | Java SE 11 qo'llab-quvvatlandi. |
| 2022 | Jakarta EE 10 | Zamonaviy imkoniyatlar qo'shildi (CDI 4.0, Jakarta Security 3.0). |

---

## 1.3 Jakarta EE Spetsifikatsiyalari

Jakarta EE bir nechta spetsifikatsiyalarni o'z ichiga oladi. Ularni quyidagi guruhlarga bo'lish mumkin:

### A) Web (Veb) Spetsifikatsiyalari

| Spetsifikatsiya | Tavsifi |
|-----------------|---------|
| **Jakarta Servlet** | HTTP so'rovlarini (synchronous va asynchronous) boshqarish uchun asosiy API. Boshqa spetsifikatsiyalar ko'pincha unga tayanadi. **Dynamic web application** (dinamik veb-ilovalar) yaratish texnologiyasi. |
| **Jakarta WebSocket** | WebSocket ulanishlari orqali real-time aloqa qilish uchun API. (Chat, onlayn o'yinlar) |
| **Jakarta Server Pages (JSP)** | HTML ichida Java kodi yozish imkonini beruvchi texnologiya. **Server-side rendering** (server tomonda sahifa generatsiyasi). |
| **Jakarta Server Faces (JSF)** | Komponentlarga asoslangan UI yaratish texnologiyasi. Backend bilan UI komponentlarini bog'lashni osonlashtiradi. |
| **Jakarta Expression Language (EL)** | JSP va JSF da backend bean'lariga murojaat qilish uchun ishlatiladigan sodda til. |

### B) Web Service Spetsifikatsiyalari

| Spetsifikatsiya | Tavsifi |
|-----------------|---------|
| **Jakarta RESTful Web Services (JAX-RS)** | **REST** arxitektura uslubida web servislar yaratish. (Hozirgi eng keng tarqalgan usul) |
| **Jakarta JSON Processing (JSON-P)** | JSON formatdagi ma'lumotlarni parse qilish va yaratish uchun API. (Low-level) |
| **Jakarta JSON Binding (JSON-B)** | JSON va Java obyektlari o'rtasida o'tkazish (binding) uchun API. (High-level) |
| **Jakarta XML Binding (JAXB)** | XML va Java obyektlari o'rtasida o'tkazish. |
| **Jakarta XML Web Services (JAX-WS)** | **SOAP** protokoli asosida web servislar yaratish. |

### C) Korxona (Enterprise) Spetsifikatsiyalari

| Spetsifikatsiya | Tavsifi |
|-----------------|---------|
| **Jakarta Contexts and Dependency Injection (CDI)** | **Dependency Injection** (bog'liqliklarni avtomatik kiritish) va kontekst boshqaruvi uchun standart. |
| **Jakarta Enterprise Beans (EJB)** | **Transaction** (tranzaksiya), **concurrency** (parallelik), **security** (xavfsizlik) kabi korxona xususiyatlarini ta'minlaydigan biznes obyektlari uchun spetsifikatsiya. EJB container tomonidan boshqariladi. |
| **Jakarta Persistence (JPA)** | **ORM** (Object-Relational Mapping) - ma'lumotlar bazasi jadvallari va Java klasslari o'rtasidagi bog'liqlikni boshqaradi. |
| **Jakarta Transactions (JTA)** | Tarqoq tizimlarda tranzaksiyalarni boshqarish uchun API. Odatda CDI yoki EJB orqali ishlatiladi. |
| **Jakarta Messaging (JMS)** | Korxona darajasidagi messaging (xabar almashish) tizimlari bilan ishlash uchun API. |

### D) Boshqa Spetsifikatsiyalar

- **Jakarta Security** - autentifikatsiya va autorizatsiya.
- **Jakarta Batch** - batch (partiyaviy) ishlov berish.
- **Jakarta Concurrency** - parallel dasturlash.
- **Jakarta Mail** - email yuborish.

---

## 1.4 Jakarta EE nima uchun kerak?

1. **Korxona darajasidagi dasturlarni soddalashtiradi** - Murakkab masalalarni (tranzaksiya, xavfsizlik, parallelik) standartlashtirilgan API'lar bilan yechish imkonini beradi.

2. **Turli xil texnologiyalar bilan ishlashni standartlashtiradi** - Turli vendor'larning (IBM, Oracle, Red Hat) mahsulotlari bir xil API'lar orqali ishlaydi.

3. **Ko'p foydalanuvchiga xizmat ko'rsatish** - Katta hajmdagi so'rovlarni boshqarish uchun mo'ljallangan.

4. **Tarmoq orqali ishlash** - Tarqoq tizimlar (microservices, SOA) qurish uchun asos.

5. **Xavfsizlik** - Autentifikatsiya, autorizatsiya, rollar, tranzaksiya xavfsizligi.

6. **Veb ilovalar yaratish** - Dinamik veb-saytlar, REST API, SOAP servislari.

---

## 1.5 Jakarta EE vs Java SE

| Java SE (Standard Edition) | Jakarta EE (Enterprise Edition) |
|----------------------------|---------------------------------|
| Oddiy dasturlar, konsol ilovalari | Korporativ ilovalar, veb-ilovalar |
| Desktop dasturlari (Swing, JavaFX) | Web applicationlar, REST/SOAP servislari |
| Bitta JVM da ishlaydi | Tarqoq tizimlar, cluster |
| Dependency injection yo'q | CDI bilan DI standarti |
| Transaction yo'q | JTA bilan transaction standarti |
| JPA yo'q | JPA bilan ORM standarti |

**Muhim:** Jakarta EE Java SE ustiga qurilgan. Java SE bilmasdan Jakarta EE ni o'rganib bo'lmaydi.

---

## 1.6 Jakarta EE Application Server'lar

Jakarta EE spetsifikatsiyalarini implement qilgan **application server** (ilova serveri) lar mavjud. Ularning vazifasi - Jakarta EE ilovalarini ishga tushirish va boshqarish.

| Application Server | Tavsifi |
|--------------------|---------|
| **Tomcat (Servlet Container)** | Faqat Servlet va JSP ni qo'llab-quvvatlaydi (web spetsifikatsiyalari). Jakarta EE ning to'liq implementatsiyasi emas. |
| **Payara Server** | Glassfish asosida, Jakarta EE to'liq implementatsiyasi. |
| **WildFly** | Red Hat tomonidan, eski nomi JBoss. To'liq Jakarta EE implementatsiyasi. |
| **Open Liberty** | IBM tomonidan. |
| **GlassFish** | Oracle tomonidan (Jakarta EE referent implementatsiyasi). |

---

## 1.7 Jakarta EE Versiyalari va Javalar Uyg'unligi

| Jakarta EE Versiyasi | Java SE Versiyasi | Muhim Xususiyat |
|---------------------|-------------------|-----------------|
| Jakarta EE 8 | Java SE 8 | javax.* namespace |
| Jakarta EE 9 | Java SE 8 | jakarta.* namespace ga o'tish |
| Jakarta EE 9.1 | Java SE 11 | Java 11 qo'llab-quvvatlandi |
| Jakarta EE 10 | Java SE 11, 17, 21 | CDI 4.0, Security 3.0 |

**Eslatma:** Jakarta EE 9 dan boshlab namespace `jakarta.*` ga o'zgargan. Bu muhim o'zgarish, chunki eski kodlar (javax.*) yangi Jakarta EE serverlarida ishlamaydi.

---

## Tekshiruv Savollari

1. **Jakarta EE nima? U Java SE dan qanday farq qiladi?**
2. **J2EE, Java EE, Jakarta EE nomlari o'rtasidagi bog'liqlikni tushuntiring.**
3. **J2EE 1.4 da qanday muhim spetsifikatsiyalar qo'shilgan?**
4. **Java EE 5 da qanday muhim o'zgarish bo'ldi?**
5. **Jakarta EE 9 da eng muhim o'zgarish nima edi va nima uchun?**
6. **Web spetsifikatsiyalariga qaysilar kiradi?**
7. **REST va SOAP web servislar uchun qaysi spetsifikatsiyalar javobgar?**
8. **CDI, EJB, JPA, JTA, JMS spetsifikatsiyalarining vazifalarini tushuntiring.**
9. **Jakarta EE application server nima? Misollar keltiring.**
10. **Tomcat Jakarta EE application server hisoblanadimi? Nima uchun?**

---

**Keyingi mavzu:** [Jakarta Server Pages (JSP)](./02_JSP.md)  
**[Mundarijaga qaytish](../README.md)**

> Jakarta EE - korxona dasturlash standarti. Java SE ni mustahkam o'zlashtirib olgach, bu platformani o'rganish orqali professional darajadagi veb-ilovalar yaratishga tayyor bo'lasiz. 🚀
