#include <QtGui/QApplication>
#include <QDeclarativeContext>
#include <QFile>
#include <QDebug>
#include "qmlapplicationviewer.h"
#include "settings.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QApplication::setApplicationName("MeeTER");
    QApplication::setApplicationVersion("0.1");

    QmlApplicationViewer viewer;

    Settings settings("MeeTER", "meeter.conf");
    if(!QFile::exists(settings.filePath()))
      {
        if(QFile::copy(":/etc/meeter.conf", settings.filePath()))
          {
            QFile fSettings(settings.filePath());
            fSettings.setPermissions(QFile::ReadOwner | QFile::WriteOwner);
          }
      }

    viewer.rootContext()->setContextProperty("appSettings", &settings);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/MeeTER/main.qml"));

    viewer.showExpanded();

    return app->exec();
}
