import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../components"

// The phone goes round the table. Everyone taps their own name.
Page {
    id: page

    allowedOrientations: defaultAllowedOrientations

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
                title: qsTr("pass the phone")
                subtitle: qsTr("Tap your own name. Hide it again before you pass the phone on.")
            }

            NameWords {
                x: Theme.horizontalPageMargin - Theme.paddingSmall
                width: parent.width - 2 * Theme.horizontalPageMargin + 2 * Theme.paddingSmall
                labels: Santa.names
                fontSize: Theme.fontSizeExtraLarge
                dim: {
                    var d = []
                    for (var i = 0; i < Santa.names.length; i++)
                        if (Santa.seen[Santa.names[i]] === true) d.push(i)
                    return d
                }
                onPicked: {
                    var name = Santa.names[index]
                    pageStack.push(Qt.resolvedUrl("RevealPage.qml"), {
                        "giver": name,
                        "receiver": Santa.receiverOf(name),
                        "budget": Santa.budget.trim(),
                        "passing": true
                    })
                }
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                visible: Santa.seenCount > 0
                wrapMode: Text.WordWrap
                text: qsTr("Names in grey have already looked.")
                color: FiatSantaTheme.secondaryText
                font.pixelSize: Theme.fontSizeExtraSmall
                font.italic: true
            }
        }

        VerticalScrollDecorator { }
    }
}
