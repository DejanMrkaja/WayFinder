import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.2

import "Database.js" as DB1
import "Database_2.js" as DB2

Item {
    id: addEdit
    width: 400
    height: 450


    Dialog{
        id:addContact_Dialog
        width:350
        height: 350
        visible: false

       contentItem:  Item{
            id:itemContact
            width:300
            height: 400

            Label {
                id: labelContact
                x: 55
                y: 20
                text: qsTr("Add New Contact")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 12
            }

            Label {
                id: labelContactName
                x: 55
                y: 90
                text: qsTr("Name:")
                font.pointSize: 11
            }

            TextField {
                id: text_contact_name
                x: 110
                y: 80
                width: 195
                height: 37
                font.pointSize: 11
                placeholderText: qsTr("Contact Name")
                //text:company_name
            }
            Label {
                id: labelContactEmail
                x: 55
                y: 140
                text: qsTr("Email:")
                font.pointSize: 11
            }

            TextField {
                id: text_contact_email
                x: 110
                y: 130
                width: 195
                height: 37
                font.pointSize: 11
                placeholderText: qsTr("Contact Email")
                //text:company_name
            }
            Label {
                id: labelContactPhone
                x: 55
                y: 190
                text: qsTr("Phone:")
                font.pointSize: 11
            }

            TextField {
                id: text_contact_phone
                x: 110
                y: 180
                width: 195
                height: 37
                font.pointSize: 11
                placeholderText: qsTr("Contact Phone")
                //text:company_name
            }
            Button {
                id: buttonSaveContact
                x: 60
                y: 290
                width: 75
                height: 31
                text: qsTr("Save")

               onClicked: {

                   DB2.dbInsertContact(text_contact_name.text,text_contact_email.text,text_contact_phone.text)

                   DB2.dbListContact("");

                   addContact_Dialog.visible=false;






               }
            }
            Button {
                id: buttonCancelContact
                x: 215
                y: 290
                width: 75
                height: 31
                text: qsTr("Cancel")
                onClicked: {

                    text_contact_name.text="";
                    text_contact_email.text="";
                    text_contact_phone.text="";
                    DB2.dbListContact("");

                    addContact_Dialog.visible=false;



                }

            }




        }
    }


    GroupBox {
        id: groupBox
        x: 19
        y: 78
        width: 370
        height: 350
        anchors.horizontalCenterOffset: 0
        flat: true
        checked: false
        anchors.horizontalCenter: parent.horizontalCenter
        title: qsTr("")

        Button {
            id: button1
            x: 235
            y: 304
            width: 75
            height: 31
            text: qsTr("Cancel")
            onClicked: winAddEditCompany.close();
        }

        Button {
            id: button
            x: 33
            y: 304
            width: 75
            height: 31
            text: qsTr("Save")
            onClicked: {
                if(edit_company==true)
                {
                    DB2.dbEditCompany(text_company_name.text,comboBox_Contacts.currentText,textArea.text)
                    edit_company=false;
                }
                else
                {

                DB2.dbInsertCompany(text_company_name.text,comboBox_Contacts.currentText,textArea.text)

                }
                DB2.dbListCompany();

                winAddEditCompany.close();
            }
        }

        Label {
            id: label3
            x: -3
            y: 124
            text: qsTr("Description:")
            font.pointSize: 10
        }

        Label {
            id: label1
            x: -3
            y: 68
            text: qsTr("Contact:")
            font.pointSize: 10
        }

        Label {
            id: label
            x: -2
            y: 15
            text: qsTr("Company Name:")
            font.pointSize: 10
        }

        TextField {
            id: text_company_name
            x: 100
            y: 5
            width: 195
            height: 37
            font.pixelSize: 14
            placeholderText: qsTr("Company Name")
            text:company_name
        }

        ComboBox {
            id: comboBox_Contacts
            x: 100
            y: 58
            width: 195
            height: 37
            model: listContacts
            textRole:"Name"
        }

        TextArea {
            id: textArea
            x: 100
            y: 123
            width: 195
            height: 59
            text:company_description

        }

        Button {
            id: button2
            x: 301
            y: 58
            width: 53
            height: 38
            text: qsTr("Add New")

            onClicked: addContact_Dialog.visible=true

        }



    }

    Label {
        id: label5
        x: 151
        y: 27
        text:label_text
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
    }

}
