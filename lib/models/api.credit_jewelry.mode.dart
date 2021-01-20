class CreditJewelry {
  CreditJewelry({
    this.userId,
    this.diamond,
    this.gold,
    this.silver,
  });

  String userId;
  String diamond;
  String gold;
  String silver;

  factory CreditJewelry.fromJson(Map<String, dynamic> json) => CreditJewelry(
        userId: json["user_ID"],
        diamond: json["diamond"],
        gold: json["gold"],
        silver: json["silver"],
      );

  Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "diamond": diamond,
        "gold": gold,
        "silver": silver,
      };
}
