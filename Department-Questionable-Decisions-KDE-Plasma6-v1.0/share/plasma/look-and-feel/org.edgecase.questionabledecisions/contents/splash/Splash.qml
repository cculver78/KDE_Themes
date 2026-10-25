import QtQuick

Rectangle {
    id: root
    color: "#101920"
    property int stage: 0

    Image {
        anchors.fill: parent
        source: "department-splash.svg"
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    Rectangle {
        width: Math.min(root.width * 0.34, 440)
        height: 4
        radius: 2
        color: "#24383e"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: Math.min(root.height * 0.19, 210)

        Rectangle {
            height: parent.height
            width: parent.width * Math.max(0.07, Math.min(1, root.stage / 6))
            radius: parent.radius
            color: "#b99c69"
            Behavior on width { NumberAnimation { duration: 260 } }
        }
    }
}
