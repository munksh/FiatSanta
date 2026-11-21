import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../components"

// One person's draw. Passing the phone, it asks first, so the name is not on
// the screen while the phone is still on its way. From a code it shows at
// once. Either way it closes itself if the app leaves the screen.
Page {
    id: page

    property string giver: ""
    property string receiver: ""
    property string budget: ""
    property bool passing: false

    property bool shown: !passing

    allowedOrientations: defaultAllowedOrientations

    function paint() { FiatSantaTheme.applyPalette(page) }
    Component.onCompleted: paint()
    Connections { target: FiatSantaTheme; onAmbientChanged: page.paint() }

    function show() {
        shown = true
        if (passing)
            Santa.markSeen(giver)
    }

    function hide() {
        pageStack.pop()
    }

    Connections {
        target: Qt.application
        onStateChanged: {
            if (Qt.application.state !== Qt.ApplicationActive && page.shown && page.status === PageStatus.Active)
                pageStack.pop(pageStack.previousPage(page), PageStackAction.Immediate)
        }
    }

    FiatBackground { }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height + Theme.paddingLarge

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingLarge

            PageHead {
                title: qsTr("only you")
            }

            // ---- asking ----
            Column {
                width: parent.width
                spacing: Theme.paddingLarge
                visible: !page.shown

                Item { width: 1; height: Theme.itemSizeMedium }

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    //: %1 is the name the person tapped
                    text: qsTr("Are you %1?").arg(page.giver)
                    color: FiatSantaTheme.primaryText
                    font.pixelSize: Theme.fontSizeExtraLarge
                    font.family: FiatSantaTheme.serif
                }

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Only you should see the next screen.")
                    color: FiatSantaTheme.secondaryText
                    font.pixelSize: Theme.fontSizeSmall
                }

                Item { width: 1; height: Theme.itemSizeSmall }

                FiatButton {
                    text: qsTr("yes, show")
                    onClicked: page.show()
                }

                LinkText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("no, back")
                    onClicked: pageStack.pop()
                }
            }

            // ---- showing ----
            Column {
                width: parent.width
                spacing: Theme.paddingLarge
                visible: page.shown

                Item { width: 1; height: Theme.paddingLarge }

                Rectangle {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    height: cardCol.height + 2 * Theme.paddingLarge * 2
                    radius: FiatSantaTheme.cardRadius
                    color: FiatSantaTheme.card
                    border.color: FiatSantaTheme.cardBorder
                    border.width: FiatSantaTheme.cardBorderWidth

                    Column {
                        id: cardCol
                        x: Theme.paddingLarge
                        width: parent.width - 2 * Theme.paddingLarge
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Theme.paddingMedium

                        Label {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            //: Above the name on the card. %1 is the giver.
                            text: qsTr("%1, you give a present to").arg(page.giver)
                            color: FiatSantaTheme.secondaryText
                            font.pixelSize: Theme.fontSizeSmall
                        }
                        Label {
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            text: page.receiver
                            color: FiatSantaTheme.accent
                            font.pixelSize: Theme.fontSizeHuge
                            font.family: FiatSantaTheme.serif
                            fontSizeMode: Text.HorizontalFit
                            minimumPixelSize: Theme.fontSizeLarge
                        }
                        Label {
                            width: parent.width
                            visible: page.budget !== ""
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            text: qsTr("Price limit: %1").arg(page.budget)
                            color: FiatSantaTheme.secondaryText
                            font.pixelSize: Theme.fontSizeSmall
                        }
                    }
                }

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Keep it secret until the presents are opened.")
                    color: FiatSantaTheme.secondaryText
                    font.pixelSize: Theme.fontSizeSmall
                    font.family: FiatSantaTheme.serif
                    font.italic: true
                }

                Item { width: 1; height: Theme.itemSizeSmall }

                FiatButton {
                    text: page.passing ? qsTr("hide and pass on") : qsTr("hide")
                    onClicked: page.hide()
                }
            }
        }

        VerticalScrollDecorator { }
    }
}
