import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2



import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import "Database.js" as DB1
import "Database_2.js" as DB2


Item {
    id: item1

    width: 1920
    height: 1080


    property bool add_edit
    function general()
    {
      comboBox_AllFloors.currentIndex="0"
    }
    ListModel{
        id:listAllFloors
        Component.onCompleted: {
          DB1.dbReadFloors()
          comboBox_AllFloors.currentIndex="0"
        }
    }

Component.onCompleted:{

   comboBox_AllFloors.currentIndex="0"
    currentFloorGeneral=comboBox_AllFloors.currentText
   //DB.dbReadFloorObjects(comboBox_AllFloors.currentText)


   // DB.dbReadFloors()

}






    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        visible: false

        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
            //mapImage.source=fileDialog.fileUrl

            textField_Map_Url.text=fileDialog.fileUrl
            fileDialog.visible=false

        }
        onRejected: {
            console.log("Canceled")
            fileDialog.visible=false
        }

    }

    Dialog{
        id:floorDialog
        width: 500
        height: 500
        visible: false




        contentItem: Item{

            width: floorDialog.width
            height: floorDialog.height


            Button {
                id: button4
                x: 269
                y: 420
                width: 90
                height: 33
                text: qsTr("Save")
                font.pointSize: 10
                onClicked: {


                 if (add_edit===true)
                    {
                         DB1.dbAddFloor(text_Floor_Name.text,textField_Map_Url.text)

                    }
                    else if (add_edit===false)
                    {
                        DB1.dbEditFloor(text_Floor_Name.text,textField_Map_Url.text)
                    }

                    DB1.dbReadFloors()
                    //DB.dbListFloors()



                    text_Floor_Name.text=""
                    textField_Map_Url.text=""



                    listFloorObjects.clear()
                    floorDialog.visible=false
                    comboBox_AllFloors.currentIndex="0"




                }
            }

            Button {
                id: button5
                x: 383
                y: 422
                width: 90
                height: 33
                text: qsTr("Cancel")
                font.pointSize: 10

                onClicked: {

                    comboBox_AllFloors.enabled=true

                    text_Floor_Name.text=""
                    textField_Map_Url.text=""

                    listFloorObjects.clear()

                    floorDialog.visible=false
                }

            }

            Label {
                id: label4
                x: 24
                y: 112
                text: qsTr("Floor Name:")
                font.pointSize: 12
            }



            Label {
                id: label6
                x: 23
                y: 203
                text: qsTr("Map URL:")
                font.pointSize: 12
            }

            TextField {
                id: textField_Map_Url
                x: 115
                y: 198
                width: 248
                height: 33

                enabled: true
            }

            Button {
                id: button6
                x: 382
                y: 198
                width: 85
                height: 33
                text: qsTr("Load Map")
                onClicked: fileDialog.open()
            }



            TextField {
                id: text_Floor_Name
                x: 121
                y: 110
                width: 235
                height: 33


                enabled: true
                leftPadding: 10
                font.wordSpacing: 0
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 12
                color: "black"

            }
        }

    }





    Rectangle{
        id: rectangleBuilding
        x: 115
        y: 162

        width:500
        height:579
        color: "#ffffff"
        border.color: "#a9acad"

        Button {
            id: button1
            x: 367
            y: 528
            width: 90
            height: 33
            text: qsTr("Cancel")
            font.pointSize: 10
        }

        Button {
            id: button
            x: 239
            y: 527
            width: 90
            height: 33
            text: qsTr("Save")
            font.pointSize: 10
        }



        TextField {
            id: textField_Description
            x: 146
            y: 181
            width: 200
            height: 69
            text: qsTr("")
        }

        TextField {
            id: textField_NumberFloors
            x: 169
            y: 121
            width: 175
            height: 30
            text: qsTr("")
        }

        Label {
            id: label2
            x: 33
            y: 181
            text: qsTr("Description:")
            font.pointSize: 11
        }

        TextField {
            id: textField_BuildingName
            x: 146
            y: 65
            width: 200
            height: 30
            text: qsTr("")
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            id: label
            x: 33
            y: 65
            text: qsTr("Building Name:")
            font.pointSize: 11
        }

        Label {
            id: label1
            x: 31
            y: 125
            text: qsTr("Number of Floors:")
            font.pointSize: 11
        }




    }

    Rectangle{
        id: rectangleFloor
        x: 952
        y: 162

        width:488
        height:579
        color: "#00000000"
        border.color: "#00000000"





        Item {
            id: homeTab
            anchors.fill: parent



            ComboBox {
                id: comboBox_AllFloors

                x: 93
                y: 76
                width: 252
                height: 33
                currentIndex: 0

                visible: true
                font.pointSize: 12
                textRole: "Name"
                model: listAllFloors
              onCurrentTextChanged:  {

                  DB1.dbReadFloorObjects(comboBox_AllFloors.currentText)

                  currentFloorGeneral=comboBox_AllFloors.currentText


              }


            }


            Button {
                id: button2
                x: 378
                y: 76
                width: 90
                height: 33
                text: qsTr("Edit")
                font.pointSize: 10
                onClicked: {

                    add_edit=false
                    floorDialog.visible=true

                    text_Floor_Name.text=comboBox_AllFloors.currentText


                }

            }

            Button {
                id: button3
                x: 380
                y: 130
                width: 90
                height: 33
                text: qsTr("Add New")
                font.pointSize: 10
                onClicked: {

                    add_edit=true

                    floorDialog.visible=true



                    text_Floor_Name.text=""
                    textField_Map_Url.text=""



                    listFloorObjects.clear()



                }
            }
            Label {
                id: label3
                x: 33
                y: 81
                text: qsTr("Floor:")
                font.pointSize: 14
            }

            Label {
                id: label7
                x: 187
                y: 0
                text: qsTr("Add / Edit Floor")
                font.pointSize: 16
            }




        }

        GroupBox {
            id: groupBox
            x: 8
            y: 238
            width: 466
            height: 336
            title: qsTr("Information")

            Label {
                id: label8
                x: 0
                y: 22
                text: qsTr("Number of Objects:")
                font.pointSize: 12
            }

            Text {
                id: text1
                x: 144
                y: 25
                text: qsTr("Text")
                font.pixelSize: 12
            }

            Label {
                id: label9
                x: 0
                y: 80
                text: qsTr("Map:")
                font.pointSize: 12
            }

            Rectangle {
                id: rectangle
                x: 255
                y: 53
                width: 181
                height: 233
                color: "#e7e9ea"
               // Component.onCompleted:  DB.dbReadFloorObjects(comboBox_AllFloors.currentText)

                ListView {
                    id: listView
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    anchors.bottomMargin: 8
                    anchors.topMargin: 9

                    clip: true
                    anchors.fill: parent
                    model: listFloorObjects
                    delegate:Item{
                        x: 10
                        y:20
                        width: 80
                        height: 40

                        Row {
                            id: row1


                            Text {
                                text: Name
                                font.pointSize: 10
                                anchors.verticalCenter: parent.verticalCenter
                                font.bold: false
                            }
                            spacing: 10
                        }
                    }

                     ScrollBar.vertical: ScrollBar {}

                }
            }

            Text {
                id: text2
                x: 40
                y: 84
                text: qsTr("Text")
                font.pixelSize: 12
            }

            Label {
                id: label10
                x: 319
                y: 22
                text: qsTr("Objects:")
                anchors.horizontalCenterOffset: 63
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 12
            }



        }


    }


}
