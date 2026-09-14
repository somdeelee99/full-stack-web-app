class ChartPoint {
  final double x;
  final double y;
  final String? label; // ສຳລັບແສງປ້າຍຊື່ເທິງ graph

  ChartPoint({required this.x, required this.y, this.label});

  factory ChartPoint.fromJson(Map<String, dynamic> json) {
    return ChartPoint(
      x: (json['x'] ?? 0).toDouble(),
      y: (json['y'] ?? 0).toDouble(),
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y, 'label': label};
  }
}
