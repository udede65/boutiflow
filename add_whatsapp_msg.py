import re

file_path = 'lib/core/localization/app_localizations.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

new_keys = {
    'en': "Hello {guestName}, your reservation for {roomName} between {checkIn} and {checkOut} is confirmed. We look forward to welcoming you!",
    'tr': "Merhaba {guestName}, {checkIn} - {checkOut} tarihleri arasındaki {roomName} rezervasyonunuz onaylanmıştır. Sizi ağırlamayı sabırsızlıkla bekliyoruz!",
    'de': "Hallo {guestName}, Ihre Reservierung für {roomName} zwischen {checkIn} und {checkOut} ist bestätigt. Wir freuen uns auf Sie!",
    'ru': "Здравствуйте {guestName}, ваше бронирование для {roomName} с {checkIn} по {checkOut} подтверждено. Ждем вас!",
    'fr': "Bonjour {guestName}, votre réservation pour {roomName} entre {checkIn} et {checkOut} est confirmée. Nous avons hâte de vous accueillir !",
    'es': "Hola {guestName}, su reserva para {roomName} entre {checkIn} y {checkOut} está confirmada. ¡Esperamos darle la bienvenida!",
}

for lang, val in new_keys.items():
    pattern = r"('" + lang + r"':\s*\{)(.*?)(^\s*\},\n)"
    def make_replacer(value):
        def replacer(match):
            block = match.group(2)
            if "'whatsappBookingMessage'" not in block:
                val_escaped = value.replace("'", "\\'")
                block += f"      'whatsappBookingMessage': '{val_escaped}',\n"
            return match.group(1) + block + match.group(3)
        return replacer
    content = re.sub(pattern, make_replacer(val), content, flags=re.MULTILINE | re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Localization updated with whatsappBookingMessage.')
