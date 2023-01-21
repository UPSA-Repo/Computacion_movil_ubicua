class Utils {
  static String GetSentiment(double pos, double neu, double neg) {
    if (pos > neu && pos > neg) {
      return 'Positivo';
    }

    if (neu > pos && neu > neg) {
      return 'Neutro';
    }

    return 'Negativo';
  }
}
