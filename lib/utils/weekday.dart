String weekDayStr(weekday) {
  if (weekday is int) {
    return weekDayStrFromInt(weekday);
  } else if (weekday is DateTime) {
    return weekDayStrFromDateTime(weekday);
  } else {
    return "Error";
  }
}

String weekDayStrFromInt(int weekday) {
  switch (weekday) {
    case 1:
      return "Lunes";
    case 2:
      return "Martes";
    case 3:
      return "Miércoles";
    case 4:
      return "Jueves";
    case 5:
      return "Viernes";
    case 6:
      return "Sábado";
    case 7:
      return "Domingo";
    default:
      return "Error";
  }
}

String weekDayStrFromDateTime(DateTime time) {
  return weekDayStrFromInt(time.weekday);
}
