# fiat santa — the family's Secret Santa
TARGET = harbour-fiatsanta

# Version: one source of truth, the spec. The spec passes it to qmake
# (%qmake5 APP_VERSION=%{version}); a plain qmake run in Qt Creator falls back.
isEmpty(APP_VERSION) {
    APP_VERSION = 0.0.0-dev
}
DEFINES += APP_VERSION=\\\"$$APP_VERSION\\\"

CONFIG += sailfishapp sailfishapp_i18n

SOURCES += \
    src/main.cpp

REQUIRED_FILES = \
    $${TARGET}.desktop \
    qml/$${TARGET}.qml \
    qml/qmldir \
    qml/FiatSantaTheme.qml \
    qml/Santa.qml \
    qml/js/santa.js \
    qml/components/PageHead.qml \
    qml/components/DialogHead.qml \
    qml/components/SectionLabel.qml \
    qml/components/EmptyNote.qml \
    qml/components/MunkstolenMark.qml \
    qml/components/LinkText.qml \
    qml/components/FiatButton.qml \
    qml/components/FiatBackground.qml \
    qml/components/NameWords.qml \
    qml/pages/MainPage.qml \
    qml/pages/images/family/harbour-fiatsanta.png \
    qml/pages/images/family/harbour-fiatagenda.png \
    qml/pages/images/family/harbour-fiatcor.png \
    qml/pages/images/family/harbour-fiatglossa.png \
    qml/pages/images/family/harbour-fiatimago.png \
    qml/pages/images/family/harbour-fiatlux.png \
    qml/pages/images/family/harbour-fiatmargo.png \
    qml/pages/images/family/harbour-fiatmos.png \
    qml/pages/images/family/harbour-fiatpenus.png \
    qml/pages/images/family/harbour-fiatpons.png \
    qml/pages/images/family/harbour-fiatpassus.png \
    qml/pages/images/family/harbour-fiatratio.png \
    qml/pages/images/family/harbour-fiattessera.png \
    qml/pages/images/family/harbour-fiatvox.png \
    LICENSE
for(f, REQUIRED_FILES) {
    !exists($$PWD/$$f): error("Missing $$f -- expected it at $$PWD/$$f")
}

DISTFILES += \
    qml/harbour-fiatsanta.qml \
    qml/FiatSantaTheme.qml \
    qml/Santa.qml \
    qml/qmldir \
    qml/cover/*.qml \
    qml/pages/*.qml \
    qml/components/*.qml \
    qml/js/*.js \
    qml/pages/images/family/*.png \
    rpm/harbour-fiatsanta.spec \
    harbour-fiatsanta.desktop \
    translations/*.ts \
    README.md

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

licensefile.files = $$PWD/LICENSE
# Harbour installs nothing outside /usr/share/$${TARGET}, so the licence
# goes there and not to /usr/share/licenses.
licensefile.path = /usr/share/$${TARGET}
INSTALLS += licensefile

# The language follows the phone. English is the source.
TRANSLATIONS += \
    translations/harbour-fiatsanta-sv.ts \
    translations/harbour-fiatsanta-fr.ts \
    translations/harbour-fiatsanta-de.ts \
    translations/harbour-fiatsanta-ru.ts \
    translations/harbour-fiatsanta-es.ts \
    translations/harbour-fiatsanta-pt.ts \
    translations/harbour-fiatsanta-it.ts \
    translations/harbour-fiatsanta-zh.ts \
    translations/harbour-fiatsanta-ja.ts
