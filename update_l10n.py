import re

file_path = 'lib/core/localization/app_localizations.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

new_keys = {
    'en': {
        'totalBookingsBreak': 'Total\\nBookings',
        'totalRevenueBreak': 'Total\\nRevenue',
        'thisMonthBookingsBreak': 'This Month\\nBookings',
        'thisMonthRevenueBreak': 'This Month\\nRevenue',
        'weeklyOccupancy': 'Weekly Occupancy',
        'noGuestDataYet': 'No guest data yet',
        'monthlyRevenueSummary': 'Monthly Revenue Summary',
        'downloadPdf': 'Download PDF',
        'reportGenerationFailed': 'Failed to generate report: {error}'
    },
    'tr': {
        'totalBookingsBreak': 'Toplam\\nRezervasyon',
        'totalRevenueBreak': 'Toplam\\nGelir',
        'thisMonthBookingsBreak': 'Bu Ay\\nRezervasyon',
        'thisMonthRevenueBreak': 'Bu Ay\\nGelir',
        'weeklyOccupancy': 'Haftalık Doluluk',
        'noGuestDataYet': 'Henüz misafir verisi yok',
        'monthlyRevenueSummary': 'Aylık Gelir Özeti',
        'downloadPdf': 'PDF İndir',
        'reportGenerationFailed': 'Rapor oluşturulamadı: {error}'
    },
    'de': {
        'totalBookingsBreak': 'Gesamt\\nBuchungen',
        'totalRevenueBreak': 'Gesamt\\nUmsatz',
        'thisMonthBookingsBreak': 'Diesen Monat\\nBuchungen',
        'thisMonthRevenueBreak': 'Diesen Monat\\nUmsatz',
        'weeklyOccupancy': 'Wöchentliche Auslastung',
        'noGuestDataYet': 'Noch keine Gästedaten',
        'monthlyRevenueSummary': 'Monatliche Umsatzzusammenfassung',
        'downloadPdf': 'PDF herunterladen',
        'reportGenerationFailed': 'Bericht konnte nicht erstellt werden: {error}'
    },
    'ru': {
        'totalBookingsBreak': 'Всего\\nбронирований',
        'totalRevenueBreak': 'Общий\\nдоход',
        'thisMonthBookingsBreak': 'Бронирования\\nв этом месяце',
        'thisMonthRevenueBreak': 'Доход\\nв этом месяце',
        'weeklyOccupancy': 'Еженедельная заполняемость',
        'noGuestDataYet': 'Пока нет данных о гостях',
        'monthlyRevenueSummary': 'Ежемесячный отчет о доходах',
        'downloadPdf': 'Скачать PDF',
        'reportGenerationFailed': 'Не удалось создать отчет: {error}'
    },
    'fr': {
        'totalBookingsBreak': 'Total\\nréservations',
        'totalRevenueBreak': 'Revenu\\ntotal',
        'thisMonthBookingsBreak': 'Réservations\\nce mois',
        'thisMonthRevenueBreak': 'Revenu\\nce mois',
        'weeklyOccupancy': 'Occupation hebdomadaire',
        'noGuestDataYet': 'Pas encore de données invité',
        'monthlyRevenueSummary': 'Résumé mensuel des revenus',
        'downloadPdf': 'Télécharger le PDF',
        'reportGenerationFailed': 'Échec de la génération du rapport : {error}'
    },
    'es': {
        'totalBookingsBreak': 'Total\\nreservas',
        'totalRevenueBreak': 'Ingresos\\ntotales',
        'thisMonthBookingsBreak': 'Reservas\\neste mes',
        'thisMonthRevenueBreak': 'Ingresos\\neste mes',
        'weeklyOccupancy': 'Ocupación semanal',
        'noGuestDataYet': 'Aún no hay datos de huéspedes',
        'monthlyRevenueSummary': 'Resumen de ingresos mensuales',
        'downloadPdf': 'Descargar PDF',
        'reportGenerationFailed': 'Error al generar el informe: {error}'
    }
}

for lang, keys in new_keys.items():
    # Find the language block
    pattern = r"('" + lang + r"':\s*\{)(.*?)(^\s*\},\n)"
    
    def replacer(match):
        block = match.group(2)
        # Avoid duplicates
        for key, value in keys.items():
            if f"'{key}'" not in block:
                val_escaped = value.replace("'", "\\'")
                block += f"      '{key}': '{val_escaped}',\n"
        return match.group(1) + block + match.group(3)

    content = re.sub(pattern, replacer, content, flags=re.MULTILINE | re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Updated translations successfully.')
