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
    width: 350
    height: 300


            id: item2



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
                y: 142
                text: qsTr("Date OUT:")

                font.pointSize: 10
            }

            TextField {
                id: textField_LogOUT
                x: 87
                y: 135
                width: 175
                height: 30
                anchors.horizontalCenterOffset: 2
                anchors.horizontalCenter: parent.horizontalCenter

            }

            Button {
                id: button1
                x: 270
                y: 135
                width: 61
                height: 31
                text: qsTr("Calendar")
                onClicked: {

                    calendar_LogOUT.visible=true;

                }

            }

            Button {
                id: button2
                x: 58
                y: 250
                width: 90
                height: 30
                text: qsTr("Log OUT")
                onClicked: {

                    DB2.dbInsertLogOUT(comboBox_CurrentObject.currentText,textField_LogOUT.text)

                    DB2.dbLogOutUserObject(comboBox_CurrentObject.currentText);

                    DB2.dbReadObject(comboBox_CurrentObject.currentText)
                    log_out_clinet_Dialog.visible=false
                }

            }

            Button {
                id: button3
                x: 211
                y: 250
                width: 90
                height: 30
                text: qsTr("Cancel")
                onClicked: log_out_clinet_Dialog.visible=false
            }

            Calendar{
                id:calendar_LogOUT
                x: 69
                y: 21
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



