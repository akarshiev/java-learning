# 08 - Regular Expressions (Regex)

## Regular Expressions nima?

**Regular Expression (Regex)** - matn ichida pattern (qolip) qidirish uchun ishlatiladigan maxsus belgilar ketma-ketligi.

```java
// Regex - bu qolip (pattern)
String pattern = "[A-Z]+";  // Katta harflar ketma-ketligi
String text = "HELLO world 123";

// Regex orqali tekshirish
boolean matches = text.matches(pattern); // false (to'liq matn pattern'ga mos kelmaydi)
```

### Nima uchun Regex ishlatiladi?

1. **Murakkab string parsing kodlaridan qutulish**
2. **Kodni soddalashtirish**
3. **Aniqlikni oshirish**

```java
// ❌ Regex'siz - murakkab va xatolikka moyil
public boolean isValidPhoneNumber(String phone) {
    if (phone == null || phone.length() != 13) return false;
    if (!phone.startsWith("+998")) return false;
    for (int i = 4; i < phone.length(); i++) {
        if (!Character.isDigit(phone.charAt(i))) return false;
    }
    return true;
}

// ✅ Regex bilan - sodda va tushunarli
public boolean isValidPhoneNumber(String phone) {
    return phone.matches("\\+998[0-9]{9}");
}
```

---

## Regex Sintaksisi

### Quantifiers (Miqdor ko'rsatkichlari)

| Metacharacter | Ma'nosi | Misol |
|--------------|---------|-------|
| `x*` | x ning 0 yoki undan ko'p takrorlanishi | `"a*"` → "", "a", "aa", "aaa" |
| `x+` | x ning 1 yoki undan ko'p takrorlanishi | `"a+"` → "a", "aa", "aaa" |
| `x?` | x ning 0 yoki 1 marta takrorlanishi | `"a?"` → "", "a" |
| `x{n}` | x ning aniq n marta takrorlanishi | `"a{3}"` → "aaa" |
| `x{n,}` | x ning kamida n marta takrorlanishi | `"a{2,}"` → "aa", "aaa", "aaaa" |
| `x{n,m}` | x ning n dan m gacha takrorlanishi | `"a{2,4}"` → "aa", "aaa", "aaaa" |

```java
public class QuantifiersExample {
    public static void main(String[] args) {
        String[] patterns = {
            "a*",   // 0 yoki undan ko'p
            "a+",   // 1 yoki undan ko'p
            "a?",   // 0 yoki 1
            "a{3}", // aniq 3 ta
            "a{2,}", // kamida 2 ta
            "a{2,4}" // 2 dan 4 gacha
        };
        
        String[] testStrings = {"", "a", "aa", "aaa", "aaaa", "aaaaa"};
        
        for (String pattern : patterns) {
            System.out.println("\nPattern: " + pattern);
            for (String test : testStrings) {
                System.out.printf("  '%s' -> %s%n", 
                    test, test.matches(pattern));
            }
        }
    }
}
```

### Character Classes (Belgilar sinflari)

| Pattern | Ma'nosi |
|---------|---------|
| `[abc]` | a, b yoki c (simple class) |
| `[^abc]` | a, b, c dan boshqa har qanday belgi |
| `[a-zA-Z]` | a dan z gacha yoki A dan Z gacha (range) |
| `[a-d[m-p]]` | a-d yoki m-p (union) [a-dm-p] |
| `[a-z&&[def]]` | d, e, f (intersection) |
| `[a-z&&[^bc]]` | a-z, b va c dan tashqari (subtraction) |
| `[a-z&&[^m-p]]` | a-z, m-p dan tashqari |

```java
public class CharacterClassesExample {
    public static void main(String[] args) {
        
        // 1. Simple class
        System.out.println("=== Simple class [abc] ===");
        String pattern1 = "[abc]";
        System.out.println("a".matches(pattern1));  // true
        System.out.println("d".matches(pattern1));  // false
        
        // 2. Negation
        System.out.println("\n=== Negation [^abc] ===");
        String pattern2 = "[^abc]";
        System.out.println("d".matches(pattern2));  // true
        System.out.println("a".matches(pattern2));  // false
        
        // 3. Range
        System.out.println("\n=== Range [a-z] ===");
        String pattern3 = "[a-z]";
        System.out.println("m".matches(pattern3));  // true
        System.out.println("M".matches(pattern3));  // false
        System.out.println("5".matches(pattern3));  // false
        
        // 4. Union
        System.out.println("\n=== Union [a-d[m-p]] ===");
        String pattern4 = "[a-d[m-p]]";
        System.out.println("b".matches(pattern4));  // true (a-d)
        System.out.println("n".matches(pattern4));  // true (m-p)
        System.out.println("z".matches(pattern4));  // false
        
        // 5. Intersection
        System.out.println("\n=== Intersection [a-z&&[def]] ===");
        String pattern5 = "[a-z&&[def]]";
        System.out.println("d".matches(pattern5));  // true
        System.out.println("e".matches(pattern5));  // true
        System.out.println("a".matches(pattern5));  // false
        
        // 6. Subtraction
        System.out.println("\n=== Subtraction [a-z&&[^bc]] ===");
        String pattern6 = "[a-z&&[^bc]]";
        System.out.println("a".matches(pattern6));  // true
        System.out.println("b".matches(pattern6));  // false
        System.out.println("c".matches(pattern6));  // false
        System.out.println("d".matches(pattern6));  // true
    }
}
```

### Predefined Character Classes (Oldindan belgilangan sinflar)

| Pattern | Ma'nosi |
|---------|---------|
| `.` | Har qanday belgi (newline dan tashqari) |
| `\d` | Digit (raqam): `[0-9]` |
| `\D` | Non-digit: `[^0-9]` |
| `\s` | Whitespace: `[ \t\n\x0B\f\r]` |
| `\S` | Non-whitespace: `[^\s]` |
| `\w` | Word character: `[a-zA-Z_0-9]` |
| `\W` | Non-word character: `[^\w]` |
| `a\|b` | a yoki b |

```java
public class PredefinedClassesExample {
    public static void main(String[] args) {
        
        // 1. Any character (.)
        System.out.println(". : " + "A".matches("."));  // true
        System.out.println(". : " + "5".matches("."));  // true
        System.out.println(". : " + "\n".matches(".")); // false
        
        // 2. Digit (\d)
        System.out.println("\\d : " + "5".matches("\\d"));   // true
        System.out.println("\\d : " + "A".matches("\\d"));   // false
        
        // 3. Non-digit (\D)
        System.out.println("\\D : " + "A".matches("\\D"));   // true
        System.out.println("\\D : " + "5".matches("\\D"));   // false
        
        // 4. Whitespace (\s)
        System.out.println("\\s : " + " ".matches("\\s"));   // true
        System.out.println("\\s : " + "\t".matches("\\s"));  // true
        System.out.println("\\s : " + "\n".matches("\\s"));  // true
        System.out.println("\\s : " + "A".matches("\\s"));   // false
        
        // 5. Word character (\w)
        System.out.println("\\w : " + "A".matches("\\w"));   // true
        System.out.println("\\w : " + "5".matches("\\w"));   // true
        System.out.println("\\w : " + "_".matches("\\w"));   // true
        System.out.println("\\w : " + "@".matches("\\w"));   // false
        
        // 6. Or (|)
        System.out.println("a|b : " + "a".matches("a|b"));   // true
        System.out.println("a|b : " + "b".matches("a|b"));   // true
        System.out.println("a|b : " + "c".matches("a|b"));   // false
        
        // 7. Grouping
        System.out.println("(ab)|(cd) : " + "ab".matches("(ab)|(cd)")); // true
        System.out.println("(ab)|(cd) : " + "cd".matches("(ab)|(cd)")); // true
        System.out.println("(ab)|(cd) : " + "ac".matches("(ab)|(cd)")); // false
    }
}
```

### POSIX Character Classes

| Pattern | Ma'nosi |
|---------|---------|
| `\p{Lower}` | Kichik harf: `[a-z]` |
| `\p{Upper}` | Katta harf: `[A-Z]` |
| `\p{ASCII}` | ASCII: `[\x00-\x7F]` |
| `\p{Alpha}` | Alfavit: `[\p{Lower}\p{Upper}]` |
| `\p{Digit}` | Raqam: `[0-9]` |
| `\p{Alnum}` | Alfanumerik: `[\p{Alpha}\p{Digit}]` |
| `\p{Punct}` | Punctuation: `!"#$%&'()*+,-./:;<=>?@[\]^_{|}~` |
| `\p{Space}` | Bo'shliq: `[ \t\n\x0B\f\r]` |
| `\p{Blank}` | Space yoki tab: `[ \t]` |

### Boundary Matchers (Chegara ko'rsatkichlari)

| Pattern | Ma'nosi |
|---------|---------|
| `^` | Qator boshi |
| `$` | Qator oxiri |
| `\b` | Word boundary (so'z chegarasi) |
| `\B` | Non-word boundary |

```java
public class BoundaryExample {
    public static void main(String[] args) {
        String text = "Hello world! Java is great.";
        
        // 1. ^ - qator boshi
        System.out.println("Starts with Hello: " + 
            text.matches("^Hello.*"));  // true
        
        // 2. $ - qator oxiri
        System.out.println("Ends with great.: " + 
            text.matches(".*great\\.$")); // true
        
        // 3. \b - word boundary
        Pattern pattern = Pattern.compile("\\bJava\\b");
        Matcher matcher = pattern.matcher("Java, JavaScript, Java!");
        
        while (matcher.find()) {
            System.out.println("Found 'Java' at: " + matcher.start());
        }
    }
}
```

---

## Regex in Java

### Pattern va Matcher Classlari

```java
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class PatternMatcherExample {
    public static void main(String[] args) {
        
        // 1. Pattern yaratish
        String regex = "\\d+";  // bir yoki bir nechta raqam
        Pattern pattern = Pattern.compile(regex);
        
        // 2. Matcher yaratish
        String input = "The price is 100 dollars and 50 cents";
        Matcher matcher = pattern.matcher(input);
        
        // 3. find() - pattern qidirish
        System.out.println("Finding all numbers:");
        while (matcher.find()) {
            System.out.printf("  Found '%s' at position %d%n", 
                matcher.group(), matcher.start());
        }
        
        // 4. matches() - to'liq moslik
        System.out.println("\nFull matches:");
        System.out.println("123".matches("\\d+"));     // true
        System.out.println("abc123".matches("\\d+"));  // false
        
        // 5. lookingAt() - boshidan boshlab moslik
        matcher = pattern.matcher("123abc");
        System.out.println("\nlookingAt: " + matcher.lookingAt()); // true
        System.out.println("matches: " + matcher.matches());       // false
        
        // 6. Grouping
        Pattern groupPattern = Pattern.compile("(\\d{3})-(\\d{2})-(\\d{4})");
        Matcher groupMatcher = groupPattern.matcher("123-45-6789");
        
        if (groupMatcher.matches()) {
            System.out.println("\nGrouping:");
            System.out.println("  Full: " + groupMatcher.group(0));  // 123-45-6789
            System.out.println("  Part1: " + groupMatcher.group(1)); // 123
            System.out.println("  Part2: " + groupMatcher.group(2)); // 45
            System.out.println("  Part3: " + groupMatcher.group(3)); // 6789
        }
    }
}
```

### Matcher Class Methodlari

```java
public class MatcherMethodsExample {
    public static void main(String[] args) {
        String text = "The quick brown fox jumps over the lazy dog.";
        
        // 1. find() - keyingi moslikni topish
        Pattern wordPattern = Pattern.compile("\\b\\w{3}\\b"); // 3 harfli so'zlar
        Matcher matcher = wordPattern.matcher(text);
        
        System.out.println("Three-letter words:");
        while (matcher.find()) {
            System.out.printf("  '%s' (%d-%d)%n", 
                matcher.group(), matcher.start(), matcher.end());
        }
        
        // 2. reset() - matcherni qayta boshlash
        matcher.reset();
        
        // 3. replaceFirst() - birinchi moslikni almashtirish
        String replaced = matcher.replaceFirst("***");
        System.out.println("\nReplace first: " + replaced);
        
        // 4. replaceAll() - hamma mosliklarni almashtirish
        matcher.reset();
        replaced = matcher.replaceAll("***");
        System.out.println("Replace all: " + replaced);
        
        // 5. groupCount() - guruhlar soni
        Pattern complex = Pattern.compile("(\\d+)-(\\d+)-(\\d+)");
        Matcher complexMatcher = complex.matcher("123-456-789");
        
        if (complexMatcher.matches()) {
            System.out.println("\nGroup count: " + complexMatcher.groupCount());
            for (int i = 0; i <= complexMatcher.groupCount(); i++) {
                System.out.println("  Group " + i + ": " + complexMatcher.group(i));
            }
        }
        
        // 6. hitEnd() - matn oxiriga yetdimi?
        matcher = Pattern.compile("\\d+").matcher("abc123");
        System.out.println("\nhitEnd: " + matcher.hitEnd()); // false
        
        // 7. usePattern() - patternni o'zgartirish
        matcher.usePattern(Pattern.compile("[a-z]+"));
        System.out.println("After pattern change: " + matcher.find()); // true
    }
}
```

### String Class Regex Methodlari

```java
public class StringRegexExample {
    public static void main(String[] args) {
        String text = "Hello, World! 123 Java 456 Programming";
        
        // 1. matches() - to'liq moslik
        System.out.println("Starts with Hello: " + 
            text.matches("^Hello.*")); // true
        
        // 2. replaceAll() - hamma mosliklarni almashtirish
        String noDigits = text.replaceAll("\\d+", "###");
        System.out.println("No digits: " + noDigits);
        
        String noWords = text.replaceAll("\\w+", "***");
        System.out.println("No words: " + noWords);
        
        // 3. replaceFirst() - birinchi moslikni almashtirish
        String firstDigit = text.replaceFirst("\\d+", "###");
        System.out.println("First digit replaced: " + firstDigit);
        
        // 4. split() - regex asosida bo'lish
        System.out.println("\nSplit by non-word characters:");
        String[] words = text.split("\\W+");
        for (String word : words) {
            System.out.println("  " + word);
        }
        
        System.out.println("\nSplit by digits:");
        String[] parts = text.split("\\d+");
        for (String part : parts) {
            System.out.println("  '" + part + "'");
        }
        
        // Split with limit
        System.out.println("\nSplit with limit 3:");
        String[] limited = text.split("\\s+", 3);
        for (String part : limited) {
            System.out.println("  '" + part + "'");
        }
    }
}
```

---

## Amaliy Misollar

### 1. Phone Number Validator

```java
public class PhoneValidator {
    
    // Uzbek phone numbers: +998 XX XXX XX XX
    public static boolean isValidUzbekPhone(String phone) {
        String regex = "^\\+998[ -]?\\d{2}[ -]?\\d{3}[ -]?\\d{2}[ -]?\\d{2}$";
        return phone != null && phone.matches(regex);
    }
    
    // International phone numbers
    public static boolean isValidInternationalPhone(String phone) {
        String regex = "^\\+(?:[0-9] ?){6,14}[0-9]$";
        return phone != null && phone.matches(regex);
    }
    
    // Extract phone numbers from text
    public static List<String> extractPhones(String text) {
        List<String> phones = new ArrayList<>();
        String regex = "\\+998[ -]?\\d{2}[ -]?\\d{3}[ -]?\\d{2}[ -]?\\d{2}";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(text);
        
        while (matcher.find()) {
            phones.add(matcher.group());
        }
        return phones;
    }
    
    public static void main(String[] args) {
        String[] phones = {
            "+998901234567",
            "+998 90 123 45 67",
            "+998-90-123-45-67",
            "+99890 1234567",
            "+99890abcd567",  // invalid
            "+9989012345",     // invalid (too short)
            "998901234567"     // invalid (no +)
        };
        
        System.out.println("Phone number validation:");
        for (String phone : phones) {
            System.out.printf("%-20s -> %s%n", 
                phone, isValidUzbekPhone(phone));
        }
        
        String text = "Contact us: +998901234567 or +998 90 123 45 67";
        System.out.println("\nExtracted phones: " + extractPhones(text));
    }
}
```

### 2. Email Validator

```java
public class EmailValidator {
    
    public static boolean isValidEmail(String email) {
        // Basic email validation
        String regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return email != null && email.matches(regex);
    }
    
    public static boolean isValidStrictEmail(String email) {
        // Strict email validation
        String regex = "^[a-zA-Z0-9][a-zA-Z0-9._%+-]{0,63}" +
                      "@[a-zA-Z0-9][a-zA-Z0-9.-]{0,63}" +
                      "\\.[a-zA-Z]{2,}$";
        return email != null && email.matches(regex);
    }
    
    public static String extractDomain(String email) {
        String regex = "@(.+)$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(email);
        
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }
    
    public static void main(String[] args) {
        String[] emails = {
            "user@example.com",
            "first.last@example.co.uk",
            "user+tag@example.com",
            "invalid.email@.com",
            "@example.com",
            "user@.com",
            "user@example.c"
        };
        
        System.out.println("Email validation:");
        for (String email : emails) {
            System.out.printf("%-30s -> %s (domain: %s)%n", 
                email, 
                isValidEmail(email),
                extractDomain(email));
        }
    }
}
```

### 3. Strong Password Validator

```java
public class PasswordValidator {
    
    // Password requirements:
    // - at least 8 characters
    // - at least one uppercase letter
    // - at least one lowercase letter
    // - at least one digit
    // - at least one special character
    
    public static boolean isStrongPassword(String password) {
        String regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
        return password != null && password.matches(regex);
    }
    
    public static List<String> validatePassword(String password) {
        List<String> errors = new ArrayList<>();
        
        if (password == null || password.length() < 8) {
            errors.add("Password must be at least 8 characters long");
        }
        if (!password.matches(".*[a-z].*")) {
            errors.add("Password must contain at least one lowercase letter");
        }
        if (!password.matches(".*[A-Z].*")) {
            errors.add("Password must contain at least one uppercase letter");
        }
        if (!password.matches(".*\\d.*")) {
            errors.add("Password must contain at least one digit");
        }
        if (!password.matches(".*[@$!%*?&].*")) {
            errors.add("Password must contain at least one special character (@$!%*?&)");
        }
        
        return errors;
    }
    
    public static void main(String[] args) {
        String[] passwords = {
            "Password123!",
            "weak",
            "onlylowercase",
            "OnlyUppercase",
            "NoSpecialChar123",
            "Short1!",
            "GoodPass123!"
        };
        
        System.out.println("Password validation:");
        for (String password : passwords) {
            System.out.println("\nPassword: " + password);
            System.out.println("  Strong? " + isStrongPassword(password));
            
            List<String> errors = validatePassword(password);
            if (!errors.isEmpty()) {
                System.out.println("  Errors:");
                for (String error : errors) {
                    System.out.println("    - " + error);
                }
            }
        }
    }
}
```

### 4. Text Processing Examples

```java
public class TextProcessingExample {
    
    // Extract all numbers from text
    public static List<Integer> extractNumbers(String text) {
        List<Integer> numbers = new ArrayList<>();
        Pattern pattern = Pattern.compile("\\d+");
        Matcher matcher = pattern.matcher(text);
        
        while (matcher.find()) {
            numbers.add(Integer.parseInt(matcher.group()));
        }
        return numbers;
    }
    
    // Split text into words
    public static String[] splitIntoWords(String text) {
        return text.split("\\W+");
    }
    
    // Count word occurrences
    public static Map<String, Integer> countWords(String text) {
        Map<String, Integer> wordCount = new HashMap<>();
        String[] words = text.toLowerCase().split("\\W+");
        
        for (String word : words) {
            if (!word.isEmpty()) {
                wordCount.put(word, wordCount.getOrDefault(word, 0) + 1);
            }
        }
        return wordCount;
    }
    
    // Remove HTML tags
    public static String removeHtmlTags(String html) {
        return html.replaceAll("<[^>]*>", "");
    }
    
    // Validate URL
    public static boolean isValidUrl(String url) {
        String regex = "^(https?://)?(www\\.)?[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+(/\\S*)?$";
        return url != null && url.matches(regex);
    }
    
    public static void main(String[] args) {
        String text = "The price is $100 and $50. Also 30 items for 25.5 dollars.";
        
        System.out.println("Numbers: " + extractNumbers(text));
        System.out.println("Words: " + Arrays.toString(splitIntoWords(text)));
        
        String paragraph = "Java is great. Java is powerful. I love Java!";
        System.out.println("\nWord counts: " + countWords(paragraph));
        
        String html = "<p>Hello <b>World</b>!</p>";
        System.out.println("\nHTML: " + html);
        System.out.println("Plain text: " + removeHtmlTags(html));
        
        String[] urls = {
            "https://www.example.com",
            "http://example.com/path",
            "www.example.com",
            "invalid-url",
            "example.com"
        };
        
        System.out.println("\nURL validation:");
        for (String url : urls) {
            System.out.printf("  %-20s -> %s%n", url, isValidUrl(url));
        }
    }
}
```

### 5. Advanced Regex Examples

```java
public class AdvancedRegexExamples {
    
    // Extract date from text
    public static LocalDate extractDate(String text) {
        // Matches YYYY-MM-DD format
        String regex = "\\b(\\d{4})-(\\d{2})-(\\d{2})\\b";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(text);
        
        if (matcher.find()) {
            int year = Integer.parseInt(matcher.group(1));
            int month = Integer.parseInt(matcher.group(2));
            int day = Integer.parseInt(matcher.group(3));
            return LocalDate.of(year, month, day);
        }
        return null;
    }
    
    // Validate IP address
    public static boolean isValidIP(String ip) {
        String regex = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}" +
                      "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$";
        return ip != null && ip.matches(regex);
    }
    
    // Extract hashtags from text
    public static List<String> extractHashtags(String text) {
        List<String> hashtags = new ArrayList<>();
        Pattern pattern = Pattern.compile("#\\w+");
        Matcher matcher = pattern.matcher(text);
        
        while (matcher.find()) {
            hashtags.add(matcher.group());
        }
        return hashtags;
    }
    
    // Mask credit card number
    public static String maskCreditCard(String cardNumber) {
        // Show only last 4 digits
        return cardNumber.replaceAll("\\d(?=\\d{4})", "*");
    }
    
    public static void main(String[] args) {
        // Date extraction
        String text = "Meeting on 2023-12-25 at 10:00";
        System.out.println("Date: " + extractDate(text));
        
        // IP validation
        String[] ips = {
            "192.168.1.1",
            "255.255.255.255",
            "256.0.0.1",
            "192.168.1"
        };
        
        System.out.println("\nIP validation:");
        for (String ip : ips) {
            System.out.printf("  %-15s -> %s%n", ip, isValidIP(ip));
        }
        
        // Hashtags
        String tweet = "I love #Java and #Programming! #100DaysOfCode";
        System.out.println("\nHashtags: " + extractHashtags(tweet));
        
        // Credit card masking
        String card = "1234567890123456";
        System.out.println("\nMasked card: " + maskCreditCard(card));
    }
}
```

---

## Tekshiruv Savollari

### Lesson 8.1 - Regular Expressions

1. **Regular Expression nima?**
2. **Regular Expression nima uchun ishlatiladi?**
3. **Pattern nima?**
4. **Matcher nima?**
5. **Pattern classini matcher() method nima uchun ishlatiladi?**
6. **Matcher classini matches() method nima uchun ishlatiladi?**
7. **Matcher classini find() method nima uchun ishlatiladi?**
8. **matches() va find() o'rtasidagi farq nima?**
9. **Regex'da grouping qanday ishlatiladi?**
10. **Quantifiers (+, *, ?, {n}) nima uchun ishlatiladi?**

### Qo'shimcha savollar

1. **Character class va predefined class o'rtasidagi farq?**
2. **Greedy va reluctant quantifiers farqi?**
3. **replaceAll() va replaceFirst() farqi?**
4. **split() method qanday ishlaydi?**
5. **Pattern.CASE_INSENSITIVE flag nima uchun ishlatiladi?**

---

## Regex Testing Resources

- **[regex101.com](https://regex101.com/)** - Online regex tester
- **[regexr.com](https://regexr.com/)** - Another great regex tool
- **[regexcrossword.com](https://regexcrossword.com/)** - Regex puzzles

---

**Keyingi mavzu:** [Java Networking](./09%20-%20Git%20va%20GitHub.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
