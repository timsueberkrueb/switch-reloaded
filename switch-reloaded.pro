QT += qml quick svg

CONFIG += c++11

SOURCES += src/main.cpp \

RESOURCES += src/app/app.qrc \
             src/logic/logic.qrc \
             src/controls/controls.qrc \
             res/images/images.qrc \
             res/translations/translations.qrc \
             res/icons/icons.qrc \
             res/switch/icon.qrc \

TRANSLATIONS += res/translations/switch-reloaded.ts \
                res/translations/de_DE.ts \

DISTFILES += \
    src/logic/qmldir \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle \

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /usr/bin
!isEmpty(target.path): INSTALLS += target

unix:!android: {
    icon.files = res/switch/switch-reloaded.png
    icon.path = /usr/local/share/icons/hicolor/512x512/apps
    INSTALLS += icon

    desktop.path = /usr/share/applications
    desktop.files += res/switch/Switch-Reloaded.desktop
    INSTALLS += desktop
}
