class Message {
  final String id;
  final String text;
  final String? sentiment;
  final double? positive;
  final double? neutral;
  final double? negative;
  final int? idDataset;

  Message({
    required this.id,
    required this.text,
    this.sentiment,
    this.positive,
    this.neutral,
    this.negative,
    this.idDataset,
  });

  Message.empty({
    this.id = '',
    this.text = '',
    this.sentiment,
    this.positive,
    this.neutral,
    this.negative,
    this.idDataset,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    if (json['positivePercentage'].runtimeType == int) {
      json['positivePercentage'] = json['positivePercentage'].toDouble();
    }

    if (json['neutralPercentage'].runtimeType == int) {
      json['neutralPercentage'] = json['neutralPercentage'].toDouble();
    }

    if (json['negativePercentage'].runtimeType == int) {
      json['negativePercentage'] = json['negativePercentage'].toDouble();
    }

    return Message(
      id: json['id'],
      text: json['messageContent'],
      sentiment: json['messageSentiment'],
      positive: json['positivePercentage'],
      neutral: json['neutralPercentage'],
      negative: json['negativePercentage'],
      idDataset: json['idDataset'],
    );
  }
}
