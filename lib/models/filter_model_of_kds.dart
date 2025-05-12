// To parse this JSON data, do
//
//     final filterModelOfKds = filterModelOfKdsFromJson(jsonString);


import 'dart:convert';
List<FilterModelOfKds> filterModelOfKdsFromJson(String str) => List<FilterModelOfKds>.from(json.decode(str).map((x) => FilterModelOfKds.fromJson(x)));

String filterModelOfKdsToJson(List<FilterModelOfKds> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson()))); 

class FilterModelOfKds {
  int shopvno;
  List<Order> orders;

  FilterModelOfKds({
    required this.shopvno,
    required this.orders,
  });

  factory FilterModelOfKds.fromJson(Map<String, dynamic> json) => FilterModelOfKds(
    shopvno: json["shopvno"], 
    orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "shopvno": shopvno,
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
  };
  }


class Order {
  KotData kot;
  String statusName;
  String kottypeName;
  String kitchenName;
  String? UnitName;


  Order({
    required this.kot,
    required this.statusName,
    required this.kottypeName,
    required this.kitchenName,
    required this.UnitName,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    kot: KotData.fromJson(json["kot"]),
    statusName: json["statusName"],
    kottypeName: json["kottypeName"],
    kitchenName: json["kitchenName"],
    UnitName:json["UnitName"],
  );

  Map<String, dynamic> toJson() => {
    "kot": kot.toJson(),
    "statusName": statusName,
    "kottypeName": kottypeName,
    "kitchenName": kitchenName,
    "UnitName":UnitName,
  };
}



class KotData {
  final int? id;
  final int? shopid;
  final dynamic itemremarks;
  final int? shopvno;
  final DateTime? kotdate;
  final String? kottime;
  final String? timeotp;
  final int? kottype;
  final int? rawcode;
  final double? qty;
  final dynamic status;
  final int? blno;
  final int? tablecode;
  final String? tablename;
  final String? itname;
  final String? barcode;
  final dynamic itemview;
  final dynamic discperc;
  final dynamic rate;
  final dynamic vat;
  final dynamic vatamt;
  final dynamic gst;
  final double? gstamt;
  final double? ittotal;
  final dynamic discamt;
  final dynamic totqty;
  final dynamic totgst;
  final dynamic totdiscamt;
  final dynamic roundoff;
  final dynamic totordamt;
  final dynamic cess;
  final dynamic cessamt;
  final String? kitchenmessage;
  final dynamic isdiscountable;
  final dynamic servicechperc;
  final double? servicechamt;
  final double? totalservicechamt;
  final dynamic taxableamt;
  final dynamic totaltaxableamt;
  final dynamic wcode;
  final String? wname;
  final dynamic nop;
  final dynamic bldiscperc;
  final dynamic bldiscamt;
  final String? itcomment;
  final dynamic cancelreason;
  final dynamic bldlvchperc;
  final dynamic bldlvchamt;
  final dynamic bldlvchamount;
  final dynamic flatdiscount;
  final dynamic kdsstatus;
  bool isLoading;
  final dynamic havetopack;


  KotData({
    required this.havetopack,
    required this.id,
    required this.shopid,
    required this.itemremarks,
    required this.shopvno,
    required this.kotdate,
    required this.kottime,
    required this.timeotp,
    required this.kottype,
    required this.rawcode,
    required this.qty,
    required this.status,
    required this.blno,
    required this.tablecode,
    required this.tablename,
    required this.itname,
    required this.barcode,
    required this.itemview,
    required this.discperc,
    required this.rate,
    required this.vat,
    required this.vatamt,
    required this.gst,
    required this.gstamt,
    required this.ittotal,
    required this.discamt,
    required this.totqty,
    required this.totgst,
    required this.totdiscamt,
    required this.roundoff,
    required this.totordamt,
    required this.cess,
    required this.cessamt,
    required this.kitchenmessage,
    required this.isdiscountable,
    required this.servicechperc,
    required this.servicechamt,
    required this.totalservicechamt,
    required this.taxableamt,
    required this.totaltaxableamt,
    required this.wcode,
    required this.wname,
    required this.nop,
    required this.bldiscperc,
    required this.bldiscamt,
    required this.itcomment,
    required this.cancelreason,
    required this.bldlvchperc,
    required this.bldlvchamt,
    required this.bldlvchamount,
    required this.flatdiscount,
    required this.kdsstatus,
    this.isLoading = false

    //    final dynamic havetopack;

  });

  factory KotData.fromJson(Map<String, dynamic> json) => KotData(
    id: json["id"],
    shopid: json["shopid"],
    itemremarks: json["itemremarks"],
    shopvno: json["shopvno"],
    kotdate: DateTime.parse(json["kotdate"]),
    kottime: json["kottime"],
    timeotp: json["timeotp"],
    kottype: json["kottype"],
    rawcode: json["rawcode"],
    havetopack:json['havetopack'],
    qty: json["qty"],
    status: json["status"],
    blno: json["blno"],
    tablecode: json["tablecode"],
    tablename: json["tablename"],
    itname: json["itname"],
    barcode: json["barcode"],
    itemview: json["itemview"],
    discperc: json["discperc"],
    rate: json["rate"],
    vat: json["vat"],
    vatamt: json["vatamt"],
    gst: json["gst"],
    gstamt: json["gstamt"]?.toDouble(),
    ittotal: json["ittotal"]?.toDouble(),
    discamt: json["discamt"],
    totqty: json["totqty"],
    totgst: json["totgst"]?.toDouble(),
    totdiscamt: json["totdiscamt"],
    roundoff: json["roundoff"],
    totordamt: json["totordamt"],
    cess: json["cess"],
    cessamt: json["cessamt"],
    kitchenmessage: json["kitchenmessage"],
    isdiscountable: json["isdiscountable"],
    servicechperc: json["servicechperc"],
    servicechamt: json["servicechamt"],
    totalservicechamt: json["totalservicechamt"],
    taxableamt: json["taxableamt"],
    totaltaxableamt: json["totaltaxableamt"],
    wcode: json["wcode"],
    wname: json["wname"],
    nop: json["nop"],
    bldiscperc: json["bldiscperc"],
    bldiscamt: json["bldiscamt"],
    itcomment: json["itcomment"],
    cancelreason: json["cancelreason"],
    bldlvchperc: json["bldlvchperc"],
    bldlvchamt: json["bldlvchamt"],
    bldlvchamount: json["bldlvchamount"],
    flatdiscount: json["flatdiscount"],
    kdsstatus: json["kdsstatus"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "shopid": shopid,
    "itemremarks": itemremarks,
    "shopvno": shopvno,
    "kotdate": "${kotdate?.year.toString().padLeft(4, '0')}-${kotdate?.month.toString().padLeft(2, '0')}-${kotdate?.day.toString().padLeft(2, '0')}",
    "kottime": kottime,
    "timeotp": timeotp,
    "kottype": kottype,
    "rawcode": rawcode,
    "qty": qty,
    "status": status,
    "blno": blno,
    "tablecode": tablecode,
    "tablename": tablename,
    "itname": itname,
    "barcode": barcode,
    "itemview": itemview,
    "discperc": discperc,
    "rate": rate,
    "vat": vat,
    "vatamt": vatamt,
    "gst": gst,
    "gstamt": gstamt,
    "ittotal": ittotal,
    "discamt": discamt,
    "totqty": totqty,
    "totgst": totgst,
    "totdiscamt": totdiscamt,
    "roundoff": roundoff,
    "totordamt": totordamt,
    "cess": cess,
    "cessamt": cessamt,
    "kitchenmessage": kitchenmessage,
    "isdiscountable": isdiscountable,
    "servicechperc": servicechperc,
    "servicechamt": servicechamt,
    "totalservicechamt": totalservicechamt,
    "taxableamt": taxableamt,
    "totaltaxableamt": totaltaxableamt,
    "wcode": wcode,
    "wname": wname,
    "nop": nop,
    "bldiscperc": bldiscperc,
    "bldiscamt": bldiscamt,
    "itcomment": itcomment,
    "cancelreason": cancelreason,
    "bldlvchperc": bldlvchperc,
    "bldlvchamt": bldlvchamt,
    "bldlvchamount": bldlvchamount,
    "flatdiscount": flatdiscount,
    "kdsstatus": kdsstatus,
  };
}



    

  










