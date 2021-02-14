int computeAmountGridView(double width, {int max, int factor}) {
  final avaiableAmount = width.toInt() ~/ (factor ?? 140);
  if (max != null && avaiableAmount > max) return max;
  return avaiableAmount;
}
