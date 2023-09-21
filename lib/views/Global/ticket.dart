class Ticket {
  final String firstName;
  final String middleName;
  final String lastName;
  final bool checkInStatus;
  final int bagQuantity;
  final String mealType;
  final double ticketPrice;
  final String ticketUserId;
  final DateTime birthDate;
  final String flightReference;
  final String ticketClass;

  Ticket(
      {required this.firstName,
      required this.middleName,
      required this.checkInStatus,
      required this.bagQuantity,
      required this.mealType,
      required this.lastName,
      required this.ticketPrice,
      required this.ticketUserId,
      required this.birthDate,
      required this.flightReference,
      required this.ticketClass});
}
