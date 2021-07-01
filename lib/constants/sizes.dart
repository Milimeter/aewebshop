class WindowSizes {
  static List<double> small = [0.0, 640.0];
  static List<double> medium = [641.0, 980];
  static List<double> large = [981, 99999.0];
  static Sizes size(double width) {
    if (width >= small[0] && width <= small[1]) {
      return Sizes.Small;
    } else if (width >= medium[0] && width <= medium[1]) {
      return Sizes.Medium;
    } else {
      return Sizes.Large;
    }
  }
}

enum Sizes { Small, Medium, Large }
