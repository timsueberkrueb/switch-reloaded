#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QDebug>

int main(int argc, char *argv[])
{
    // Enabled high dpi scaling
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

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

    app.setOrganizationName("timsueberkrueb");
    app.setApplicationName("switch-reloaded.timsueberkrueb");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/app/Main.qml")));

    return app.exec();
}
