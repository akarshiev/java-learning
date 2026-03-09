# NIO (Non-blocking I/O)

Java NIO (New I/O) - Java 1.4 da kiritilgan, an'anaviy IO ga alternativ bo'lgan kutubxona.

## Asosiy Tushunchalar

- **Buffer** - Ma'lumotlarni saqlash uchun konteyner
- **Channel** - Ma'lumot uzatish uchun kanal
- **Selector** - Ko'p kanallarni boshqarish uchun

## NIO vs IO

| IO | NIO |
|----|-----|
| Stream oriented | Buffer oriented |
| Blocking | Non-blocking |
| No selector | Selectors |

## Asosiy Sinflar

- `FileChannel` - Fayllar bilan ishlash
- `SocketChannel` - TCP ulanishlari
- `ServerSocketChannel` - TCP server
- `DatagramChannel` - UDP ulanishlari
- `ByteBuffer` - Bayt buferi

---

**Keyingi mavzu:** [Serializatsiya](./09-serialization.md)
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
