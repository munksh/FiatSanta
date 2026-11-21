import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../components"

// One message per person, each with their own code, to copy and send however
// the family talks to each other.
Page {
    id: page

    allowedOrientations: defaultAllowedOrientations

    property string copied: ""
    Timer { id: copiedTimer; interval: 4000; onTriggered: page.copied = "" }

    function copy(name) {
        Clipboard.text = Santa.message(name)
        copied = name
        copiedTimer.restart()
    }

    function paint() { FiatSantaTheme.applyPalette(page) }
    Component.onCompleted: paint()
    Connections { target: FiatSantaTheme; onAmbientChanged: page.paint() }

    FiatBackground { }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height + Theme.paddingLarge * 2

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            PageHead {
                title: qsTr("send codes")
                subtitle: qsTr("One message each, to that person only.")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                text: qsTr("sms and email open Messages or Email with the text filled in. Pick who it goes to there.")
                color: FiatSantaTheme.secondaryText
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            Item { width: 1; height: Theme.paddingMedium }

            Repeater {
                model: Santa.names
                delegate: Column {
                    x: Theme.horizontalPageMargin
                    width: content.width - 2 * Theme.horizontalPageMargin
                    spacing: Theme.paddingSmall

                    Label {
                        width: parent.width
                        truncationMode: TruncationMode.Fade
                        text: modelData === undefined ? "" : modelData
                        color: FiatSantaTheme.primaryText
                        font.pixelSize: Theme.fontSizeLarge
                        font.family: FiatSantaTheme.serif
                    }

                    Rectangle {
                        width: parent.width
                        height: messageLabel.height + 2 * Theme.paddingMedium
                        radius: Theme.paddingMedium
                        color: FiatSantaTheme.recessFill
                        border.color: FiatSantaTheme.recessBorder
                        border.width: 1

                        Label {
                            id: messageLabel
                            x: Theme.paddingMedium
                            y: Theme.paddingMedium
                            width: parent.width - 2 * Theme.paddingMedium
                            wrapMode: Text.Wrap
                            text: modelData === undefined ? "" : Santa.message(modelData)
                            color: FiatSantaTheme.secondaryText
                            font.pixelSize: Theme.fontSizeExtraSmall
                        }
                    }

                    Row {
                        x: -Theme.paddingSmall
                        spacing: Theme.paddingLarge
                        LinkText {
                            text: qsTr("sms")
                            onClicked: Santa.sms(modelData)
                        }
                        LinkText {
                            text: qsTr("email")
                            onClicked: Santa.email(modelData)
                        }
                        LinkText {
                            text: page.copied === modelData ? qsTr("copied") : qsTr("copy")
                            underline: page.copied !== modelData
                            italic: page.copied === modelData
                            onClicked: page.copy(modelData)
                        }
                    }

                    Item { width: 1; height: Theme.paddingMedium }
                }
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                text: qsTr("The codes are hidden from the eye, not encrypted. Anyone who really wants to can read someone else's, so send each one only to its person.")
                color: FiatSantaTheme.secondaryText
                font.pixelSize: Theme.fontSizeExtraSmall
                font.italic: true
            }
        }

        VerticalScrollDecorator { }
    }
}
