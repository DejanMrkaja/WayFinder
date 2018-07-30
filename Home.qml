import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import "Database.js" as DB1
import "Database_2.js" as DB2


Item{
    id: item1
    z: -1


    width: 1920
    height: 1080



Dialog{

    id:configuration_Dialog
    width: 1920
    height: 1080
    visible: false
    contentItem: Item{
        Configuration{}
    }

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
                text: "General"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15*scaleFont

            }
            onClicked:{


                DB2.dbListCompany()
                DB2.dbListType()


            }


        }

        TabButton{
            height: parent.height
            Rectangle{

                anchors.fill: parent
                color: parent.checked? "#afafb0":"#d2d2d6"
            }

            Text {
                id: text3
                text: "Client"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15*scaleFont
            }

            onClicked: DB2.dbListCompany()
        }
        TabButton{
            height: parent.height

            Rectangle{
                anchors.fill: parent
                color: parent.checked? "#afafb0":"#d2d2d6"
            }

            Text {
                id: text4
                text: "History"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15*scaleFont
            }
            onClicked: DB2.dbHistory()
        }
        TabButton{
            height: parent.height

            Rectangle{
                anchors.fill: parent
                color: parent.checked? "#afafb0":"#d2d2d6"
            }

            Text {
                id: text5
                text: "Settings"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15*scaleFont
            }
            onClicked: configuration_Dialog.visible=true
        }


    }

    StackLayout{
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        currentIndex: bar.currentIndex
        General{
            id:general
            visible: true

        }



       Client{
           id:client
           visible: true
    }
       History
       {
           id:history
           visible: true
       }
    /*   Settings
       {
           id:settings
           visible: true
       }*/


    }
}


