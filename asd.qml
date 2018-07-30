import QtQuick 2.0

Item {
    Rectangle {
        id: rectangle
        x: 259
        y: 133
        width: 81
        height: 63
        color: "#00000000"

        Image {
            id: image
            x: 18
            y: 2
            width: 35
            height: 35
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/qtquickplugin/images/template_image.png"
        }

        Text {
            id: text1
            x: 0
            y: 41
            width: 80
            height: 22
            text: qsTr("Text")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenterOffset: -1
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 18
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
        }

    }

}
