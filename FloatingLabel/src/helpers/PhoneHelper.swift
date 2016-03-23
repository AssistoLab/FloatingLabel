//
//  PhoneHelper.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 23/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import Foundation

internal final class PhoneHelper {
	
	static func componentsFromNumber(number: String) -> (String?, String?) {
		let undecoratedNumber = undecorateNumberString(number)
		let prefix = prefixes()
			.filter { undecoratedNumber.characters.startsWith($0.characters) }
			.sort { $0.characters.count > $1.characters.count }.first
		
		let suffix: String?
		
		if let prefix = prefix {
			suffix = undecoratedNumber.substringFromIndex(undecoratedNumber.startIndex.advancedBy(prefix.characters.count))
		} else {
			suffix = undecoratedNumber
		}
		
		return (prefix, suffix)
	}
	
	private static func undecorateNumberString(number: String) -> String {
		// Remove leading "+"
		var undecoratedNumber = number.stringByReplacingOccurrencesOfString(
			"+",
			withString: "",
			range: number.startIndex..<number.startIndex.advancedBy(1))
		
		// Remove leading "00"
		undecoratedNumber = undecoratedNumber.stringByReplacingOccurrencesOfString(
			"00",
			withString: "",
			range: undecoratedNumber.startIndex..<undecoratedNumber.startIndex.advancedBy(2))
		
		// Remove spaces
		undecoratedNumber = undecoratedNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
		
		// Remove spaces
		undecoratedNumber = undecoratedNumber.stringByReplacingOccurrencesOfString(".", withString: "")
		
		// Remove spaces
		undecoratedNumber = undecoratedNumber.stringByReplacingOccurrencesOfString("/", withString: "")
		
		return undecoratedNumber
	}
	
	private static func prefixes() -> [String] {
		return ["93","355","213","1684","376","244","1264","1268","54","374","297","61","43","994","1242","973","880","1246","375","32","501","229","1441","975","387","267","55","246","359","226","257","855","237","1","238","345","236","235","56","86","61","57","269","242","682","506","385","53","537","420","45","253","1767","1849","593","20","503","240","291","372","251","298","679","358","33","594","689","241","220","995","49","233","350","30","299","1473","590","1671","502","224","245","595","509","504","36","354","91","62","964","353","972","39","1876","81","962","77","254","686","965","996","371","961","266","231","423","370","352","261","265","60","960","223","356","692","596","222","230","262","52","377","976","382","1664","212","95","264","674","977","31","599","687","64","505","227","234","683","672","1670","47","968","92","680","507","675","595","51","63","48","351","1939","974","40","250","685","378","966","221","381","248","232","65","421","386","677","27","500","34","94","249","597","268","46","41","992","66","228","690","676","1868","216","90","993","1649","688","256","380","971","44","598","998","678","681","967","260","263","358","591","673","61","243","225","500","44","379","852","98","44","44","850","82","856","218","853","389","691","373","258","970","872","262","7","590","290","1869","1758","590","508","1784","239","252","47","963","886","255","670","58","84","1284","1340"]
	}
	
}
