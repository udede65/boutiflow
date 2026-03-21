import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/models/entities.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class CalendarGrid extends StatefulWidget {
  const CalendarGrid({
    super.key,
    required this.rooms,
    required this.bookings,
    required this.dates,
    required this.currencySymbol,
    this.cellWidth = 100,
    this.cellHeight = 60,
    this.roomColumnWidth = 120,
    this.onBookingMove,
    this.onRoomTap,
  });

  final List<Room> rooms;
  final List<Booking> bookings;
  final List<DateTime> dates;
  final String currencySymbol;
  final double cellWidth;
  final double cellHeight;
  final double roomColumnWidth;
  final Function(Booking, Room, DateTime)? onBookingMove;
  final Function(Room)? onRoomTap;

  @override
  State<CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  late ScrollController _headerHorizontalController;
  late ScrollController _roomVerticalController;
  late ScrollController _gridHorizontalController;
  late ScrollController _gridVerticalController;

  @override
  void initState() {
    super.initState();
    _headerHorizontalController = ScrollController();
    _roomVerticalController = ScrollController();
    _gridHorizontalController = ScrollController();
    _gridVerticalController = ScrollController();

    // Link Horizontal Controllers
    _headerHorizontalController.addListener(() {
      if (_headerHorizontalController.hasClients &&
          _gridHorizontalController.hasClients) {
        if (_headerHorizontalController.offset !=
            _gridHorizontalController.offset) {
          _gridHorizontalController.jumpTo(_headerHorizontalController.offset);
        }
      }
    });
    _gridHorizontalController.addListener(() {
      if (_headerHorizontalController.hasClients &&
          _gridHorizontalController.hasClients) {
        if (_gridHorizontalController.offset !=
            _headerHorizontalController.offset) {
          _headerHorizontalController.jumpTo(_gridHorizontalController.offset);
        }
      }
    });

    // Link Vertical Controllers
    _roomVerticalController.addListener(() {
      if (_roomVerticalController.hasClients &&
          _gridVerticalController.hasClients) {
        if (_roomVerticalController.offset != _gridVerticalController.offset) {
          _gridVerticalController.jumpTo(_roomVerticalController.offset);
        }
      }
    });
    _gridVerticalController.addListener(() {
      if (_roomVerticalController.hasClients &&
          _gridVerticalController.hasClients) {
        if (_gridVerticalController.offset != _roomVerticalController.offset) {
          _roomVerticalController.jumpTo(_gridVerticalController.offset);
        }
      }
    });
  }

  @override
  void dispose() {
    _headerHorizontalController.dispose();
    _roomVerticalController.dispose();
    _gridHorizontalController.dispose();
    _gridVerticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final borderColor = NeoBrutalistTheme.black.withOpacity(0.2);
    final bgSurface = Colors.transparent;
    final textPrimary = NeoBrutalistTheme.black;
    final textSecondary = NeoBrutalistTheme.black.withOpacity(0.7);
    final textMuted = NeoBrutalistTheme.black.withOpacity(0.5);
    const primary = Color(0xFF2560E9);

    return Column(
      children: [
        // 1. Header Row (Corner + Dates)
        SizedBox(
          height: 60,
          child: Row(
            children: [
              // Top Left Corner (Fixed)
              Container(
                width: widget.roomColumnWidth,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: borderColor),
                    right: BorderSide(color: borderColor),
                  ),
                  color: bgSurface,
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.t('rooms'),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: textSecondary,
                  ),
                ),
              ),
              // Dates Header (Scrolls Horizontally)
              Expanded(
                child: SingleChildScrollView(
                  controller: _headerHorizontalController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: Row(
                    children: widget.dates.map((date) {
                      final isWeekend = date.weekday == 6 || date.weekday == 7;
                      final isToday = _isSameDay(date, DateTime.now());
                      return Container(
                        width: widget.cellWidth,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              isToday ? primary.withOpacity(0.15) : bgSurface,
                          border: Border(
                            bottom: BorderSide(color: borderColor),
                            right: BorderSide(color: borderColor),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${date.day}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: isToday ? primary : textPrimary,
                              ),
                            ),
                            Text(
                              _weekdayName(context, date),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isToday
                                    ? primary
                                    : (isWeekend
                                        ? Colors.redAccent
                                        : textSecondary),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2. Body (Rooms + Grid)
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Column (Scrolls Vertically)
              SizedBox(
                width: widget.roomColumnWidth,
                child: SingleChildScrollView(
                  controller: _roomVerticalController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      ...widget.rooms
                          .map((room) => InkWell(
                                onTap: () => widget.onRoomTap?.call(room),
                                child: Container(
                                  height: widget.cellHeight,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: borderColor),
                                      right: BorderSide(color: borderColor),
                                    ),
                                    color: bgSurface,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        room.name,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (room.type != null)
                                        Text(
                                          room.type!.name,
                                          style: GoogleFonts.inter(
                                            color: textMuted,
                                            fontSize: 10,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                      const SizedBox(height: 100), // Bottom padding for nav bar
                    ],
                  ),
                ),
              ),

              // Grid Content (Scrolls Both Ways)
              Expanded(
                child: SingleChildScrollView(
                  controller: _gridVerticalController,
                  physics: const ClampingScrollPhysics(),
                  child: SingleChildScrollView(
                    controller: _gridHorizontalController,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        ...widget.rooms.map((room) {
                          return Row(
                            children: widget.dates.map((date) {
                              final booking = _findBooking(room, date);
                              final isWeekend =
                                  date.weekday == 6 || date.weekday == 7;

                              return GestureDetector(
                                onTap: () {
                                  if (booking != null) {
                                    _showBookingOptions(context, booking);
                                  } else {
                                    _showEmptySlotOptions(context, room, date);
                                  }
                                },
                                onLongPress: () {
                                  // Start drag logic if needed
                                },
                                child: DragTarget<Booking>(
                                  onWillAccept: (data) =>
                                      data != null && data.room.id != room.id ||
                                      _isDifferentDate(data, date),
                                  onAccept: (data) {
                                    widget.onBookingMove
                                        ?.call(data, room, date);
                                  },
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    final isHovered = candidateData.isNotEmpty;

                                    return Semantics(
                                      label: booking != null
                                          ? l10n.tf('bookingSemanticLabel', {
                                              'guest': booking.guest.name,
                                              'room': room.name,
                                              'date':
                                                  _formatDate(context, date),
                                            })
                                          : l10n.tf('availableSemanticLabel', {
                                              'room': room.name,
                                              'date':
                                                  _formatDate(context, date),
                                            }),
                                      hint: booking != null
                                          ? l10n.t('doubleTapToEdit')
                                          : l10n.t('doubleTapToCreateBooking'),
                                      child: Container(
                                        width: widget.cellWidth,
                                        height: widget.cellHeight,
                                        decoration: BoxDecoration(
                                          color: isHovered
                                              ? primary.withOpacity(0.1)
                                              : (isWeekend
                                                  ? bgSurface
                                                  : Colors.transparent),
                                          border: Border(
                                            bottom:
                                                BorderSide(color: borderColor),
                                            right:
                                                BorderSide(color: borderColor),
                                          ),
                                        ),
                                        child: booking != null
                                            ? _buildBookingCell(booking)
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                        const SizedBox(
                            height: 100), // Bottom padding for nav bar
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCell(Booking booking) {
    Color color;
    switch (booking.status) {
      case BookingStatus.checkedIn:
        color = Colors.blue;
        break;
      case BookingStatus.checkedOut:
        color = Colors.grey;
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        break;
      case BookingStatus.reserved:
      default:
        color = const Color(0xFFFFC107); // Gold
    }

    return Draggable<Booking>(
      data: booking,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: widget.cellWidth,
          height: widget.cellHeight,
          color: color.withOpacity(0.8),
          alignment: Alignment.center,
          child: Text(
            booking.guest.name,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      childWhenDragging: Container(
        color: color.withOpacity(0.3),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              booking.guest.name,
              style: GoogleFonts.inter(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (booking.priceTotal != null)
              Text(
                '${booking.priceTotal!.toStringAsFixed(0)} ${widget.currencySymbol}',
                style: GoogleFonts.inter(
                  color: Colors.black54,
                  fontSize: 9,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Booking? _findBooking(Room room, DateTime date) {
    // Simple check if date falls within booking range
    // Note: This is simplified. Real logic should handle multi-day spans visually better.
    // For this grid, we just show the booking on every day it spans.
    try {
      return widget.bookings.firstWhere((b) =>
          b.room.id == room.id &&
          (date.isAtSameMomentAs(b.checkIn) ||
              (date.isAfter(b.checkIn) && date.isBefore(b.checkOut))));
    } catch (_) {
      return null;
    }
  }

  bool _isDifferentDate(Booking? booking, DateTime date) {
    if (booking == null) return false;
    return !_isSameDay(booking.checkIn, date);
  }

  void _showEmptySlotOptions(BuildContext context, Room room, DateTime date) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${room.name} - ${_formatDate(context, date)}',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle, color: Color(0xFFFFC107)),
              title: Text(l10n.t('newBooking'),
                  style: GoogleFonts.inter(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                context.push('/bookings/add',
                    extra: {'roomId': room.id, 'date': date});
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.redAccent),
              title: Text(l10n.t('markMaintenance'),
                  style: GoogleFonts.inter(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement maintenance block
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showBookingOptions(BuildContext context, Booking booking) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                booking.guest.name,
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: Text(l10n.t('editBookingTitle'),
                  style: GoogleFonts.inter(color: Colors.white)),
              subtitle: Text(
                  '${_formatDate(context, booking.checkIn)} - ${_formatDate(context, booking.checkOut)}',
                  style: GoogleFonts.inter(color: Colors.white54)),
              onTap: () {
                Navigator.pop(context);
                context.push('/bookings/${booking.id}');
              },
            ),
            if (booking.status == BookingStatus.reserved)
              ListTile(
                leading: const Icon(Icons.login, color: Colors.green),
                title: Text(l10n.t('checkIn'),
                    style: GoogleFonts.inter(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Quick Check-in
                },
              ),
            if (booking.status == BookingStatus.checkedIn)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.orange),
                title: Text(l10n.t('checkOut'),
                    style: GoogleFonts.inter(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Quick Check-out
                },
              ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white70),
              title: Text(l10n.t('shareViaWhatsapp'),
                  style: GoogleFonts.inter(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // TODO: WhatsApp share
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _weekdayName(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.E(locale).format(date);
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.yMd(locale).format(date);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
