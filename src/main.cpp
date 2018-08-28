#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QDebug>

#ifdef UBUNTU_TOUCH_SUPPORT
#include <QByteArray>
#include <QString>

#define ENV_GRID_UNIT_PX "GRID_UNIT_PX"
#define DEFAULT_GRID_UNIT_PX 8

void fixHighDpiUbuntuTouch() {
    // Qt's builtin High Dpi support does not work on Ubuntu touch, yet.
    // Therefore we workaround by manually setting QT_SCALE_FACTOR.
    int gridUnitPixel = qgetenv(ENV_GRID_UNIT_PX).toInt();
    double scaleFactor = (double)gridUnitPixel / DEFAULT_GRID_UNIT_PX;
    qputenv("QT_SCALE_FACTOR", QString::number(scaleFactor).toUtf8());
}
#endif

int main(int argc, char *argv[])
{
    // Enabled high dpi scaling
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef UBUNTU_TOUCH_SUPPORT
    fixHighDpiUbuntuTouch();
#endif

    // Set Material Design QtQuick Controls 2 style
    qputenv("QT_QUICK_CONTROLS_STYLE", "material");

    QGuiApplication app(argc, argv);

    qDebug() << "Locale:" << QLocale::system().name();

    QTranslator translator;
    if(translator.load(QLocale::system().name(), ":/translations")) {
        qDebug() << "Installing translator ...";
        app.installTranslator(&translator);
        qDebug() << "Translator installed.";
    } else {
        qDebug() << "Translation file not loaded.";
    }

#ifdef UBUNTU_TOUCH_SUPPORT
    // We may only write configuration to ~/.config/switch-reloaded.timsueberkrueb on Ubuntu touch.
    // Settings will be stored in ~/.config/[organizationName]/[applicationName].conf
    // Therefore set the organization to the app name on Ubuntu touch:
    app.setOrganizationName("switch-reloaded.timsueberkrueb");
#else
    app.setOrganizationName("timsueberkrueb");
#endif
    app.setApplicationName("switch-reloaded.timsueberkrueb");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/app/Main.qml")));

    return app.exec();
}
