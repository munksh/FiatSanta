pragma Singleton
import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import "js/santa.js" as S

// The one draw the app keeps: who is taking part, who must not draw whom, the
// price limit, the draw itself and who has looked. A singleton, so the pages
// and the cover read the same thing.
//
// Lists and maps are replaced, never changed in place: a binding does not see
// a change inside a var.
QtObject {
    id: santa

    property var names: []
    property var pairs: []
    property string budget: ""

    // The code page, for everyone without fiat santa. The code rides in the
    // link after the #, which a browser never sends to the server.
    readonly property string web: "https://munkstolen.se/secret-santa-c.html"
    property var result: null
    property var seen: ({})

    readonly property bool drawn: result !== null && result !== undefined
    readonly property int count: names.length
    readonly property int seenCount: {
        var n = 0
        for (var i = 0; i < names.length; i++)
            if (seen[names[i]] === true) n++
        return n
    }

    // ---- storage ----

    function db() {
        var d = LocalStorage.openDatabaseSync("FiatSanta", "", "fiat santa", 100000)
        d.transaction(function (tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS state (k TEXT PRIMARY KEY, v TEXT)")
        })
        return d
    }

    function save() {
        var s = JSON.stringify({ names: names, pairs: pairs, budget: budget,
                                 result: result, seen: seen })
        db().transaction(function (tx) {
            tx.executeSql("INSERT OR REPLACE INTO state (k, v) VALUES ('draw', ?)", [s])
        })
    }

    function load() {
        var raw = ""
        try {
            db().readTransaction(function (tx) {
                var rs = tx.executeSql("SELECT v FROM state WHERE k = 'draw'")
                if (rs.rows.length > 0) raw = rs.rows.item(0).v
            })
        } catch (e) { raw = "" }
        if (!raw) return
        var s = null
        try { s = JSON.parse(raw) } catch (e) { s = null }
        if (s === null || !Array.isArray(s.names)) return

        var ns = s.names.filter(function (n) { return typeof n === "string" && n !== "" })
        var ps = Array.isArray(s.pairs) ? s.pairs.filter(function (p) {
            return Array.isArray(p) && ns.indexOf(p[0]) >= 0 && ns.indexOf(p[1]) >= 0
        }) : []
        var r = s.result && typeof s.result === "object" ? s.result : null
        // A draw that does not cover exactly these names is not trusted.
        if (r !== null) {
            for (var i = 0; i < ns.length; i++)
                if (typeof r[ns[i]] !== "string" || ns.indexOf(r[ns[i]]) < 0) { r = null; break }
            if (r !== null && Object.keys(r).length !== ns.length) r = null
        }
        names = ns
        pairs = ps
        budget = typeof s.budget === "string" ? s.budget : ""
        result = r
        seen = r !== null && s.seen && typeof s.seen === "object" ? s.seen : ({})
    }

    Component.onCompleted: load()

    // ---- names and pairs ----

    function clean(name) { return String(name).replace(/\s+/g, " ").trim() }

    // "" when added, else the reason it was not.
    function addName(name) {
        var v = clean(name)
        if (v === "") return ""
        for (var i = 0; i < names.length; i++)
            if (names[i].toLowerCase() === v.toLowerCase())
                //: %1 is a name already on the list
                return qsTr("%1 is already there. Add a surname or an initial.").arg(v)
        names = names.concat([v])
        save()
        return ""
    }

    function removeName(name) {
        names = names.filter(function (n) { return n !== name })
        pairs = pairs.filter(function (p) { return p[0] !== name && p[1] !== name })
        save()
    }

    function hasPair(a, b) {
        for (var i = 0; i < pairs.length; i++)
            if ((pairs[i][0] === a && pairs[i][1] === b) || (pairs[i][0] === b && pairs[i][1] === a))
                return true
        return false
    }

    function addPair(a, b) {
        if (a === b || hasPair(a, b)) return
        pairs = pairs.concat([[a, b]])
        save()
    }

    function removePair(index) {
        var p = pairs.slice()
        p.splice(index, 1)
        pairs = p
        save()
    }

    function setBudget(v) {
        if (v === budget) return
        budget = v
        save()
    }

    // ---- the draw ----

    // true when drawn; false when the pairs leave no possible draw.
    function doDraw() {
        var r = S.draw(names, pairs)
        if (r === null) return false
        result = r
        seen = ({})
        save()
        return true
    }

    function clearDraw() {
        result = null
        seen = ({})
        save()
    }

    function receiverOf(name) { return drawn ? (result[name] || "") : "" }

    function markSeen(name) {
        var s = {}
        for (var k in seen) s[k] = seen[k]
        s[name] = true
        seen = s
        save()
    }

    // ---- codes ----

    function codeFor(name) { return S.encode(name, receiverOf(name), budget) }
    function decode(text) { return S.decode(text) }

    function message(name) {
        //: The first line of the message sent to each person. %1 is their name.
        var m = qsTr("Hi %1! You are in the family's Secret Santa.").arg(name) + "\n"
        m += qsTr("Open the link to see who you give a present to:") + "\n"
        m += web + "#"
        m += codeFor(name)
        return m
    }

    // ---- sending ----
    // The phone's own Messages and Email open with the text filled in; who it
    // goes to is picked there. Reading contacts here would take a permission
    // Harbour does not give.

    function sms(name) {
        Qt.openUrlExternally("sms:?body=" + encodeURIComponent(message(name)))
    }

    function email(name) {
        Qt.openUrlExternally("mailto:?subject=" + encodeURIComponent(qsTr("Secret Santa"))
                             + "&body=" + encodeURIComponent(message(name)))
    }
}
