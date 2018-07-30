import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import "Database.js" as DB1
import "Database_2.js" as DB2

Item {
    width: 400
    height: 400



    Calendar{
        id:calendar_LogIN
        x:67
        y: 12
        width: 232
        height: 237
        visible: false
        z: 1


        minimumDate: new Date(2018, 0, 1)
        //maximumDate: new Date(2019, 0, 1)

        onClicked:{

          console.log("DATE: "+selectedDate.toLocaleDateString("en-GB"))
          textField_DateIN.text=selectedDate.toLocaleDateString("en-GB");
           calendar_LogIN.visible=false

        }

    }

    Dialog {
        id:dialog
        width: 400
        height: 250
        visible: false
        title: "Log OUT"


        contentItem: Item{
            id: item2
            width: 350


            Label{

                id:label_logOUT
                x:112
                y:26
                text:"Log OUT User from Object"
                anchors.horizontalCenterOffset: 0
                font.pointSize: 11
                anchors.horizontalCenter: parent.horizontalCenter

            }

            Label {
                id: label6
                x: 25
                y: 92
                text: qsTr("Date OUT:")

                font.pointSize: 11
            }

            TextField {
                id: textField_LogOUT
                x: 87
                y: 87
                width: 175
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter

            }

            Button {
                id: button1
                x: 300
                y: 86
                width: 61
                height: 31
                text: qsTr("Calendar")
                onClicked: {

                    calendar_LogOUT.visible=true;

                }

            }

            Button {
                id: button2
                x: 80
                y: 192
                width: 90
                height: 30
                text: qsTr("Log OUT")
                onClicked: {

                    DB2.dbInsertLogOUT(comboBox_CurrentObject.currentText,textField_LogOUT.text)

                    DB2.dbLogOutUserObject(comboBox_CurrentObject.currentText);
                    add_change_client_Dialog.visible=false
                    DB1.dbReadFloorObjects(comboBox_CurrentFloor.currentText)
                }

            }

            Button {
                id: button3
                x: 220
                y: 192
                width: 90
                height: 30
                text: qsTr("Cancel")
                onClicked: add_change_client_Dialog.visible=false
            }

            Calendar{
                id:calendar_LogOUT
                x: 60
                y: 0
                width: 232
                height: 237
                visible: false
                z: 1


                minimumDate: new Date(2018, 0, 1)
               // maximumDate: new Date(2019, 0, 1)


                onClicked:{
                    console.log("DATE: "+selectedDate.toLocaleDateString("en-GB"))

                    textField_LogOUT.text=selectedDate.toLocaleDateString("en-GB");
                    onReleased: calendar_LogOUT.visible=false

                }

            }

        }
    }


    Dialog {
        id:dialog_Type
        width: 400
        height: 300
        visible: false
        title: "Object Type"




        contentItem: Item{
            id: typeItem
            width: 300


            Label{

                id:label_Type
                x:112
                y:25
                text:"Object Type"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 11

            }



            Label {
                id: label_nameType
                x: 48
                y: 89
                text: qsTr("Type:")

                font.pointSize: 11
            }

            TextField {
                id: textField_nameType
                x: 115
                y: 83
                width: 175
                height: 30

                placeholderText: qsTr("Text Field")
            }

            Label {
                id: label_nameCategory
                x: 48
                y: 146
                text: qsTr("Category:")
                visible: true

                font.pointSize: 11
            }

            ComboBox {
                id: comboBox_Category
                x: 115
                y: 140
                width: 175

                height: 30

                model:["Shopping","Gastro","Entertainment","Offices","Services"]



                }







            Button {
                id: button_SaveType
                x: 74
                y: 244
                width: 91
                height: 30
                text: qsTr("Save")
                onClicked: {
                    DB2.dbInsertType(textField_nameType.text,comboBox_Category.currentText)
                    DB2.dbListType();
                    dialog_Type.visible=false
                }
            }

            Button {
                id: button_CancelType
                x: 208
                y: 244
                width: 90
                height: 30
                text: qsTr("Cancel")
                onClicked: dialog_Type.visible=false
            }
        }

}


    ComboBox {
        id: comboBox_addClient
        x: 121
        y: 87
        width: 178
        height: 30
        activeFocusOnPress: true
        currentIndex: -2
        model:listCompany
        textRole: "Name"


    }

    Label {
        id: label7
        x: 25
        y: 92
        text: qsTr("Client name:")
        font.pointSize: 11
    }

    Label {
        id: label9
        x: 23
        y: 152
        text: qsTr("Shown name:")
        font.pointSize: 11
    }

    TextField {
        id: textField_ShownName
        x: 119
        y: 146
        width: 180
        height: 30
        placeholderText: qsTr("Text Field")
    }

    CheckBox {
        id: checkBox
        x: 305
        y: 152
        width: 55
        height: 31
        text: qsTr("Enable")
    }

    Label {
        id: label10
        x: 23
        y: 202
        text: qsTr("Object Type:")
        font.pointSize: 11
    }

    ComboBox {
        id: comboBox_Type
        x: 121
        y: 198
        width: 178
        height: 30
        activeFocusOnPress: true
        currentIndex: -2
        model: listType
        textRole: "Type"

    }

    Label {
        id: label12
        x: 29
        y: 261
        text: qsTr("Date IN:")
        font.pointSize: 11
    }

    TextField {
        id: textField_DateIN
        x: 121
        y: 255
        width: 178
        height: 30
        placeholderText: qsTr("Text Field")
    }

    Button {
        id: button5
        x: 310
        y: 254
        width: 69
        height: 32
        text: qsTr("Calendar")
        onClicked:{

            calendar_LogIN.visible=true

        }
    }

    Button {
        id: button6
        x: 39
        y: 340
        width: 95
        height: 33
        text: qsTr("Save")
        onClicked:
        {
            //frontScreen.deleteObjects()


            DB2.dbInsertLogOUT(comboBox_CurrentObject.currentText,textField_DateIN.text);
            var currentIndex=comboBox_CurrentObject.currentIndex;

            DB2.dbObjectUserInsert(comboBox_CurrentObject.currentText,comboBox_addClient.currentText,
                                  textField_ShownName.text,comboBox_Type.currentText,textField_DateIN.text);
           DB1.dbReadFloorObjects(comboBox_CurrentFloor.currentText)

            comboBox_CurrentObject.currentIndex=currentIndex




           // comboBox_addClient.currentIndex=-1
            textField_ShownName.text=""
            //comboBox_Type.currentIndex=-1
            textField_DateIN.text=""
            add_change_client_Dialog.visible=false
            DB2.dbReadObjectUser()

            DB1.dbReadObjectsPosition(comboBox_CurrentFloor.currentText)



            frontScreen.readObjectsPosition()



        }
    }

    Button {
        id: button7
        x: 276
        y: 340
        width: 95
        height: 33
        text: qsTr("Cancel")
        onClicked: {
            comboBox_addClient.currentIndex=-1
            textField_ShownName.text=""
            comboBox_Type.currentIndex=-1
            textField_DateIN.text=""

            add_change_client_Dialog.visible=false
        }
    }

    Button {
        id: button8
        x: 309
        y: 197
        width: 69
        height: 32
        text: qsTr("Add New")
        onClicked: dialog_Type.visible=true
    }
}


