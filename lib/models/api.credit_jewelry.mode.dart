import 'dart:convert';

String apiCreditJewelryToJson(ApiCreditJewelry data) => json.encode(data.toJson());

class ApiCreditJewelry {
  ApiCreditJewelry({
    this.userId,
    this.diamond,
    this.gold,
    this.silver,
  });

  String userId;
  String diamond;
  String gold;
  String silver;

  factory ApiCreditJewelry.fromJson(Map<String, dynamic> json) => ApiCreditJewelry(
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
