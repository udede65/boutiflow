import '../models/entities.dart';

/// Centralized plan capabilities for Free vs Premium tiers.
class PlanLimits {
  // Free tier limits
  static const int freeMaxRooms = 2;
  static const int freeMaxBookingsTotal = 15;
  static const int freeMaxTemplates = 3;
  static const int freeMaxCalendarDays = 7;

  // Premium tier limits
  static const int proMaxRooms = 999999;
  static const int proMaxBookingsTotal = 999999;
  static const int proMaxTemplates = 999999;
  static const int premiumMaxCalendarDays = 90;
  static const int premiumPlusMaxCalendarDays = 365;

  static bool isPremium(PlanType plan) =>
      plan == PlanType.premium || plan == PlanType.premiumPlus;

  static int maxCalendarDays(PlanType plan) {
    if (plan == PlanType.premiumPlus) return premiumPlusMaxCalendarDays;
    if (plan == PlanType.premium) return premiumMaxCalendarDays;
    return freeMaxCalendarDays;
  }

  /// Check if user can add another room
  static bool canAddRoom(PlanType plan, int currentRoomCount) {
    if (isPremium(plan)) return true;
    return currentRoomCount < freeMaxRooms;
  }

  /// Check if user can add another booking
  static bool canAddBooking(PlanType plan, int totalBookingCount) {
    if (isPremium(plan)) return true;
    return totalBookingCount < freeMaxBookingsTotal;
  }

  /// Check if user can create another message template
  static bool canAddTemplate(PlanType plan, int currentTemplateCount) {
    if (isPremium(plan)) return true;
    return currentTemplateCount < freeMaxTemplates;
  }

  /// Check if selected calendar range is available for plan
  static bool canUseCalendarRange(PlanType plan, int selectedDays) {
    return selectedDays <= maxCalendarDays(plan);
  }

  /// Get remaining rooms for Free tier
  static int remainingRooms(PlanType plan, int currentRoomCount) {
    if (isPremium(plan)) return proMaxRooms;
    return (freeMaxRooms - currentRoomCount).clamp(0, freeMaxRooms);
  }

  /// Get remaining bookings for Free tier
  static int remainingBookings(PlanType plan, int totalBookingCount) {
    if (isPremium(plan)) return proMaxBookingsTotal;
    return (freeMaxBookingsTotal - totalBookingCount)
        .clamp(0, freeMaxBookingsTotal);
  }

  /// Get remaining template slots
  static int remainingTemplates(PlanType plan, int currentTemplateCount) {
    if (isPremium(plan)) return proMaxTemplates;
    return (freeMaxTemplates - currentTemplateCount).clamp(0, freeMaxTemplates);
  }

  /// Check if extended calendar view is available
  static bool hasExtendedCalendar(PlanType plan) {
    return maxCalendarDays(plan) > freeMaxCalendarDays;
  }

  /// Check if drag & drop booking move in calendar is available
  static bool hasCalendarDragDrop(PlanType plan) {
    return isPremium(plan);
  }

  /// Check if iCal import/export is available
  static bool hasIcalSync(PlanType plan) {
    return isPremium(plan);
  }

  /// Check if cloud sync is available
  static bool hasCloudSync(PlanType plan) {
    return isPremium(plan);
  }

  /// Check if PDF export is available
  static bool hasPdfExport(PlanType plan) {
    return isPremium(plan);
  }

  /// Check if advanced reports are available
  static bool hasAdvancedReports(PlanType plan) {
    return isPremium(plan);
  }

  /// Check if guest documents are available
  static bool hasGuestDocuments(PlanType plan) {
    return isPremium(plan);
  }
}
