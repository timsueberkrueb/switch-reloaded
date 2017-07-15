import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import "../logic"
import "../controls"

Item {
    id: levelScreen

    property var level
    property var config
    property bool closing
    property bool isSolved: false

    function loadSaved() {
        matrixWidget.matrix = config.saved;
        console.log("Loaded saved matrix: " + JSON.stringify(config.saved));
    }

    function generateRandom() {
        var solution = Matrix.randomSolution(level.solutionCount, level.solutionMin, level.solutionMax);
        var matrix = Matrix.randomMatrix(solution, level.multiplierMax);
        console.log("Generated solution: " + JSON.stringify(solution))
        console.log("Generated matrix: " + JSON.stringify(matrix))
        matrixWidget.matrix = matrix;
    }

    function load() {
        if (config.saved) {
            loadSaved();
        }
        else {
            generateRandom();
        }
    }

    function close() {
        // Save config
        if (!isSolved)
            config.saved = matrixWidget.currentMatrix();
        // Close
        closing = true;
        headerbar.close();
        closeAnimation.start();
    }

    signal closed()

    NumberAnimation {
        id: closeAnimation
        target: levelScreen
        property: "opacity"
        duration: 300
        easing.type: Easing.InOutQuad
        to: 0
        onStopped: {
            closed();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, isSolved ? 1 : 0.75)

        Behavior on color {
            ColorAnimation {
                duration: 500
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.preferredHeight: 64  // 48 headerbar + 16 padding
            Layout.fillWidth: true

            ToolBar {
                id: headerbar
                anchors {
                    left: parent.left
                    right: parent.right
                }

                function open() {
                    y = 0;
                }

                function close() {
                    y = -height;
                }

                Material.primary: level.color

                y: -height
                implicitHeight: 48

                Behavior on y {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 16
                        rightMargin: 16
                    }

                    spacing: 16

                    IconButton {
                        iconName: "close"
                        iconColor: "white"

                        onClicked: {
                            levelScreen.close();
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        text: level.title
                        color: "white"
                        font.pixelSize: 18
                        elide: Qt.ElideRight
                    }

                    Checkmarks {
                        color: "white"
                        current: (level.name in levelConfig.levels)
                                 ? Math.min(levelConfig.levels[level.name].solved, max)
                                 : 0
                    }

                    IconButton {
                        iconName: "more-vertical"
                        iconColor: "white"

                        onClicked: menu.open()

                        Menu {
                            id: menu

                            y: parent.y
                            rightMargin: 16

                            MenuItem {
                                text: qsTr("Generate new")
                                onClicked: {
                                    generateRandom();
                                    matrixWidget.active = true;
                                    levelScreen.isSolved = false;
                                }
                            }
                        }
                    }
                }
            }
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 16

            opacity: isSolved ? 1 : 0
            text: qsTr("Matrix solved.")
            color: "white"
            font.pixelSize: 16

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Item { Layout.fillHeight: true }    // Spacer

        MatrixWidget {
            id: matrixWidget
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            themeColor: level.color
            onIsRowSelectedChanged: {
                if (isRowSelected)
                    multiplySlider.open();
            }
            onSolved: {
                // Update config
                config.saved = false;
                config.solved++;
                levelConfig.levels[level.name] = config;
                levelConfig.levelsChanged();
                if (config.solved >= 5)
                    levelConfig.checkUnlocked();

                active = false;
                levelScreen.isSolved = true;
                multiplySlider.close();
            }
        }

        Item { Layout.fillHeight: true }    // Spacer

        RowLayout {
            Layout.fillWidth: true
            opacity: isSolved ? 1 : 0
            enabled: opacity > 0
            spacing: 48

            Item { Layout.fillWidth: true }     // Spacer

            IconButton {
                iconName: "arrow-back"
                iconSize: 32
                iconColor: "white"
                onClicked: close()
            }

            IconButton {
                iconName: "play"
                iconSize: 32
                iconColor: "white"
                onClicked: {
                    generateRandom();
                    matrixWidget.active = true;
                    levelScreen.isSolved = false;
                }
            }

            Item { Layout.fillWidth: true }     // Spacer

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Item {
            Layout.preferredHeight: 48
            Layout.fillWidth: true

            MultiplySlider {
                id: multiplySlider

                anchors {
                    left: parent.left
                    right: parent.right
                }

                function open() {
                    sliderOpenAnimation.start();
                }

                function close() {
                    sliderCloseAnimation.start();
                }

                visible: y < parent.height
                y: height
                themeColor: level.color

                onMultiply: {
                    var newRm = Matrix.multiplyRow(matrixWidget.selectedRow.rowModel, factor);
                    matrixWidget.selectedRow.rowModel = newRm;
                }

                NumberAnimation {
                    id: sliderOpenAnimation
                    target: multiplySlider
                    property: "y"
                    to: 0
                    duration: 200
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    id: sliderCloseAnimation
                    target: multiplySlider
                    property: "y"
                    to: height
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    Keys.onBackPressed: {
        close();
    }

    Component.onCompleted: {
        forceActiveFocus();
        headerbar.open();
    }
}
