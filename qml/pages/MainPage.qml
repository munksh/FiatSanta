import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../components"

// The front page. Before the draw: who is taking part, who must not draw whom,
// the price limit and the button. After it: how everyone gets to see theirs.
Page {
    id: page

    allowedOrientations: defaultAllowedOrientations

    property string nameProblem: ""
    property string drawProblem: ""
    property int markedName: -1
    property int markedPair: -1

    function paint() { FiatSantaTheme.applyPalette(page) }
    Component.onCompleted: paint()
    Connections { target: FiatSantaTheme; onAmbientChanged: page.paint() }
    Connections {
        target: Santa
        onNamesChanged: { page.drawProblem = ""; page.markedName = -1 }
        onPairsChanged: { page.drawProblem = ""; page.markedPair = -1 }
    }

    //: Two people who must not draw each other: "Anna and Erik"
    function pairText(p) { return qsTr("%1 and %2").arg(p[0]).arg(p[1]) }

    function addName() {
        nameProblem = Santa.addName(nameField.text)
        if (nameProblem === "")
            nameField.text = ""
    }

    function draw() {
        if (Santa.doDraw()) {
            drawProblem = ""
            flick.scrollToTop()
        } else {
            drawProblem = qsTr("These pairs leave no possible draw. Remove a pair and try again.")
        }
    }

    FiatBackground { }

    RemorsePopup { id: remorse }

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: content.height + Theme.paddingLarge * 2

        PullDownMenu {
            highlightColor: FiatSantaTheme.chromeAccent

            MenuItem {
                text: qsTr("About")
                color: FiatSantaTheme.primaryText
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: FiatSantaTheme.ambient ? qsTr("Fiat colours") : qsTr("Follow ambience")
                color: FiatSantaTheme.primaryText
                onClicked: FiatSantaTheme.setAmbient(!FiatSantaTheme.ambient)
            }
            MenuItem {
                text: qsTr("I have a code")
                color: FiatSantaTheme.primaryText
                onClicked: pageStack.push(Qt.resolvedUrl("CodePage.qml"))
            }
            MenuItem {
                visible: Santa.drawn
                text: qsTr("Change names and draw again")
                color: FiatSantaTheme.primaryText
                onClicked: remorse.execute(qsTr("Clearing the draw"), function () { Santa.clearDraw() })
            }
        }

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            // ---- wordmark ----
            Item {
                width: parent.width
                height: FiatSantaTheme.statusRowCenter + wordmark.height / 2 + Theme.paddingMedium
                Text {
                    id: wordmark
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    anchors.top: parent.top
                    anchors.topMargin: Math.max(0, FiatSantaTheme.statusRowCenter - height / 2)
                    text: "fiat santa"
                    color: FiatSantaTheme.primaryText
                    font.pixelSize: Theme.fontSizeLarge
                    font.family: FiatSantaTheme.serif
                    font.italic: true
                }
            }

            // ---- before the draw ----
            Column {
                width: parent.width
                spacing: Theme.paddingMedium
                visible: !Santa.drawn

                SectionLabel { x: Theme.horizontalPageMargin; text: qsTr("Taking part") }

                TextField {
                    id: nameField
                    width: parent.width
                    label: qsTr("Name")
                    placeholderText: qsTr("Add a name")
                    // Predictive text holds the last word back until a
                    // space; the name would be added without it.
                    inputMethodHints: Qt.ImhNoPredictiveText
                    onTextChanged: page.nameProblem = ""
                    EnterKey.enabled: text.trim() !== ""
                    EnterKey.iconSource: "image://theme/icon-m-add"
                    EnterKey.onClicked: page.addName()
                    rightItem: IconButton {
                        icon.source: "image://theme/icon-m-add"
                        enabled: nameField.text.trim() !== ""
                        opacity: enabled ? 1.0 : 0.35
                        onClicked: page.addName()
                    }
                }

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    visible: page.nameProblem !== ""
                    wrapMode: Text.WordWrap
                    text: page.nameProblem
                    color: FiatSantaTheme.wrong
                    font.pixelSize: Theme.fontSizeExtraSmall
                }

                NameWords {
                    x: Theme.horizontalPageMargin - Theme.paddingSmall
                    width: parent.width - 2 * Theme.horizontalPageMargin + 2 * Theme.paddingSmall
                    visible: Santa.count > 0
                    labels: Santa.names
                    on: page.markedName >= 0 ? [page.markedName] : []
                    onPicked: page.markedName = (index === page.markedName ? -1 : index)
                }

                LinkText {
                    x: Theme.horizontalPageMargin - Theme.paddingSmall
                    visible: page.markedName >= 0 && page.markedName < Santa.count
                    //: %1 is a name, or a pair such as "Anna and Erik"
                    text: visible ? qsTr("remove %1").arg(Santa.names[page.markedName]) : ""
                    color: FiatSantaTheme.wrong
                    onClicked: Santa.removeName(Santa.names[page.markedName])
                }

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    wrapMode: Text.WordWrap
                    text: Santa.count === 0 ? qsTr("Add at least three people.")
                          : Santa.count < 3 ? qsTr("Add at least three people. Tap a name to remove it.")
                          : qsTr("%1 people. Tap a name to remove it.").arg(Santa.count)
                    color: FiatSantaTheme.secondaryText
                    font.pixelSize: Theme.fontSizeExtraSmall
                }

                Item { width: 1; height: Theme.paddingMedium }

                SectionLabel { x: Theme.horizontalPageMargin; text: qsTr("Not each other") }

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    wrapMode: Text.WordWrap
                    text: qsTr("Couples, for example. It works both ways.")
                    color: FiatSantaTheme.secondaryText
                    font.pixelSize: Theme.fontSizeExtraSmall
                }

                NameWords {
                    x: Theme.horizontalPageMargin - Theme.paddingSmall
                    width: parent.width - 2 * Theme.horizontalPageMargin + 2 * Theme.paddingSmall
                    visible: Santa.pairs.length > 0
                    labels: Santa.pairs.map(function (p) { return page.pairText(p) })
                    on: page.markedPair >= 0 ? [page.markedPair] : []
                    fontSize: Theme.fontSizeMedium
                    onPicked: page.markedPair = (index === page.markedPair ? -1 : index)
                }

                LinkText {
                    x: Theme.horizontalPageMargin - Theme.paddingSmall
                    visible: page.markedPair >= 0 && page.markedPair < Santa.pairs.length
                    text: visible ? qsTr("remove %1").arg(page.pairText(Santa.pairs[page.markedPair])) : ""
                    color: FiatSantaTheme.wrong
                    onClicked: Santa.removePair(page.markedPair)
                }

                LinkText {
                    x: Theme.horizontalPageMargin - Theme.paddingSmall
                    visible: Santa.count >= 3
                    text: qsTr("+ a pair")
                    onClicked: pageStack.push(Qt.resolvedUrl("PairDialog.qml"))
                }
                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    visible: Santa.count < 3
                    wrapMode: Text.WordWrap
                    text: qsTr("Pairs can be added once three names are in.")
                    color: FiatSantaTheme.secondaryText
                    font.pixelSize: Theme.fontSizeExtraSmall
                    font.italic: true
                }

                Item { width: 1; height: Theme.paddingMedium }

                SectionLabel { x: Theme.horizontalPageMargin; text: qsTr("Price limit") }

                TextField {
                    id: budgetField
                    width: parent.width
                    text: Santa.budget
                    label: qsTr("Price limit, if any")
                    placeholderText: qsTr("200 kr, for example")
                    onTextChanged: Santa.setBudget(text)
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: budgetField.focus = false
                }

                Item { width: 1; height: Theme.paddingLarge }

                FiatButton {
                    text: qsTr("draw")
                    enabled: Santa.count >= 3
                    onClicked: page.draw()
                }

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    visible: page.drawProblem !== ""
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    text: page.drawProblem
                    color: FiatSantaTheme.wrong
                    font.pixelSize: Theme.fontSizeSmall
                }
            }

            // ---- after the draw ----
            Column {
                width: parent.width
                spacing: Theme.paddingMedium
                visible: Santa.drawn

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    wrapMode: Text.WordWrap
                    text: qsTr("The draw is done.")
                    color: FiatSantaTheme.primaryText
                    font.pixelSize: Theme.fontSizeExtraLarge
                    font.family: FiatSantaTheme.serif
                }

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    wrapMode: Text.WordWrap
                    text: Santa.seenCount === 0
                          ? qsTr("%1 people are in the draw. Nobody has looked yet.").arg(Santa.count)
                          : Santa.seenCount === Santa.count
                            ? qsTr("Everyone has looked on this phone.")
                            : qsTr("%1 of %2 have looked on this phone.").arg(Santa.seenCount).arg(Santa.count)
                    color: FiatSantaTheme.secondaryText
                    font.pixelSize: Theme.fontSizeSmall
                }

                Item { width: 1; height: Theme.paddingLarge }

                SectionLabel {
                    x: Theme.horizontalPageMargin
                    text: qsTr("How will everyone see who they got?")
                }

                Repeater {
                    model: [
                        { title: qsTr("pass the phone"), detail: qsTr("Everyone looks in turn, on this phone."), page: "PassPage.qml" },
                        { title: qsTr("send codes"), detail: qsTr("Everyone gets a message with a code to open on their own phone."), page: "CodesPage.qml" }
                    ]
                    delegate: BackgroundItem {
                        width: content.width
                        height: choiceCol.height + 2 * Theme.paddingLarge
                        highlightedColor: FiatSantaTheme.highlightWash
                        onClicked: pageStack.push(Qt.resolvedUrl(modelData.page))

                        Column {
                            id: choiceCol
                            x: Theme.horizontalPageMargin
                            width: parent.width - 2 * Theme.horizontalPageMargin
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: Theme.paddingSmall / 2
                            Label {
                                width: parent.width
                                text: modelData.title
                                color: FiatSantaTheme.accent
                                font.pixelSize: Theme.fontSizeLarge
                                font.family: FiatSantaTheme.serif
                            }
                            Label {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: modelData.detail
                                color: FiatSantaTheme.secondaryText
                                font.pixelSize: Theme.fontSizeExtraSmall
                            }
                        }
                    }
                }

                Item { width: 1; height: Theme.paddingLarge }

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    visible: Santa.budget.trim() !== ""
                    wrapMode: Text.WordWrap
                    text: qsTr("Price limit: %1").arg(Santa.budget.trim())
                    color: FiatSantaTheme.secondaryText
                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }
        }

        VerticalScrollDecorator { }
    }
}
