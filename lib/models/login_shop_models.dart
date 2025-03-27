

import 'dart:convert';

List<Loginshopmallmodels> loginshopmallmodelsFromJson(String str) => List<Loginshopmallmodels>.from(json.decode(str).map((x) => Loginshopmallmodels.fromJson(x)));

String loginshopmallmodelsToJson(List<Loginshopmallmodels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Loginshopmallmodels {
    final int? id;
    final DateTime? startdate;
    final DateTime? lastbilldate;
    final String? email;
    final String? password;
    final String? cname;
    final String? address;
    final String? billprintline1;
    final String? billprintline2;
    final String? billprintline3;
    final String? billprintline4;
    final String? billprintline5;
    final String? billprintlineTc1;
    final String? billprintlineTc2;
    final String? billprintlineTc3;
    final String? billprintlineTc4;
    final String? billprintlineTc5;
    final String? accountname;
    final String? accountno;
    final String? ifsc;
    final String? bankname;
    final String? branch;
    final String? saccode;
    final int? restservicechperc;
    final int? showbatchinpurchase;
    final int? otheritemprintname;
    final int? restdlvchperc;
    final int? cardsale;
    final int? userstatus;
    final int? cardsecurityamt;
    final DateTime? cardexpdate;
    final int? restdlvchamt;
    final String? gstno;
    final String? chmid;
    final String? chmuserapikey;
    final String? chmapikeyname;
    final String? chmhostname;
    final dynamic roomtypedescription;
    final int? chanelstatus;
    final int? autopaymenttakeaway;
    final int? showvatitemmaster;
    final int? pincode;
    final int? showtaxsummary;
    final int? gsttype;
    final int? mobno;
    final int? gst5;
    final int? deptcode;
    final int? takeawaypaycode;
    final int? rwcode;
    final int? fgcode;
    final int? wastagedeptcode;
    final int? hidetakeaway;
    final int? hidedelivery;
    final int? hidekot;
    final int? hideonline;
    final int? printlogo;
    final int? printkot;
    final int? printbill;
    final int? askprintkot;
    final int? gst12;
    final int? gst18;
    final int? gst28;
    final int? showcommissioncheckin;
    final int? changecheckoutdate;
    final int? printHidekotno;
    final int? fsKottype;
    final int? fsKotno;
    final int? fsCname;
    final int? itwashow;
    final int? hotelshopid;
    final int? roomshopid;
    final int? creditcardacc;
    final int? askqtyboxonsale;
    final int? roomserviceremarkshow;
    final int? showrestkds;
    final int? showhotelkds;
    final int? creditcardlimit;
    final int? taxondinein;
    final int? taxondelivery;
    final int? taxontakeaway;
    final int? taxononline;
    final int? printertype;
    final int? printertypesize;
    final String? printername;
    final int? dcotont;

    Loginshopmallmodels({
        this.id,
        this.startdate,
        this.lastbilldate,
        this.email,
        this.password,
        this.cname,
        this.address,
        this.billprintline1,
        this.billprintline2,
        this.billprintline3,
        this.billprintline4,
        this.billprintline5,
        this.billprintlineTc1,
        this.billprintlineTc2,
        this.billprintlineTc3,
        this.billprintlineTc4,
        this.billprintlineTc5,
        this.accountname,
        this.accountno,
        this.ifsc,
        this.bankname,
        this.branch,
        this.saccode,
        this.restservicechperc,
        this.showbatchinpurchase,
        this.otheritemprintname,
        this.restdlvchperc,
        this.cardsale,
        this.userstatus,
        this.cardsecurityamt,
        this.cardexpdate,
        this.restdlvchamt,
        this.gstno,
        this.chmid,
        this.chmuserapikey,
        this.chmapikeyname,
        this.chmhostname,
        this.roomtypedescription,
        this.chanelstatus,
        this.autopaymenttakeaway,
        this.showvatitemmaster,
        this.pincode,
        this.showtaxsummary,
        this.gsttype,
        this.mobno,
        this.gst5,
        this.deptcode,
        this.takeawaypaycode,
        this.rwcode,
        this.fgcode,
        this.wastagedeptcode,
        this.hidetakeaway,
        this.hidedelivery,
        this.hidekot,
        this.hideonline,
        this.printlogo,
        this.printkot,
        this.printbill,
        this.askprintkot,
        this.gst12,
        this.gst18,
        this.gst28,
        this.showcommissioncheckin,
        this.changecheckoutdate,
        this.printHidekotno,
        this.fsKottype,
        this.fsKotno,
        this.fsCname,
        this.itwashow,
        this.hotelshopid,
        this.roomshopid,
        this.creditcardacc,
        this.askqtyboxonsale,
        this.roomserviceremarkshow,
        this.showrestkds,
        this.showhotelkds,
        this.creditcardlimit,
        this.taxondinein,
        this.taxondelivery,
        this.taxontakeaway,
        this.taxononline,
        this.printertype,
        this.printertypesize,
        this.printername,
        this.dcotont,
    });

    factory Loginshopmallmodels.fromJson(Map<String, dynamic> json) => Loginshopmallmodels(
        id: json["id"],
        startdate: json["startdate"] == null ? null : DateTime.parse(json["startdate"]),
        lastbilldate: json["lastbilldate"] == null ? null : DateTime.parse(json["lastbilldate"]),
        email: json["email"],
        password: json["password"],
        cname: json["cname"],
        address: json["address"],
        billprintline1: json["billprintline1"],
        billprintline2: json["billprintline2"],
        billprintline3: json["billprintline3"],
        billprintline4: json["billprintline4"],
        billprintline5: json["billprintline5"],
        billprintlineTc1: json["billprintlineTC1"],
        billprintlineTc2: json["billprintlineTC2"],
        billprintlineTc3: json["billprintlineTC3"],
        billprintlineTc4: json["billprintlineTC4"],
        billprintlineTc5: json["billprintlineTC5"],
        accountname: json["accountname"],
        accountno: json["accountno"],
        ifsc: json["ifsc"],
        bankname: json["bankname"],
        branch: json["branch"],
        saccode: json["saccode"],
        restservicechperc: json["restservicechperc"],
        showbatchinpurchase: json["showbatchinpurchase"],
        otheritemprintname: json["otheritemprintname"],
        restdlvchperc: json["restdlvchperc"],
        cardsale: json["cardsale"],
        userstatus: json["userstatus"],
        cardsecurityamt: json["cardsecurityamt"],
        cardexpdate: json["cardexpdate"] == null ? null : DateTime.parse(json["cardexpdate"]),
        restdlvchamt: json["restdlvchamt"],
        gstno: json["gstno"],
        chmid: json["chmid"],
        chmuserapikey: json["chmuserapikey"],
        chmapikeyname: json["chmapikeyname"],
        chmhostname: json["chmhostname"],
        roomtypedescription: json["roomtypedescription"],
        chanelstatus: json["chanelstatus"],
        autopaymenttakeaway: json["autopaymenttakeaway"],
        showvatitemmaster: json["showvatitemmaster"],
        pincode: json["pincode"],
        showtaxsummary: json["showtaxsummary"],
        gsttype: json["gsttype"],
        mobno: json["mobno"],
        gst5: json["gst5"],
        deptcode: json["deptcode"],
        takeawaypaycode: json["takeawaypaycode"],
        rwcode: json["rwcode"],
        fgcode: json["fgcode"],
        wastagedeptcode: json["wastagedeptcode"],
        hidetakeaway: json["hidetakeaway"],
        hidedelivery: json["hidedelivery"],
        hidekot: json["hidekot"],
        hideonline: json["hideonline"],
        printlogo: json["printlogo"],
        printkot: json["printkot"],
        printbill: json["printbill"],
        askprintkot: json["askprintkot"],
        gst12: json["gst12"],
        gst18: json["gst18"],
        gst28: json["gst28"],
        showcommissioncheckin: json["showcommissioncheckin"],
        changecheckoutdate: json["changecheckoutdate"],
        printHidekotno: json["print_hidekotno"],
        fsKottype: json["fs_kottype"],
        fsKotno: json["fs_kotno"],
        fsCname: json["fs_cname"],
        itwashow: json["itwashow"],
        hotelshopid: json["hotelshopid"],
        roomshopid: json["roomshopid"],
        creditcardacc: json["creditcardacc"],
        askqtyboxonsale: json["askqtyboxonsale"],
        roomserviceremarkshow: json["roomserviceremarkshow"],
        showrestkds: json["showrestkds"],
        showhotelkds: json["showhotelkds"],
        creditcardlimit: json["creditcardlimit"],
        taxondinein: json["taxondinein"],
        taxondelivery: json["taxondelivery"],
        taxontakeaway: json["taxontakeaway"],
        taxononline: json["taxononline"],
        printertype: json["printertype"],
        printertypesize: json["printertypesize"],
        printername: json["printername"],
        dcotont: json["dcotont"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "startdate": startdate?.toIso8601String(),
        "lastbilldate": lastbilldate?.toIso8601String(),
        "email": email,
        "password": password,
        "cname": cname,
        "address": address,
        "billprintline1": billprintline1,
        "billprintline2": billprintline2,
        "billprintline3": billprintline3,
        "billprintline4": billprintline4,
        "billprintline5": billprintline5,
        "billprintlineTC1": billprintlineTc1,
        "billprintlineTC2": billprintlineTc2,
        "billprintlineTC3": billprintlineTc3,
        "billprintlineTC4": billprintlineTc4,
        "billprintlineTC5": billprintlineTc5,
        "accountname": accountname,
        "accountno": accountno,
        "ifsc": ifsc,
        "bankname": bankname,
        "branch": branch,
        "saccode": saccode,
        "restservicechperc": restservicechperc,
        "showbatchinpurchase": showbatchinpurchase,
        "otheritemprintname": otheritemprintname,
        "restdlvchperc": restdlvchperc,
        "cardsale": cardsale,
        "userstatus": userstatus,
        "cardsecurityamt": cardsecurityamt,
        "cardexpdate": cardexpdate?.toIso8601String(),
        "restdlvchamt": restdlvchamt,
        "gstno": gstno,
        "chmid": chmid,
        "chmuserapikey": chmuserapikey,
        "chmapikeyname": chmapikeyname,
        "chmhostname": chmhostname,
        "roomtypedescription": roomtypedescription,
        "chanelstatus": chanelstatus,
        "autopaymenttakeaway": autopaymenttakeaway,
        "showvatitemmaster": showvatitemmaster,
        "pincode": pincode,
        "showtaxsummary": showtaxsummary,
        "gsttype": gsttype,
        "mobno": mobno,
        "gst5": gst5,
        "deptcode": deptcode,
        "takeawaypaycode": takeawaypaycode,
        "rwcode": rwcode,
        "fgcode": fgcode,
        "wastagedeptcode": wastagedeptcode,
        "hidetakeaway": hidetakeaway,
        "hidedelivery": hidedelivery,
        "hidekot": hidekot,
        "hideonline": hideonline,
        "printlogo": printlogo,
        "printkot": printkot,
        "printbill": printbill,
        "askprintkot": askprintkot,
        "gst12": gst12,
        "gst18": gst18,
        "gst28": gst28,
        "showcommissioncheckin": showcommissioncheckin,
        "changecheckoutdate": changecheckoutdate,
        "print_hidekotno": printHidekotno,
        "fs_kottype": fsKottype,
        "fs_kotno": fsKotno,
        "fs_cname": fsCname,
        "itwashow": itwashow,
        "hotelshopid": hotelshopid,
        "roomshopid": roomshopid,
        "creditcardacc": creditcardacc,
        "askqtyboxonsale": askqtyboxonsale,
        "roomserviceremarkshow": roomserviceremarkshow,
        "showrestkds": showrestkds,
        "showhotelkds": showhotelkds,
        "creditcardlimit": creditcardlimit,
        "taxondinein": taxondinein,
        "taxondelivery": taxondelivery,
        "taxontakeaway": taxontakeaway,
        "taxononline": taxononline,
        "printertype": printertype,
        "printertypesize": printertypesize,
        "printername": printername,
        "dcotont": dcotont,
    };
}
