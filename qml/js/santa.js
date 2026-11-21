.pragma library

// The draw and the codes. Pure functions, no storage.
//
// A code is the giver, the receiver and the price limit joined by tabs, as
// UTF-8, XOR-ed with a fixed key and written as URL-safe base64 after "SS-".
// The same format as the web version of the family's Secret Santa, so a code
// made here opens there and the other way round. It hides a name from a
// glance; it is not encryption.

var XORKEY = "munkstolen-santa"
var B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

// ---- the draw ----

function shuffle(a) {
    a = a.slice()
    for (var i = a.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1))
        var t = a[i]; a[i] = a[j]; a[j] = t
    }
    return a
}

// names: [string]; pairs: [[a, b]] who must not draw each other, either way.
// Returns { giver: receiver } or null when no draw is possible.
function draw(names, pairs) {
    var n = names.length, bad = {}, t, i, o, good, map
    for (i = 0; i < pairs.length; i++) {
        bad[pairs[i][0] + "\u0000" + pairs[i][1]] = 1
        bad[pairs[i][1] + "\u0000" + pairs[i][0]] = 1
    }
    function ok(g, r) { return g !== r && !bad[g + "\u0000" + r] }

    // One ring through everyone first, so nobody draws the person who drew them.
    for (t = 0; t < 20000; t++) {
        o = shuffle(names); good = true
        for (i = 0; i < n; i++) { if (!ok(o[i], o[(i + 1) % n])) { good = false; break } }
        if (good) {
            map = {}
            for (i = 0; i < n; i++) map[o[i]] = o[(i + 1) % n]
            return map
        }
    }
    // Failing that, any draw that keeps the pairs apart.
    for (t = 0; t < 20000; t++) {
        o = shuffle(names); good = true
        for (i = 0; i < n; i++) { if (!ok(names[i], o[i])) { good = false; break } }
        if (good) {
            map = {}
            for (i = 0; i < n; i++) map[names[i]] = o[i]
            return map
        }
    }
    return null
}

// ---- UTF-8 ----

function utf8Encode(s) {
    var out = []
    for (var i = 0; i < s.length; i++) {
        var c = s.charCodeAt(i)
        if (c >= 0xD800 && c <= 0xDBFF && i + 1 < s.length) {
            var d = s.charCodeAt(i + 1)
            if (d >= 0xDC00 && d <= 0xDFFF) {
                c = 0x10000 + ((c - 0xD800) << 10) + (d - 0xDC00)
                i++
            } else {
                c = 0xFFFD
            }
        } else if (c >= 0xD800 && c <= 0xDFFF) {
            c = 0xFFFD
        }
        if (c < 0x80) {
            out.push(c)
        } else if (c < 0x800) {
            out.push(0xC0 | (c >> 6), 0x80 | (c & 63))
        } else if (c < 0x10000) {
            out.push(0xE0 | (c >> 12), 0x80 | ((c >> 6) & 63), 0x80 | (c & 63))
        } else {
            out.push(0xF0 | (c >> 18), 0x80 | ((c >> 12) & 63), 0x80 | ((c >> 6) & 63), 0x80 | (c & 63))
        }
    }
    return out
}

// Strict: anything that is not well-formed UTF-8 throws, as the web version's
// TextDecoder does with fatal: true.
function utf8Decode(b) {
    var s = "", i = 0
    while (i < b.length) {
        var c = b[i++], need, min
        if (c < 0x80) { s += String.fromCharCode(c); continue }
        else if (c >= 0xC2 && c <= 0xDF) { need = 1; min = 0x80; c &= 0x1F }
        else if (c >= 0xE0 && c <= 0xEF) { need = 2; min = 0x800; c &= 0x0F }
        else if (c >= 0xF0 && c <= 0xF4) { need = 3; min = 0x10000; c &= 0x07 }
        else throw new Error("utf8")
        if (i + need > b.length) throw new Error("utf8")
        for (var k = 0; k < need; k++) {
            var x = b[i++]
            if ((x & 0xC0) !== 0x80) throw new Error("utf8")
            c = (c << 6) | (x & 63)
        }
        if (c < min || c > 0x10FFFF || (c >= 0xD800 && c <= 0xDFFF)) throw new Error("utf8")
        if (c >= 0x10000) {
            c -= 0x10000
            s += String.fromCharCode(0xD800 + (c >> 10), 0xDC00 + (c & 0x3FF))
        } else {
            s += String.fromCharCode(c)
        }
    }
    return s
}

// ---- base64 ----

function b64Encode(bytes) {
    var s = ""
    for (var i = 0; i < bytes.length; i += 3) {
        var a = bytes[i], b = bytes[i + 1], c = bytes[i + 2]
        var n = (a << 16) | ((b || 0) << 8) | (c || 0)
        s += B64.charAt((n >> 18) & 63) + B64.charAt((n >> 12) & 63)
        s += i + 1 < bytes.length ? B64.charAt((n >> 6) & 63) : "="
        s += i + 2 < bytes.length ? B64.charAt(n & 63) : "="
    }
    return s
}

function b64Decode(s) {
    s = s.replace(/=+$/, "")
    if (s.length % 4 === 1) throw new Error("b64")
    var out = [], bits = 0, acc = 0
    for (var i = 0; i < s.length; i++) {
        var v = B64.indexOf(s.charAt(i))
        if (v < 0) throw new Error("b64")
        acc = (acc << 6) | v
        bits += 6
        if (bits >= 8) {
            bits -= 8
            out.push((acc >> bits) & 0xFF)
        }
    }
    return out
}

// ---- codes ----

function encode(giver, receiver, budget) {
    var bytes = utf8Encode([giver, receiver, budget || ""].join("\t"))
    for (var i = 0; i < bytes.length; i++)
        bytes[i] ^= XORKEY.charCodeAt(i % XORKEY.length)
    return "SS-" + b64Encode(bytes).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "")
}

// Finds the code anywhere in what was pasted, so a whole message works too,
// and a code a messenger broke over two lines. Returns { giver, receiver,
// budget } or null.
function decode(text) {
    var t = String(text)
    var found = (t.match(/SS-[A-Za-z0-9_\-]+/g) || [])
            .concat(t.replace(/\s+/g, "").match(/SS-[A-Za-z0-9_\-]+/g) || [])
    for (var i = 0; i < found.length; i++) {
        var r = decodeOne(found[i])
        if (r !== null) return r
    }
    return null
}

function decodeOne(code) {
    try {
        var b = code.slice(3).replace(/-/g, "+").replace(/_/g, "/")
        var bytes = b64Decode(b)
        for (var i = 0; i < bytes.length; i++)
            bytes[i] ^= XORKEY.charCodeAt(i % XORKEY.length)
        var parts = utf8Decode(bytes).split("\t")
        if (parts.length < 2 || !parts[0] || !parts[1]) return null
        return { giver: parts[0], receiver: parts[1], budget: parts[2] || "" }
    } catch (e) {
        return null
    }
}
