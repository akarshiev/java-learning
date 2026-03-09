# 5-Modul: Mailing (Elektron Pochta Yuborish)

## 5.1 - Mailing asoslari

### Mailing nima?

**Mailing** - dastur orqali elektron pochta xabarlarini yuborish jarayoni. Java real hayotdagi ilovalarda keng qo'llaniladigan bu vazifa uchun **JavaMail API** ni taqdim etadi.

```java
// Oddiy email yuborish misoli
public void sendSimpleEmail(String to, String subject, String body) {
    // JavaMail API orqali email yuborish
    // Konfiguratsiya, session, message, transport
}
```

### Nima uchun Mailing kerak?

1. **Foydalanuvchilarga xabarnoma yuborish** - Registratsiya, parolni tiklash
2. **Marketing xabarlari** - Yangiliklar, aksiyalar
3. **Hisobotlarni yuborish** - Statistik ma'lumotlar
4. **Tasdiqlash xabarlari** - Buyurtma, to'lov tasdiqlash

---

## 5.2 - Asosiy tushunchalar

### SMTP (Simple Mail Transfer Protocol)

**SMTP** - elektron pochta xabarlarini yuborish uchun internet standart protokoli.

```java
// SMTP server misollari
String gmailSmtp = "smtp.gmail.com";      // Gmail uchun
String mailtrapSmtp = "sandbox.smtp.mailtrap.io"; // Test uchun
String yandexSmtp = "smtp.yandex.com";    // Yandex uchun

// Portlar:
// 465 - SSL uchun
// 587 - TLS uchun (starttls)
// 25 - standart (ko'pincha bloklangan)
```

### SSL (Secure Sockets Layer)

**SSL** - veb-server va brauzer o'rtasidagi ma'lumotlarni shifrlaydi, xavfsizlikni ta'minlaydi.

```java
// SSL konfiguratsiyasi
Properties props = new Properties();
props.put("mail.smtp.ssl.enable", "true"); // SSL yoqish
props.put("mail.smtp.port", "465");        // SSL port
```

### TLS (Transport Layer Security)

**TLS** - SSL ning davomchisi, tarmoq orqali xavfsiz aloqa qilish protokoli.

```java
// TLS konfiguratsiyasi
Properties props = new Properties();
props.put("mail.smtp.starttls.enable", "true"); // TLS yoqish
props.put("mail.smtp.port", "587");              // TLS port
```

---

## 5.3 - JavaMail API

### Maven Dependency'lar

```xml
<!-- JavaMail API -->
<dependency>
    <groupId>com.sun.mail</groupId>
    <artifactId>javax.mail</artifactId>
    <version>1.6.2</version>
</dependency>

<!-- Activation Framework (Java 9+ uchun kerak) -->
<dependency>
    <groupId>javax.activation</groupId>
    <artifactId>activation</artifactId>
    <version>1.1.1</version>
</dependency>
```

### JAR fayllar (Maven'siz)

Agar Maven ishlatmasangiz, JAR fayllarni yuklab oling:
- **[javax.mail-1.6.2.jar](https://repo1.maven.org/maven2/com/sun/mail/javax.mail/1.6.2/)**
- **[activation-1.1.1.jar](https://repo1.maven.org/maven2/javax/activation/activation/1.1.1/)**

---

## 5.4 - Gmail orqali email yuborish

### Gmail sozlamalari

```java
package uz.pdp.mailing;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class GmailExample {
    public static void main(String[] args) {
        // 1. Properties sozlash
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "465");
        properties.put("mail.smtp.ssl.enable", "true");
        properties.put("mail.smtp.auth", "true");
        
        // 2. Username va password
        String username = "sizningemail@gmail.com";
        // Google Account -> Security -> App passwords
        String password = "xxxx xxxx xxxx xxxx"; // 16 xonali app password
        
        // 3. Session yaratish
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        
        try {
            // 4. Message yaratish
            Message message = new MimeMessage(session);
            message.setSubject("Test Subject");
            message.setText("Hello from Java!");
            message.setFrom(new InternetAddress(username));
            
            // 5. Qabul qiluvchi
            String recipient = "qabulqiluvchi@gmail.com";
            message.setRecipient(Message.RecipientType.TO, 
                new InternetAddress(recipient));
            
            // 6. Yuborish
            Transport.send(message);
            
            System.out.println("✅ Message sent successfully");
            
        } catch (MessagingException e) {
            System.err.println("❌ Error sending email: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

### Gmail App Password olish

```markdown
# Gmail App Password yaratish

1. Google Account ga kiring
2. Security (Xavfsizlik) bo'limiga o'ting
3. "2-Step Verification" (2 bosqichli tasdiqlash) ni yoqing
4. "App passwords" (Ilova parollari) ni tanlang
5. App: "Mail", Device: "Other" tanlang
6. Generated password ni saqlang

⚠️ Muhim: Asosiy parolingizni EMAS, shu maxsus parolni ishlating!
```

---

## 5.5 - Mailtrap orqali test qilish

### Mailtrap nima?

**Mailtrap** - email yuborishni test qilish uchun xizmat. Haqiqiy email yubormasdan, xabarlarni ko'rish imkonini beradi.

```java
package uz.pdp.mailing;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class MailtrapExample {
    public static void main(String[] args) {
        // 1. Mailtrap credentials (mailtrap.io dan olinadi)
        String username = "27aac8a7963319";   // Your inbox username
        String password = "29b4d367a4cda2";    // Your inbox password
        
        // 2. Properties sozlash
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "sandbox.smtp.mailtrap.io");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.auth", "true");
        
        // 3. Session yaratish
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        
        // 4. Debug mode (ixtiyoriy)
        session.setDebug(true);
        
        try {
            // 5. HTML formatdagi xabar
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("sender@example.com"));
            message.setRecipient(Message.RecipientType.TO, 
                new InternetAddress("test@example.com"));
            
            message.setSubject("HTML Email Test");
            
            // HTML content yuborish
            String htmlContent = "<h1 style='color: blue;'>Hello Java!</h1>" +
                                 "<p>This is <b>HTML</b> email from Java.</p>" +
                                 "<hr><p>Regards,<br>Java Program</p>";
            
            message.setContent(htmlContent, "text/html");
            
            // 6. Yuborish
            Transport.send(message);
            
            System.out.println("✅ HTML email sent to Mailtrap");
            System.out.println("Check your inbox at: https://mailtrap.io");
            
        } catch (MessagingException e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

---

## 5.6 - Fayl biriktirish (Attachment)

### Multipart email yuborish

```java
package uz.pdp.mailing;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.util.Properties;

public class AttachmentExample {
    public static void main(String[] args) {
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "sandbox.smtp.mailtrap.io");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.auth", "true");
        
        String username = "27aac8a7963319";
        String password = "29b4d367a4cda2";
        
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("sender@example.com"));
            message.setRecipient(Message.RecipientType.TO, 
                new InternetAddress("recipient@example.com"));
            message.setSubject("Email with Attachment");
            
            // Multipart yaratish
            Multipart multipart = new MimeMultipart();
            
            // 1. HTML content
            BodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setContent(
                "<h2>Hello!</h2><p>Please find attached file.</p>", 
                "text/html"
            );
            multipart.addBodyPart(messageBodyPart);
            
            // 2. Attachment
            BodyPart attachmentPart = new MimeBodyPart();
            
            // Fayl nomi
            attachmentPart.setFileName("document.txt");
            
            // Fayl manzili
            String filePath = "files/document.txt";
            DataSource source = new FileDataSource(filePath);
            attachmentPart.setDataHandler(new DataHandler(source));
            
            multipart.addBodyPart(attachmentPart);
            
            // 3. Rasm biriktirish (inline)
            BodyPart imagePart = new MimeBodyPart();
            DataSource imageSource = new FileDataSource("files/logo.png");
            imagePart.setDataHandler(new DataHandler(imageSource));
            imagePart.setHeader("Content-ID", "<logo>");
            multipart.addBodyPart(imagePart);
            
            // 4. Content-ID bilan rasmni HTML da ishlatish
            String htmlWithImage = "<h2>Hello!</h2>" +
                                   "<p>See our logo:</p>" +
                                   "<img src='cid:logo' width='200'>";
            
            // Multipart ni message ga o'rnatish
            message.setContent(multipart);
            
            // Yuborish
            Transport.send(message);
            
            System.out.println("✅ Email with attachment sent successfully");
            
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
```

---

## 5.7 - To'liq Email Service

### EmailService Class

```java
package uz.pdp.mailing.service;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.io.File;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class EmailService {
    
    private final String host;
    private final int port;
    private final String username;
    private final String password;
    private final boolean useSSL;
    private final boolean useTLS;
    
    // Thread pool for async sending
    private final ExecutorService executor = Executors.newFixedThreadPool(5);
    
    // Builder pattern
    public static class Builder {
        private String host = "smtp.gmail.com";
        private int port = 587;
        private String username;
        private String password;
        private boolean useSSL = false;
        private boolean useTLS = true;
        
        public Builder host(String host) { this.host = host; return this; }
        public Builder port(int port) { this.port = port; return this; }
        public Builder username(String username) { this.username = username; return this; }
        public Builder password(String password) { this.password = password; return this; }
        public Builder useSSL(boolean useSSL) { this.useSSL = useSSL; return this; }
        public Builder useTLS(boolean useTLS) { this.useTLS = useTLS; return this; }
        
        public EmailService build() {
            return new EmailService(this);
        }
    }
    
    private EmailService(Builder builder) {
        this.host = builder.host;
        this.port = builder.port;
        this.username = builder.username;
        this.password = builder.password;
        this.useSSL = builder.useSSL;
        this.useTLS = builder.useTLS;
    }
    
    // Properties yaratish
    private Properties getProperties() {
        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        
        if (useSSL) {
            props.put("mail.smtp.ssl.enable", "true");
        }
        
        if (useTLS) {
            props.put("mail.smtp.starttls.enable", "true");
        }
        
        return props;
    }
    
    // Session yaratish
    private Session getSession() {
        return Session.getInstance(getProperties(), new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
    }
    
    // 1. Oddiy text email
    public void sendSimpleEmail(String to, String subject, String text) 
            throws MessagingException {
        
        Message message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(username));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
        message.setSubject(subject);
        message.setText(text);
        
        Transport.send(message);
    }
    
    // 2. HTML email
    public void sendHtmlEmail(String to, String subject, String html) 
            throws MessagingException {
        
        Message message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(username));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
        message.setSubject(subject);
        message.setContent(html, "text/html");
        
        Transport.send(message);
    }
    
    // 3. Email with attachment
    public void sendEmailWithAttachment(String to, String subject, 
                                        String html, File attachment) 
            throws MessagingException {
        
        Message message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(username));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
        message.setSubject(subject);
        
        Multipart multipart = new MimeMultipart();
        
        // HTML content
        BodyPart messageBodyPart = new MimeBodyPart();
        messageBodyPart.setContent(html, "text/html");
        multipart.addBodyPart(messageBodyPart);
        
        // Attachment
        if (attachment != null && attachment.exists()) {
            BodyPart attachmentPart = new MimeBodyPart();
            attachmentPart.attachFile(attachment);
            multipart.addBodyPart(attachmentPart);
        }
        
        message.setContent(multipart);
        Transport.send(message);
    }
    
    // 4. Asinxron yuborish (non-blocking)
    public void sendAsync(String to, String subject, String html, 
                          EmailCallback callback) {
        
        executor.submit(() -> {
            try {
                sendHtmlEmail(to, subject, html);
                if (callback != null) {
                    callback.onSuccess("Email sent to " + to);
                }
            } catch (MessagingException e) {
                if (callback != null) {
                    callback.onError(e);
                }
            }
        });
    }
    
    // 5. Multiple recipients
    public void sendBulkEmail(String[] recipients, String subject, String html) 
            throws MessagingException {
        
        Session session = getSession();
        for (String to : recipients) {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject(subject);
            message.setContent(html, "text/html");
            
            Transport.send(message);
            System.out.println("✅ Sent to: " + to);
            
            // Rate limiting (1 email per second)
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }
    }
    
    // Callback interface
    public interface EmailCallback {
        void onSuccess(String message);
        void onError(Exception e);
    }
    
    // Cleanup
    public void shutdown() {
        executor.shutdown();
    }
}
```

### EmailService ni ishlatish

```java
package uz.pdp.mailing;

import uz.pdp.mailing.service.EmailService;
import java.io.File;

public class EmailApp {
    public static void main(String[] args) {
        
        // 1. Service yaratish
        EmailService emailService = new EmailService.Builder()
            .host("smtp.gmail.com")
            .port(587)
            .username("your.email@gmail.com")
            .password("your-app-password")
            .useTLS(true)
            .build();
        
        try {
            // 2. Oddiy text email
            emailService.sendSimpleEmail(
                "user@example.com",
                "Welcome!",
                "Thank you for registering."
            );
            System.out.println("✅ Simple email sent");
            
            // 3. HTML email
            String html = "<h1 style='color:green;'>Welcome!</h1>" +
                         "<p>Thank you for joining our service.</p>";
            
            emailService.sendHtmlEmail(
                "user@example.com",
                "HTML Email",
                html
            );
            
            // 4. Attachment bilan
            File file = new File("invoice.pdf");
            emailService.sendEmailWithAttachment(
                "user@example.com",
                "Invoice",
                "<h2>Your invoice</h2>",
                file
            );
            
            // 5. Asinxron yuborish
            emailService.sendAsync(
                "user@example.com",
                "Async Email",
                "<h3>This was sent asynchronously</h3>",
                new EmailService.EmailCallback() {
                    @Override
                    public void onSuccess(String message) {
                        System.out.println("✅ " + message);
                    }
                    
                    @Override
                    public void onError(Exception e) {
                        System.err.println("❌ Failed: " + e.getMessage());
                    }
                }
            );
            
            // 6. Bulk email
            String[] users = {
                "user1@example.com",
                "user2@example.com",
                "user3@example.com"
            };
            
            emailService.sendBulkEmail(
                users,
                "Newsletter",
                "<h2>Monthly Newsletter</h2>"
            );
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            emailService.shutdown();
        }
    }
}
```

---

## 5.8 - Email Template bilan ishlash

### Template Engine

```java
package uz.pdp.mailing.template;

import java.util.Map;
import java.util.HashMap;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class EmailTemplate {
    
    private String template;
    
    public EmailTemplate(String templatePath) throws IOException {
        // Template faylni o'qish
        this.template = Files.readString(Paths.get(templatePath));
    }
    
    // Replace placeholders
    public String render(Map<String, String> values) {
        String result = template;
        for (Map.Entry<String, String> entry : values.entrySet()) {
            result = result.replace("{{" + entry.getKey() + "}}", entry.getValue());
        }
        return result;
    }
    
    // Predefined templates
    public static class Templates {
        
        public static String welcomeEmail(String name, String link) {
            return String.format(
                "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; }" +
                ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
                ".header { background: #4CAF50; color: white; padding: 10px; text-align: center; }" +
                ".content { padding: 20px; background: #f9f9f9; }" +
                ".button { background: #4CAF50; color: white; padding: 10px 20px; " +
                         "text-decoration: none; border-radius: 5px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'><h2>Welcome to Our Service!</h2></div>" +
                "<div class='content'>" +
                "<h3>Hello %s,</h3>" +
                "<p>Thank you for registering. Please verify your email:</p>" +
                "<p style='text-align: center;'>" +
                "<a href='%s' class='button'>Verify Email</a>" +
                "</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>",
                name, link
            );
        }
        
        public static String passwordResetEmail(String name, String link) {
            return String.format(
                "<!DOCTYPE html>" +
                "<html>" +
                "<body>" +
                "<h2>Password Reset Request</h2>" +
                "<p>Hello %s,</p>" +
                "<p>Click below to reset your password:</p>" +
                "<a href='%s'>Reset Password</a>" +
                "<p>If you didn't request this, ignore this email.</p>" +
                "</body>" +
                "</html>",
                name, link
            );
        }
    }
}

// Ishlatish
public class TemplateExample {
    public static void main(String[] args) throws Exception {
        EmailService emailService = new EmailService.Builder()
            .username("your.email@gmail.com")
            .password("app-password")
            .build();
        
        // Welcome email
        String welcomeHtml = EmailTemplate.Templates.welcomeEmail(
            "John Doe",
            "https://example.com/verify?token=12345"
        );
        
        emailService.sendHtmlEmail(
            "john@example.com",
            "Welcome to Our Service!",
            welcomeHtml
        );
    }
}
```

---

## Xatolar va Ularni Hal Qilish

### 1. Authentication Failed

```java
// ❌ Xato: Authentication failed
// Sabab: Noto'g'ri username/password yoki app password ishlatilmagan

// ✅ Yechim:
// 1. Gmail uchun app password yarating
// 2. 2-step verification yoqilganligini tekshiring
// 3. "Less secure apps" ruxsatini tekshiring
```

### 2. Connection Timeout

```java
// ✅ Timeout sozlamalari
Properties props = new Properties();
props.put("mail.smtp.connectiontimeout", "5000"); // 5 seconds
props.put("mail.smtp.timeout", "5000");           // 5 seconds
props.put("mail.smtp.writetimeout", "5000");      // 5 seconds
```

### 3. SSL/TLS muammolari

```java
// Agar SSL/TLS bilan muammo bo'lsa:
props.put("mail.smtp.ssl.trust", "smtp.gmail.com"); // Trust specific host
props.put("mail.smtp.ssl.protocols", "TLSv1.2");    // Specific protocol
```

---

## Tekshiruv Savollari

1. **SMTP nima va u qanday portlarda ishlaydi?**
2. **SSL va TLS o'rtasidagi farq nima?**
3. **JavaMail API qanday ishlaydi?**
4. **Gmail orqali email yuborish uchun nima qilish kerak?**
5. **Mailtrap nima va nima uchun ishlatiladi?**
6. **Multipart email nima va qachon ishlatiladi?**
7. **Attachment qanday qo'shiladi?**
8. **HTML email va text email farqi?**
9. **Asinxron email yuborish nima uchun kerak?**
10. **Email template nima va qanday ishlatiladi?**

---

## Amaliy Topshiriq

Quyidagi imkoniyatlarga ega email yuborish tizimini yozing:

1. **SMTP server** sozlamalarini o'zgartirish imkoniyati
2. **HTML template** lar bilan ishlash
3. **Fayl biriktirish** imkoniyati
4. **Bir nechta qabul qiluvchiga** yuborish
5. **Asinxron yuborish** (thread pool bilan)
6. **Xatoliklarni log** qilish
7. **Yuborish tarixini saqlash** (faylga yoki bazaga)

---

**Keyingi mavzu:** [Web Servisler](./06_Web_Services.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
