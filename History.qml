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
    id: item1

    width: 1920
    height: 1080




   TableView {
       id:table_objects
       x: 73
       y: 82
       width: 1506
       height: 839
       anchors.horizontalCenterOffset: -18
       anchors.horizontalCenter: parent.horizontalCenter
       headerVisible: true
       frameVisible: true
       selectionMode: 1
       horizontalScrollBarPolicy: 0
       sortIndicatorOrder: 0
       sortIndicatorColumn: 0
       currentRow: 0
       sortIndicatorVisible: true
       highlightOnFocus: true
       model: listHistory





       TableViewColumn {
           role:"SN"
           title:"No"

           width: table_objects.width/15
           resizable: false
           movable: false
           horizontalAlignment:4


       }

       TableViewColumn {
           role: "ObjectName"
           title: "Object Name"
           width: table_objects.width/7
           resizable: false
           movable: false
           elideMode:3
           horizontalAlignment:4



       }
       TableViewColumn {
           role: "CompanyName"
           title: "Company Name"
           width: table_objects.width/4.5
           resizable: false
           movable: false
           horizontalAlignment:4
       }

       TableViewColumn {
           role: "ShownName"
           title: "Shown Name"
           width:table_objects.width/5
           resizable: false
           movable: false
           horizontalAlignment:4
       }
       TableViewColumn {
           role: "Type"
           title: "Type"
           width:table_objects.width/6.5
           resizable: false
           movable: false
           horizontalAlignment:4
       }

       TableViewColumn {
           role: "DateIN"
           title: "Date IN"
           width:table_objects.width/9
           resizable: false
           movable: false
           horizontalAlignment:4
       }
       TableViewColumn {
           role: "DateOUT"
           title: "Date OUT"
           width:table_objects.width/9
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
                          font.pointSize: 12
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



              }

   }




   Label {
       id: label
       x: 325
       y: 43
       width: 72
       height: 25
       text: "History"
       anchors.horizontalCenterOffset: 0
       anchors.horizontalCenter: parent.horizontalCenter
       font.pointSize: 16
   }


}
