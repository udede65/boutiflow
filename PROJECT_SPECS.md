# BOUTIFLOW - PROJE TEKNİK DÖKÜMANI VE KURALLARI (MASTER PLAN - FINAL)

## 1. PROJE VİZYONU VE STRATEJİSİ
- **Ürün:** Küçük oteller, bungalovlar, pansiyonlar ve Airbnb evleri için SaaS tabanlı yönetim uygulaması.
- **Hedef Kitle:** Teknolojik karmaşadan kaçan, pratiklik arayan küçük işletmeciler.
- **Pazar:** Global odaklı (Öncelik iOS/App Store).
- **Gelir Modeli:** Aylık ve Yıllık Abonelik (In-App Purchase).
- **Kritik Prensip:** "Mevcut UI Yapısını Koru & Genişlet". Mevcut tasarım dili (%20 bitmiş kısım) bozulmadan backend entegre edilecek.

## 2. TEKNOLOJİ YIĞINI (TECH STACK)
- **Framework:** Flutter (Dart)
- **Backend & Auth:** Supabase (PostgreSQL)
- **State Management:** Riverpod (Code Generation modunda)
- **Navigation:** GoRouter
- **Localization:** easy_localization (6 Dil: TR, EN, DE, FR, IT, ES)
- **Payments:** RevenueCat (purchases_flutter)
- **OCR (Tarama):** google_mlkit_text_recognition (On-device / Cihaz içi işlem)
- **Export/Raporlama:** pdf / excel (KBS ve Polis listeleri için çıktı alma)
- **Date Handling:** intl

## 3. VERİTABANI ŞEMASI (SUPABASE)
*PostgreSQL tarafında bu yapı RLS (Row Level Security) ile korunmalıdır.*

### A. Core Tables
1. **profiles** (İşletme Ayarları)
   - `id` (uuid, PK): auth.uid
   - `currency_symbol` (text, default: '$'): Tüm uygulama bu sembolü baz alır.
   - `app_language` (text): İşletmecinin kullandığı dil.
   - `subscription_tier` (text): 'free', 'monthly', 'annual'.
   - `subscription_end_date` (datetime): Abonelik bitişi.

2. **rooms** (Üniteler)
   - `id` (uuid, PK)
   - `user_id` (uuid, FK)
   - `name` (text): "Bungalov 1", "Nehir Evi".
   - `type` (text): 'room', 'bungalow', 'tent'.
   - `default_price` (numeric): Varsayılan fiyat.
   - `color_code` (text): Takvim rengi (Hex: #FF5733).
   - `cleaning_status` (text): 'clean' (Yeşil), 'dirty' (Kırmızı).

3. **guests** (Müşteri & CRM)
   - `id` (uuid, PK)
   - `user_id` (uuid, FK)
   - `full_name` (text)
   - `phone` (text): Unique index.
   - `national_id` (text): TCKN veya Pasaport No (OCR ile dolacak).
   - `nationality` (text): 'TR', 'DE', 'IT' (İstatistik ve Polis raporu için).
   - `language_code` (text): Müşterinin dili (WhatsApp şablonu için).
   - `is_blacklisted` (bool)

4. **bookings** (Rezervasyonlar)
   - `id` (uuid, PK)
   - `room_id`, `guest_id`
   - `check_in`, `check_out` (UTC formatında sakla, Local göster)
   - `total_price` (numeric)
   - `status` (text): 'confirmed', 'pending', 'cancelled', 'checked_in', 'checked_out'.

5. **expenses** (Basit Kasa)
   - `id` (uuid, PK)
   - `title` (text)
   - `amount` (numeric)
   - `date` (datetime)
   - `category` (text)

## 4. FONKSİYONEL ÖZELLİKLER VE İŞ MANTIĞI

### A. Kimlik Tarama ve Yasal Raporlama (OCR & Export)
- **Prensip:** "Araç Sun, Sorumluluk Alma".
- **OCR (Opsiyonel):** Misafir ekleme ekranında "Kimlik Tara" butonu. Google ML Kit ile isim ve ID numarasını okuyup forma doldurur. Veri sunucuya değil, forma işlenir.
- **Export (Kritik):** Günlük "Gelen Yolcu Listesi" (Police Report) oluşturma özelliği.
  - Kullanıcıya PDF veya Excel dosyası verilir.
  - Kullanıcı bu dosyayı kendisi devlet sistemine (KBS, Alloggiati vb.) yükler.
  - *Not:* Uygulama otomatik devlet bildirimi YAPMAZ.

### B. Akıllı WhatsApp Asistanı
- `guests.language_code` verisine göre dinamik şablon seçimi.
- `assets/templates/whatsapp_templates.json`:
  - `{"tr": "Merhaba {name}, ...", "it": "Ciao {name}, ..."}`
- İşletmeci dili bilmese bile müşteriye kendi dilinde mesaj atar.

### C. Görsel Takvim (Timeline UI)
- Mevcut kart tasarımları kullanılarak oluşturulan "Resource View" takvim.
- Odaların temizlik durumu ikonlarla gösterilir.
- Sürükle-bırak veya Long-Press ile hızlı düzenleme.

### D. Abonelik Yönetimi (Monetization)
- **Freemium Model:** İlk 5 rezervasyon ücretsiz. Devamı için Premium gerekir.
- **Paywall:** Yıllık (İndirimli) ve Aylık planlar.
- **Guard:** Rezervasyon ekleme butonuna basıldığında `SubscriptionManager` kontrol yapar.

## 5. GELİŞTİRME KURALLARI (AI TALİMATLARI)

1.  **UI DOKUNULMAZLIĞI:** `lib/theme`, `lib/common_widgets` altındaki buton stillerini, renk paletini ve fontları KORU. Yeni özellikleri bu yapıya entegre et.
2.  **Dil Yapısı:** Hardcoded string yasak. Tüm metinler `codegen_loader` veya `easy_localization` keys üzerinden gelmeli.
3.  **Hata Yönetimi:** Kullanıcı dostu hata mesajları göster. Teknik detayları logla.
4.  **Güvenlik:** RLS politikalarına uygun sorgular yaz (`user_id` filtresi).
5.  **Offline-First:** İnternet kopsa bile uygulama salt-okunur modda çalışabilmeli veya uyarı vermeli.
