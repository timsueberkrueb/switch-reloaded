import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import "../logic"
import "../controls"

ApplicationWindow {
    id: applicationWindow

    property var currentLevelInstance
    property Settings settings: Settings {
        category: "game"
        property string levels
        property bool firstStart: true

        Component.onCompleted: {
            if (settings.firstStart) {
                stackview.push(tutorialPage);
                settings.firstStart = false;
            }
        }
    }
    property LevelModel levelModel: LevelModel {
        onLoaded: {
            levelConfig.checkUnlocked();
        }
    }

    function createLevel(level) {
        var incubator = levelComponent.incubateObject(levelContainer, {
            opacity: 0,
            visible: false,
            level: level
        });
        function onReady() {
            var instance = incubator.object;
            // Check for saved config
            if (level.name in levelConfig.levels) {
                instance.config = levelConfig.levels[level.name];
            }
            else {
                instance.config = {
                    solved: 0,
                    saved: false,
                    unlocked: true
                }
            }
            instance.anchors.fill = levelContainer;
            instance.visible = true;
            instance.opacity = 1;
            instance.load();
            currentLevelInstance = instance;
        }
        if (incubator.status != Component.Ready) {
            incubator.onStatusChanged = function(status) {
                if (status == Component.Ready) {
                    onReady();
                }
            }
        } else {
            onReady();
        }
    }

    title: "Switch Reloaded"
    visible: false
    width: 640
    height: 480
    background: Rectangle { color: "black" }

    header: ToolBar {
        visible: stackview.depth > 1
        height: visible ? 48 : 0
        Material.primary: "#388E3C"

        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        RowLayout {
            anchors {
                fill: parent
                leftMargin: 16
            }

            spacing: 16

            IconButton {
                iconName: "arrow-back"
                onClicked: {
                    stackview.pop();
                }
            }

            Label {
                text: stackview.currentItem.title
                font.pixelSize: 18
                color: "white"
            }

            Item { Layout.fillWidth: true }     // Spacer
        }
    }

    QtObject {
        id: levelConfig

        property var levels: ({     // First level unlocked by default
            "spoon-boy": {
                solved: 0,
                saved: false,
                unlocked: true
            }
        })

        function load() {
            var levelsString = settings.levels;
            if (levelsString) {
                levels = JSON.parse(levelsString);
                levelsChanged();
            }
        }

        function save() {
            settings.levels = JSON.stringify(levels)
        }

        function checkUnlocked() {
            console.log("Checking for unlocked levels ...")
            for (var i=1; i<levelModel.count; i++) {
                var level = levelModel.get(i);
                var previousLevel = levelModel.get(i-1);
                if (previousLevel.name in levels) {
                    if (levels[previousLevel.name].solved >= 5) {
                        unlock(level);
                    }
                }
            }
        }

        function unlock(level) {
            if (!(level.name in levels)) {
                levels[level.name] = {
                    solved: 0,
                    saved: false,
                    unlocked: true
                }
                unlocked(level);
            } else if (!levels[level.name].unlocked) {
                levels[level.name].unlocked = true;
                unlocked(level);
            }
        }

        signal unlocked(var level)

        Component.onCompleted: load()
        Component.onDestruction: save()
    }

    Component {
        id: levelComponent
        LevelScreen {
            onClosed: {
                // Save config
                levelConfig.levels[level.name] = config;
                levelConfig.levelsChanged();
                // Destroy instance
                currentLevelInstance.destroy();
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    StackView {
        id: stackview
        anchors.fill: parent
        initialItem: Page {
            visible: stackview.depth == 1

            LevelSelection {
                anchors.fill: parent
                active: stackview.depth == 1 && (!currentLevelInstance || currentLevelInstance.closing)
                levelModel: applicationWindow.levelModel
                onSelected: {
                    createLevel(level);
                }
                onTutorial: stackview.push(tutorialPage)
                onAbout: stackview.push(aboutPage)
            }

            Item {
                id: levelContainer
                anchors.fill: parent
            }
        }

        TutorialPage {
            id: tutorialPage
            onPopRequested: {
                stackview.pop();
            }
        }

        AboutPage {
            id: aboutPage
            onPopRequested: {
                stackview.pop();
            }
        }
    }

    Rectangle {
        id: unlockedToast

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 16
        }

        property string levelTitle
        property color levelColor
        property bool showing: false

        color: levelColor
        height: 48
        opacity: showing ? 0.9 : 0
        radius: 5

        RectangularGlow {
            anchors.fill: parent
            glowRadius: 6
            spread: 0.2
            color: parent.levelColor
            cornerRadius: parent.radius + glowRadius

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }


        RowLayout {
            anchors.fill: parent

            Label {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                Layout.maximumWidth: parent.width - 16
                elide: Text.ElideRight
                text: qsTr('Level %1 unlocked').arg("<b>" + unlockedToast.levelTitle + "</b>")
                font.pixelSize: 12
                color: "white"
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }

        Timer {
            id: hideTimer
            interval: 5000
            onTriggered: {
                unlockedToast.showing = false;
            }
        }

        Connections {
            target: levelConfig
            onUnlocked: {
                unlockedToast.levelTitle = level.title;
                unlockedToast.levelColor = level.color;
                unlockedToast.showing = true;
                hideTimer.start();
            }
        }
    }

    Component.onCompleted: {
        console.log("Showing main screen ...");
        visible = true;
    }
}
