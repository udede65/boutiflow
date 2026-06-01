import re

file_path = 'lib/core/localization/app_localizations.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

new_keys = {
    'en': {
        'identityNo': 'ID / Passport No',
        'duplicateGuestWarning': 'A guest with the same {field} already exists: {name}',
        'phone': 'Phone',
        'roomService': 'Room Service',
        'roomServiceOrders': 'Room Service Orders',
        'newOrder': 'New Order',
        'itemName': 'Item Name',
        'quantity': 'Quantity',
        'orderPrice': 'Price',
        'orderNotes': 'Notes',
        'orderStatus': 'Status',
        'statusPending': 'Pending',
        'statusPreparing': 'Preparing',
        'statusDelivered': 'Delivered',
        'statusCancelled': 'Cancelled',
        'orderCreated': 'Order created',
        'noOrdersYet': 'No orders yet',
        'selectRoom': 'Select Room',
        'orderStatusUpdated': 'Status updated',
    },
    'tr': {
        'identityNo': 'TC Kimlik / Pasaport No',
        'duplicateGuestWarning': 'Aynı {field} ile kayıtlı misafir var: {name}',
        'phone': 'Telefon',
        'roomService': 'Oda Servisi',
        'roomServiceOrders': 'Oda Servisi Siparişleri',
        'newOrder': 'Yeni Sipariş',
        'itemName': 'Ürün Adı',
        'quantity': 'Adet',
        'orderPrice': 'Fiyat',
        'orderNotes': 'Notlar',
        'orderStatus': 'Durum',
        'statusPending': 'Beklemede',
        'statusPreparing': 'Hazırlanıyor',
        'statusDelivered': 'Teslim Edildi',
        'statusCancelled': 'İptal Edildi',
        'orderCreated': 'Sipariş oluşturuldu',
        'noOrdersYet': 'Henüz sipariş yok',
        'selectRoom': 'Oda Seçin',
        'orderStatusUpdated': 'Durum güncellendi',
    },
    'de': {
        'identityNo': 'Ausweis / Reisepass Nr.',
        'duplicateGuestWarning': 'Ein Gast mit dem gleichen {field} existiert bereits: {name}',
        'phone': 'Telefon',
        'roomService': 'Zimmerservice',
        'roomServiceOrders': 'Zimmerservice-Bestellungen',
        'newOrder': 'Neue Bestellung',
        'itemName': 'Artikelname',
        'quantity': 'Menge',
        'orderPrice': 'Preis',
        'orderNotes': 'Notizen',
        'orderStatus': 'Status',
        'statusPending': 'Ausstehend',
        'statusPreparing': 'In Zubereitung',
        'statusDelivered': 'Geliefert',
        'statusCancelled': 'Storniert',
        'orderCreated': 'Bestellung erstellt',
        'noOrdersYet': 'Noch keine Bestellungen',
        'selectRoom': 'Zimmer auswählen',
        'orderStatusUpdated': 'Status aktualisiert',
    },
    'ru': {
        'identityNo': 'Удостоверение / Паспорт №',
        'duplicateGuestWarning': 'Гость с таким же {field} уже существует: {name}',
        'phone': 'Телефон',
        'roomService': 'Обслуживание номеров',
        'roomServiceOrders': 'Заказы обслуживания номеров',
        'newOrder': 'Новый заказ',
        'itemName': 'Название товара',
        'quantity': 'Количество',
        'orderPrice': 'Цена',
        'orderNotes': 'Заметки',
        'orderStatus': 'Статус',
        'statusPending': 'Ожидание',
        'statusPreparing': 'Готовится',
        'statusDelivered': 'Доставлено',
        'statusCancelled': 'Отменено',
        'orderCreated': 'Заказ создан',
        'noOrdersYet': 'Заказов пока нет',
        'selectRoom': 'Выберите номер',
        'orderStatusUpdated': 'Статус обновлен',
    },
    'fr': {
        'identityNo': "Pièce d'identité / Passeport N°",
        'duplicateGuestWarning': 'Un invité avec le même {field} existe déjà : {name}',
        'phone': 'Téléphone',
        'roomService': 'Service en chambre',
        'roomServiceOrders': 'Commandes de service en chambre',
        'newOrder': 'Nouvelle commande',
        'itemName': "Nom de l'article",
        'quantity': 'Quantité',
        'orderPrice': 'Prix',
        'orderNotes': 'Notes',
        'orderStatus': 'Statut',
        'statusPending': 'En attente',
        'statusPreparing': 'En préparation',
        'statusDelivered': 'Livré',
        'statusCancelled': 'Annulé',
        'orderCreated': 'Commande créée',
        'noOrdersYet': 'Pas encore de commandes',
        'selectRoom': 'Sélectionner une chambre',
        'orderStatusUpdated': 'Statut mis à jour',
    },
    'es': {
        'identityNo': 'DNI / Pasaporte Nº',
        'duplicateGuestWarning': 'Ya existe un huésped con el mismo {field}: {name}',
        'phone': 'Teléfono',
        'roomService': 'Servicio de habitación',
        'roomServiceOrders': 'Pedidos de servicio de habitación',
        'newOrder': 'Nuevo pedido',
        'itemName': 'Nombre del artículo',
        'quantity': 'Cantidad',
        'orderPrice': 'Precio',
        'orderNotes': 'Notas',
        'orderStatus': 'Estado',
        'statusPending': 'Pendiente',
        'statusPreparing': 'Preparando',
        'statusDelivered': 'Entregado',
        'statusCancelled': 'Cancelado',
        'orderCreated': 'Pedido creado',
        'noOrdersYet': 'Aún no hay pedidos',
        'selectRoom': 'Seleccionar habitación',
        'orderStatusUpdated': 'Estado actualizado',
    }
}

for lang, keys in new_keys.items():
    pattern = r"('" + lang + r"':\s*\{)(.*?)(^\s*\},\n)"
    
    def make_replacer(lang_keys):
        def replacer(match):
            block = match.group(2)
            for key, value in lang_keys.items():
                if f"'{key}'" not in block:
                    val_escaped = value.replace("'", "\\'")
                    block += f"      '{key}': '{val_escaped}',\n"
            return match.group(1) + block + match.group(3)
        return replacer

    content = re.sub(pattern, make_replacer(keys), content, flags=re.MULTILINE | re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Localization updated for all 6 languages.')
