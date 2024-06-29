String getRemainingTime(DateTime? startTime) {
  if (startTime == null) return '';
  final now = DateTime.now();
  final difference = const Duration(minutes: 60) - now.difference(startTime);
  if (difference.isNegative) return 'Zeit abgelaufen';
  return '${difference.inMinutes}:${(difference.inSeconds % 60).toString().padLeft(2, '0')}';
}