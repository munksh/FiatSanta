import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../components"

Page {
    id: page

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
                title: qsTr("about")
                subtitle: "fiat santa"
            }

            Label {
                x: Theme.horizontalPageMargin
                width: content.width - Theme.horizontalPageMargin * 2
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeMedium
                font.family: FiatSantaTheme.serif
                color: FiatSantaTheme.primaryText
                text: qsTr("Anna must not draw Erik. Grandma has no smartphone. Nobody spends more than two hundred kronor.")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: content.width - Theme.horizontalPageMargin * 2
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: FiatSantaTheme.secondaryText
                text: qsTr("fiat santa draws the family's Secret Santa: who gives a present to whom, with the pairs who must not draw each other kept apart both ways. Where it can, the draw makes one ring through everyone, so nobody draws the person who drew them. Then everyone looks in turn on this phone, or gets a message with a code of their own to open elsewhere.")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: content.width - Theme.horizontalPageMargin * 2
                wrapMode: Text.WordWrap
                textFormat: Text.StyledText
                font.pixelSize: Theme.fontSizeExtraSmall
                color: FiatSantaTheme.secondaryText
                text: qsTr("<b>fiat</b> — Latin, <i>let there be</i>. From <i>fiat lux</i> in the Vulgate: let there be light, and there was light. The first app took the phrase. The rest of the family kept the verb.")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: content.width - Theme.horizontalPageMargin * 2
                wrapMode: Text.WordWrap
                textFormat: Text.StyledText
                font.pixelSize: Theme.fontSizeExtraSmall
                color: FiatSantaTheme.secondaryText
                text: qsTr("<b>santa</b> — the one name in the family that is not Latin, though it is a letter short of it: <i>sancta</i>, holy. <i>Sanctus Nicolaus</i>, the bishop of Myra, became Sinterklaas in Dutch and Santa Claus in New York.")
            }

            Item { width: 1; height: Theme.paddingLarge }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.itemSizeSmall
                height: 1
                color: FiatSantaTheme.innerBorder
            }
            Item { width: 1; height: Theme.paddingMedium }

            Column {
                x: Theme.horizontalPageMargin
                width: content.width - Theme.horizontalPageMargin * 2
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Theme.fontSizeSmall
                    font.family: FiatSantaTheme.serif
                    font.italic: true
                    color: FiatSantaTheme.primaryText
                    text: "Hilarem enim datorem\ndiligit Deus"
                }
                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: FiatSantaTheme.secondaryText
                    text: qsTr("For God loves a cheerful giver.")
                }
                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: FiatSantaTheme.secondaryText
                    text: qsTr("2 Corinthians 9:7, Vulgate")
                }
            }

            Item { width: 1; height: Theme.paddingMedium }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.itemSizeSmall
                height: 1
                color: FiatSantaTheme.innerBorder
            }

            SectionLabel { x: Theme.horizontalPageMargin; text: qsTr("Your data") }

            Label {
                x: Theme.horizontalPageMargin
                width: content.width - Theme.horizontalPageMargin * 2
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: FiatSantaTheme.secondaryText
                text: qsTr("The names, the pairs, the price limit and the draw are kept on the phone, in the app's own storage, until you draw again. Nothing leaves the phone except the messages you send yourself.")
            }
            Label {
                x: Theme.horizontalPageMargin
                width: content.width - Theme.horizontalPageMargin * 2
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: FiatSantaTheme.secondaryText
                text: qsTr("A code holds the giver, the receiver and the price limit, scrambled so a name is not read at a glance. It is not encryption: whoever has a code and really wants to can read it.")
            }
            Label {
                x: Theme.horizontalPageMargin
                width: content.width - Theme.horizontalPageMargin * 2
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: FiatSantaTheme.secondaryText
                text: qsTr("Permissions: none.")
            }

            SectionLabel { x: Theme.horizontalPageMargin; text: qsTr("Made by") }

            Label {
                x: Theme.horizontalPageMargin
                text: "Munkstolen"
                font.pixelSize: Theme.fontSizeMedium
                font.family: FiatSantaTheme.serif
                color: FiatSantaTheme.primaryText
            }
            Label {
                x: Theme.horizontalPageMargin
                text: "Caesar Prometheus Ivarsson"
                font.pixelSize: Theme.fontSizeExtraSmall
                color: FiatSantaTheme.secondaryText
            }

            BackgroundItem {
                width: content.width
                height: Theme.itemSizeMedium
                highlightedColor: FiatSantaTheme.highlightWash
                onClicked: Qt.openUrlExternally("https://munkstolen.se")
                Column {
                    x: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    Label {
                        text: "munkstolen.se"
                        color: FiatSantaTheme.primaryText
                        font.pixelSize: Theme.fontSizeSmall
                    }
                    Label {
                        text: qsTr("Everything else I make")
                        color: FiatSantaTheme.secondaryText
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                }
            }

            BackgroundItem {
                width: content.width
                height: Theme.itemSizeMedium
                highlightedColor: FiatSantaTheme.highlightWash
                onClicked: Qt.openUrlExternally("https://github.com/munksh/FiatSanta")
                Column {
                    x: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    Label {
                        text: "github.com/munksh/FiatSanta"
                        color: FiatSantaTheme.primaryText
                        font.pixelSize: Theme.fontSizeSmall
                    }
                    Label {
                        text: qsTr("Source and issues · MIT licence")
                        color: FiatSantaTheme.secondaryText
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                }
            }

            // -- The family ---------------------------------------------------

            SectionLabel {
                x: Theme.horizontalPageMargin
                text: qsTr("The fiat family")
            }

            Repeater {
                model: [
                    { name: "fiat agenda", what: qsTr("let there be doing — a task list"), icon: "images/family/harbour-fiatagenda.png", url: "https://munkstolen.se" },
                    { name: "fiat margo", what: qsTr("let there be edge — keeps edges"), icon: "images/family/harbour-fiatmargo.png", url: "https://munkstolen.se" },
                    { name: "fiat glossa", what: qsTr("let there be tongue — a translator"), icon: "images/family/harbour-fiatglossa.png", url: "https://munkstolen.se" },
                    { name: "fiat vox", what: qsTr("let there be voice — a chromatic tuner"), icon: "images/family/harbour-fiatvox.png", url: "https://munkstolen.se" },
                    { name: "fiat pons", what: qsTr("let there be bridge — a native Qobuz client"), icon: "images/family/harbour-fiatpons.png", url: "https://munkstolen.se" },
                    { name: "fiat lux", what: qsTr("let there be light — a light meter for film"), icon: "images/family/harbour-fiatlux.png", url: "https://munkstolen.se" },
                    { name: "fiat cor", what: qsTr("let there be heart — a metronome"), icon: "images/family/harbour-fiatcor.png", url: "https://munkstolen.se" },
                    { name: "fiat passus", what: qsTr("let there be step — a step counter - Coming soon"), icon: "images/family/harbour-fiatpassus.png", url: "" },
                    { name: "fiat mos", what: qsTr("let there be habit — a habit tracker"), icon: "images/family/harbour-fiatmos.png", url: "https://munkstolen.se" },
                    { name: "fiat imago", what: qsTr("let there be image — a raw editor"), icon: "images/family/harbour-fiatimago.png", url: "https://munkstolen.se" },
                    { name: "fiat ratio", what: qsTr("let there be reckoning — a budget tool"), icon: "images/family/harbour-fiatratio.png", url: "https://munkstolen.se" },
                    { name: "fiat penus", what: qsTr("let there be provisions — a pantry client"), icon: "images/family/harbour-fiatpenus.png", url: "https://munkstolen.se" },
                    { name: "fiat tessera", what: qsTr("let there be token — a card wallet"), icon: "images/family/harbour-fiattessera.png", url: "https://munkstolen.se" },
                    { name: "fiat santa", what: qsTr("let there be santa — this one"), icon: "images/family/harbour-fiatsanta.png", url: "" }
                ]

                // A full-size icon in a row of its own height, rather than an
                // icon shrunk to the height of two lines of text. The icon is
                // the app's face; it should be readable.
                delegate: BackgroundItem {
                    width: content.width
                    height: Theme.itemSizeMedium
                    enabled: modelData.url !== ""
                    highlightedColor: FiatSantaTheme.highlightWash
                    onClicked: Qt.openUrlExternally(modelData.url)

                    Image {
                        id: familyIcon
                        x: Theme.horizontalPageMargin
                        anchors.verticalCenter: parent.verticalCenter
                        width: Theme.itemSizeSmall
                        height: Theme.itemSizeSmall
                        sourceSize.width: Theme.itemSizeSmall
                        sourceSize.height: Theme.itemSizeSmall
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        source: Qt.resolvedUrl(modelData.icon)
                    }

                    Column {
                        anchors.left: familyIcon.right
                        anchors.leftMargin: Theme.paddingLarge
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.horizontalPageMargin
                        anchors.verticalCenter: parent.verticalCenter

                        Label {
                            width: parent.width
                            font.pixelSize: Theme.fontSizeSmall
                            font.family: FiatSantaTheme.serif
                            color: modelData.url !== "" ? FiatSantaTheme.accent : FiatSantaTheme.primaryText
                            text: modelData.name
                        }

                        Label {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: FiatSantaTheme.secondaryText
                            text: modelData.what
                        }
                    }
                }
            }

            Item { width: 1; height: Theme.paddingMedium }

            // -- Version ---------------------------------------------------
            //
            // Last, because it is support and not identity. The number comes
            // from the rpm spec by way of qmake, so it is the one the package
            // was actually built with rather than one written down twice.

            SectionLabel {
                x: Theme.horizontalPageMargin
                text: qsTr("Version")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - Theme.horizontalPageMargin * 2
                font.pixelSize: Theme.fontSizeSmall
                color: FiatSantaTheme.primaryText
                text: typeof appVersion !== "undefined" ? appVersion : qsTr("unknown")
            }

            // -- Colophon --------------------------------------------------

            Item { width: 1; height: Theme.itemSizeExtraSmall }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.itemSizeSmall
                height: 1
                color: FiatSantaTheme.innerBorder
            }

            Item { width: 1; height: Theme.paddingLarge }

            MunkstolenMark {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.itemSizeMedium
                frame: "ring"
                color: FiatSantaTheme.makerMark
            }

            Item { width: 1; height: Theme.paddingSmall }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "munkstolen"
                font.pixelSize: Theme.fontSizeSmall
                font.family: FiatSantaTheme.serif
                font.italic: true
                color: FiatSantaTheme.makerMark
            }
        }

        VerticalScrollDecorator { }
    }
}
