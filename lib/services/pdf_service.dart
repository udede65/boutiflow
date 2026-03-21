import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../core/models/entities.dart';
import '../core/localization/app_localizations.dart';

class PdfService {
  Future<void> generateInvoice(Booking booking, UserProfile hotel, AppLocalizations l10n) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(l10n.t('invoice') ?? 'INVOICE', style: pw.TextStyle(font: font, fontSize: 40)),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(hotel.hotelName, style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, fontSize: 20)),
                      pw.Text(hotel.email, style: pw.TextStyle(font: font)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${l10n.t('invoiceDate')}: ${DateFormat.yMMMd().format(DateTime.now())}', style: pw.TextStyle(font: font)),
                      pw.Text('${l10n.t('bookingId')}: ${booking.id.substring(0, 8)}', style: pw.TextStyle(font: font)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Text('${l10n.t('billTo')}:', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
              pw.Text(booking.guest.name, style: pw.TextStyle(font: font)),
              if (booking.guest.email != null) pw.Text(booking.guest.email!, style: pw.TextStyle(font: font)),
              pw.SizedBox(height: 40),
              pw.Table.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                cellStyle: pw.TextStyle(font: font),
                data: <List<String>>[
                  <String>[l10n.t('description') ?? 'Description', l10n.t('amount') ?? 'Amount'],
                  <String>[
                    '${l10n.t('accommodation')} (${booking.room.name})\n${DateFormat.yMMMd().format(booking.checkIn)} - ${DateFormat.yMMMd().format(booking.checkOut)}',
                    '${getCurrencySymbol(hotel.currency)}${(booking.priceTotal ?? 0.0).toStringAsFixed(2)}'
                  ],
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('${l10n.t('total')}: ${getCurrencySymbol(hotel.currency)}${(booking.priceTotal ?? 0.0).toStringAsFixed(2)}', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, fontSize: 18)),
                ],
              ),
              pw.Spacer(),
              pw.Divider(),
              pw.Center(child: pw.Text(l10n.t('thankYou') ?? 'Thank you for your business!', style: pw.TextStyle(font: font))),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Invoice_${booking.id}.pdf',
    );
  }

  Future<void> generateConfirmation(Booking booking, UserProfile hotel, AppLocalizations l10n) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(l10n.t('bookingConfirmation') ?? 'BOOKING CONFIRMATION', style: pw.TextStyle(font: font, fontSize: 30)),
              ),
              pw.SizedBox(height: 20),
              pw.Text('${l10n.t('dear')} ${booking.guest.name},', style: pw.TextStyle(font: font, fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text(l10n.t('confirmationMessage') ?? 'We are pleased to confirm your reservation at ${hotel.hotelName}.', style: pw.TextStyle(font: font)),
              pw.SizedBox(height: 30),
              pw.Table.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                cellStyle: pw.TextStyle(font: font),
                data: <List<String>>[
                  <String>[l10n.t('detail') ?? 'Detail', l10n.t('value') ?? 'Value'],
                  <String>[l10n.t('checkIn') ?? 'Check-in', DateFormat.yMMMd().format(booking.checkIn)],
                  <String>[l10n.t('checkOut') ?? 'Check-out', DateFormat.yMMMd().format(booking.checkOut)],
                  <String>[l10n.t('room') ?? 'Room', booking.room.name],
                  <String>[l10n.t('guests') ?? 'Guests', booking.room.capacity.toString()],
                  <String>[l10n.t('totalPrice') ?? 'Total Price', '${getCurrencySymbol(hotel.currency)}${(booking.priceTotal ?? 0.0).toStringAsFixed(2)}'],
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Text(l10n.t('hotelAddress') ?? 'Hotel Address:', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
              pw.Text(hotel.hotelName, style: pw.TextStyle(font: font)),
              // Add address if available in UserProfile
              pw.Spacer(),
              pw.Divider(),
              pw.Center(child: pw.Text(l10n.t('seeYouSoon') ?? 'We look forward to welcoming you!', style: pw.TextStyle(font: font))),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Confirmation_${booking.id}.pdf',
    );
  }
}
