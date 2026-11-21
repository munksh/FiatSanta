#include <QtQuick>

#include <sailfishapp.h>

#ifndef APP_VERSION
#define APP_VERSION "0.0.0-dev"
#endif

// Exported: the launcher's booster calls main() from outside, and Harbour's
// validator refuses a binary that hides it.
Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setOrganizationName(QStringLiteral("se.munkstolen"));
    app->setApplicationName(QStringLiteral("harbour-fiatsanta"));
    app->setApplicationVersion(QString::fromUtf8(APP_VERSION));

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->rootContext()->setContextProperty(QStringLiteral("appVersion"), QString::fromUtf8(APP_VERSION));
    view->setSource(SailfishApp::pathToMainQml());
    view->show();

    return app->exec();
}
