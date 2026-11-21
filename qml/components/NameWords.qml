import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

// Names one after another, as words. Each stands on a hairline so a name of
// two words reads as one; a chosen one is the house's chosen word: accent,
// bold, underlined in the accent.
Flow {
    id: root

    property var labels: []
    property var on: []        // indices drawn as chosen
    property var dim: []       // indices drawn quietly
    property int fontSize: Theme.fontSizeLarge
    signal picked(int index)

    spacing: Theme.paddingLarge

    Repeater {
        model: root.labels
        delegate: MouseArea {
            id: word
            readonly property bool chosen: root.on.indexOf(index) >= 0
            readonly property bool quiet: root.dim.indexOf(index) >= 0
            width: wordLabel.implicitWidth + Theme.paddingSmall * 2
            height: wordLabel.implicitHeight + Theme.paddingMedium * 2
            onClicked: root.picked(index)

            Rectangle {
                anchors.fill: parent
                radius: Theme.paddingSmall
                color: FiatSantaTheme.highlightWash
                visible: word.pressed && word.containsMouse
            }

            Label {
                id: wordLabel
                anchors.horizontalCenter: parent.horizontalCenter
                y: Theme.paddingSmall
                text: modelData === undefined ? "" : modelData
                color: word.chosen ? FiatSantaTheme.accent
                     : word.quiet ? FiatSantaTheme.secondaryText
                     : FiatSantaTheme.primaryText
                font.pixelSize: root.fontSize
                font.family: FiatSantaTheme.serif
                font.bold: word.chosen
                font.italic: word.quiet && !word.chosen
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: wordLabel.bottom
                anchors.topMargin: Theme.paddingSmall / 2
                width: wordLabel.width
                height: word.chosen ? Math.max(2, Theme.paddingSmall / 2) : 1
                color: word.chosen ? FiatSantaTheme.accent : FiatSantaTheme.innerBorder
            }
        }
    }
}
