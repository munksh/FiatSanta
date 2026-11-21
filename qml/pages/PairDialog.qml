import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../components"

// Two people who must not draw each other. Tap two names; a third tap moves
// the second choice.
Dialog {
    id: dialog

    property string first: ""
    property string second: ""

    readonly property bool already: first !== "" && second !== "" && Santa.hasPair(first, second)
    canAccept: first !== "" && second !== "" && !already

    function pick(name) {
        if (name === first) { first = second; second = ""; return }
        if (name === second) { second = ""; return }
        if (first === "") first = name
        else second = name
    }

    onAccepted: Santa.addPair(first, second)

    function paint() { FiatSantaTheme.applyPalette(dialog) }
    Component.onCompleted: paint()
    Connections { target: FiatSantaTheme; onAmbientChanged: dialog.paint() }

    FiatBackground { }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            DialogHead {
                owner: dialog
                title: qsTr("a pair")
                acceptText: qsTr("add")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                text: dialog.already ? qsTr("%1 and %2 are already a pair.").arg(dialog.first).arg(dialog.second)
                                     : qsTr("Pick the two who must not draw each other.")
                color: FiatSantaTheme.secondaryText
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            Item { width: 1; height: Theme.paddingMedium }

            NameWords {
                x: Theme.horizontalPageMargin - Theme.paddingSmall
                width: parent.width - 2 * Theme.horizontalPageMargin + 2 * Theme.paddingSmall
                labels: Santa.names
                on: [Santa.names.indexOf(dialog.first), Santa.names.indexOf(dialog.second)].filter(function (i) { return i >= 0 })
                onPicked: dialog.pick(Santa.names[index])
            }
        }

        VerticalScrollDecorator { }
    }
}
