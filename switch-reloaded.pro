TEMPLATE = app
TARGET = switch-reloaded

load(ubuntu-click)

UBUNTU_MANIFEST_FILE = click/manifest.json

QT += qml quick svg xml quickcontrols2

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


isEmpty(UBUNTU_CLICK_BINARY_PATH) {
    unix:!android: {
        target.path = /usr/bin

        icon.files = res/switch/switch-reloaded.png
        icon.path = /usr/local/share/icons/hicolor/512x512/apps

        desktop.path = /usr/share/applications
        desktop.files += res/switch/Switch-Reloaded.desktop
        INSTALLS += desktop
    }
} else {
    target.path = $${UBUNTU_CLICK_BINARY_PATH}

    icon.files = res/switch/icon_256.png
    icon.path = /

    CONF_FILES += click/switch-reloaded.apparmor

    desktop_file.path = /
    desktop_file.files = click/switch-reloaded.desktop
    desktop_file.CONFIG += no_check_exist
    INSTALLS+=desktop_file

    config_files.path = /
    config_files.files += $${CONF_FILES}
    INSTALLS+=config_files
}

INSTALLS += icon

!isEmpty(target.path): INSTALLS += target
