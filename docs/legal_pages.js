(function () {
  const supportedLanguages = ['en', 'tr', 'de', 'ru', 'fr', 'es'];
  const languageNames = {
    en: 'English',
    tr: 'Türkçe',
    de: 'Deutsch',
    ru: 'Русский',
    fr: 'Français',
    es: 'Español',
  };

  const common = {
    en: {
      home: 'Home',
      support: 'Support',
      privacy: 'Privacy',
      terms: 'Terms',
      copyright: '© 2026 BoutiFlow. All rights reserved.',
      contactSupport: 'Contact Support',
      accountDeletionSubject: 'BoutiFlow Account Deletion Request',
    },
    tr: {
      home: 'Ana Sayfa',
      support: 'Destek',
      privacy: 'Gizlilik',
      terms: 'Koşullar',
      copyright: '© 2026 BoutiFlow. Tüm hakları saklıdır.',
      contactSupport: 'Destek ile İletişim',
      accountDeletionSubject: 'BoutiFlow Hesap Silme Talebi',
    },
    de: {
      home: 'Startseite',
      support: 'Hilfe',
      privacy: 'Datenschutz',
      terms: 'Bedingungen',
      copyright: '© 2026 BoutiFlow. Alle Rechte vorbehalten.',
      contactSupport: 'Support kontaktieren',
      accountDeletionSubject: 'BoutiFlow Antrag auf Kontolöschung',
    },
    ru: {
      home: 'Главная',
      support: 'Поддержка',
      privacy: 'Конфиденциальность',
      terms: 'Условия',
      copyright: '© 2026 BoutiFlow. Все права защищены.',
      contactSupport: 'Связаться с поддержкой',
      accountDeletionSubject: 'Запрос на удаление аккаунта BoutiFlow',
    },
    fr: {
      home: 'Accueil',
      support: 'Support',
      privacy: 'Confidentialité',
      terms: 'Conditions',
      copyright: '© 2026 BoutiFlow. Tous droits réservés.',
      contactSupport: 'Contacter le support',
      accountDeletionSubject: 'Demande de suppression de compte BoutiFlow',
    },
    es: {
      home: 'Inicio',
      support: 'Soporte',
      privacy: 'Privacidad',
      terms: 'Términos',
      copyright: '© 2026 BoutiFlow. Todos los derechos reservados.',
      contactSupport: 'Contactar soporte',
      accountDeletionSubject: 'Solicitud de eliminación de cuenta BoutiFlow',
    },
  };

  const pages = {
    privacy: {
      en: {
        title: 'Privacy Policy - BoutiFlow',
        heading: 'Privacy Policy',
        updated: 'Last updated: May 2026',
        sections: [
          ['1. Introduction', 'Welcome to BoutiFlow. We respect your privacy and are committed to protecting your personal data. This policy explains how we handle data when you use our mobile application.'],
          ['2. Data We Collect', 'BoutiFlow is an offline-first hotel management app. The data you enter may include account information, hotel profile details, room settings, reservation records, guest names, guest contact details, ID or passport numbers that you manually enter, payment records, income and expense records, and app preferences.'],
          ['3. Service Providers', 'If you sign in, use cloud sync, subscriptions, or premium features, relevant data may be processed by Supabase for authentication and cloud sync, RevenueCat for subscription status, Apple for App Store purchases, and advertising or analytics providers where applicable.'],
          ['4. How We Use Data', 'We use your data to provide app features such as managing reservations, guests, rooms, payments, finance records, reports, and subscriptions. We do not sell your personal data.'],
          ['5. Data Security', 'We use reasonable technical and organizational safeguards to help protect your data from unauthorized access, loss, alteration, or disclosure.'],
          ['6. Your Rights', 'You can request access, correction, or deletion of your data. For cloud-synced data, open BoutiFlow and go to Settings > Legal & Support > Delete Account. You can also contact us from the support page. Local-only data can be removed by deleting the app or clearing local app data.'],
          ['7. Contact Us', 'For privacy questions, contact support@boutiflow.com.'],
        ],
      },
      tr: {
        title: 'Gizlilik Politikası - BoutiFlow',
        heading: 'Gizlilik Politikası',
        updated: 'Son güncelleme: Mayıs 2026',
        sections: [
          ['1. Giriş', 'BoutiFlow olarak gizliliğinize önem veriyoruz. Bu politika, mobil uygulamayı kullanırken verilerinizi nasıl işlediğimizi açıklar.'],
          ['2. Topladığımız Veriler', 'BoutiFlow çevrimdışı öncelikli bir otel yönetim uygulamasıdır. Girdiğiniz veriler kullanıcı hesabı, otel profili, oda ayarları, rezervasyon kayıtları, misafir adı, misafir iletişim bilgileri, sizin manuel girdiğiniz kimlik veya pasaport numarası, ödeme kayıtları, gelir-gider kayıtları ve uygulama tercihlerini içerebilir.'],
          ['3. Hizmet Sağlayıcılar', 'Giriş yaptığınızda, bulut senkronizasyonu, abonelik veya premium özellikleri kullandığınızda ilgili veriler Supabase, RevenueCat, Apple ve gerekli olduğunda reklam/analitik sağlayıcıları tarafından işlenebilir. Supabase kimlik doğrulama ve bulut senkronizasyonu, RevenueCat abonelik durumu, Apple App Store satın alımları için kullanılır.'],
          ['4. Verileri Kullanma Amacımız', 'Verileri rezervasyon, misafir, oda, ödeme, finans kayıtları, raporlar ve abonelik özelliklerini çalıştırmak için kullanırız. Kişisel verilerinizi satmayız.'],
          ['5. Veri Güvenliği', 'Verilerin yetkisiz erişim, kayıp, değişiklik veya ifşaya karşı korunmasına yardımcı olmak için makul teknik ve organizasyonel önlemler kullanırız.'],
          ['6. Haklarınız', 'Verilerinize erişim, düzeltme veya silme talep edebilirsiniz. Bulutla senkronize edilen veriler için BoutiFlow içinde Ayarlar > Yasal & Destek > Hesabı Sil bölümünden talep başlatabilirsiniz. Yalnızca cihazda tutulan veriler uygulamayı silerek veya yerel uygulama verilerini temizleyerek kaldırılabilir.'],
          ['7. İletişim', 'Gizlilik soruları için support@boutiflow.com adresinden bize ulaşabilirsiniz.'],
        ],
      },
      de: {
        title: 'Datenschutzerklärung - BoutiFlow',
        heading: 'Datenschutzerklärung',
        updated: 'Zuletzt aktualisiert: Mai 2026',
        sections: [
          ['1. Einführung', 'BoutiFlow respektiert Ihre Privatsphäre. Diese Erklärung beschreibt, wie wir Daten bei der Nutzung unserer mobilen App verarbeiten.'],
          ['2. Erhobene Daten', 'BoutiFlow ist eine Offline-First-App für Hotelverwaltung. Die von Ihnen eingegebenen Daten können Kontoinformationen, Hotelprofil, Zimmereinstellungen, Reservierungen, Gästenamen, Kontaktdaten, manuell eingegebene Ausweis- oder Passnummern, Zahlungsdaten, Einnahmen/Ausgaben und App-Einstellungen enthalten.'],
          ['3. Dienstleister', 'Bei Anmeldung, Cloud-Sync, Abonnements oder Premium-Funktionen können relevante Daten von Supabase, RevenueCat, Apple und gegebenenfalls Werbe-/Analysediensten verarbeitet werden.'],
          ['4. Nutzung der Daten', 'Wir verwenden Daten zur Bereitstellung von Reservierungen, Gästen, Zimmern, Zahlungen, Finanzaufzeichnungen, Berichten und Abonnements. Wir verkaufen Ihre personenbezogenen Daten nicht.'],
          ['5. Datensicherheit', 'Wir setzen angemessene technische und organisatorische Schutzmaßnahmen gegen unbefugten Zugriff, Verlust, Änderung oder Offenlegung ein.'],
          ['6. Ihre Rechte', 'Sie können Zugriff, Berichtigung oder Löschung verlangen. Für Cloud-Daten öffnen Sie BoutiFlow und gehen zu Einstellungen > Rechtliches & Hilfe > Konto löschen. Nur lokal gespeicherte Daten können durch Löschen der App oder der lokalen App-Daten entfernt werden.'],
          ['7. Kontakt', 'Bei Datenschutzfragen kontaktieren Sie support@boutiflow.com.'],
        ],
      },
      ru: {
        title: 'Политика конфиденциальности - BoutiFlow',
        heading: 'Политика конфиденциальности',
        updated: 'Обновлено: май 2026',
        sections: [
          ['1. Введение', 'BoutiFlow уважает вашу конфиденциальность. Эта политика объясняет, как мы обрабатываем данные при использовании мобильного приложения.'],
          ['2. Какие данные мы собираем', 'BoutiFlow работает по принципу offline-first для управления отелем. Введенные вами данные могут включать учетную запись, профиль отеля, настройки номеров, бронирования, имена гостей, контактные данные, вручную введенные номера документов или паспортов, платежи, доходы/расходы и настройки приложения.'],
          ['3. Поставщики услуг', 'При входе, облачной синхронизации, подписках или premium-функциях данные могут обрабатываться Supabase, RevenueCat, Apple, а также рекламными или аналитическими поставщиками, если применимо.'],
          ['4. Как мы используем данные', 'Мы используем данные для работы функций бронирования, гостей, номеров, платежей, финансов, отчетов и подписок. Мы не продаем персональные данные.'],
          ['5. Безопасность данных', 'Мы применяем разумные технические и организационные меры для защиты данных от несанкционированного доступа, потери, изменения или раскрытия.'],
          ['6. Ваши права', 'Вы можете запросить доступ, исправление или удаление данных. Для облачных данных откройте BoutiFlow и перейдите в Настройки > Правовая информация > Удалить аккаунт. Локальные данные можно удалить, удалив приложение или очистив локальные данные приложения.'],
          ['7. Контакты', 'По вопросам конфиденциальности пишите на support@boutiflow.com.'],
        ],
      },
      fr: {
        title: 'Politique de confidentialité - BoutiFlow',
        heading: 'Politique de confidentialité',
        updated: 'Dernière mise à jour : mai 2026',
        sections: [
          ['1. Introduction', 'BoutiFlow respecte votre vie privée. Cette politique explique comment nous traitons les données lorsque vous utilisez notre application mobile.'],
          ['2. Données collectées', 'BoutiFlow est une application de gestion hôtelière offline-first. Les données saisies peuvent inclure compte utilisateur, profil hôtel, paramètres des chambres, réservations, noms et contacts des clients, numéros d’identité ou passeport saisis manuellement, paiements, revenus/dépenses et préférences.'],
          ['3. Prestataires', 'Si vous vous connectez, utilisez la synchronisation cloud, les abonnements ou les fonctions premium, les données pertinentes peuvent être traitées par Supabase, RevenueCat, Apple et, le cas échéant, des fournisseurs publicitaires ou analytiques.'],
          ['4. Utilisation des données', 'Nous utilisons vos données pour gérer réservations, clients, chambres, paiements, finances, rapports et abonnements. Nous ne vendons pas vos données personnelles.'],
          ['5. Sécurité', 'Nous appliquons des mesures techniques et organisationnelles raisonnables pour protéger les données contre l’accès non autorisé, la perte, la modification ou la divulgation.'],
          ['6. Vos droits', 'Vous pouvez demander l’accès, la correction ou la suppression de vos données. Pour les données synchronisées, ouvrez BoutiFlow puis Paramètres > Légal & Support > Supprimer le compte. Les données locales peuvent être supprimées en supprimant l’application ou ses données locales.'],
          ['7. Contact', 'Pour toute question de confidentialité, contactez support@boutiflow.com.'],
        ],
      },
      es: {
        title: 'Política de privacidad - BoutiFlow',
        heading: 'Política de privacidad',
        updated: 'Última actualización: mayo de 2026',
        sections: [
          ['1. Introducción', 'BoutiFlow respeta tu privacidad. Esta política explica cómo tratamos los datos cuando usas nuestra aplicación móvil.'],
          ['2. Datos que recopilamos', 'BoutiFlow es una app de gestión hotelera offline-first. Los datos introducidos pueden incluir cuenta, perfil del hotel, configuración de habitaciones, reservas, nombres y contactos de huéspedes, números de documento o pasaporte introducidos manualmente, pagos, ingresos/gastos y preferencias.'],
          ['3. Proveedores', 'Si inicias sesión, usas sincronización en la nube, suscripciones o funciones premium, los datos relevantes pueden ser tratados por Supabase, RevenueCat, Apple y, cuando corresponda, proveedores de publicidad o analítica.'],
          ['4. Uso de datos', 'Usamos los datos para gestionar reservas, huéspedes, habitaciones, pagos, finanzas, informes y suscripciones. No vendemos tus datos personales.'],
          ['5. Seguridad', 'Aplicamos medidas técnicas y organizativas razonables para proteger los datos frente a acceso no autorizado, pérdida, alteración o divulgación.'],
          ['6. Tus derechos', 'Puedes solicitar acceso, corrección o eliminación de tus datos. Para datos sincronizados, abre BoutiFlow y ve a Ajustes > Legal y Soporte > Eliminar cuenta. Los datos locales pueden eliminarse borrando la app o limpiando sus datos locales.'],
          ['7. Contacto', 'Para preguntas de privacidad, contacta con support@boutiflow.com.'],
        ],
      },
    },
    terms: {
      en: {
        title: 'Terms of Service - BoutiFlow',
        heading: 'Terms of Service',
        updated: 'Last updated: May 2026',
        sections: [
          ['1. Acceptance of Terms', 'By downloading or using BoutiFlow, these terms apply to you. Please read them carefully before using the app.'],
          ['2. Use of the App', 'BoutiFlow provides hotel and property management tools. You may use the app for lawful business purposes and may not copy, reverse engineer, or misuse the app or our trademarks.'],
          ['3. Subscriptions', 'Premium features may be offered through monthly or annual subscriptions. Subscriptions renew automatically unless cancelled through your App Store or Google Play account settings. Refunds are handled according to store policies and applicable law.'],
          ['4. User Responsibilities', 'You are responsible for the accuracy of the data you enter, securing your device, and complying with local rules that apply to your property or guests.'],
          ['5. Limitation of Liability', 'BoutiFlow is provided as a management tool. We are not liable for indirect, incidental, consequential, or business interruption damages to the extent permitted by law.'],
        ],
      },
      tr: {
        title: 'Kullanım Koşulları - BoutiFlow',
        heading: 'Kullanım Koşulları',
        updated: 'Son güncelleme: Mayıs 2026',
        sections: [
          ['1. Koşulların Kabulü', 'BoutiFlow’u indirerek veya kullanarak bu koşulları kabul etmiş olursunuz. Uygulamayı kullanmadan önce dikkatlice okuyun.'],
          ['2. Uygulamanın Kullanımı', 'BoutiFlow otel ve tesis yönetimi araçları sunar. Uygulamayı yasal iş amaçları için kullanabilirsiniz; uygulamayı, parçalarını veya markalarımızı kopyalayamaz, tersine mühendislik yapamaz veya kötüye kullanamazsınız.'],
          ['3. Abonelikler', 'Premium özellikler aylık veya yıllık abonelikle sunulabilir. Abonelikler App Store veya Google Play hesap ayarlarınızdan iptal edilmediği sürece yenilenir. İadeler mağaza politikaları ve geçerli kanunlara göre yürütülür.'],
          ['4. Kullanıcı Sorumlulukları', 'Girdiğiniz verilerin doğruluğundan, cihaz güvenliğinden ve tesisiniz veya misafirleriniz için geçerli yerel kurallara uymaktan siz sorumlusunuz.'],
          ['5. Sorumluluğun Sınırı', 'BoutiFlow bir yönetim aracı olarak sunulur. Kanunun izin verdiği ölçüde dolaylı, arızi, sonuçsal zararlar veya iş kesintilerinden sorumlu değiliz.'],
        ],
      },
      de: {
        title: 'Nutzungsbedingungen - BoutiFlow',
        heading: 'Nutzungsbedingungen',
        updated: 'Zuletzt aktualisiert: Mai 2026',
        sections: [
          ['1. Annahme der Bedingungen', 'Durch Herunterladen oder Nutzen von BoutiFlow gelten diese Bedingungen. Bitte lesen Sie sie sorgfältig.'],
          ['2. Nutzung der App', 'BoutiFlow bietet Werkzeuge für Hotel- und Objektverwaltung. Sie dürfen die App für rechtmäßige geschäftliche Zwecke nutzen und die App oder Marken nicht kopieren, missbrauchen oder zurückentwickeln.'],
          ['3. Abonnements', 'Premium-Funktionen können als monatliches oder jährliches Abonnement angeboten werden. Abonnements verlängern sich automatisch, sofern sie nicht in den App Store- oder Google Play-Einstellungen gekündigt werden.'],
          ['4. Verantwortung der Nutzer', 'Sie sind für die Richtigkeit Ihrer Eingaben, die Sicherheit Ihres Geräts und die Einhaltung lokaler Vorschriften verantwortlich.'],
          ['5. Haftungsbeschränkung', 'BoutiFlow wird als Verwaltungstool bereitgestellt. Soweit gesetzlich zulässig, haften wir nicht für indirekte Schäden, Folgeschäden oder Betriebsunterbrechungen.'],
        ],
      },
      ru: {
        title: 'Условия использования - BoutiFlow',
        heading: 'Условия использования',
        updated: 'Обновлено: май 2026',
        sections: [
          ['1. Принятие условий', 'Загружая или используя BoutiFlow, вы соглашаетесь с этими условиями. Пожалуйста, внимательно прочитайте их.'],
          ['2. Использование приложения', 'BoutiFlow предоставляет инструменты управления отелем и объектом размещения. Приложение можно использовать для законных деловых целей; копирование, злоупотребление или обратная разработка запрещены.'],
          ['3. Подписки', 'Premium-функции могут предоставляться по месячной или годовой подписке. Подписки продлеваются автоматически, если не отменены в настройках App Store или Google Play.'],
          ['4. Ответственность пользователя', 'Вы отвечаете за точность введенных данных, безопасность устройства и соблюдение местных правил, применимых к вашему объекту или гостям.'],
          ['5. Ограничение ответственности', 'BoutiFlow предоставляется как инструмент управления. В пределах, разрешенных законом, мы не отвечаем за косвенные, случайные, последующие убытки или перерывы в работе бизнеса.'],
        ],
      },
      fr: {
        title: 'Conditions d’utilisation - BoutiFlow',
        heading: 'Conditions d’utilisation',
        updated: 'Dernière mise à jour : mai 2026',
        sections: [
          ['1. Acceptation', 'En téléchargeant ou en utilisant BoutiFlow, vous acceptez ces conditions. Veuillez les lire attentivement.'],
          ['2. Utilisation de l’application', 'BoutiFlow fournit des outils de gestion hôtelière. Vous pouvez utiliser l’app à des fins professionnelles légales, sans copier, détourner ni rétroconcevoir l’application ou nos marques.'],
          ['3. Abonnements', 'Les fonctions premium peuvent être proposées via des abonnements mensuels ou annuels. Les abonnements se renouvellent automatiquement sauf annulation dans les réglages App Store ou Google Play.'],
          ['4. Responsabilités', 'Vous êtes responsable de l’exactitude des données saisies, de la sécurité de votre appareil et du respect des règles locales applicables.'],
          ['5. Limitation de responsabilité', 'BoutiFlow est fourni comme outil de gestion. Dans la mesure permise par la loi, nous ne sommes pas responsables des dommages indirects, accessoires, consécutifs ou interruptions d’activité.'],
        ],
      },
      es: {
        title: 'Términos de servicio - BoutiFlow',
        heading: 'Términos de servicio',
        updated: 'Última actualización: mayo de 2026',
        sections: [
          ['1. Aceptación', 'Al descargar o usar BoutiFlow, aceptas estos términos. Léelos cuidadosamente antes de usar la app.'],
          ['2. Uso de la app', 'BoutiFlow ofrece herramientas de gestión hotelera. Puedes usar la app para fines comerciales legales y no puedes copiar, abusar ni aplicar ingeniería inversa a la app o nuestras marcas.'],
          ['3. Suscripciones', 'Las funciones premium pueden ofrecerse mediante suscripción mensual o anual. Las suscripciones se renuevan automáticamente salvo cancelación desde App Store o Google Play.'],
          ['4. Responsabilidades', 'Eres responsable de la exactitud de los datos introducidos, de proteger tu dispositivo y de cumplir las normas locales aplicables.'],
          ['5. Limitación de responsabilidad', 'BoutiFlow se proporciona como herramienta de gestión. En la medida permitida por la ley, no somos responsables por daños indirectos, incidentales, consecuentes o interrupción del negocio.'],
        ],
      },
    },
    support: {
      en: {
        title: 'Help & Support - BoutiFlow',
        heading: 'Help & Support',
        updated: 'Welcome to the BoutiFlow support center. Find answers to common questions or reach out directly.',
        sections: [
          ['Frequently Asked Questions', ''],
          ['How do I reset my password?', 'Use the reset option on the sign-in screen if available, or contact support with the email address connected to your account.'],
          ['Does the app work offline?', 'Yes. BoutiFlow is designed offline-first. Local data is saved on your device and cloud-enabled data syncs when you are online.'],
          ['How do I upgrade to Premium?', 'Open Settings inside the app and choose Upgrade to Premium. You can select a monthly or annual plan.'],
          ['How do I delete my account?', 'Open BoutiFlow and go to Settings > Legal & Support > Delete Account. The app opens a pre-filled support email so we can verify and process deletion of your account and cloud-synced data.'],
          ['Can I generate reports?', 'Yes. BoutiFlow can generate operational and finance reports from your reservations, payments, income, and expenses.'],
          ['Still need help?', 'If you could not find an answer, contact our support team at support@boutiflow.com.'],
        ],
      },
      tr: {
        title: 'Yardım ve Destek - BoutiFlow',
        heading: 'Yardım ve Destek',
        updated: 'BoutiFlow destek merkezine hoş geldiniz. Sık sorulan sorulara bakabilir veya bizimle iletişime geçebilirsiniz.',
        sections: [
          ['Sık Sorulan Sorular', ''],
          ['Şifremi nasıl sıfırlarım?', 'Giriş ekranındaki sıfırlama seçeneğini kullanın veya hesabınıza bağlı e-posta adresiyle destek ekibine yazın.'],
          ['Uygulama çevrimdışı çalışır mı?', 'Evet. BoutiFlow çevrimdışı önceliklidir. Yerel veriler cihazınızda saklanır, bulut özellikleri ise internet olduğunda senkronize edilir.'],
          ['Premium’a nasıl geçerim?', 'Uygulama içindeki Ayarlar bölümünden Premium’a Yükselt seçeneğini açın. Aylık veya yıllık plan seçebilirsiniz.'],
          ['Hesabımı nasıl silerim?', 'BoutiFlow içinde Ayarlar > Yasal & Destek > Hesabı Sil bölümüne gidin. Uygulama, hesabınızı ve bulutla senkronize verilerinizi doğrulayıp silebilmemiz için hazır bir destek e-postası açar.'],
          ['Rapor oluşturabilir miyim?', 'Evet. BoutiFlow rezervasyon, ödeme, gelir ve gider kayıtlarından operasyonel ve finans raporları oluşturabilir.'],
          ['Hala yardıma mı ihtiyacınız var?', 'Cevap bulamadıysanız support@boutiflow.com adresinden destek ekibimize ulaşın.'],
        ],
      },
      de: {
        title: 'Hilfe & Support - BoutiFlow',
        heading: 'Hilfe & Support',
        updated: 'Willkommen im BoutiFlow-Supportcenter. Finden Sie Antworten oder kontaktieren Sie uns direkt.',
        sections: [
          ['Häufige Fragen', ''],
          ['Wie setze ich mein Passwort zurück?', 'Nutzen Sie die Zurücksetzen-Option auf dem Anmeldebildschirm oder kontaktieren Sie den Support mit Ihrer Konto-E-Mail.'],
          ['Funktioniert die App offline?', 'Ja. BoutiFlow ist offline-first. Lokale Daten bleiben auf dem Gerät, cloudfähige Daten synchronisieren sich online.'],
          ['Wie upgrade ich auf Premium?', 'Öffnen Sie Einstellungen in der App und wählen Sie Upgrade auf Premium. Sie können einen Monats- oder Jahresplan wählen.'],
          ['Wie lösche ich mein Konto?', 'Öffnen Sie BoutiFlow und gehen Sie zu Einstellungen > Rechtliches & Hilfe > Konto löschen. Die App öffnet eine vorbereitete Support-E-Mail zur Verifizierung und Löschung.'],
          ['Kann ich Berichte erstellen?', 'Ja. BoutiFlow erstellt Betriebs- und Finanzberichte aus Reservierungen, Zahlungen, Einnahmen und Ausgaben.'],
          ['Brauchen Sie weitere Hilfe?', 'Wenn Sie keine Antwort gefunden haben, kontaktieren Sie support@boutiflow.com.'],
        ],
      },
      ru: {
        title: 'Помощь и поддержка - BoutiFlow',
        heading: 'Помощь и поддержка',
        updated: 'Добро пожаловать в центр поддержки BoutiFlow. Найдите ответы или свяжитесь с нами.',
        sections: [
          ['Частые вопросы', ''],
          ['Как сбросить пароль?', 'Используйте опцию сброса на экране входа или напишите в поддержку с адреса электронной почты вашего аккаунта.'],
          ['Работает ли приложение офлайн?', 'Да. BoutiFlow работает offline-first. Локальные данные хранятся на устройстве, облачные данные синхронизируются при подключении.'],
          ['Как перейти на Premium?', 'Откройте Настройки в приложении и выберите переход на Premium. Доступны месячный и годовой планы.'],
          ['Как удалить аккаунт?', 'Откройте BoutiFlow и перейдите в Настройки > Правовая информация > Удалить аккаунт. Приложение откроет подготовленное письмо в поддержку для проверки и удаления.'],
          ['Можно ли создавать отчеты?', 'Да. BoutiFlow создает операционные и финансовые отчеты из бронирований, платежей, доходов и расходов.'],
          ['Нужна помощь?', 'Если вы не нашли ответ, напишите на support@boutiflow.com.'],
        ],
      },
      fr: {
        title: 'Aide & Support - BoutiFlow',
        heading: 'Aide & Support',
        updated: 'Bienvenue dans le centre d’aide BoutiFlow. Trouvez des réponses ou contactez-nous directement.',
        sections: [
          ['Questions fréquentes', ''],
          ['Comment réinitialiser mon mot de passe ?', 'Utilisez l’option de réinitialisation sur l’écran de connexion ou contactez le support avec l’adresse e-mail de votre compte.'],
          ['L’application fonctionne-t-elle hors ligne ?', 'Oui. BoutiFlow est offline-first. Les données locales restent sur l’appareil et les données cloud se synchronisent en ligne.'],
          ['Comment passer à Premium ?', 'Ouvrez les Paramètres dans l’app et choisissez Passer à Premium. Vous pouvez choisir un plan mensuel ou annuel.'],
          ['Comment supprimer mon compte ?', 'Ouvrez BoutiFlow puis Paramètres > Légal & Support > Supprimer le compte. L’app ouvre un e-mail préparé pour vérifier et traiter la suppression.'],
          ['Puis-je créer des rapports ?', 'Oui. BoutiFlow génère des rapports opérationnels et financiers à partir des réservations, paiements, revenus et dépenses.'],
          ['Besoin d’aide ?', 'Si vous ne trouvez pas de réponse, contactez support@boutiflow.com.'],
        ],
      },
      es: {
        title: 'Ayuda y Soporte - BoutiFlow',
        heading: 'Ayuda y Soporte',
        updated: 'Bienvenido al centro de soporte de BoutiFlow. Encuentra respuestas o contáctanos directamente.',
        sections: [
          ['Preguntas frecuentes', ''],
          ['¿Cómo restablezco mi contraseña?', 'Usa la opción de restablecimiento en la pantalla de inicio de sesión o contacta con soporte usando el email de tu cuenta.'],
          ['¿La app funciona sin conexión?', 'Sí. BoutiFlow es offline-first. Los datos locales se guardan en el dispositivo y los datos en la nube se sincronizan cuando hay conexión.'],
          ['¿Cómo paso a Premium?', 'Abre Ajustes dentro de la app y elige Pasar a Premium. Puedes elegir plan mensual o anual.'],
          ['¿Cómo elimino mi cuenta?', 'Abre BoutiFlow y ve a Ajustes > Legal y Soporte > Eliminar cuenta. La app abre un email preparado para verificar y procesar la eliminación.'],
          ['¿Puedo generar informes?', 'Sí. BoutiFlow genera informes operativos y financieros desde reservas, pagos, ingresos y gastos.'],
          ['¿Necesitas ayuda?', 'Si no encontraste respuesta, contacta con support@boutiflow.com.'],
        ],
      },
    },
  };

  function currentLanguage() {
    const params = new URLSearchParams(window.location.search);
    const requested = params.get('lang');
    if (supportedLanguages.includes(requested)) return requested;

    const browserLanguage = (navigator.language || 'en').slice(0, 2);
    return supportedLanguages.includes(browserLanguage) ? browserLanguage : 'en';
  }

  function withLanguage(path, language) {
    return `${path}?lang=${language}`;
  }

  function renderSection(section, index, page, language) {
    const [title, text] = section;
    if (page === 'support') {
      if (index === 0) {
        const h2 = document.createElement('h2');
        h2.textContent = title;
        return h2;
      }

      const item = document.createElement('div');
      item.className = 'faq-item';
      const h3 = document.createElement('h3');
      h3.textContent = title;
      item.appendChild(h3);
      if (text) {
        const p = document.createElement('p');
        p.textContent = text;
        item.appendChild(p);
      }
      if (index === 4) {
        const mail = document.createElement('p');
        const link = document.createElement('a');
        link.href = `mailto:support@boutiflow.com?subject=${encodeURIComponent(common[language].accountDeletionSubject)}`;
        link.textContent = 'support@boutiflow.com';
        mail.appendChild(link);
        item.appendChild(mail);
      }
      return item;
    }

    const fragment = document.createDocumentFragment();
    const h2 = document.createElement('h2');
    h2.textContent = title;
    fragment.appendChild(h2);
    if (text) {
      const p = document.createElement('p');
      p.textContent = text;
      fragment.appendChild(p);
    }
    return fragment;
  }

  function renderLegalPage() {
    const page = document.body.dataset.legalPage;
    const language = currentLanguage();
    const pageData = pages[page][language];
    const commonData = common[language];

    document.documentElement.lang = language;
    document.title = pageData.title;
    document.getElementById('nav-home').textContent = commonData.home;
    document.getElementById('nav-home').href = withLanguage('index.html', language);
    document.getElementById('nav-secondary').textContent = page === 'support' ? commonData.privacy : commonData.support;
    document.getElementById('nav-secondary').href = withLanguage(page === 'support' ? 'privacy.html' : 'support.html', language);
    document.getElementById('legal-title').textContent = pageData.heading;
    document.getElementById('legal-updated').textContent = pageData.updated;
    document.getElementById('copyright').textContent = commonData.copyright;

    const languageSelect = document.getElementById('language-select');
    languageSelect.innerHTML = '';
    supportedLanguages.forEach((code) => {
      const option = document.createElement('option');
      option.value = code;
      option.textContent = languageNames[code];
      option.selected = code === language;
      languageSelect.appendChild(option);
    });
    languageSelect.addEventListener('change', () => {
      window.location.search = `?lang=${languageSelect.value}`;
    });

    const content = document.getElementById('legal-sections');
    content.innerHTML = '';
    pageData.sections.forEach((section, index) => {
      content.appendChild(renderSection(section, index, page, language));
    });

    if (page === 'support') {
      const contact = document.createElement('div');
      contact.className = 'contact-box';
      const h2 = document.createElement('h2');
      h2.textContent = commonData.contactSupport;
      const p = document.createElement('p');
      p.textContent = 'support@boutiflow.com';
      const link = document.createElement('a');
      link.className = 'btn btn-yellow';
      link.style.marginTop = '16px';
      link.href = 'mailto:support@boutiflow.com';
      link.textContent = commonData.contactSupport;
      contact.append(h2, p, link);
      content.appendChild(contact);
    }
  }

  renderLegalPage();
})();
