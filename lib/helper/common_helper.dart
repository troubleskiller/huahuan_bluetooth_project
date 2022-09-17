class CommonHelper {
  static int getHoleCount(double? width, double? top, double? side) {
    if (width == null || top == null || side == null) return 0;
    if (side == 0) return 1;
    num a = (width - top) / side;
    if (a < 1) return 1;
    return a.toInt() + 1;
  }

  static double convertMeasure(double x, double fx, int isDouble) {
    if (isDouble == 1) {
      return x;
    }
    return (x - fx) / 2;
  }

  static List<double> toAdd(List<double> list) {
    List<double> a = list.reversed.toList();
    for (int i = 1; i < a.length; i++) {
      a[i] = a[i] + a[i - 1];
      // print(a[i]);
    }
    return a.reversed.toList();
  }

  static double toInt(double x) {
    if (x >= 8.4) {
      return 100;
    } else if (x >= 8.3) {
      return 99;
    } else if (x >= 8.28) {
      return 97;
    } else if (x >= 8.24) {
      return 95;
    } else if (x >= 8.2) {
      return 92;
    } else if (x >= 8.16) {
      return 90;
    } else if (x >= 8.1) {
      return 87;
    } else if (x >= 8.06) {
      return 85;
    } else if (x >= 7.94) {
      return 80;
    } else if (x >= 7.86) {
      return 75;
    } else if (x >= 7.8) {
      return 70;
    } else if (x >= 7.74) {
      return 65;
    } else if (x >= 7.68) {
      return 60;
    } else if (x >= 7.62) {
      return 55;
    } else if (x >= 7.58) {
      return 50;
    } else if (x >= 7.54) {
      return 45;
    } else if (x >= 7.52) {
      return 42;
    } else if (x >= 7.5) {
      return 40;
    } else if (x >= 7.48) {
      return 35;
    } else if (x >= 7.46) {
      return 30;
    } else if (x >= 7.44) {
      return 25;
    } else if (x >= 7.42) {
      return 20;
    } else if (x >= 7.38) {
      return 15;
    } else if (x >= 7.32) {
      return 12;
    } else if (x >= 7.3) {
      return 10;
    } else if (x >= 7.28) {
      return 8;
    } else if (x >= 7.26) {
      return 5;
    } else if (x >= 7.22) {
      return 3;
    } else if (x >= 7.18) {
      return 1;
    } else if (x >= 7.16) {
      return 0;
    } else {
      return 0;
    }
  }
}
