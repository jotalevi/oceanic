String formatDuration(int durationMinutes) {
  if (durationMinutes == 0) {
    return '0 min';
  }

  if (durationMinutes < 60) {
    return '$durationMinutes min';
  }

  if (durationMinutes % 60 == 0) {
    return '${durationMinutes ~/ 60} ${(durationMinutes / 60) == 1 ? 'hr' : 'hrs'}';
  }

  return '${int.parse((durationMinutes / 60).toString().split('.')[0])}h ${durationMinutes % 60}m';
}
