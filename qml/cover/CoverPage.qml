// How many are in the draw, and whether it is done. Never who got whom.
// No actions: everything here wants the whole screen and a hidden one.
import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../components"

CoverBackground {
    id: cover

    // ---- state ----
    readonly property int count: Santa.count
    readonly property bool drawn: Santa.drawn
    readonly property int looked: Santa.seenCount

    // ---- paper ----
    FiatBackground { }

    // ---- wordmark ----
    Label {
        anchors.top: parent.top
        anchors.topMargin: FiatSantaTheme.coverWordmarkTop
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        text: "fiat santa"
        color: FiatSantaTheme.secondaryText
        font.pixelSize: Theme.fontSizeTiny
        font.family: FiatSantaTheme.serif
        font.italic: true
    }

    // ---- figure ----
    Column {
        y: cover.height * FiatSantaTheme.coverFigureFraction
        x: FiatSantaTheme.coverSideMargin
        width: parent.width - 2 * FiatSantaTheme.coverSideMargin
        spacing: Theme.paddingSmall
        visible: cover.count > 0

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: cover.count
            color: FiatSantaTheme.accent
            font.pixelSize: FiatSantaTheme.coverFigureSize
            font.family: FiatSantaTheme.serif
        }
        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: !cover.drawn ? qsTr("taking part")
                 : cover.looked === 0 ? qsTr("drawn")
                 //: Cover: "drawn · 3 looked"
                 : qsTr("drawn · %1 looked").arg(cover.looked)
            color: FiatSantaTheme.secondaryText
            font.pixelSize: Theme.fontSizeExtraSmall
        }
    }
    Label {
        y: cover.height * FiatSantaTheme.coverFigureFraction
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        visible: cover.count === 0
        text: qsTr("nobody yet")
        color: FiatSantaTheme.secondaryText
        font.pixelSize: Theme.fontSizeSmall
        font.family: FiatSantaTheme.serif
        font.italic: true
    }
}
