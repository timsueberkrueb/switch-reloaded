import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import "../logic"
import "../controls"


Item {
    id: levelSelection

    property bool active: true
    property LevelModel levelModel
    property color currentBackgroundColor: {
        if (levelView.currentIndex === -1)
            return "green";
        else if (!isUnlocked(levelView.model.get(levelView.currentIndex)))
            return "#607D8B"
        else
            return levelView.model.get(levelView.currentIndex).color;
    }

    signal selected(var level)
    signal tutorial()
    signal about()

    function isUnlocked(level) {
        if (level.name in levelConfig.levels)
            return levelConfig.levels[level.name].unlocked;
        return false;
    }

    MatrixBackground {
        anchors.fill: parent
        characterColor: levelSelection.currentBackgroundColor
    }

    ListView {
        id: levelView
        anchors.fill: parent

        opacity: active ? 1 : 0
        visible: opacity > 0
        enabled: opacity == 1
        orientation: ListView.Horizontal
        preferredHighlightBegin: width/2 - 64
        preferredHighlightEnd: width/2 + 64
        highlightFollowsCurrentItem: true
        highlightRangeMode: ListView.StrictlyEnforceRange
        spacing: 16

        model: levelModel

        delegate: Component {
            Item {
                id: levelItem
                property bool isCurrent: levelView.currentIndex == index
                property real maxSize: Math.max(160, Math.min(levelView.width * (1/3), 256))
                property real scaleFactor: isCurrent ? 1 : 0.7
                property bool unlocked: isUnlocked(model)

                property color backgroundColor: unlocked ? model.color: "#9E9E9E"
                property string name: model.name
                property string title: model.title

                height: levelView.height
                width: maxSize

                Behavior on scaleFactor {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                RectangularGlow {
                    anchors.fill: levelRect
                    opacity: levelView.currentIndex == index ? 1 : 0
                    glowRadius: 6
                    spread: 0.2
                    color: levelItem.backgroundColor
                    cornerRadius: levelRect.radius + glowRadius

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                Rectangle {
                    id: levelRect
                    anchors.centerIn: parent
                    radius: 5
                    color: levelItem.backgroundColor
                    width: maxSize
                    height: maxSize
                    transform: Scale {
                        xScale: levelItem.scaleFactor
                        yScale: levelItem.scaleFactor
                        origin.x: levelRect.width/2
                        origin.y: levelRect.height/2
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            Icon {
                                anchors.centerIn: parent
                                name: "play"
                                color: "white"
                                size: parent.width * (1/4)
                            }

                            Label {
                                anchors {
                                    top: parent.top
                                    right: parent.right
                                    margins: 8
                                }

                                function dec2bin(dec){
                                    return (dec >>> 0).toString(2);
                                }

                                text: dec2bin((index + 1).toString())
                                color: "white"
                            }
                        }

                        Item {
                            Layout.preferredHeight: maxSize * (2/5)
                            Layout.fillWidth: true

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 10
                                radius: 5
                            }

                            Rectangle {
                                width: parent.width
                                height: parent.height - 5

                                ColumnLayout {
                                    anchors {
                                        fill: parent
                                        margins: 8
                                    }

                                    Label {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        text: levelItem.unlocked ? levelItem.title : qsTr("Locked")
                                        font.pixelSize: 16
                                        elide: Text.ElideRight
                                    }

                                    Checkmarks {
                                        current: (levelItem.name in levelConfig.levels)
                                                 ? Math.min(levelConfig.levels[levelItem.name].solved, max)
                                                 : 0
                                        color: "#757575"
                                    }
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (!levelItem.isCurrent) {
                                levelView.currentIndex = index;
                            } else if (levelItem.unlocked) {
                                selected(levelView.model.get(index));
                            }
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    }

    Item {
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }
        width: parent.width * (1/6)

        ShaderEffect {
            anchors.fill: parent

            property variant source: parent

            // Default vertex shader
            vertexShader: "
                uniform highp mat4 qt_Matrix;
                attribute highp vec4 qt_Vertex;
                attribute highp vec2 qt_MultiTexCoord0;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    qt_TexCoord0 = qt_MultiTexCoord0;
                    gl_Position = qt_Matrix * qt_Vertex;
                }
            "

            // Fragment shader
            fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform highp sampler2D source;

            void main()
            {
                highp vec4 sourceColor = texture2D(source, qt_TexCoord0);
                highp float alpha = 1. - qt_TexCoord0.x;
                sourceColor *= alpha;
                gl_FragColor = sourceColor;
            }
            "
        }
    }

    Item {
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        width: parent.width * (1/6)

        ShaderEffect {
            anchors.fill: parent

            property variant source: parent

            // Default vertex shader
            vertexShader: "
                uniform highp mat4 qt_Matrix;
                attribute highp vec4 qt_Vertex;
                attribute highp vec2 qt_MultiTexCoord0;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    qt_TexCoord0 = qt_MultiTexCoord0;
                    gl_Position = qt_Matrix * qt_Vertex;
                }
            "
            // Fragment shader
            fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform highp sampler2D source;

            void main()
            {
                highp vec4 sourceColor = texture2D(source, qt_TexCoord0);
                highp float alpha = qt_TexCoord0.x;
                sourceColor *= alpha;
                gl_FragColor = sourceColor;
            }
            "
        }
    }

    Rectangle {
        anchors {
            top: parent.top
            right: parent.right
            margins: 16
        }

        opacity: active ? 1 : 0
        visible: opacity > 0
        color: "white"
        radius: width * 0.5
        implicitHeight: 32
        implicitWidth: 32

        Icon {
            anchors.centerIn: parent
            name: "menu"
            color: "#212121"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                menu.open();
            }
        }

        Menu {
            id: menu
            y: parent.y
            rightMargin: 24

            MenuItem {
                text: qsTr("Tutorial")
                onClicked: levelSelection.tutorial()
            }

            MenuItem {
                text: qsTr("About")
                onClicked: levelSelection.about()
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }
}
