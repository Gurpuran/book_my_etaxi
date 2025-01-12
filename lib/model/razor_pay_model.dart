class RazorpayOrderResponse {
  String? id;
  String? entity;
  int? amount;
  int? amountPaid;
  int? amountDue;
  String? currency;
  String? receipt;
  String? offerId;
  String? status;
  int? attempts;
  int? createdAt;

  RazorpayOrderResponse({
    this.id,
    this.entity,
    this.amount,
    this.amountPaid,
    this.amountDue,
    this.currency,
    this.receipt,
    this.offerId,
    this.status,
    this.attempts,
    this.createdAt,
  });

  RazorpayOrderResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    entity = json["entity"]?.toString();
    amount = json["amount"]?.toInt();
    amountPaid = json["amount_paid"]?.toInt();
    amountDue = json["amount_due"]?.toInt();
    currency = json["currency"]?.toString();
    receipt = json["receipt"]?.toString();
    offerId = json["offer_id"]?.toString();
    status = json["status"]?.toString();
    attempts = json["attempts"]?.toInt();
    createdAt = json["created_at"]?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["entity"] = entity;
    data["amount"] = amount;
    data["amount_paid"] = amountPaid;
    data["amount_due"] = amountDue;
    data["currency"] = currency;
    data["receipt"] = receipt;
    data["offer_id"] = offerId;
    data["status"] = status;
    data["attempts"] = attempts;
    data["created_at"] = createdAt;
    return data;
  }
}
