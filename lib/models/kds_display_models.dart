// To parse this JSON data, do
//
//     final kdsDisplayModel = kdsDisplayModelFromJson(jsonString);

import 'dart:convert';


    class KdsDisplayModel { 
    final Kot? kot;
    final String? statusName;
    final String? kottypeName;
    final String? kitchenName;
    final String? UnitName;

        KdsDisplayModel({
        this.kot,
        this.statusName,
        this.kottypeName,
        this.kitchenName,
        this.UnitName,
    });

    factory KdsDisplayModel.fromJson(Map<String, dynamic> json) => KdsDisplayModel(
        kot: json["kot"] == null ? null : Kot.fromJson(json["kot"]),
        statusName: json["statusName"]??"",
        kottypeName: json["kottypeName"]??"",
        kitchenName: json["kitchenName"],
        UnitName: json ["UnitName"]??"",
    );

    Map<String, dynamic> toJson() => {
        "kot": kot?.toJson(),
        "statusName": statusName,
        "kottypeName": kottypeName,
        "kitchenName": kitchenName,
        "UnitName": UnitName,
    };
}

    class Kot {
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
    final int? status;
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
    final dynamic havetopack;

    Kot({
        this.id,
        this.shopid,
        this.itemremarks,
        this.shopvno,
        this.kotdate,
        this.kottime,
        this.timeotp,
        this.kottype,
        this.rawcode,
        this.qty,
        this.status,
        this.blno,
        this.tablecode,
        this.tablename,
        this.itname,
        this.barcode,
        this.itemview,
        this.discperc,
        this.rate,
        this.vat,
        this.vatamt,
        this.gst,
        this.gstamt,
        this.ittotal,
        this.discamt,
        this.totqty,
        this.totgst,
        this.totdiscamt,
        this.roundoff,
        this.totordamt,
        this.cess,
        this.cessamt,
        this.kitchenmessage,
        this.isdiscountable,
        this.servicechperc,
        this.servicechamt,
        this.totalservicechamt,
        this.taxableamt,
        this.totaltaxableamt,
        this.wcode,
        this.wname,
        this.nop,
        this.bldiscperc,
        this.bldiscamt,
        this.itcomment,
        this.cancelreason,
        this.bldlvchperc,
        this.bldlvchamt,
        this.bldlvchamount,
        this.flatdiscount,
        this.kdsstatus,
        this.havetopack
    });

    factory Kot.fromJson(Map<String, dynamic> json) => Kot(
        id: json["id"],
        havetopack:json['havetopack'],
        shopid: json["shopid"],
        itemremarks: json["itemremarks"],
        shopvno: json["shopvno"],
        kotdate: json["kotdate"] == null ? null : DateTime.parse(json["kotdate"]),
        kottime: json["kottime"],
        timeotp: json["timeotp"],
        kottype: json["kottype"],
        rawcode: json["rawcode"],
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
        servicechamt: json["servicechamt"]?.toDouble(),
        totalservicechamt: json["totalservicechamt"]?.toDouble(),
        taxableamt: json["taxableamt"],
        totaltaxableamt: json["totaltaxableamt"],
        wcode: json["wcode"],
        wname:json["wname"]??"",
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
        "kotdate": "${kotdate!.year.toString().padLeft(4, '0')}-${kotdate!.month.toString().padLeft(2, '0')}-${kotdate!.day.toString().padLeft(2, '0')}",
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











