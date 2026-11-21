import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../components"

// For the one who got a message: paste it, see who you give to. The code
// carries everything, so this works on any phone with fiat santa, whether it
// did the draw or not.
Page {
    id: page

    allowedOrientations: defaultAllowedOrientations

    property string problem: ""

    function open() {
        var r = Santa.decode(codeArea.text)
        if (r === null) {
            problem = qsTr("That code does not read. Copy the whole message, or everything from SS- to the end.")
            return
        }
        problem = ""
        codeArea.text = ""
        codeArea.focus = false
        pageStack.push(Qt.resolvedUrl("RevealPage.qml"), {
            "giver": r.giver,
            "receiver": r.receiver,
            "budget": r.budget,
            "passing": false
        })
    }

    function paint() { FiatSantaTheme.applyPalette(page) }
    Component.onCompleted: paint()
    Connections { target: FiatSantaTheme; onAmbientChanged: page.paint() }

    FiatBackground { }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height + Theme.paddingLarge

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            PageHead {
                title: qsTr("a code")
                subtitle: qsTr("Paste the message you got.")
            }

            TextArea {
                id: codeArea
                width: parent.width
                label: qsTr("Message or code")
                placeholderText: qsTr("SS-…")
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                onTextChanged: page.problem = ""
            }

            LinkText {
                x: Theme.horizontalPageMargin - Theme.paddingSmall
                visible: codeArea.text === "" && Clipboard.hasText
                text: qsTr("paste")
                onClicked: codeArea.text = Clipboard.text
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                visible: page.problem !== ""
                wrapMode: Text.WordWrap
                text: page.problem
                color: FiatSantaTheme.wrong
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            Item { width: 1; height: Theme.paddingLarge }

            FiatButton {
                text: qsTr("show")
                enabled: codeArea.text.trim() !== ""
                onClicked: page.open()
            }
        }

        VerticalScrollDecorator { }
    }
}
