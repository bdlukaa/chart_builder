int computeAmountGridView(double width, {int max, int factor, int min}) {
  final avaiableAmount = width.toInt() ~/ (factor ?? 140);
  if (min != null && min > avaiableAmount) return min;
  if (max != null && avaiableAmount > max) return max;
  return avaiableAmount;
}
