# 16 - Telegram Bot

## Bot nima?

**Bot (Internet bot)** - internetda avtomatlashtirilgan vazifalarni bajaradigan dasturiy ta'minot. Botlar oddiy va takrorlanuvchi ishlarni odamlarga qaraganda ancha tez bajaradi.

```java
// Bot - bu foydalanuvchi bilan muloqot qiladigan dastur
Foydalanuvchi <--> Telegram <--> Bot (sizning Java dasturingiz)
```

### Telegram Bot nima?

**Telegram Bot** - Telegram messenjeri ichida ishlaydigan, foydalanuvchilar bilan matn, rasm, audio va boshqa formatlarda muloqot qila oladigan dastur.

---

## Nima uchun Telegram Bot kerak?

1. **Avtomatlashtirish** - Takrorlanuvchi vazifalarni avtomatik bajarish
2. **24/7 ishlash** - Doimiy ravishda foydalanuvchilarga xizmat ko'rsatish
3. **Ko'p foydalanuvchi** - Bir vaqtning o'zida minglab foydalanuvchilarga xizmat ko'rsatish
4. **Integratsiya** - Boshqa tizimlar bilan bog'lanish (API, ma'lumotlar bazasi)
5. **Valyuta kursi, ob-havo, yangiliklar** - Real vaqt ma'lumotlarini yetkazib berish

---

## 16.1 - Telegram Bot yaratish

### BotFather orqali bot yaratish

Telegram'da **@BotFather** ga murojaat qilib, yangi bot yaratish mumkin:

```
1. @BotFather ni qidiring va "Start" ni bosing
2. /newbot komandasini yuboring
3. Bot nomini kiriting (masalan: "Currency Converter Bot")
4. Bot username'ini kiriting (masalan: "my_currency_converter_bot")
5. BotFather sizga TOKEN beradi: 123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11

Bu token sizning botingizning kaliti - hech kimga bermang!
```

### Telegram Bot API

Telegram Bot API - HTTP asosidagi interfeys. Barcha so'rovlar HTTPS orqali yuboriladi:

```
https://api.telegram.org/bot<TOKEN>/METHOD_NAME

Misol: 
https://api.telegram.org/bot123456:ABC-DEF/getMe
```

API metodlari:
- **GET** va **POST** metodlari qo'llab-quvvatlanadi
- Parametrlar URL, form data yoki JSON formatida yuborilishi mumkin

---

## 16.2 - Java kutubxonalari

### Kutubxona tanlash

Telegram botlar yaratish uchun bir nechta Java kutubxonalari mavjud:

| Kutubxona | Tavsif | GitHub |
|-----------|--------|--------|
| **TelegramBots** | Ishlatish uchun qulay, keng imkoniyatli | [rubenlagus/TelegramBots](https://github.com/rubenlagus/TelegramBots) |
| **java-telegram-bot-api** | Pengrad tomonidan, sodda va tez | [pengrad/java-telegram-bot-api](https://github.com/pengrad/java-telegram-bot-api) |
| **Teleight Bots** | Eng yengil wrapper | [Teleight/TeleightBots](https://github.com/Teleight/TeleightBots) |
| **Telebof** | Zamonaviy va oson | [natanimn/Telebof](https://github.com/natanimn/Telebof) |

### Maven dependency (pengrad)

```xml
<dependency>
    <groupId>com.github.pengrad</groupId>
    <artifactId>java-telegram-bot-api</artifactId>
    <version>9.5.0</version>
</dependency>
```

---

## 16.3 - Asosiy tushunchalar

### Bot yaratish va xabar yuborish

```java
package uz.pdp.telegram;

import com.pengrad.telegrambot.TelegramBot;
import com.pengrad.telegrambot.request.SendMessage;
import com.pengrad.telegrambot.model.request.ParseMode;

public class SimpleBot {
    public static void main(String[] args) {
        // 1. Bot yaratish (tokenni o'rnating)
        TelegramBot bot = new TelegramBot("YOUR_BOT_TOKEN");
        
        // 2. Xabar yuborish
        SendMessage sendMessage = new SendMessage(
            "7227908040",  // chat_id (foydalanuvchi ID si)
            "Hello from Java Telegram Bot"
        );
        
        // 3. Xabarni yuborish
        bot.execute(sendMessage);
        
        System.out.println("Xabar yuborildi!");
    }
}
```

### Foydalanuvchi ID sini qanday olish mumkin?

Telegram'da @userinfobot ga murojaat qilib, o'z ID'ingizni olish mumkin. Yoki botga xabar yuborib, uni log'da ko'rish mumkin.

---

## 16.4 - Xabarlarni qabul qilish

### UpdatesListener bilan ishlash

```java
import com.pengrad.telegrambot.UpdatesListener;
import com.pengrad.telegrambot.model.Update;
import com.pengrad.telegrambot.model.Message;
import com.pengrad.telegrambot.model.Chat;
import com.pengrad.telegrambot.request.SendMessage;
import com.pengrad.telegrambot.ExceptionHandler;
import com.pengrad.telegrambot.TelegramException;

public class EchoBot {
    public static void main(String[] args) {
        TelegramBot bot = new TelegramBot("YOUR_BOT_TOKEN");
        
        // Xabarlarni tinglash
        bot.setUpdatesListener(new UpdatesListener() {
            @Override
            public int process(List<Update> updates) {
                for (Update update : updates) {
                    // Kelgan xabarni o'qish
                    Message message = update.message();
                    
                    if (message != null && message.text() != null) {
                        Chat chat = message.chat();
                        Long chatId = chat.id();
                        String text = message.text();
                        
                        System.out.println("Xabar: " + text + " (from: " + chatId + ")");
                        
                        // Javob qaytarish
                        SendMessage sendMessage = new SendMessage(
                            chatId, 
                            "Siz yozdingiz: " + text
                        );
                        bot.execute(sendMessage);
                    }
                }
                return UpdatesListener.CONFIRMED_UPDATES_ALL;
            }
        }, new ExceptionHandler() {
            @Override
            public void onException(TelegramException e) {
                System.out.println("Xatolik: " + e.getMessage());
                e.printStackTrace();
            }
        });
        
        System.out.println("Bot ishga tushdi. Ctrl+C bilan to'xtating.");
        
        // Botni ishlatishda davom etish
        // (oddiy holatda dastur to'xtab qolmasligi uchun)
        try {
            Thread.sleep(Long.MAX_VALUE);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

### Xabarlarni tahlil qilish

```java
public int process(List<Update> updates) {
    for (Update update : updates) {
        Message message = update.message();
        
        if (message == null) continue;
        
        Long chatId = message.chat().id();
        String text = message.text();
        
        // Komandalarni boshqarish
        if (text != null) {
            if (text.equals("/start")) {
                sendMessage(chatId, "Assalomu alaykum! Botga xush kelibsiz!");
            } else if (text.equals("/help")) {
                sendMessage(chatId, "/start - botni ishga tushirish\n/help - yordam");
            } else if (text.startsWith("/")) {
                sendMessage(chatId, "Noma'lum komanda: " + text);
            } else {
                // Oddiy xabar
                sendMessage(chatId, "Siz yozdingiz: " + text);
            }
        }
    }
    return UpdatesListener.CONFIRMED_UPDATES_ALL;
}

private void sendMessage(Long chatId, String text) {
    bot.execute(new SendMessage(chatId, text));
}
```

---

## 16.5 - Klaviaturalar (Keyboards)

### ReplyKeyboardMarkup (Oddiy klaviatura)

Foydalanuvchi xabar yozish o'rniga tugmalarni bosishi uchun:

```java
import com.pengrad.telegrambot.model.request.KeyboardButton;
import com.pengrad.telegrambot.model.request.ReplyKeyboardMarkup;
import com.pengrad.telegrambot.request.SendMessage;

public class KeyboardExample {
    public static void main(String[] args) {
        TelegramBot bot = new TelegramBot("YOUR_BOT_TOKEN");
        Long chatId = 7227908040L;
        
        // Tugmalar yaratish
        KeyboardButton contactButton = new KeyboardButton("📞 Kontakt yuborish");
        contactButton.requestContact(true);  // Telefon raqam so'rash
        
        KeyboardButton locationButton = new KeyboardButton("📍 Joylashuv yuborish");
        locationButton.requestLocation(true);  // Geolokatsiya so'rash
        
        // Qatorlar yaratish
        KeyboardButton[] row1 = {
            new KeyboardButton("💰 Valyuta kursi"),
            new KeyboardButton("🌤 Ob-havo")
        };
        
        KeyboardButton[] row2 = {
            contactButton,
            locationButton
        };
        
        KeyboardButton[] row3 = {
            new KeyboardButton("⚙️ Sozlamalar")
        };
        
        // Klaviatura yaratish
        ReplyKeyboardMarkup keyboardMarkup = new ReplyKeyboardMarkup(row1, row2, row3)
            .resizeKeyboard(true)        // Tugmalarni moslashtirish
            .oneTimeKeyboard(true)       // Bir martalik klaviatura
            .selective(true);            // Faqat ma'lum foydalanuvchilarga
        
        // Xabar yuborish
        SendMessage sendMessage = new SendMessage(chatId, "Tanlang:")
            .replyMarkup(keyboardMarkup);
        
        bot.execute(sendMessage);
    }
}
```

### InlineKeyboardMarkup (Xabar ichidagi tugmalar)

```java
import com.pengrad.telegrambot.model.request.InlineKeyboardButton;
import com.pengrad.telegrambot.model.request.InlineKeyboardMarkup;
import com.pengrad.telegrambot.request.SendMessage;

public class InlineKeyboardExample {
    public static void main(String[] args) {
        TelegramBot bot = new TelegramBot("YOUR_BOT_TOKEN");
        Long chatId = 7227908040L;
        
        // Inline tugmalar (xabar ichida)
        InlineKeyboardButton[] row1 = {
            new InlineKeyboardButton("🇺🇿 Uzbek").callbackData("uzbek"),
            new InlineKeyboardButton("🇬🇧 English").callbackData("english"),
            new InlineKeyboardButton("🇷🇺 Russian").callbackData("russian")
        };
        
        InlineKeyboardButton[] row2 = {
            new InlineKeyboardButton("💵 USD").callbackData("usd"),
            new InlineKeyboardButton("💶 EUR").callbackData("eur"),
            new InlineKeyboardButton("₽ RUB").callbackData("rub")
        };
        
        InlineKeyboardButton[] row3 = {
            new InlineKeyboardButton("🔗 Open Web").url("https://example.com")
        };
        
        InlineKeyboardMarkup inlineKeyboard = new InlineKeyboardMarkup(row1, row2, row3);
        
        SendMessage sendMessage = new SendMessage(chatId, "Tanlang:")
            .replyMarkup(inlineKeyboard);
        
        bot.execute(sendMessage);
    }
}
```

### CallbackQuery ni qabul qilish

```java
public int process(List<Update> updates) {
    for (Update update : updates) {
        // Oddiy xabarlar
        Message message = update.message();
        if (message != null) {
            handleMessage(message);
        }
        
        // Inline tugmalar bosilganda
        CallbackQuery callbackQuery = update.callbackQuery();
        if (callbackQuery != null) {
            handleCallback(callbackQuery);
        }
    }
    return UpdatesListener.CONFIRMED_UPDATES_ALL;
}

private void handleCallback(CallbackQuery callbackQuery) {
    String data = callbackQuery.data();
    Long chatId = callbackQuery.message().chat().id();
    
    switch (data) {
        case "uzbek":
            sendMessage(chatId, "Assalomu alaykum!");
            break;
        case "english":
            sendMessage(chatId, "Hello!");
            break;
        case "usd":
            sendMessage(chatId, "USD kursi: 12800 so'm");
            break;
        default:
            sendMessage(chatId, "Noma'lum tanlov: " + data);
    }
}
```

---

## 16.6 - Media yuborish

### Rasm yuborish

```java
import com.pengrad.telegrambot.request.SendPhoto;

// Fayldan rasm yuborish
SendPhoto sendPhoto = new SendPhoto(chatId, new File("photo.jpg"));
bot.execute(sendPhoto);

// URL dan rasm yuborish
SendPhoto sendPhotoUrl = new SendPhoto(chatId, "https://example.com/image.jpg");
bot.execute(sendPhotoUrl);
```

### Audio yuborish

```java
import com.pengrad.telegrambot.request.SendAudio;
import java.nio.file.Files;
import java.nio.file.Path;

// Fayldan audio yuborish
byte[] audioBytes = Files.readAllBytes(Path.of("/home/user/music.mp3"));
SendAudio sendAudio = new SendAudio(chatId, audioBytes)
    .fileName("My Favourite Music")
    .title("Amazing Song")
    .performer("Famous Singer");

bot.execute(sendAudio);
```

### Dokument yuborish

```java
import com.pengrad.telegrambot.request.SendDocument;

SendDocument sendDocument = new SendDocument(chatId, new File("document.pdf"))
    .caption("Muhim hujjat");

bot.execute(sendDocument);
```

---

## 16.7 - Amaliy misol: Valyuta kursi boti

### CBU.uz API dan foydalanish

O'zbekiston Markaziy banki valyuta kurslari API'si:
- `https://cbu.uz/oz/arkhiv-kursov-valyut/json/USD/2023-01-01/`
- `https://cbu.uz/oz/arkhiv-kursov-valyut/json/RUB/2023-01-01/`

### Valyuta kursi modeli

```java
import com.google.gson.annotations.SerializedName;

public class CurrencyRate {
    
    @SerializedName("Ccy")
    private String code;          // USD, RUB, EUR
    
    @SerializedName("CcyNm_UZ")
    private String nameUz;         // AQSH dollari
    
    @SerializedName("Rate")
    private double rate;           // 12800.0
    
    @SerializedName("Date")
    private String date;           // 2023-01-01
    
    // getters, setters, toString
}
```

### Valyuta kursi servisi

```java
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.lang.reflect.Type;
import java.util.List;

public class CurrencyService {
    
    private static final String BASE_URL = "https://cbu.uz/oz/arkhiv-kursov-valyut/json/";
    private final HttpClient httpClient;
    private final Gson gson;
    
    public CurrencyService() {
        this.httpClient = HttpClient.newHttpClient();
        this.gson = new Gson();
    }
    
    public List<CurrencyRate> getCurrencyRate(String currencyCode) throws Exception {
        String url = BASE_URL + currencyCode + "/";
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create(url))
            .GET()
            .build();
        
        HttpResponse<String> response = httpClient.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() == 200) {
            Type listType = new TypeToken<List<CurrencyRate>>(){}.getType();
            return gson.fromJson(response.body(), listType);
        } else {
            throw new RuntimeException("API xatosi: " + response.statusCode());
        }
    }
    
    public double getUSDRate() throws Exception {
        List<CurrencyRate> rates = getCurrencyRate("USD");
        return rates.get(0).getRate();
    }
    
    public double getRUBRate() throws Exception {
        List<CurrencyRate> rates = getCurrencyRate("RUB");
        return rates.get(0).getRate();
    }
    
    public double getEURRate() throws Exception {
        List<CurrencyRate> rates = getCurrencyRate("EUR");
        return rates.get(0).getRate();
    }
}
```

### To'liq bot

```java
package uz.pdp.telegram;

import com.pengrad.telegrambot.TelegramBot;
import com.pengrad.telegrambot.UpdatesListener;
import com.pengrad.telegrambot.model.Message;
import com.pengrad.telegrambot.model.Update;
import com.pengrad.telegrambot.model.Chat;
import com.pengrad.telegrambot.model.request.*;
import com.pengrad.telegrambot.request.SendMessage;
import com.pengrad.telegrambot.ExceptionHandler;
import com.pengrad.telegrambot.TelegramException;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class CurrencyBot {
    
    private final TelegramBot bot;
    private final CurrencyService currencyService;
    private final Map<Long, String> userLanguage;
    
    public CurrencyBot(String token) {
        this.bot = new TelegramBot(token);
        this.currencyService = new CurrencyService();
        this.userLanguage = new HashMap<>();
        
        // Botni ishga tushirish
        startBot();
    }
    
    private void startBot() {
        bot.setUpdatesListener(new UpdatesListener() {
            @Override
            public int process(List<Update> updates) {
                for (Update update : updates) {
                    handleUpdate(update);
                }
                return UpdatesListener.CONFIRMED_UPDATES_ALL;
            }
        }, new ExceptionHandler() {
            @Override
            public void onException(TelegramException e) {
                System.out.println("Xatolik: " + e.getMessage());
                e.printStackTrace();
            }
        });
        
        System.out.println("✅ Bot ishga tushdi! @CurrencyRateBot");
    }
    
    private void handleUpdate(Update update) {
        // Oddiy xabar
        Message message = update.message();
        if (message != null) {
            handleMessage(message);
        }
        
        // Inline tugmalar
        if (update.callbackQuery() != null) {
            handleCallbackQuery(update.callbackQuery());
        }
    }
    
    private void handleMessage(Message message) {
        Long chatId = message.chat().id();
        String text = message.text();
        
        if (text == null) return;
        
        switch (text) {
            case "/start":
                sendLanguageSelection(chatId);
                break;
            case "/help":
                sendHelp(chatId);
                break;
            case "🇺🇿 USD kursi":
            case "🇬🇧 USD rate":
                sendCurrencyRate(chatId, "USD");
                break;
            case "🇷🇺 RUB kursi":
            case "🇷🇺 RUB rate":
                sendCurrencyRate(chatId, "RUB");
                break;
            case "🇪🇺 EUR kursi":
            case "🇪🇺 EUR rate":
                sendCurrencyRate(chatId, "EUR");
                break;
            default:
                sendMainMenu(chatId);
        }
    }
    
    private void handleCallbackQuery(CallbackQuery callbackQuery) {
        Long chatId = callbackQuery.message().chat().id();
        String data = callbackQuery.data();
        
        if (data.startsWith("lang_")) {
            String lang = data.replace("lang_", "");
            userLanguage.put(chatId, lang);
            sendWelcome(chatId);
        } else if (data.startsWith("currency_")) {
            String currency = data.replace("currency_", "");
            sendCurrencyRate(chatId, currency);
        }
    }
    
    private void sendLanguageSelection(Long chatId) {
        InlineKeyboardButton[] row1 = {
            new InlineKeyboardButton("🇺🇿 O'zbek").callbackData("lang_uz"),
            new InlineKeyboardButton("🇬🇧 English").callbackData("lang_en"),
            new InlineKeyboardButton("🇷🇺 Русский").callbackData("lang_ru")
        };
        
        InlineKeyboardMarkup keyboard = new InlineKeyboardMarkup(row1);
        
        SendMessage sendMessage = new SendMessage(chatId, "Tilni tanlang / Choose language / Выберите язык:")
            .replyMarkup(keyboard);
        
        bot.execute(sendMessage);
    }
    
    private void sendWelcome(Long chatId) {
        String lang = userLanguage.getOrDefault(chatId, "uz");
        String text;
        
        if ("uz".equals(lang)) {
            text = "Assalomu alaykum! Valyuta kurslari botiga xush kelibsiz!";
        } else if ("en".equals(lang)) {
            text = "Hello! Welcome to Currency Rates Bot!";
        } else {
            text = "Здравствуйте! Добро пожаловать в бот курсов валют!";
        }
        
        sendMainMenu(chatId);
    }
    
    private void sendMainMenu(Long chatId) {
        String lang = userLanguage.getOrDefault(chatId, "uz");
        
        KeyboardButton[] row1;
        KeyboardButton[] row2;
        
        if ("uz".equals(lang)) {
            row1 = new KeyboardButton[]{
                new KeyboardButton("🇺🇿 USD kursi"),
                new KeyboardButton("🇪🇺 EUR kursi")
            };
            row2 = new KeyboardButton[]{
                new KeyboardButton("🇷🇺 RUB kursi"),
                new KeyboardButton("❓ Yordam")
            };
        } else if ("en".equals(lang)) {
            row1 = new KeyboardButton[]{
                new KeyboardButton("🇺🇿 USD rate"),
                new KeyboardButton("🇪🇺 EUR rate")
            };
            row2 = new KeyboardButton[]{
                new KeyboardButton("🇷🇺 RUB rate"),
                new KeyboardButton("❓ Help")
            };
        } else {
            row1 = new KeyboardButton[]{
                new KeyboardButton("🇺🇿 USD курс"),
                new KeyboardButton("🇪🇺 EUR курс")
            };
            row2 = new KeyboardButton[]{
                new KeyboardButton("🇷🇺 RUB курс"),
                new KeyboardButton("❓ Помощь")
            };
        }
        
        ReplyKeyboardMarkup keyboard = new ReplyKeyboardMarkup(row1, row2)
            .resizeKeyboard(true)
            .oneTimeKeyboard(false);
        
        String text = lang.equals("uz") ? "Tanlang:" : 
                     (lang.equals("en") ? "Choose:" : "Выберите:");
        
        SendMessage sendMessage = new SendMessage(chatId, text)
            .replyMarkup(keyboard);
        
        bot.execute(sendMessage);
    }
    
    private void sendCurrencyRate(Long chatId, String currency) {
        String lang = userLanguage.getOrDefault(chatId, "uz");
        
        try {
            double rate = 0;
            if ("USD".equals(currency)) {
                rate = currencyService.getUSDRate();
            } else if ("EUR".equals(currency)) {
                rate = currencyService.getEURRate();
            } else if ("RUB".equals(currency)) {
                rate = currencyService.getRUBRate();
            }
            
            String message;
            if ("uz".equals(lang)) {
                message = String.format("💰 %s kursi: %.2f so'm", currency, rate);
            } else if ("en".equals(lang)) {
                message = String.format("💰 %s rate: %.2f UZS", currency, rate);
            } else {
                message = String.format("💰 Курс %s: %.2f UZS", currency, rate);
            }
            
            SendMessage sendMessage = new SendMessage(chatId, message);
            bot.execute(sendMessage);
            
        } catch (Exception e) {
            String errorMsg = lang.equals("uz") ? "Xatolik yuz berdi" :
                             (lang.equals("en") ? "Error occurred" : "Произошла ошибка");
            bot.execute(new SendMessage(chatId, errorMsg));
            e.printStackTrace();
        }
    }
    
    private void sendHelp(Long chatId) {
        String lang = userLanguage.getOrDefault(chatId, "uz");
        
        String helpText;
        if ("uz".equals(lang)) {
            helpText = """
                🤖 *Valyuta kurslari boti*
                
                *Komandalar:*
                /start - Botni qayta ishga tushirish
                /help - Yordam
                
                Valyuta kurslarini ko'rish uchun quyidagi tugmalardan foydalaning:
                🇺🇿 USD kursi
                🇪🇺 EUR kursi
                🇷🇺 RUB kursi
                
                Ma'lumotlar O'zbekiston Markaziy banki API'sidan olinadi.
                """;
        } else if ("en".equals(lang)) {
            helpText = """
                🤖 *Currency Rates Bot*
                
                *Commands:*
                /start - Restart bot
                /help - Help
                
                Use buttons below to see currency rates:
                🇺🇿 USD rate
                🇪🇺 EUR rate
                🇷🇺 RUB rate
                
                Data from Central Bank of Uzbekistan API.
                """;
        } else {
            helpText = """
                🤖 *Бот курсов валют*
                
                *Команды:*
                /start - Перезапустить бота
                /help - Помощь
                
                Используйте кнопки ниже для просмотра курсов:
                🇺🇿 USD курс
                🇪🇺 EUR курс
                🇷🇺 RUB курс
                
                Данные с API Центрального банка Узбекистана.
                """;
        }
        
        SendMessage sendMessage = new SendMessage(chatId, helpText)
            .parseMode(ParseMode.Markdown);
        
        bot.execute(sendMessage);
    }
    
    public static void main(String[] args) {
        // Tokenni o'rnating
        String token = "YOUR_BOT_TOKEN";
        
        // Botni ishga tushirish
        new CurrencyBot(token);
    }
}
```

---

## Telegram Bot Cheat Sheet

```java
// 1. Bot yaratish
TelegramBot bot = new TelegramBot("TOKEN");

// 2. Xabar yuborish
SendMessage msg = new SendMessage(chatId, "Hello");
bot.execute(msg);

// 3. Xabarlarni qabul qilish
bot.setUpdatesListener(updates -> {
    for (Update update : updates) {
        Message message = update.message();
        if (message != null) {
            String text = message.text();
            Long chatId = message.chat().id();
        }
    }
    return UpdatesListener.CONFIRMED_UPDATES_ALL;
});

// 4. Klaviatura yaratish
ReplyKeyboardMarkup keyboard = new ReplyKeyboardMarkup(
    new KeyboardButton[]{
        new KeyboardButton("Button 1"),
        new KeyboardButton("Button 2")
    }
).resizeKeyboard(true);

// 5. Inline klaviatura
InlineKeyboardMarkup inline = new InlineKeyboardMarkup(
    new InlineKeyboardButton[]{
        new InlineKeyboardButton("Text").callbackData("data")
    }
);

// 6. Rasm yuborish
SendPhoto photo = new SendPhoto(chatId, new File("photo.jpg"));
bot.execute(photo);

// 7. Callback ni qabul qilish
CallbackQuery callback = update.callbackQuery();
if (callback != null) {
    String data = callback.data();
}
```

---

## Tekshiruv Savollari

1. **Bot nima va Telegram Bot qanday ishlaydi?**
2. **BotFather orqali bot qanday yaratiladi?**
3. **Telegram Bot API qanday ishlaydi?**
4. **UpdatesListener nima vazifani bajaradi?**
5. **ReplyKeyboardMarkup va InlineKeyboardMarkup farqi nima?**
6. **CallbackQuery nima va qanday ishlatiladi?**
7. **Media fayllar (rasm, audio) qanday yuboriladi?**
8. **Foydalanuvchi tilini qanday saqlash mumkin?**
9. **CBU.uz API dan valyuta kurslarini qanday olish mumkin?**
10. **Botda xatoliklarni qanday boshqarish kerak?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega Telegram bot yarating:

1. **/start** - Botni ishga tushirish va til tanlash (O'zbek, English, Русский)
2. **Valyuta kurslari** - USD, EUR, RUB kurslarini Markaziy bank API'sidan olish
3. **Ob-havo** - Toshkent ob-havo ma'lumotini boshqa API dan olish
4. **Klaviatura** - Barcha funksiyalar uchun tugmalar
5. **Inline tugmalar** - Qo'shimcha ma'lumot uchun

```bash
# Botni test qilish
1. @BotFather dan token olish
2. Yukoridagi kodni token bilan ishga tushirish
3. Telegram'da botga yozish va funksiyalarni tekshirish
```

---

**Keyingi mavzu:** [Annotations](./17_Annotations.md)  
**[Mundarijaga qaytish](../README.md)**

> Telegram bot yaratish - qiziqarli va foydali tajriba! 🚀
