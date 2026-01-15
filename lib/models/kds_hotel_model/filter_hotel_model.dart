import 'dart:convert';

List<FilterModelOfHotel> filterModelOfKdsFromJson(String str) =>
    List<FilterModelOfHotel>.from(
        json.decode(str).map((x) => FilterModelOfHotel.fromJson(x)));

String filterModelOfKdsToJson(List<FilterModelOfHotel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FilterModelOfHotel {
  //int roomnoview;
  //mofify int to dynamic
  dynamic roomnoview;

  List<Orders> orders;

  FilterModelOfHotel({
    required this.roomnoview,
    required this.orders,
  });

  factory FilterModelOfHotel.fromJson(Map<String, dynamic> json) =>
      FilterModelOfHotel(
        roomnoview: json["roomnoview"],
        orders:
            List<Orders>.from(json["orders"].map((x) => Orders.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "roomnoview": roomnoview,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Orders {
  KotDatas kot;
  String kitchenName;
  dynamic UnitName;

  Orders({
    required this.kot,
    required this.kitchenName,
    required this.UnitName,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        kot: KotDatas.fromJson(json["kot"]),
        kitchenName: json["kitchenName"],
        UnitName: json["UnitName"],
      );

  Map<String, dynamic> toJson() => {
        "kot": kot.toJson(),
        "kitchenName": kitchenName,
        "UnitName": UnitName,
      };
}

class KotDatas {
  final int? id;
  final int? chid;
  final int? rcode;
  final dynamic roomnoview;
  final DateTime? orddate;
  final String? ordtime;
  final int? deptcode;
  dynamic rawcode;
  final String? rawname;
  final String? serviceremarks;
  final String? barcode;
  dynamic qty;
  dynamic rate;
  dynamic gst;
  final int? billno;
  final double? gstamt;
  dynamic discperc;
  dynamic discamt;
  final double? roundoff;
  dynamic totdiscamt;
  final double? ittotal;
  dynamic totqty;
  dynamic totgst;
  dynamic totordamt;
  dynamic shopvno;
  //final int? shopvno;
  final String? guestname;
  final String? guestmob;
  final String? guestadd;
  final String? itemview;
  final int? shopid;
  final int? kdsstatus;
  bool isLoading;

  KotDatas(
      {required this.id,
      required this.chid,
      required this.rcode,
      required this.roomnoview,
      required this.orddate,
      required this.ordtime,
      required this.deptcode,
      required this.rawcode,
      required this.rawname,
      required this.serviceremarks,
      required this.barcode,
      required this.qty,
      required this.rate,
      required this.gst,
      required this.billno,
      required this.gstamt,
      required this.discperc,
      required this.discamt,
      required this.roundoff,
      required this.totdiscamt,
      required this.ittotal,
      required this.totqty,
      required this.totgst,
      required this.totordamt,
      required this.shopvno,
      required this.guestname,
      required this.guestmob,
      required this.guestadd,
      required this.itemview,
      required this.shopid,
      required this.kdsstatus,
      this.isLoading = false});

  factory KotDatas.fromRawJson(String str) =>
      KotDatas.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory KotDatas.fromJson(Map<String, dynamic> json) => KotDatas(
        id: json["id"],
        chid: json["chid"],
        rcode: json["rcode"],
        roomnoview: json["roomnoview"],
        orddate: DateTime.parse(json["orddate"]),
        ordtime: json["ordtime"],
        deptcode: json["deptcode"],
        rawcode: json["rawcode"],
        rawname: json["rawname"],
        serviceremarks: json["serviceremarks"],
        barcode: json["barcode"],
        qty: json["qty"],
        rate: json["rate"],
        gst: json["gst"],
        billno: json["billno"],
        gstamt: json["gstamt"]?.toDouble(),
        discperc: json["discperc"],
        discamt: json["discamt"],
        roundoff: json["roundoff"]?.toDouble(),
        totdiscamt: json["totdiscamt"],
        ittotal: json["ittotal"]?.toDouble(),
        totqty: json["totqty"],
        totgst: json["totgst"]?.toDouble(),
        totordamt: json["totordamt"],
        shopvno: json["shopvno"],
        guestname: json["guestname"],
        guestmob: json["guestmob"],
        guestadd: json["guestadd"],
        itemview: json["itemview"],
        shopid: json["shopid"],
        kdsstatus: json["kdsstatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chid": chid,
        "rcode": rcode,
        "roomnoview": roomnoview,
        "orddate":
            "${orddate!.year.toString().padLeft(4, '0')}-${orddate!.month.toString().padLeft(2, '0')}-${orddate!.day.toString().padLeft(2, '0')}",
        "ordtime": ordtime,
        "deptcode": deptcode,
        "rawcode": rawcode,
        "rawname": rawname,
        "serviceremarks": serviceremarks,
        "barcode": barcode,
        "qty": qty,
        "rate": rate,
        "gst": gst,
        "billno": billno,
        "gstamt": gstamt,
        "discperc": discperc,
        "discamt": discamt,
        "roundoff": roundoff,
        "totdiscamt": totdiscamt,
        "ittotal": ittotal,
        "totqty": totqty,
        "totgst": totgst,
        "totordamt": totordamt,
        "shopvno": shopvno,
        "guestname": guestname,
        "guestmob": guestmob,
        "guestadd": guestadd,
        "itemview": itemview,
        "shopid": shopid,
        "kdsstatus": kdsstatus,
      };
}
