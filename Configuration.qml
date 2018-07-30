
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import "Database.js" as DB



Item{
    id: item1
    z: -1

    property var scaleH: 1
    property var scaleW: 1
    property var scaleFont:1
    width: 1920
    height: 1080

    property var currentFloorGeneral
    property var currentFloorFloor
    FloorSettings{
        id:floorSettings
        visible: false
    }

    GeneralSettings{
        id:gen
        visible: false
    }


    TabBar{
        id:bar
        x: 0
        y: 0
        width:parent.width
        height:40*scaleH
        //font.pointSize:dp*12


        TabButton{
            id: tabButton
            height: parent.height



            Rectangle{
                anchors.fill: parent
                color: parent.checked? "#afafb0":"#d2d2d6"
            }
            //onClicked: JS.dbReadAll()

            Text {
                id: text1
                text: "General Settings"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15*scaleFont

            }
            onClicked:{

                DB.dbReadFloorObjects(currentFloorGeneral)
                generalSettings.general()


            }


        }
        TabButton{
            height:parent.height
            Rectangle{
                anchors.fill: parent
                color: parent.checked? "#afafb0":"#d2d2d6"
            }


            Text {
                id: text2
                text: "Floor Settings"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize:  15*scaleFont
            }
            onClicked:{

                DB.dbReadFloors()


                    floorSettings.refresh()
                DB.dbReadFloorObjects(currentFloorFloor)





             floorSettings.readCoordinates()









            }


        }
        TabButton{
            height:parent.height
            Rectangle{
                anchors.fill: parent
                color: parent.checked? "#afafb0":"#d2d2d6"
            }


            Text {
                id: text_Account
                text: "Account"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize:  15*scaleFont
            }


        }






    }

    StackLayout{
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        currentIndex: bar.currentIndex


        GeneralSettings
        {
            id:generalSettings
            Layout.fillWidth: true
            visible:true
        }

        FloorSettings{
            id:objects
            Layout.fillWidth: true
            visible: true
        }





    }
}


