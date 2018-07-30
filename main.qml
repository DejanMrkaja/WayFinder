import QtQuick 2.9

import QtQuick.Controls 2.2

import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import QtQuick.Window 2.3

import "Database.js" as DB1
import "Database_2.js" as DB2



Window {
    visible: true
    title: qsTr("WayFinder V3.0")

    minimumHeight: 1080
    minimumWidth: 1920
    visibility: "FullScreen"
   screen: Qt.application.screens[1]


/*
    property var scaleH: height/minimumHeight
    property var scaleW: width/minimumWidth
    property var scaleFont: (scaleH+scaleW)/2

    onHeightChanged: {
        scaleH: height/minimumHeight
         scaleW: width/minimumWidth
        scaleFont: (scaleH+scaleW)/2
        console.log("H: "+scaleH+"  W: "+scaleW)

    }
    onWidthChanged:{
        scaleH: height/minimumHeight
         scaleW: width/minimumWidth
        scaleFont: (scaleH+scaleW)/2

        console.log("H: "+scaleH+"  W: "+scaleW)
    }*/




     property var scaleH: 1
        property var scaleW: 1
        property var scaleFont: 1

    Component.onCompleted: {

        DB1.dbInit()
        DB2.dbInit()


    }

    ListModel{
        id:listFloorObjects
        //Component.onCompleted: DB.dbReadObjects()
    }

    ListModel{
        id:listAllFloors
        Component.onCompleted:{

            DB1.dbReadFloors()
            frontScreen.readObjectsPosition()



        }
    }
    ListModel{
        id:listFloors
        //Component.onCompleted: DB1.dbListFloors()
    }

    ListModel{
        id:pointCoordintes

    }

    ListModel{
        id:objectsPosition

    }
    ListModel{
        id:elevatorPosition

    }



    ListModel{
        id:listCoordinates

    }
    ListModel{
        id:listDistance

    }
    ListModel{
        id: pathCoordinates

    }
    ListModel{
        id:positionObject

    }
    ListModel{
        id:listCompany
        Component.onCompleted: DB2.dbListCompany()
    }



     ListModel{
         id:listobjectHistory

     }
     ListModel{
         id:listHistory

         Component.onCompleted: DB2.dbHistory()

     }
     ListModel{
         id:listContacts
         Component.onCompleted: DB2.dbListContact("")


     }
     ListModel{
         id:listType
         Component.onCompleted: DB2.dbListType()


     }
     ListModel{
         id:listObjectUser
         Component.onCompleted:DB2.dbReadObjectUser()


     }


Window{


    id:homeSettings
    width: 1920
    height: 1080



  //
  screen: Qt.application.screens[0]
//visibility: "FullScreen"
    visible: false


    Home{



    }


}


    FrontScreen{
        id:frontScreen
        anchors.fill: parent
        visible: true
        width: parent.width
        height: parent.height
        Component.onCompleted: {

            DB1.dbReadFrontMap(listAllFloors.get("1").Name)




        }

    }

    General{
        id:g1
        visible: false
    }




}
