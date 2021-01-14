class DailyBonus {
  DailyBonus({
    this.userId,
    this.date,
    this.stamp,
    this.silver,
    this.gold,
    this.diamond,
    this.historySilver,
    this.historyGold,
    this.historyDiamond,
  });

  String userId;
  String date;
  String stamp;
  String silver;
  String gold;
  String diamond;
  String historySilver;
  String historyGold;
  String historyDiamond;

  factory DailyBonus.fromJson(Map<String, dynamic> json) => DailyBonus(
        userId: json["user_ID"].toString(),
        date: json["date"].toString(),
        stamp: json["stamp"].toString(),
        silver: json["silver"].toString(),
        gold: json["gold"].toString(),
        diamond: json["diamond"].toString(),
        historySilver: json["history_silver"].toString(),
        historyGold: json["history_gold"].toString(),
        historyDiamond: json["history_diamond"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "date": date,
        "stamp": stamp,
        "silver": silver,
        "gold": gold,
        "diamond": diamond,
        "history_silver": historySilver,
        "history_gold": historyGold,
        "history_diamond": historyDiamond,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
