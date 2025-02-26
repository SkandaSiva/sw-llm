/**
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
* We offer the best and most useful modules PrestaShop and modifications for your online store.
*
* @category  PrestaShop Module
* @author    knowband.com <support@knowband.com>
* @copyright 2015 Knowband
* @license   see file: LICENSE.txt
*/
!function (i, s) {
    "use strict";
//////////////
// Constants
/////////////
    var e = "0.7.17", o = "", r = "?", n = "function", a = "undefined", d = "object", t = "string", l = "major", // deprecated
            w = "model", u = "name", c = "type", m = "vendor", b = "version", p = "architecture", g = "console", f = "mobile", h = "tablet", v = "smarttv", x = "wearable", k = "embedded", y = {extend: function (i, s) {
                    var e = {};
                    for (var o in i)
                        s[o] && s[o].length % 2 === 0 ? e[o] = s[o].concat(i[o]) : e[o] = i[o];
                    return e
                }, has: function (i, s) {
                    return"string" == typeof i && s.toLowerCase().indexOf(i.toLowerCase()) !== -1
                }, lowerize: function (i) {
                    return i.toLowerCase()
                }, major: function (i) {
                    return typeof i === t ? i.replace(/[^\d\.]/g, "").split(".")[0] : s
                }, trim: function (i) {
                    return i.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, "")
                }}, T = {rgx: function (i, e) {//, args = arguments;
            /*// construct object barebones
             for (p = 0; p < args[1].length; p++) {
             q = args[1][p];
             result[typeof q === OBJ_TYPE ? q[0] : q] = undefined;
             }*/
// loop through all regexes maps
            for (
//var result = {},
                    var o, r, a, t, l, w, u = 0; u < e.length && !l; ) {
                var c = e[u], // even sequence (0,2,4,..)
                        m = e[u + 1];
// try matching uastring with regexes
                for (// odd sequence (1,3,5,..)
                        o = r = 0; o < c.length && !l; )
                    if (l = c[o++].exec(i))
                        for (a = 0; a < m.length; a++)
                            w = l[++r], t = m[a],
// check if given property is actually array
                                    typeof t === d && t.length > 0 ? 2 == t.length ? typeof t[1] == n ?
// assign modified match
                                    this[t[0]] = t[1].call(this, w) :
// assign given value, ignore regex match
                                    this[t[0]] = t[1] : 3 == t.length ?
// check whether function or regex
                                    typeof t[1] !== n || t[1].exec && t[1].test ?
// sanitize match using given regex
                                    this[t[0]] = w ? w.replace(t[1], t[2]) : s :
// call function (usually string mapper)
                                    this[t[0]] = w ? t[1].call(this, w, t[2]) : s : 4 == t.length && (this[t[0]] = w ? t[3].call(this, w.replace(t[1], t[2])) : s) : this[t] = w ? w : s;
                u += 2
            }
        }, str: function (i, e) {
            for (var o in e)
// check if array
                if (typeof e[o] === d && e[o].length > 0) {
                    for (var n = 0; n < e[o].length; n++)
                        if (y.has(e[o][n], i))
                            return o === r ? s : o
                } else if (y.has(e[o], i))
                    return o === r ? s : o;
            return i
        }}, A = {browser: {oldsafari: {version: {"1.0": "/8", 1.2: "/1", 1.3: "/3", "2.0": "/412", "2.0.2": "/416", "2.0.3": "/417", "2.0.4": "/419", "?": "/"}}}, device: {amazon: {model: {"Fire Phone": ["SD", "KF"]}}, sprint: {model: {"Evo Shift 4G": "7373KT"}, vendor: {HTC: "APA", Sprint: "Sprint"}}}, os: {windows: {version: {ME: "4.90", "NT 3.11": "NT3.51", "NT 4.0": "NT4.0", 2000: "NT 5.0", XP: ["NT 5.1", "NT 5.2"], Vista: "NT 6.0", 7: "NT 6.1", 8: "NT 6.2", 8.1: "NT 6.3", 10: ["NT 6.4", "NT 10.0"], RT: "ARM"}}}}, S = {browser: [[
// Presto based
                /(opera\smini)\/([\w\.-]+)/i, // Opera Mini
                /(opera\s[mobiletab]+).+version\/([\w\.-]+)/i, // Opera Mobi/Tablet
                /(opera).+version\/([\w\.]+)/i, // Opera > 9.80
                /(opera)[\/\s]+([\w\.]+)/i], [u, b], [/(opios)[\/\s]+([\w\.]+)/i], [[u, "Opera Mini"], b], [/\s(opr)\/([\w\.]+)/i], [[u, "Opera"], b], [
// Mixed
                /(kindle)\/([\w\.]+)/i, // Kindle
                /(lunascape|maxthon|netfront|jasmine|blazer)[\/\s]?([\w\.]+)*/i,
// Lunascape/Maxthon/Netfront/Jasmine/Blazer
// Trident based
                /(avant\s|iemobile|slim|baidu)(?:browser)?[\/\s]?([\w\.]*)/i,
// Avant/IEMobile/SlimBrowser/Baidu
                /(?:ms|\()(ie)\s([\w\.]+)/i, // Internet Explorer
// Webkit/KHTML based
                /(rekonq)\/([\w\.]+)*/i, // Rekonq
                /(chromium|flock|rockmelt|midori|epiphany|silk|skyfire|ovibrowser|bolt|iron|vivaldi|iridium|phantomjs|bowser)\/([\w\.-]+)/i], [u, b], [/(trident).+rv[:\s]([\w\.]+).+like\sgecko/i], [[u, "IE"], b], [/(edge)\/((\d+)?[\w\.]+)/i], [u, b], [/(yabrowser)\/([\w\.]+)/i], [[u, "Yandex"], b], [/(puffin)\/([\w\.]+)/i], [[u, "Puffin"], b], [/((?:[\s\/])uc?\s?browser|(?:juc.+)ucweb)[\/\s]?([\w\.]+)/i], [[u, "UCBrowser"], b], [/(comodo_dragon)\/([\w\.]+)/i], [[u, /_/g, " "], b], [/(micromessenger)\/([\w\.]+)/i], [[u, "WeChat"], b], [/(QQ)\/([\d\.]+)/i], [u, b], [/m?(qqbrowser)[\/\s]?([\w\.]+)/i], [u, b], [/xiaomi\/miuibrowser\/([\w\.]+)/i], [b, [u, "MIUI Browser"]], [/;fbav\/([\w\.]+);/i], [b, [u, "Facebook"]], [/headlesschrome(?:\/([\w\.]+)|\s)/i], [b, [u, "Chrome Headless"]], [/\swv\).+(chrome)\/([\w\.]+)/i], [[u, /(.+)/, "$1 WebView"], b], [/((?:oculus|samsung)browser)\/([\w\.]+)/i], [[u, /(.+(?:g|us))(.+)/, "$1 $2"], b], [// Oculus / Samsung Browser
                /android.+version\/([\w\.]+)\s+(?:mobile\s?safari|safari)*/i], [b, [u, "Android Browser"]], [/(chrome|omniweb|arora|[tizenoka]{5}\s?browser)\/v?([\w\.]+)/i], [u, b], [/(dolfin)\/([\w\.]+)/i], [[u, "Dolphin"], b], [/((?:android.+)crmo|crios)\/([\w\.]+)/i], [[u, "Chrome"], b], [/(coast)\/([\w\.]+)/i], [[u, "Opera Coast"], b], [/fxios\/([\w\.-]+)/i], [b, [u, "Firefox"]], [/version\/([\w\.]+).+?mobile\/\w+\s(safari)/i], [b, [u, "Mobile Safari"]], [/version\/([\w\.]+).+?(mobile\s?safari|safari)/i], [b, u], [/webkit.+?(gsa)\/([\w\.]+).+?(mobile\s?safari|safari)(\/[\w\.]+)/i], [[u, "GSA"], b], [/webkit.+?(mobile\s?safari|safari)(\/[\w\.]+)/i], [u, [b, T.str, A.browser.oldsafari.version]], [/(konqueror)\/([\w\.]+)/i, // Konqueror
                /(webkit|khtml)\/([\w\.]+)/i], [u, b], [
// Gecko based
                /(navigator|netscape)\/([\w\.-]+)/i], [[u, "Netscape"], b], [/(swiftfox)/i, // Swiftfox
                /(icedragon|iceweasel|camino|chimera|fennec|maemo\sbrowser|minimo|conkeror)[\/\s]?([\w\.\+]+)/i,
// IceDragon/Iceweasel/Camino/Chimera/Fennec/Maemo/Minimo/Conkeror
                /(firefox|seamonkey|k-meleon|icecat|iceape|firebird|phoenix)\/([\w\.-]+)/i,
// Firefox/SeaMonkey/K-Meleon/IceCat/IceApe/Firebird/Phoenix
                /(mozilla)\/([\w\.]+).+rv\:.+gecko\/\d+/i, // Mozilla
// Other
                /(polaris|lynx|dillo|icab|doris|amaya|w3m|netsurf|sleipnir)[\/\s]?([\w\.]+)/i,
// Polaris/Lynx/Dillo/iCab/Doris/Amaya/w3m/NetSurf/Sleipnir
                /(links)\s\(([\w\.]+)/i, // Links
                /(gobrowser)\/?([\w\.]+)*/i, // GoBrowser
                /(ice\s?browser)\/v?([\w\._]+)/i, // ICE Browser
                /(mosaic)[\/\s]([\w\.]+)/i], [u, b]], cpu: [[/(?:(amd|x(?:(?:86|64)[_-])?|wow|win)64)[;\)]/i], [[p, "amd64"]], [/(ia32(?=;))/i], [[p, y.lowerize]], [/((?:i[346]|x)86)[;\)]/i], [[p, "ia32"]], [
// PocketPC mistakenly identified as PowerPC
                /windows\s(ce|mobile);\sppc;/i], [[p, "arm"]], [/((?:ppc|powerpc)(?:64)?)(?:\smac|;|\))/i], [[p, /ower/, "", y.lowerize]], [/(sun4\w)[;\)]/i], [[p, "sparc"]], [/((?:avr32|ia64(?=;))|68k(?=\))|arm(?:64|(?=v\d+;))|(?=atmel\s)avr|(?:irix|mips|sparc)(?:64)?(?=;)|pa-risc)/i], [[p, y.lowerize]]], device: [[/\((ipad|playbook);[\w\s\);-]+(rim|apple)/i], [w, m, [c, h]], [/applecoremedia\/[\w\.]+ \((ipad)/], [w, [m, "Apple"], [c, h]], [/(apple\s{0,1}tv)/i], [[w, "Apple TV"], [m, "Apple"]], [/(archos)\s(gamepad2?)/i, // Archos
                /(hp).+(touchpad)/i, // HP TouchPad
                /(hp).+(tablet)/i, // HP Tablet
                /(kindle)\/([\w\.]+)/i, // Kindle
                /\s(nook)[\w\s]+build\/(\w+)/i, // Nook
                /(dell)\s(strea[kpr\s\d]*[\dko])/i], [m, w, [c, h]], [/(kf[A-z]+)\sbuild\/[\w\.]+.*silk\//i], [w, [m, "Amazon"], [c, h]], [/(sd|kf)[0349hijorstuw]+\sbuild\/[\w\.]+.*silk\//i], [[w, T.str, A.device.amazon.model], [m, "Amazon"], [c, f]], [/\((ip[honed|\s\w*]+);.+(apple)/i], [w, m, [c, f]], [/\((ip[honed|\s\w*]+);/i], [w, [m, "Apple"], [c, f]], [/(blackberry)[\s-]?(\w+)/i, // BlackBerry
                /(blackberry|benq|palm(?=\-)|sonyericsson|acer|asus|dell|meizu|motorola|polytron)[\s_-]?([\w-]+)*/i,
// BenQ/Palm/Sony-Ericsson/Acer/Asus/Dell/Meizu/Motorola/Polytron
                /(hp)\s([\w\s]+\w)/i, // HP iPAQ
                /(asus)-?(\w+)/i], [m, w, [c, f]], [/\(bb10;\s(\w+)/i], [w, [m, "BlackBerry"], [c, f]], [
// Asus Tablets
                /android.+(transfo[prime\s]{4,10}\s\w+|eeepc|slider\s\w+|nexus 7|padfone)/i], [w, [m, "Asus"], [c, h]], [/(sony)\s(tablet\s[ps])\sbuild\//i, // Sony
                /(sony)?(?:sgp.+)\sbuild\//i], [[m, "Sony"], [w, "Xperia Tablet"], [c, h]], [/android.+\s([c-g]\d{4}|so[-l]\w+)\sbuild\//i], [w, [m, "Sony"], [c, f]], [/\s(ouya)\s/i, // Ouya
                /(nintendo)\s([wids3u]+)/i], [m, w, [c, g]], [/android.+;\s(shield)\sbuild/i], [w, [m, "Nvidia"], [c, g]], [/(playstation\s[34portablevi]+)/i], [w, [m, "Sony"], [c, g]], [/(sprint\s(\w+))/i], [[m, T.str, A.device.sprint.vendor], [w, T.str, A.device.sprint.model], [c, f]], [/(lenovo)\s?(S(?:5000|6000)+(?:[-][\w+]))/i], [m, w, [c, h]], [/(htc)[;_\s-]+([\w\s]+(?=\))|\w+)*/i, // HTC
                /(zte)-(\w+)*/i, // ZTE
                /(alcatel|geeksphone|lenovo|nexian|panasonic|(?=;\s)sony)[_\s-]?([\w-]+)*/i], [m, [w, /_/g, " "], [c, f]], [/(nexus\s9)/i], [w, [m, "HTC"], [c, h]], [/d\/huawei([\w\s-]+)[;\)]/i, /(nexus\s6p)/i], [w, [m, "Huawei"], [c, f]], [/(microsoft);\s(lumia[\s\w]+)/i], [m, w, [c, f]], [/[\s\(;](xbox(?:\sone)?)[\s\);]/i], [w, [m, "Microsoft"], [c, g]], [/(kin\.[onetw]{3})/i], [[w, /\./g, " "], [m, "Microsoft"], [c, f]], [
// Motorola
                /\s(milestone|droid(?:[2-4x]|\s(?:bionic|x2|pro|razr))?(:?\s4g)?)[\w\s]+build\//i, /mot[\s-]?(\w+)*/i, /(XT\d{3,4}) build\//i, /(nexus\s6)/i], [w, [m, "Motorola"], [c, f]], [/android.+\s(mz60\d|xoom[\s2]{0,2})\sbuild\//i], [w, [m, "Motorola"], [c, h]], [/hbbtv\/\d+\.\d+\.\d+\s+\([\w\s]*;\s*(\w[^;]*);([^;]*)/i], [[m, y.trim], [w, y.trim], [c, v]], [/hbbtv.+maple;(\d+)/i], [[w, /^/, "SmartTV"], [m, "Samsung"], [c, v]], [/\(dtv[\);].+(aquos)/i], [w, [m, "Sharp"], [c, v]], [/android.+((sch-i[89]0\d|shw-m380s|gt-p\d{4}|gt-n\d+|sgh-t8[56]9|nexus 10))/i, /((SM-T\w+))/i], [[m, "Samsung"], w, [c, h]], [// Samsung
                /smart-tv.+(samsung)/i], [m, [c, v], w], [/((s[cgp]h-\w+|gt-\w+|galaxy\snexus|sm-\w[\w\d]+))/i, /(sam[sung]*)[\s-]*(\w+-?[\w-]*)*/i, /sec-((sgh\w+))/i], [[m, "Samsung"], w, [c, f]], [/sie-(\w+)*/i], [w, [m, "Siemens"], [c, f]], [/(maemo|nokia).*(n900|lumia\s\d+)/i, // Nokia
                /(nokia)[\s_-]?([\w-]+)*/i], [[m, "Nokia"], w, [c, f]], [/android\s3\.[\s\w;-]{10}(a\d{3})/i], [w, [m, "Acer"], [c, h]], [/android.+([vl]k\-?\d{3})\s+build/i], [w, [m, "LG"], [c, h]], [/android\s3\.[\s\w;-]{10}(lg?)-([06cv9]{3,4})/i], [[m, "LG"], w, [c, h]], [/(lg) netcast\.tv/i], [m, w, [c, v]], [/(nexus\s[45])/i, // LG
                /lg[e;\s\/-]+(\w+)*/i, /android.+lg(\-?[\d\w]+)\s+build/i], [w, [m, "LG"], [c, f]], [/android.+(ideatab[a-z0-9\-\s]+)/i], [w, [m, "Lenovo"], [c, h]], [/linux;.+((jolla));/i], [m, w, [c, f]], [/((pebble))app\/[\d\.]+\s/i], [m, w, [c, x]], [/android.+;\s(oppo)\s?([\w\s]+)\sbuild/i], [m, w, [c, f]], [/crkey/i], [[w, "Chromecast"], [m, "Google"]], [/android.+;\s(glass)\s\d/i], [w, [m, "Google"], [c, x]], [/android.+;\s(pixel c)\s/i], [w, [m, "Google"], [c, h]], [/android.+;\s(pixel xl|pixel)\s/i], [w, [m, "Google"], [c, f]], [/android.+(\w+)\s+build\/hm\1/i, // Xiaomi Hongmi 'numeric' models
                /android.+(hm[\s\-_]*note?[\s_]*(?:\d\w)?)\s+build/i, // Xiaomi Hongmi
                /android.+(mi[\s\-_]*(?:one|one[\s_]plus|note lte)?[\s_]*(?:\d\w)?)\s+build/i, // Xiaomi Mi
                /android.+(redmi[\s\-_]*(?:note)?(?:[\s_]*[\w\s]+)?)\s+build/i], [[w, /_/g, " "], [m, "Xiaomi"], [c, f]], [/android.+(mi[\s\-_]*(?:pad)?(?:[\s_]*[\w\s]+)?)\s+build/i], [[w, /_/g, " "], [m, "Xiaomi"], [c, h]], [/android.+;\s(m[1-5]\snote)\sbuild/i], [w, [m, "Meizu"], [c, h]], [/android.+a000(1)\s+build/i], [w, [m, "OnePlus"], [c, f]], [/android.+[;\/]\s*(RCT[\d\w]+)\s+build/i], [w, [m, "RCA"], [c, h]], [/android.+[;\/]\s*(Venue[\d\s]*)\s+build/i], [w, [m, "Dell"], [c, h]], [/android.+[;\/]\s*(Q[T|M][\d\w]+)\s+build/i], [w, [m, "Verizon"], [c, h]], [/android.+[;\/]\s+(Barnes[&\s]+Noble\s+|BN[RT])(V?.*)\s+build/i], [[m, "Barnes & Noble"], w, [c, h]], [/android.+[;\/]\s+(TM\d{3}.*\b)\s+build/i], [w, [m, "NuVision"], [c, h]], [/android.+[;\/]\s*(zte)?.+(k\d{2})\s+build/i], [[m, "ZTE"], w, [c, h]], [/android.+[;\/]\s*(gen\d{3})\s+build.*49h/i], [w, [m, "Swiss"], [c, f]], [/android.+[;\/]\s*(zur\d{3})\s+build/i], [w, [m, "Swiss"], [c, h]], [/android.+[;\/]\s*((Zeki)?TB.*\b)\s+build/i], [w, [m, "Zeki"], [c, h]], [/(android).+[;\/]\s+([YR]\d{2}x?.*)\s+build/i, /android.+[;\/]\s+(Dragon[\-\s]+Touch\s+|DT)(.+)\s+build/i], [[m, "Dragon Touch"], w, [c, h]], [/android.+[;\/]\s*(NS-?.+)\s+build/i], [w, [m, "Insignia"], [c, h]], [/android.+[;\/]\s*((NX|Next)-?.+)\s+build/i], [w, [m, "NextBook"], [c, h]], [/android.+[;\/]\s*(Xtreme\_?)?(V(1[045]|2[015]|30|40|60|7[05]|90))\s+build/i], [[m, "Voice"], w, [c, f]], [// Voice Xtreme Phones
                /android.+[;\/]\s*(LVTEL\-?)?(V1[12])\s+build/i], [[m, "LvTel"], w, [c, f]], [/android.+[;\/]\s*(V(100MD|700NA|7011|917G).*\b)\s+build/i], [w, [m, "Envizen"], [c, h]], [/android.+[;\/]\s*(Le[\s\-]+Pan)[\s\-]+(.*\b)\s+build/i], [m, w, [c, h]], [/android.+[;\/]\s*(Trio[\s\-]*.*)\s+build/i], [w, [m, "MachSpeed"], [c, h]], [/android.+[;\/]\s*(Trinity)[\-\s]*(T\d{3})\s+build/i], [m, w, [c, h]], [/android.+[;\/]\s*TU_(1491)\s+build/i], [w, [m, "Rotor"], [c, h]], [/android.+(KS(.+))\s+build/i], [w, [m, "Amazon"], [c, h]], [/android.+(Gigaset)[\s\-]+(Q.+)\s+build/i], [m, w, [c, h]], [/\s(tablet|tab)[;\/]/i, // Unidentifiable Tablet
                /\s(mobile)(?:[;\/]|\ssafari)/i], [[c, y.lowerize], m, w], [/(android.+)[;\/].+build/i], [w, [m, "Generic"]]], engine: [[/windows.+\sedge\/([\w\.]+)/i], [b, [u, "EdgeHTML"]], [/(presto)\/([\w\.]+)/i, // Presto
                /(webkit|trident|netfront|netsurf|amaya|lynx|w3m)\/([\w\.]+)/i, // WebKit/Trident/NetFront/NetSurf/Amaya/Lynx/w3m
                /(khtml|tasman|links)[\/\s]\(?([\w\.]+)/i, // KHTML/Tasman/Links
                /(icab)[\/\s]([23]\.[\d\.]+)/i], [u, b], [/rv\:([\w\.]+).*(gecko)/i], [b, u]], os: [[
// Windows based
                /microsoft\s(windows)\s(vista|xp)/i], [u, b], [/(windows)\snt\s6\.2;\s(arm)/i, // Windows RT
                /(windows\sphone(?:\sos)*)[\s\/]?([\d\.\s]+\w)*/i, // Windows Phone
                /(windows\smobile|windows)[\s\/]?([ntce\d\.\s]+\w)/i], [u, [b, T.str, A.os.windows.version]], [/(win(?=3|9|n)|win\s9x\s)([nt\d\.]+)/i], [[u, "Windows"], [b, T.str, A.os.windows.version]], [
// Mobile/Embedded OS
                /\((bb)(10);/i], [[u, "BlackBerry"], b], [/(blackberry)\w*\/?([\w\.]+)*/i, // Blackberry
                /(tizen)[\/\s]([\w\.]+)/i, // Tizen
                /(android|webos|palm\sos|qnx|bada|rim\stablet\sos|meego|contiki)[\/\s-]?([\w\.]+)*/i,
// Android/WebOS/Palm/QNX/Bada/RIM/MeeGo/Contiki
                /linux;.+(sailfish);/i], [u, b], [/(symbian\s?os|symbos|s60(?=;))[\/\s-]?([\w\.]+)*/i], [[u, "Symbian"], b], [/\((series40);/i], [u], [/mozilla.+\(mobile;.+gecko.+firefox/i], [[u, "Firefox OS"], b], [
// Console
                /(nintendo|playstation)\s([wids34portablevu]+)/i, // Nintendo/Playstation
// GNU/Linux based
                /(mint)[\/\s\(]?(\w+)*/i, // Mint
                /(mageia|vectorlinux)[;\s]/i, // Mageia/VectorLinux
                /(joli|[kxln]?ubuntu|debian|[open]*suse|gentoo|(?=\s)arch|slackware|fedora|mandriva|centos|pclinuxos|redhat|zenwalk|linpus)[\/\s-]?(?!chrom)([\w\.-]+)*/i,
// Joli/Ubuntu/Debian/SUSE/Gentoo/Arch/Slackware
// Fedora/Mandriva/CentOS/PCLinuxOS/RedHat/Zenwalk/Linpus
                /(hurd|linux)\s?([\w\.]+)*/i, // Hurd/Linux
                /(gnu)\s?([\w\.]+)*/i], [u, b], [/(cros)\s[\w]+\s([\w\.]+\w)/i], [[u, "Chromium OS"], b], [
// Solaris
                /(sunos)\s?([\w\.]+\d)*/i], [[u, "Solaris"], b], [
// BSD based
                /\s([frentopc-]{0,4}bsd|dragonfly)\s?([\w\.]+)*/i], [u, b], [/(haiku)\s(\w+)/i], [u, b], [/cfnetwork\/.+darwin/i, /ip[honead]+(?:.*os\s([\w]+)\slike\smac|;\sopera)/i], [[b, /_/g, "."], [u, "iOS"]], [/(mac\sos\sx)\s?([\w\s\.]+\w)*/i, /(macintosh|mac(?=_powerpc)\s)/i], [[u, "Mac OS"], [b, /_/g, "."]], [
// Other
                /((?:open)?solaris)[\/\s-]?([\w\.]+)*/i, // Solaris
                /(aix)\s((\d)(?=\.|\)|\s)[\w\.]*)*/i, // AIX
                /(plan\s9|minix|beos|os\/2|amigaos|morphos|risc\sos|openvms)/i,
// Plan9/Minix/BeOS/OS2/AmigaOS/MorphOS/RISCOS/OpenVMS
                /(unix)\s?([\w\.]+)*/i], [u, b]]}, E = function (e, r) {
        if ("object" == typeof e && (r = e, e = s), !(this instanceof E))
            return new E(e, r).getResult();
        var n = e || (i && i.navigator && i.navigator.userAgent ? i.navigator.userAgent : o), a = r ? y.extend(S, r) : S;
//var browser = new Browser();
//var cpu = new CPU();
//var device = new Device();
//var engine = new Engine();
//var os = new OS();
        return this.getBrowser = function () {
            var i = {name: s, version: s};// deprecated
            return T.rgx.call(i, n, a.browser), i.major = y.major(i.version), i
        }, this.getCPU = function () {
            var i = {architecture: s};
            return T.rgx.call(i, n, a.cpu), i
        }, this.getDevice = function () {
            var i = {vendor: s, model: s, type: s};
            return T.rgx.call(i, n, a.device), i
        }, this.getEngine = function () {
            var i = {name: s, version: s};
            return T.rgx.call(i, n, a.engine), i
        }, this.getOS = function () {
            var i = {name: s, version: s};
            return T.rgx.call(i, n, a.os), i
        }, this.getResult = function () {
            return{ua: this.getUA(), browser: this.getBrowser(), engine: this.getEngine(), os: this.getOS(), device: this.getDevice(), cpu: this.getCPU()}
        }, this.getUA = function () {
            return n
        }, this.setUA = function (i) {
//browser = new Browser();
//cpu = new CPU();
//device = new Device();
//engine = new Engine();
//os = new OS();
            return n = i, this
        }, this
    };
    E.VERSION = e, E.BROWSER = {NAME: u, MAJOR: l, // deprecated
        VERSION: b}, E.CPU = {ARCHITECTURE: p}, E.DEVICE = {MODEL: w, VENDOR: m, TYPE: c, CONSOLE: g, MOBILE: f, SMARTTV: v, TABLET: h, WEARABLE: x, EMBEDDED: k}, E.ENGINE = {NAME: u, VERSION: b}, E.OS = {NAME: u, VERSION: b},
//UAParser.Utils = util;
///////////
// Export
//////////
// check js environment
    typeof exports !== a ? (
// nodejs env
            typeof module !== a && module.exports && (exports = module.exports = E),
// TODO: test!!!!!!!!
            /*
             if (require && require.main === module && process) {
             // cli
             var jsonize = function (arr) {
             var res = [];
             for (var i in arr) {
             res.push(new UAParser(arr[i]).getResult());
             }
             process.stdout.write(JSON.stringify(res, null, 2) + '\n');
             };
             if (process.stdin.isTTY) {
             // via args
             jsonize(process.argv.slice(2));
             } else {
             // via pipe
             var str = '';
             process.stdin.on('readable', function() {
             var read = process.stdin.read();
             if (read !== null) {
             str += read;
             }
             });
             process.stdin.on('end', function () {
             jsonize(str.replace(/\n$/, '').split('\n'));
             });
             }
             }
             */
            exports.UAParser = E) :
// requirejs env (optional)
            typeof define === n && define.amd ? define(function () {
                return i.UAParser = E, E
            }) : i && (
// browser env
            i.UAParser = E);
// jQuery/Zepto specific (optional)
// Note:
//   In AMD env the global scope should be kept clean, but jQuery is an exception.
//   jQuery always exports to global scope, unless jQuery.noConflict(true) is used,
//   and we should catch that.
    var N = i && (i.jQuery || i.Zepto);
    if (typeof N !== a) {
        i.UAParser = E;
        var z = new E;
        N.ua = z.getResult(), N.ua.get = function () {
            return z.getUA()
        }, N.ua.set = function (i) {
            z.setUA(i);
            var s = z.getResult();
            for (var e in s)
                N.ua[e] = s[e]
        }
    }
}("object" == typeof window ? window : this);



var browser;
var os;
var device;
 
self.addEventListener('install', function (event) {
//    console.log('[Webpush SW] installed');
    //Automatically take over the previous worker.
    console.log("in-1");
    event.waitUntil(self.skipWaiting());
});

self.addEventListener('activate', function (event) {
    console.log('[Webpush SW] running');
});

var base_url = '';
var is_button = 0;
var push_id = '';
var shop_url = '';
var click_url = '';
//var browser;
self.addEventListener('push', function (event) {
    if (!(self.Notification && self.Notification.permission === 'granted')) {
        return;
    }
    console.log("in-2");
    if (event.data) {
        var payload = event.data.json().data;
        console.log(payload);
        if (payload['actions']) {
            payload['actions'] = JSON.parse(payload['actions']);
        }
        if (typeof payload['action_links'] !== "undefined") {
            payload['action_links'] = JSON.parse(payload['action_links']);
        }
        
        if (typeof payload['actions'] != 'undefined') {
            if (typeof payload['actions'][0]['title'] != 'undefined') {
                    var button_1_title = payload['actions'][0]['title'];
                } else {
                    button_1_title = '';
                }
            } else {
                button_1_title = '';
            }
        if (typeof payload['actions'] != 'undefined') {
            if (typeof payload['actions'][0]['action'] != 'undefined') {
                    var button_1_action = payload['actions'][0]['action'];
                } else {
                    button_1_action = '';
                }
            } else {
                button_1_action = '';
            }

        if (typeof payload['actions'] != 'undefined') {
            if (typeof payload['actions'][0]['icon'] != 'undefined') {
                    var button_1_icon = payload['actions'][0]['icon'];
                } else {
                    button_1_icon = '';
                }
            } else {
                button_1_icon = '';
            }

//        console.log(payload['action_links'][1].hasOwnProperty('title'));
        if (typeof payload['actions'] != 'undefined' && typeof payload['actions'][1]['title'] != 'undefined') {
            if (typeof payload['actions'][1]['title'] != 'undefined') {
                var button_2_title = payload['actions'][1]['title'];
            } else {
                button_2_title = '';
            }
        } else {
            button_2_title = '';
        }

        if (typeof payload['actions'] != 'undefined') {
            if (typeof payload['actions'][1]['action'] != 'undefined') {
                var button_2_action = payload['actions'][1]['action'];
            } else {
                button_2_action = '';
            }
        } else {
            button_2_action = '';
        }


        if (typeof payload['actions'] != 'undefined') {
            if (typeof payload['actions'][1]['icon'] != 'undefined') {
                var button_2_icon = payload['actions'][1]['icon'];
            } else {
                button_2_icon = '';
            }
        } else {
            button_2_icon = '';
        }


        base_url = payload['base_url'];
        click_url = payload['click_url'];
//        shop_url = payload['shop_url'];
        push_id = payload['push_id'];
        
        console.log(button_1_title);
        console.log(button_2_title);
        
        if (button_1_title != '' && button_2_title != '') {
        var push = {
            link: payload['link'],
            //image: payload['hero_image'],
                actions: [
                    {action: button_1_action, title: button_1_title,
                        icon: button_1_icon},
                    {action: button_2_action, title: button_2_title,
                        icon: button_2_icon},
                ],
        };
        } else if(button_1_title != '' && button_2_title == ''){
            var push = {
                link: payload['link'],
                //image: payload['hero_image'],
                actions: [
                    {action: button_1_action, title: button_1_title,
                        icon: button_1_icon},
                    ],
            };
        } else if(button_1_title == '' && button_2_title != ''){
            var push = {
                link: payload['link'],
                //image: payload['hero_image'],
                actions: [
                    {action: button_2_action, title: button_2_title,
                        icon: button_2_icon},
                    ],
            };
        } else {
            var push = {
                link: payload['link'],
            };
        }
        var browser_parser = new UAParser();
        browser = browser_parser.getBrowser();
        
        if (browser['name'] == 'Firefox' || browser['name'] == 'firefox') {
            var push = {
                link: payload['link'],
            };
        }

        if (button_1_action !== '' || button_1_title !== '') {
            is_button = 1;
        } else if (button_2_action !== '' || button_2_title !== '') {
            is_button = 1;
        } else {
            is_button = 0;
        }
        event.waitUntil(showNotification(payload['title'], payload['body'], payload['icon'], push));
    }
});

function checkUpdate(force_update) {

    if (force_update && self.registration) {
        self.registration.update();
    }
}

function showNotification(title, message, icon, push) {
    var options = {
        body: message,
        icon: icon,
        requireInteraction: true,
        data: JSON.stringify(push)
    };
    if (push.image) {
        options.image = push.image;
    }
    if (push.actions) {
        options.actions = push.actions;
    }

    console.log(options);
    return self.registration.showNotification(title, options);
}

// The user has clicked on the notification ...
self.addEventListener('notificationclick', function (event) {
    var push = JSON.parse(event.notification.data);
    
    if (push.actions) {
        if (event.action != '') {
            push.link = event.action;
        } else {
            push.link = push.link;
    }
    }
//    alert('test123');
//console.log("clicked");
//    api_url = base_url + "shopify/saveClickAction";
    fetch(
            click_url +
            '&push_id=' + push_id
            ).then(
            function (response) {
//                if (response.status !== 200) {
//                    console.log('[Firepush SW] close push error: ' + response.status);
//                    throw new Error();
//                }
            }
    );
    


    // Android doesn't close the notification when you click on it  
    // See: http://crbug.com/463146  
    if (is_button == 0) {
    event.notification.close();
    }
    // This looks to see if the current is already open and  
    // focuses if it is  
    event.waitUntil(clients.matchAll({
        type: "window"
    }).then(function (clientList) {
        for (var i = 0; i < clientList.length; i++) {
            var client = clientList[i];
            if (client.url == push.link && 'focus' in client) {
                return client.focus();
            }
        }
        if (clients.openWindow) {
            return clients.openWindow(push.link);
        }
    }));
});

self.addEventListener('notificationclose', function (event) {
//    console.log('[Webpush SW] push closed');
    var push = JSON.parse(event.notification.data);
//    console.log(push);
});