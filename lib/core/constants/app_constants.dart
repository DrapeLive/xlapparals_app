class AppConstants {
  AppConstants._();

  static const String appName = "XL Apparals";
  static const double borderRadius = 12;

  static const Map<dynamic, dynamic> pieceCount = {
    "gents": {"M,L,XL": 3, "M,L,XL,XXL": 4, "S,M,L,XL": 4, "S,M,L,XL,XXL": 5},
    "kids": {
      "20-38": 10,
      "20-36": 9,
      "26-38": 7,
      "20-30": 6,
      "26-36": 6,
      "32-38": 4,
      "32-36": 3,
      "20-24": 3,
    },
  };

  static const Map<String, List<String>> orderCreationSizesByType = {
    "gents": ["S,M,L,XL,XXL", "S,M,L,XL", "M,L,XL,XXL", "M,L,XL"],
    "kids": [
      "20-24",
      "20-36",
      "20-30",
      "26-36",
      "32-36",
      "20-38",
      "26-38",
      "32-38",
    ],
  };

  static const Map<String, Map<String, List<String>>> sizeMapping = {
    "kids": {
      "20-24": ["20-24"],
      "20-38": ["20-24", "26-30", "32-36", "38"],
      "20-36": ["20-24", "26-30", "32-36"],
      "26-38": ["26-30", "32-36", "38"],
      "26-36": ["26-30", "32-36"],
      "20-30": ["20-24", "26-30"],
      "32-38": ["32-36", "38"],
      "32-36": ["32-36"],
      "38": ["38"],
    },
    "gents": {
      "S,M,L,XL": ["S", "M,L,XL"],
      "S,M,L,XL,XXL": ["S", "M,L,XL", "XXL"],
      "M,L,XL,XXL": ["M,L,XL", "XXL"],
      "M,L,XL": ["M,L,XL"],
    },
  };

  static const Map<String, Map<List<String>, String>> reverseSizeMapping = {
    "kids": {
      ["20-24"]: "20-24",
      ["20-24", "26-30", "32-36", "38"]: "20-38",
      ["20-24", "26-30", "32-36"]: "20-36",
      ["26-30", "32-36", "38"]: "26-38",
      ["26-30", "32-36"]: "26-36",
      ["20-24", "26-30"]: "20-30",
      ["32-36", "38"]: "32-38",
      ["32-36"]: "32-36",
    },
    "gents": {
      ["S", "M,L,XL"]: "S,M,L,XL",
      ["S", "M,L,XL", "XXL"]: "S,M,L,XL,XXL",
      ["M,L,XL", "XXL"]: "M,L,XL,XXL",
      ["M,L,XL"]: "M,L,XL",
    },
  };

  static const Map<String, List<String>> sizeRangeToSizes = {
    "20-38": ["20-24", "26-30", "32-36", "38"],
    "20-36": ["20-24", "26-30", "32-36"],
    "26-38": ["26-30", "32-36", "38"],
    "26-36": ["26-30", "32-36"],
    "20-30": ["20-24", "26-30"],
    "32-38": ["32-36", "38"],
    "20-24": ["20-24"],
    "32-36": ["32-36"],
    "38": ["38"],
    "S,M,L,XL": ["S", "M,L,XL"],
    "M,L,XL,XXL": ["M,L,XL", "XXL"],
    "S,M,L,XL,XXL": ["S", "M,L,XL", "XXL"],
    "M,L,XL": ["M,L,XL"],
  };
}
