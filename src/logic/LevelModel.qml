import QtQuick 2.0

ListModel {
    id: model

    signal loaded()

    Component.onCompleted: {
        model.append({
            name: "spoon-boy",
            title: qsTr("Spoon boy"),
            color: "#00BCD4",
            solutionCount: 2,
            solutionMin: -3,
            solutionMax: 3,
            multiplierMax: 2
        });
        model.append({
            name: "mouse",
            title: qsTr("Mouse"),
            color: "#E91E63",
            solutionCount: 2,
            solutionMin: -5,
            solutionMax: 5,
            multiplierMax: 2
        });
        model.append({
            name: "choi",
            title: qsTr("Choi"),
            color: "#FF5722",
            solutionCount: 3,
            solutionMin: -3,
            solutionMax: 3,
            multiplierMax: 3
        });
        model.append({
            name: "trinity",
            title: qsTr("Trinity"),
            color: "#607D8B",
            solutionCount: 3,
            solutionMin: -6,
            solutionMax: 6,
            multiplierMax: 3,
        });
        model.append({
            name: "cypher",
            title: qsTr("Cypher"),
            color: "#7C4DFF",
            solutionCount: 3,
            solutionMin: -10,
            solutionMax: 10,
            multiplierMax: 4
        });
        model.append({
            name: "switch",
            title: qsTr("Switch"),
            color: "#388E3C",
            solutionCount: 4,
            solutionMin: -7,
            solutionMax: 7,
            multiplierMax: 2
        });
        model.append({
            name: "morpheus",
            title: qsTr("Morpheus"),
            color: "#FFC107",
            solutionCount: 4,
            solutionMin: -8,
            solutionMax: 8,
            multiplierMax: 3
        });
        model.append({
            name: "agent-smith",
            title: qsTr("Agent Smith"),
            color: "#212121",
            solutionCount: 4,
            solutionMin: -9,
            solutionMax: 9,
            multiplierMax: 3
        });
        model.append({
            name: "neo",
            title: qsTr("Neo"),
            color: "#00796B",
            solutionCount: 4,
            solutionMin: -10,
            solutionMax: 10,
            multiplierMax: 3
        });
        model.append({
            name: "merovingian",
            title: qsTr("Merovingian"),
            color: "#F57C00",
            solutionCount: 5,
            solutionMin: -10,
            solutionMax: 10,
            multiplierMax: 2
        });
        model.append({
            name: "oracle",
            title: qsTr("Oracle"),
            color: "#9C27B0",
            solutionCount: 5,
            solutionMin: -10,
            solutionMax: 10,
            multiplierMax: 3
        });
        model.append({
            name: "architect",
            title: qsTr("The Architect"),
            color: "#512DA8",
            solutionCount: 5,
            solutionMin: -10,
            solutionMax: 10,
            multiplierMax: 4
        });
        loaded();
    }
}
