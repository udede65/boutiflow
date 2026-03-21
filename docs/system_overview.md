# RoomPilot - Sistem ve Mantık Genel Bakışı

Bu belge, RoomPilot uygulamasının mevcut durumunu, teknik mimarisini ve modüllerin nasıl çalıştığını açıklar.

## 1. Genel Mimari (Architecture)
RoomPilot, **"Local-First" (Önce Yerel)** prensibiyle tasarlanmış bir Flutter uygulamasıdır.
*   **Çevrimdışı Çalışma:** Uygulama internet bağlantısı gerektirmez. Tüm veriler cihazda yerel bir veritabanında (SQLite) saklanır.
*   **Teknoloji Yığını:**
    *   **Framework:** Flutter (UI)
    *   **State Management:** Riverpod (Uygulama durumu ve mantığı)
    *   **Veritabanı:** Drift (SQLite ORM - Veri saklama)
    *   **Navigasyon:** GoRouter (Sayfa geçişleri)
    *   **Tasarım:** Özel "Premium" Tasarım Sistemi (Glassmorphism, Gradientler)

## 2. Veri Mantığı (Data Logic)
Uygulamanın beyni `lib/core/database/database.dart` dosyasındaki **Drift** veritabanıdır.
*   **İlişkisel Yapı:**
    *   `Hotels`: Otel ayarları.
    *   `Rooms`: Odalar ve özellikleri.
    *   `Guests`: Misafir profilleri.
    *   `Bookings`: Rezervasyonlar (Oda ve Misafir tablolarına bağlıdır).
    *   `Payments`: Gelir/Gider kayıtları (Rezervasyonlara bağlanabilir).
*   **Reaktif Veri:** Veritabanındaki herhangi bir değişiklik (örn: yeni rezervasyon), Riverpod "Stream"leri sayesinde anında UI'a yansır (Dashboard sayıları otomatik güncellenir).

## 3. Modüller ve İşleyiş

### A. Dashboard (Kontrol Paneli)
*   **Mantık:** Veritabanından o günkü "Girişler", "Çıkışlar" ve "Konaklayanlar"ı sorgular.
*   **Hesaplama:** Doluluk oranı = (Dolu Oda / Toplam Oda) * 100.
*   **UI:** Yatay kaydırılabilir cam kartlar (Glassmorphism) ve son aktiviteler listesi.

### B. Takvim (Calendar)
*   **Mantık:** 2 Boyutlu bir ızgara (Grid) oluşturur.
    *   **Satırlar:** Odalar
    *   **Sütunlar:** Tarihler
*   **İşleyiş:** Her hücre için o tarihte ve o odada bir rezervasyon olup olmadığını kontrol eder. Varsa renkli bir blok çizer.
*   **Etkileşim:** Boş hücreye tıklanırsa "Yeni Rezervasyon", dolu hücreye tıklanırsa "Detay" açılır.

### C. Rezervasyon ve Misafirler (CRM)
*   **Akış:** Rezervasyon oluşturulurken önce Misafir seçilir (veya yeni oluşturulur), sonra Oda ve Tarih aralığı belirlenir.
*   **Fiyatlandırma:** Oda fiyatı x Gün sayısı = Toplam Tutar.
*   **Durumlar:** Onaylandı, Giriş Yaptı (Check-in), Çıkış Yaptı (Check-out), İptal.

### D. Housekeeping (Kat Hizmetleri)
*   **Otomasyon:** Bir misafir "Check-out" yaptığında, o odanın durumu otomatik olarak **"Kirli" (Dirty)** olur.
*   **Personel Ekranı:** Temizlik personeli odayı temizleyince durumu **"Temiz" (Clean)** olarak işaretler ve oda tekrar kiralanabilir hale gelir.

### E. Finans (Finance)
*   **Takip:** Rezervasyonlara bağlı ödemeler (Nakit/Kredi Kartı) ve ekstra harcamalar kaydedilir.
*   **Bakiye:** Toplam Tutar - Ödenen Tutar = Kalan Bakiye (Balance Due) otomatik hesaplanır.

## 4. Premium Özellikler (Monetization)
Uygulama "Freemium" modelini kullanır. Bazı özellikler kilitlidir.
*   **Paywall (Ödeme Duvarı):** `PaywallProvider` kullanıcının abonelik durumunu kontrol eder.
*   **Kilitli Özellikler:**
    *   **Gelişmiş Raporlar:** Gelir grafikleri, kaynak analizi.
    *   **Bulut Yedekleme (Cloud Backup):** Yerel veritabanını Supabase bulutuna şifreli olarak yedekler.
    *   **PDF Dışa Aktarma:** Fatura ve konfirmasyon mektubu oluşturma.
*   **Dev Modu:** Geliştirici girişinde (Hızlı Giriş) otomatik Premium yetkisi verilir (Test amaçlı, şu an kapalı olabilir).

## 5. Tasarım Dili (UI/UX)
*   **Tema:** "Slate Blue & Gold". Koyu, modern ve lüks bir görünüm.
*   **Bileşenler:**
    *   `PremiumBackground`: Tüm sayfalarda ortak kullanılan gradyan arka plan.
    *   `GlassContainer`: Buzlu cam efekti veren kutular.
    *   `Floating Navigation`: Alt kısımda yüzen, cam görünümlü navigasyon çubuğu.

## Özet
RoomPilot, modern teknolojilerle (Flutter/Riverpod) yazılmış, internete bağımlı olmayan, ancak istendiğinde buluta yedekleme yapabilen, otelcilerin tüm günlük operasyonlarını (Ön büro, Temizlik, Muhasebe) tek yerden yönetmesini sağlayan akıllı bir asistan uygulamasıdır.
