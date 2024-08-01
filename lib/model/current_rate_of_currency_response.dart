class CurrentRateOfCurrencyResponse {
  String? result;
  String? documentation;
  String? termsOfUse;
  int? timeLastUpdateUnix;
  String? timeLastUpdateUtc;
  int? timeNextUpdateUnix;
  String? timeNextUpdateUtc;
  String? baseCode;
  ConversionRates? conversionRates;

  CurrentRateOfCurrencyResponse(
      {this.result,
        this.documentation,
        this.termsOfUse,
        this.timeLastUpdateUnix,
        this.timeLastUpdateUtc,
        this.timeNextUpdateUnix,
        this.timeNextUpdateUtc,
        this.baseCode,
        this.conversionRates});

  CurrentRateOfCurrencyResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    documentation = json['documentation'];
    termsOfUse = json['terms_of_use'];
    timeLastUpdateUnix = json['time_last_update_unix'];
    timeLastUpdateUtc = json['time_last_update_utc'];
    timeNextUpdateUnix = json['time_next_update_unix'];
    timeNextUpdateUtc = json['time_next_update_utc'];
    baseCode = json['base_code'];
    conversionRates = json['conversion_rates'] != null
        ? new ConversionRates.fromJson(json['conversion_rates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['documentation'] = this.documentation;
    data['terms_of_use'] = this.termsOfUse;
    data['time_last_update_unix'] = this.timeLastUpdateUnix;
    data['time_last_update_utc'] = this.timeLastUpdateUtc;
    data['time_next_update_unix'] = this.timeNextUpdateUnix;
    data['time_next_update_utc'] = this.timeNextUpdateUtc;
    data['base_code'] = this.baseCode;
    if (this.conversionRates != null) {
      data['conversion_rates'] = this.conversionRates!.toJson();
    }
    return data;
  }
}

class ConversionRates {
  String? uSD;
  String? aED;
  String? aFN;
  String? aLL;
  String? aMD;
  String? aNG;
  String? aOA;
  String? aRS;
  String? aUD;
  String? aWG;
  String? aZN;
  String? bAM;
  String? bBD;
  String? bDT;
  String? bGN;
  String? bHD;
  String? bIF;
  String? bMD;
  String? bND;
  String? bOB;
  String? bRL;
  String? bSD;
  String? bTN;
  String? bWP;
  String? bYN;
  String? bZD;
  String? cAD;
  String? cDF;
  String? cHF;
  String? cLP;
  String? cNY;
  String? cOP;
  String? cRC;
  String? cUP;
  String? cVE;
  String? cZK;
  String? dJF;
  String? dKK;
  String? dOP;
  String? dZD;
  String? eGP;
  String? eRN;
  String? eTB;
  String? eUR;
  String? fJD;
  String? fKP;
  String? fOK;
  String? gBP;
  String? gEL;
  String? gGP;
  String? gHS;
  String? gIP;
  String? gMD;
  String? gNF;
  String? gTQ;
  String? gYD;
  String? hKD;
  String? hNL;
  String? hRK;
  String? hTG;
  String? hUF;
  String? iDR;
  String? iLS;
  String? iMP;
  String? iNR;
  String? iQD;
  String? iRR;
  String? iSK;
  String? jEP;
  String? jMD;
  String? jOD;
  String? jPY;
  String? kES;
  String? kGS;
  String? kHR;
  String? kID;
  String? kMF;
  String? kRW;
  String? kWD;
  String? kYD;
  String? kZT;
  String? lAK;
  String? lBP;
  String? lKR;
  String? lRD;
  String? lSL;
  String? lYD;
  String? mAD;
  String? mDL;
  String? mGA;
  String? mKD;
  String? mMK;
  String? mNT;
  String? mOP;
  String? mRU;
  String? mUR;
  String? mVR;
  String? mWK;
  String? mXN;
  String? mYR;
  String? mZN;
  String? nAD;
  String? nGN;
  String? nIO;
  String? nOK;
  String? nPR;
  String? nZD;
  String? oMR;
  String? pAB;
  String? pEN;
  String? pGK;
  String? pHP;
  String? pKR;
  String? pLN;
  String? pYG;
  String? qAR;
  String? rON;
  String? rSD;
  String? rUB;
  String? rWF;
  String? sAR;
  String? sBD;
  String? sCR;
  String? sDG;
  String? sEK;
  String? sGD;
  String? sHP;
  String? sLE;
  String? sLL;
  String? sOS;
  String? sRD;
  String? sSP;
  String? sTN;
  String? sYP;
  String? sZL;
  String? tHB;
  String? tJS;
  String? tMT;
  String? tND;
  String? tOP;
  String? tRY;
  String? tTD;
  String? tVD;
  String? tWD;
  String? tZS;
  String? uAH;
  String? uGX;
  String? uYU;
  String? uZS;
  String? vES;
  String? vND;
  String? vUV;
  String? wST;
  String? xAF;
  String? xCD;
  String? xDR;
  String? xOF;
  String? xPF;
  String? yER;
  String? zAR;
  String? zMW;
  String? zWL;

  ConversionRates(
      {this.uSD,
        this.aED,
        this.aFN,
        this.aLL,
        this.aMD,
        this.aNG,
        this.aOA,
        this.aRS,
        this.aUD,
        this.aWG,
        this.aZN,
        this.bAM,
        this.bBD,
        this.bDT,
        this.bGN,
        this.bHD,
        this.bIF,
        this.bMD,
        this.bND,
        this.bOB,
        this.bRL,
        this.bSD,
        this.bTN,
        this.bWP,
        this.bYN,
        this.bZD,
        this.cAD,
        this.cDF,
        this.cHF,
        this.cLP,
        this.cNY,
        this.cOP,
        this.cRC,
        this.cUP,
        this.cVE,
        this.cZK,
        this.dJF,
        this.dKK,
        this.dOP,
        this.dZD,
        this.eGP,
        this.eRN,
        this.eTB,
        this.eUR,
        this.fJD,
        this.fKP,
        this.fOK,
        this.gBP,
        this.gEL,
        this.gGP,
        this.gHS,
        this.gIP,
        this.gMD,
        this.gNF,
        this.gTQ,
        this.gYD,
        this.hKD,
        this.hNL,
        this.hRK,
        this.hTG,
        this.hUF,
        this.iDR,
        this.iLS,
        this.iMP,
        this.iNR,
        this.iQD,
        this.iRR,
        this.iSK,
        this.jEP,
        this.jMD,
        this.jOD,
        this.jPY,
        this.kES,
        this.kGS,
        this.kHR,
        this.kID,
        this.kMF,
        this.kRW,
        this.kWD,
        this.kYD,
        this.kZT,
        this.lAK,
        this.lBP,
        this.lKR,
        this.lRD,
        this.lSL,
        this.lYD,
        this.mAD,
        this.mDL,
        this.mGA,
        this.mKD,
        this.mMK,
        this.mNT,
        this.mOP,
        this.mRU,
        this.mUR,
        this.mVR,
        this.mWK,
        this.mXN,
        this.mYR,
        this.mZN,
        this.nAD,
        this.nGN,
        this.nIO,
        this.nOK,
        this.nPR,
        this.nZD,
        this.oMR,
        this.pAB,
        this.pEN,
        this.pGK,
        this.pHP,
        this.pKR,
        this.pLN,
        this.pYG,
        this.qAR,
        this.rON,
        this.rSD,
        this.rUB,
        this.rWF,
        this.sAR,
        this.sBD,
        this.sCR,
        this.sDG,
        this.sEK,
        this.sGD,
        this.sHP,
        this.sLE,
        this.sLL,
        this.sOS,
        this.sRD,
        this.sSP,
        this.sTN,
        this.sYP,
        this.sZL,
        this.tHB,
        this.tJS,
        this.tMT,
        this.tND,
        this.tOP,
        this.tRY,
        this.tTD,
        this.tVD,
        this.tWD,
        this.tZS,
        this.uAH,
        this.uGX,
        this.uYU,
        this.uZS,
        this.vES,
        this.vND,
        this.vUV,
        this.wST,
        this.xAF,
        this.xCD,
        this.xDR,
        this.xOF,
        this.xPF,
        this.yER,
        this.zAR,
        this.zMW,
        this.zWL});

  ConversionRates.fromJson(Map<String, dynamic> json) {
    uSD = json['USD'].toString();
    aED = json['AED'].toString();
    aFN = json['AFN'].toString();
    aLL = json['ALL'].toString();
    aMD = json['AMD'].toString();
    aNG = json['ANG'].toString();
    aOA = json['AOA'].toString();
    aRS = json['ARS'].toString();
    aUD = json['AUD'].toString();
    aWG = json['AWG'].toString();
    aZN = json['AZN'].toString();
    bAM = json['BAM'].toString();
    bBD = json['BBD'].toString();
    bDT = json['BDT'].toString();
    bGN = json['BGN'].toString();
    bHD = json['BHD'].toString();
    bIF = json['BIF'].toString();
    bMD = json['BMD'].toString();
    bND = json['BND'].toString();
    bOB = json['BOB'].toString();
    bRL = json['BRL'].toString();
    bSD = json['BSD'].toString();
    bTN = json['BTN'].toString();
    bWP = json['BWP'].toString();
    bYN = json['BYN'].toString();
    bZD = json['BZD'].toString();
    cAD = json['CAD'].toString();
    cDF = json['CDF'].toString();
    cHF = json['CHF'].toString();
    cLP = json['CLP'].toString();
    cNY = json['CNY'].toString();
    cOP = json['COP'].toString();
    cRC = json['CRC'].toString();
    cUP = json['CUP'].toString();
    cVE = json['CVE'].toString();
    cZK = json['CZK'].toString();
    dJF = json['DJF'].toString();
    dKK = json['DKK'].toString();
    dOP = json['DOP'].toString();
    dZD = json['DZD'].toString();
    eGP = json['EGP'].toString();
    eRN = json['ERN'].toString();
    eTB = json['ETB'].toString();
    eUR = json['EUR'].toString();
    fJD = json['FJD'].toString();
    fKP = json['FKP'].toString();
    fOK = json['FOK'].toString();
    gBP = json['GBP'].toString();
    gEL = json['GEL'].toString();
    gGP = json['GGP'].toString();
    gHS = json['GHS'].toString();
    gIP = json['GIP'].toString();
    gMD = json['GMD'].toString();
    gNF = json['GNF'].toString();
    gTQ = json['GTQ'].toString();
    gYD = json['GYD'].toString();
    hKD = json['HKD'].toString();
    hNL = json['HNL'].toString();
    hRK = json['HRK'].toString();
    hTG = json['HTG'].toString();
    hUF = json['HUF'].toString();
    iDR = json['IDR'].toString();
    iLS = json['ILS'].toString();
    iMP = json['IMP'].toString();
    iNR = json['INR'].toString();
    iQD = json['IQD'].toString();
    iRR = json['IRR'].toString();
    iSK = json['ISK'].toString();
    jEP = json['JEP'].toString();
    jMD = json['JMD'].toString();
    jOD = json['JOD'].toString();
    jPY = json['JPY'].toString();
    kES = json['KES'].toString();
    kGS = json['KGS'].toString();
    kHR = json['KHR'].toString();
    kID = json['KID'].toString();
    kMF = json['KMF'].toString();
    kRW = json['KRW'].toString();
    kWD = json['KWD'].toString();
    kYD = json['KYD'].toString();
    kZT = json['KZT'].toString();
    lAK = json['LAK'].toString();
    lBP = json['LBP'].toString();
    lKR = json['LKR'].toString();
    lRD = json['LRD'].toString();
    lSL = json['LSL'].toString();
    lYD = json['LYD'].toString();
    mAD = json['MAD'].toString();
    mDL = json['MDL'].toString();
    mGA = json['MGA'].toString();
    mKD = json['MKD'].toString();
    mMK = json['MMK'].toString();
    mNT = json['MNT'].toString();
    mOP = json['MOP'].toString();
    mRU = json['MRU'].toString();
    mUR = json['MUR'].toString();
    mVR = json['MVR'].toString();
    mWK = json['MWK'].toString();
    mXN = json['MXN'].toString();
    mYR = json['MYR'].toString();
    mZN = json['MZN'].toString();
    nAD = json['NAD'].toString();
    nGN = json['NGN'].toString();
    nIO = json['NIO'].toString();
    nOK = json['NOK'].toString();
    nPR = json['NPR'].toString();
    nZD = json['NZD'].toString();
    oMR = json['OMR'].toString();
    pAB = json['PAB'].toString();
    pEN = json['PEN'].toString();
    pGK = json['PGK'].toString();
    pHP = json['PHP'].toString();
    pKR = json['PKR'].toString();
    pLN = json['PLN'].toString();
    pYG = json['PYG'].toString();
    qAR = json['QAR'].toString();
    rON = json['RON'].toString();
    rSD = json['RSD'].toString();
    rUB = json['RUB'].toString();
    rWF = json['RWF'].toString();
    sAR = json['SAR'].toString();
    sBD = json['SBD'].toString();
    sCR = json['SCR'].toString();
    sDG = json['SDG'].toString();
    sEK = json['SEK'].toString();
    sGD = json['SGD'].toString();
    sHP = json['SHP'].toString();
    sLE = json['SLE'].toString();
    sLL = json['SLL'].toString();
    sOS = json['SOS'].toString();
    sRD = json['SRD'].toString();
    sSP = json['SSP'].toString();
    sTN = json['STN'].toString();
    sYP = json['SYP'].toString();
    sZL = json['SZL'].toString();
    tHB = json['THB'].toString();
    tJS = json['TJS'].toString();
    tMT = json['TMT'].toString();
    tND = json['TND'].toString();
    tOP = json['TOP'].toString();
    tRY = json['TRY'].toString();
    tTD = json['TTD'].toString();
    tVD = json['TVD'].toString();
    tWD = json['TWD'].toString();
    tZS = json['TZS'].toString();
    uAH = json['UAH'].toString();
    uGX = json['UGX'].toString();
    uYU = json['UYU'].toString();
    uZS = json['UZS'].toString();
    vES = json['VES'].toString();
    vND = json['VND'].toString();
    vUV = json['VUV'].toString();
    wST = json['WST'].toString();
    xAF = json['XAF'].toString();
    xCD = json['XCD'].toString();
    xDR = json['XDR'].toString();
    xOF = json['XOF'].toString();
    xPF = json['XPF'].toString();
    yER = json['YER'].toString();
    zAR = json['ZAR'].toString();
    zMW = json['ZMW'].toString();
    zWL = json['ZWL'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['USD'] = this.uSD;
    data['AED'] = this.aED;
    data['AFN'] = this.aFN;
    data['ALL'] = this.aLL;
    data['AMD'] = this.aMD;
    data['ANG'] = this.aNG;
    data['AOA'] = this.aOA;
    data['ARS'] = this.aRS;
    data['AUD'] = this.aUD;
    data['AWG'] = this.aWG;
    data['AZN'] = this.aZN;
    data['BAM'] = this.bAM;
    data['BBD'] = this.bBD;
    data['BDT'] = this.bDT;
    data['BGN'] = this.bGN;
    data['BHD'] = this.bHD;
    data['BIF'] = this.bIF;
    data['BMD'] = this.bMD;
    data['BND'] = this.bND;
    data['BOB'] = this.bOB;
    data['BRL'] = this.bRL;
    data['BSD'] = this.bSD;
    data['BTN'] = this.bTN;
    data['BWP'] = this.bWP;
    data['BYN'] = this.bYN;
    data['BZD'] = this.bZD;
    data['CAD'] = this.cAD;
    data['CDF'] = this.cDF;
    data['CHF'] = this.cHF;
    data['CLP'] = this.cLP;
    data['CNY'] = this.cNY;
    data['COP'] = this.cOP;
    data['CRC'] = this.cRC;
    data['CUP'] = this.cUP;
    data['CVE'] = this.cVE;
    data['CZK'] = this.cZK;
    data['DJF'] = this.dJF;
    data['DKK'] = this.dKK;
    data['DOP'] = this.dOP;
    data['DZD'] = this.dZD;
    data['EGP'] = this.eGP;
    data['ERN'] = this.eRN;
    data['ETB'] = this.eTB;
    data['EUR'] = this.eUR;
    data['FJD'] = this.fJD;
    data['FKP'] = this.fKP;
    data['FOK'] = this.fOK;
    data['GBP'] = this.gBP;
    data['GEL'] = this.gEL;
    data['GGP'] = this.gGP;
    data['GHS'] = this.gHS;
    data['GIP'] = this.gIP;
    data['GMD'] = this.gMD;
    data['GNF'] = this.gNF;
    data['GTQ'] = this.gTQ;
    data['GYD'] = this.gYD;
    data['HKD'] = this.hKD;
    data['HNL'] = this.hNL;
    data['HRK'] = this.hRK;
    data['HTG'] = this.hTG;
    data['HUF'] = this.hUF;
    data['IDR'] = this.iDR;
    data['ILS'] = this.iLS;
    data['IMP'] = this.iMP;
    data['INR'] = this.iNR;
    data['IQD'] = this.iQD;
    data['IRR'] = this.iRR;
    data['ISK'] = this.iSK;
    data['JEP'] = this.jEP;
    data['JMD'] = this.jMD;
    data['JOD'] = this.jOD;
    data['JPY'] = this.jPY;
    data['KES'] = this.kES;
    data['KGS'] = this.kGS;
    data['KHR'] = this.kHR;
    data['KID'] = this.kID;
    data['KMF'] = this.kMF;
    data['KRW'] = this.kRW;
    data['KWD'] = this.kWD;
    data['KYD'] = this.kYD;
    data['KZT'] = this.kZT;
    data['LAK'] = this.lAK;
    data['LBP'] = this.lBP;
    data['LKR'] = this.lKR;
    data['LRD'] = this.lRD;
    data['LSL'] = this.lSL;
    data['LYD'] = this.lYD;
    data['MAD'] = this.mAD;
    data['MDL'] = this.mDL;
    data['MGA'] = this.mGA;
    data['MKD'] = this.mKD;
    data['MMK'] = this.mMK;
    data['MNT'] = this.mNT;
    data['MOP'] = this.mOP;
    data['MRU'] = this.mRU;
    data['MUR'] = this.mUR;
    data['MVR'] = this.mVR;
    data['MWK'] = this.mWK;
    data['MXN'] = this.mXN;
    data['MYR'] = this.mYR;
    data['MZN'] = this.mZN;
    data['NAD'] = this.nAD;
    data['NGN'] = this.nGN;
    data['NIO'] = this.nIO;
    data['NOK'] = this.nOK;
    data['NPR'] = this.nPR;
    data['NZD'] = this.nZD;
    data['OMR'] = this.oMR;
    data['PAB'] = this.pAB;
    data['PEN'] = this.pEN;
    data['PGK'] = this.pGK;
    data['PHP'] = this.pHP;
    data['PKR'] = this.pKR;
    data['PLN'] = this.pLN;
    data['PYG'] = this.pYG;
    data['QAR'] = this.qAR;
    data['RON'] = this.rON;
    data['RSD'] = this.rSD;
    data['RUB'] = this.rUB;
    data['RWF'] = this.rWF;
    data['SAR'] = this.sAR;
    data['SBD'] = this.sBD;
    data['SCR'] = this.sCR;
    data['SDG'] = this.sDG;
    data['SEK'] = this.sEK;
    data['SGD'] = this.sGD;
    data['SHP'] = this.sHP;
    data['SLE'] = this.sLE;
    data['SLL'] = this.sLL;
    data['SOS'] = this.sOS;
    data['SRD'] = this.sRD;
    data['SSP'] = this.sSP;
    data['STN'] = this.sTN;
    data['SYP'] = this.sYP;
    data['SZL'] = this.sZL;
    data['THB'] = this.tHB;
    data['TJS'] = this.tJS;
    data['TMT'] = this.tMT;
    data['TND'] = this.tND;
    data['TOP'] = this.tOP;
    data['TRY'] = this.tRY;
    data['TTD'] = this.tTD;
    data['TVD'] = this.tVD;
    data['TWD'] = this.tWD;
    data['TZS'] = this.tZS;
    data['UAH'] = this.uAH;
    data['UGX'] = this.uGX;
    data['UYU'] = this.uYU;
    data['UZS'] = this.uZS;
    data['VES'] = this.vES;
    data['VND'] = this.vND;
    data['VUV'] = this.vUV;
    data['WST'] = this.wST;
    data['XAF'] = this.xAF;
    data['XCD'] = this.xCD;
    data['XDR'] = this.xDR;
    data['XOF'] = this.xOF;
    data['XPF'] = this.xPF;
    data['YER'] = this.yER;
    data['ZAR'] = this.zAR;
    data['ZMW'] = this.zMW;
    data['ZWL'] = this.zWL;
    return data;
  }
}
