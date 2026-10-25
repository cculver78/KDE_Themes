import QtQuick 2.15
import QtQuick.Window 2.15
Item {
    id: root
    width: Screen.width
    height: Screen.height
    property int stage: 0
    Image { anchors.fill: parent; source: "../../../../../wallpapers/NevermoreMidnight/contents/images/1920x1080.png"; fillMode: Image.PreserveAspectCrop; visible: false }
    Rectangle { anchors.fill: parent; color: "#101014" }
    Column {
        anchors.centerIn: parent
        spacing: 20
        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "NEVERMORE"; color: "#e2ceb1"; font.family: "serif"; font.pixelSize: 76; font.letterSpacing: 5 }
        Rectangle { anchors.horizontalCenter: parent.horizontalCenter; width: 280; height: 2; color: "#79273d" }
        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "POE MEETS MODERN LINUX"; color: "#b7a18e"; font.family: "serif"; font.pixelSize: 15; font.letterSpacing: 3 }
    }
    Rectangle { anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 100; width: Math.max(20, Math.min(320, (root.stage + 1) * 55)); height: 3; color: "#8a2b43" }
}
