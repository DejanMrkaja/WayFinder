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

    width: 1920
    height: 1080





   property var label_text:""
   property var company_name:""
   property var company_contact:""
   property var company_description:""

   property bool edit_company:false




   Window{
       id:winAddEditCompany
       visible:false
       width: 400
       height: 450
       AddEditCompany{

       }

   }






   TableView {
       id:table_company
       x: 67
       y: 148
       width: 1322
       height: 792
       headerVisible: true
       frameVisible: true
       selectionMode: 1
       horizontalScrollBarPolicy: 0
       sortIndicatorOrder: 0
       sortIndicatorColumn: 0
       currentRow: 0
       sortIndicatorVisible: true
       highlightOnFocus: true
       model:listCompany
       onClicked: {

           getSelectRow()
           DB2.dbListContact(company_contact)


       }


       function getSelectRow()
       {


           company_name=listCompany.get(currentRow).Name
           company_contact=listCompany.get(currentRow).Contact
           company_description=listCompany.get(currentRow).Description;

       }



       TableViewColumn {
           role:"SN"
           title:"No"

           width: table_company.width/9
           resizable: false
           movable: false
           horizontalAlignment:4


       }

       TableViewColumn {
           role: "Name"
           title: "Name"
           width: table_company.width/3
           resizable: false
           movable: false
           elideMode:3
           horizontalAlignment:4



       }
       TableViewColumn {
           role: "Contact"
           title: "Contact"
           width: table_company.width/4
           resizable: false
           movable: false
           horizontalAlignment:4
       }


       TableViewColumn {
           role: "Description"
           title: "Description"
           width:table_company.width/3
           resizable: false
           movable: false
           horizontalAlignment:4
       }

       style: TableViewStyle {
           id: tableViewStyle
           alternateBackgroundColor: "#d1d1d1"
           handleOverlap: 1
           highlightedTextColor: "black"

           scrollToClickedPosition: true
           activateItemOnSingleClick: true
                  headerDelegate: Rectangle {
                      id: rectangle
                      height: textItem.implicitHeight * 1.4
                      width: textItem.implicitWidth
                      color: "#b5c3dc"
                      anchors.horizontalCenter: parent.horizontalCenter
                      Text {
                          id: textItem
                          color: "#414654"
                          verticalAlignment: Text.AlignVCenter
                          text: styleData.value
                          anchors.horizontalCenter: parent.horizontalCenter
                          anchors.left: parent.left
                          anchors.bottom: parent.bottom
                          anchors.top: parent.top
                          font.bold: true
                          horizontalAlignment: Text.AlignHCenter
                          font.pointSize: 10
                          elide: Text.ElideRight
                          renderType: Text.NativeRendering
                      }
                      Rectangle {
                          anchors.right: parent.right
                          anchors.top: parent.top
                          anchors.bottom: parent.bottom
                          anchors.bottomMargin: 1
                          anchors.topMargin: 1
                          width: 1
                          color: "#6e747f"
                      }
                  }

                  /*rowDelegate:

                      Text {
                          id: text_row
                          verticalAlignment: Text.AlignVCenter
                          horizontalAlignment: Text.AlignHCenter
                      font.pointSize: 10
                      }*/


              }

   }



   Button {
       id: button
       x: 1630
       y: 149
       width: 135
       height: 50
       text: qsTr("Add New")
       onClicked: {


           label_text="Add New Company";
           company_name="";
           company_description="";
           company_contact="";

           DB2.dbListContact("")

           edit_company=false;
           winAddEditCompany.show();
       }
   }

   Button {
       id: button1
       x: 1630
       y: 326
       width: 135
       height: 50
       text: qsTr("Delete")
       onClicked: {
           table_company.getSelectRow();
           DB2.dbDeleteCompany(company_name)

           DB2.dbListCompany();

       }
   }

   Button {
       id: button2
       x: 1630
       y: 236
       width: 135
       height: 50
       text: qsTr("Edit")
       enabled:table_company.currentRow===-1? false:true

       onClicked: {
           table_company.getSelectRow();
           winAddEditCompany.show();
           label_text="Edit Object"
            DB2.dbListContact()
           edit_company=true;
       }
   }

   Label {
       id: label
       x: 613
       y: 105
       text: qsTr("List of clients:")
       font.pointSize: 15
   }

   GroupBox {
       id: groupBox
       x: 1433
       y: 535
       width: 405
       height: 407
       title: qsTr("Company Details:")

       Label {
           id: label1
           x: 0
           y: 19
           text: qsTr("Company Name:")
           font.pointSize: 12
       }

       Label {
           id: label2
           x: 1
           y: 62
           text: qsTr("Contact:")
           font.pointSize: 12
       }

       Label {
           id: label3
           x: 34
           y: 268
           text: qsTr("Description:")
           font.pointSize: 12
       }

       Label {
           id: label4
           x: 72
           y: 64
           text: qsTr("Name:")
           font.pointSize: 12
       }

       Label {
           id: label5
           x: 73
           y: 114
           width: 44
           height: 19
           text: qsTr("Email:")
           font.pointSize: 12
       }

       Label {
           id: label6
           x: 63
           y: 155
           text: qsTr("Phone:")
           font.pointSize: 12
       }

       TextArea {
           id: textArea
           x: 126
           y: 274
           width: 261
           height: 96
           text:table_company.currentRow===-1? "":company_description
       }

       Text {
           id: text1
           x: 125
           y: 19
           width: 166
           height: 23
           text: table_company.currentRow===-1? "":company_name
           font.pointSize: 12
       }

       Text {
           id: text_Contact_Name
           x: 125
           y: 69
           width: 166
           height: 14
           font.pointSize: 12

       }

       Text {
           id: text_Contact_Email
           x: 123
           y: 118
           width: 166
           height: 14
           font.pointSize: 12

       }

       Text {
           id: text_Contact_Phone
           x: 123
           y: 161
           width: 166
           height: 14
           font.pointSize: 12

       }
   }


}
