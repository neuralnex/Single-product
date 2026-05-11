String formatNgn(int naira) {
  final negative = naira < 0;
  final digits = naira.abs().toString();
  final reversed = digits.split('').reversed.join();
  final buf = StringBuffer();
  for (var i = 0; i < reversed.length; i++) {
    if (i != 0 && i % 3 == 0) buf.write(',');
    buf.write(reversed[i]);
  }
  final formatted = buf.toString().split('').reversed.join();
  return '${negative ? '-' : ''}₦$formatted';
}
