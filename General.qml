
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.1

import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import "Database.js" as DB1
import "Database_2.js" as DB2



Item {
    id: item1

    width: 1920
    height: 1080


    property var numPoints:0
    property var numObjects:0
    property var textPoint: []
    property var objectTextName:[]

    property var mapFrame_height:600*scaleH
    property var mapFrame_width:990*scaleW
    property var mapFrame_x:8*scaleW
    property var mapFrame_y:50*scaleH

    property var numObjectsGeneral

    ListModel {
        id:listFloorObjects
        //Component.onCompleted: DB.dbReadObjects()
    }
    ListModel {
        id:listElevator
    }



    ListModel{
        id:listAllFloors
        Component.onCompleted:
        {

            DB1.dbReadFloors()
            comboBox_CurrentFloor.currentIndex="0"
            readObjects()
            comboBox_CurrentObject.currentIndex="0"
        }
    }



    ListModel{
        id:listFloors
        Component.onCompleted: {

        }

    }


    ListModel{
        id:pointCoordintes
    }

    ListModel{
        id:positionObject



    }



    Component.onCompleted: {
        DB1.dbReadFloors()
        comboBox_CurrentFloor.currentIndex="0"




        //   DB1.dbReadFloorObjects(comboBox_CurrentFloor.currentText)
        //comboBox_CurrentObject.currentIndex="0"
    }




    function readObjects()
    {
        if(comboBox_CurrentFloor.currentText==="")
            return
        else{
            DB1.dbReadFloorObjects(comboBox_CurrentFloor.currentText)
            for(var i=0;i<listFloorObjects.count;i++)
            {
                canvasObject.arrpoints.push({"x": scaleW*positionObject.get(i).X, "y": scaleH*positionObject.get(i).Y})
                createObjectName(listFloorObjects.get(i).Name,scaleW*positionObject.get(i).X,scaleH*positionObject.get(i).Y,i)

                //console.log("Ime: "+listFloorObjects.get(i).Name+"X: "+positionObject.get(i).X+"Y: "+positionObject.get(i).Y)
            }

            numObjectsGeneral=listFloorObjects.count
        }

    }

    function createObjectName(name,x,y,num)
    {
        var X=Number([x])
        var Y=Number([y])
        var Name=name.split("_")
        var object=Name[1]+"_"+Name[2]


        objectTextName[num]=Qt.createQmlObject("import QtQuick 2.3;Text {text:'"+object+"'; x:"+X+";y:"+Y+";}", map_Frame, "")

    }
    function deleteObjects()
    {
        //  var num=listFloorObjects.count


        for(var i=0;i<numObjectsGeneral;i++)
        {

            objectTextName[i].destroy();
        }


    }


    ComboBox {
        id: comboBox_CurrentFloor
        x: 1645
        y: 130
        width: 231
        height: 41
        visible: true
        font.pointSize: 12*scaleFont
        textRole: "Name"
        currentIndex: 0
        model: listAllFloors
        onCurrentTextChanged: {


            DB1.dbReadFloorMap(comboBox_CurrentFloor.currentText)


            DB1.dbReadFloorObjects(comboBox_CurrentFloor.currentText)
            comboBox_CurrentObject.currentIndex="0"
            DB2.dbReadObject(comboBox_CurrentObject.currentText)

            //DB.dbReadCurrentFloor(comboBox_CurrentFloor.currentText)

            deleteObjects();

            canvasObject.clear()

            numObjectsGeneral=0;

            readObjects();


            comboBox_CurrentObject.currentIndex="0"


            // DB1.dbReadElevator(comboBox_CurrentObject.currentText)






        }
    }

    ComboBox {
        id: comboBox_CurrentObject
        x: 1645
        y: 214
        width: 231
        height: 41
        currentIndex: 0

        font.pointSize: 12*scaleFont
        visible: true


        textRole: "Name"
        model:listFloorObjects
        onCurrentTextChanged: {

            DB2.dbReadObject(comboBox_CurrentObject.currentText)
        }





    }



    Dialog{
        id:add_change_client_Dialog
        width: 400
        height: 400
        visible: false
        contentItem: Item{
            AddChangeClient{

            }
        }
    }
    Dialog{
        id:log_out_clinet_Dialog
        width: 350
        height: 300
        visible: false
        contentItem: Item{
            LogOutClient{

            }
        }
    }










    Rectangle {
        id: map_Frame
        x: 6
        y: 93
        width: 1490
        height: 925
        color: "#ffffff"
        clip: true
        z: 0
        border.width: 1
        border.color: "#5b6369"


        Image {
            id: image
            x: -5
            y: -52
            anchors.rightMargin: 3
            anchors.leftMargin: 3
            anchors.bottomMargin: 3
            anchors.topMargin: 3
            z: 0
            anchors.fill: parent
            // source: DB.floorMap

        }

        Canvas {
            id: canvasObject
            function clear() {
                var ctx = getContext("2d");
                ctx.reset();
                canvasObject.arrpoints=[]
                canvasObject.requestPaint();
            }
            function deletLast()
            {
                var ctx = getContext("2d");
                ctx.reset();
                canvasObject.arrpoints.pop()
                canvasObject.requestPaint();
            }


            property real radius: 2
            property var arrpoints : []
            x: 0
            y: 0
            z: 2
            anchors.fill: parent

            onPaint: {
                var context = getContext("2d");
                context.save()
                if(arrpoints.length > 0){
                    for(var i=0; i < arrpoints.length; i++){
                        var point= arrpoints[i]
                        context.ellipse(point["x"]-radius, point["y"]-radius, 2*radius, 2*radius)
                    }

                    context.strokeStyle ="black" //Qt.rgba(0, 1, 1, 0)
                    context.fill()
                    context.stroke()

                }

            }
        }







    }







    Label {
        id: label5
        x: 1588
        y: 226
        text: qsTr("Object:")
        font.pointSize: 10
    }


    GroupBox {
        id: groupBox
        x: 1549
        y: 352
        width: 317
        height: 651
        title: qsTr("")

        Label {
            id: label8
            x: -2
            y: 59
            text: qsTr("Shown Name:")
            font.pointSize: 10
            font.family: "Arial"
        }

        Label {
            id: label4
            x: 0
            y: 113
            text: qsTr("Object Type:")
            font.pointSize: 10
            font.family: "Arial"
        }

        Label {
            id: label3
            x: -3
            y: 167
            text: qsTr("Object Group:")
            font.pointSize: 10
            font.family: "Arial"
        }

        Label {
            id: label2
            x: -1
            y: 9
            text: qsTr("Client Name:")
            font.pointSize: 10
            font.family: "Arial"
        }

        Label {
            id: label1
            x: 10
            y: 280
            height: 15
            text: qsTr("Floor:")
            font.pointSize: 10
            font.family: "Arial"
        }

        Text {
            id: text1
            x: 83
            y: 3
            width: 166
            height: 28
            leftPadding: 4
            font.italic: false
            font.pointSize: 10

            text: "EMPTY"

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: text2
            x: 87
            y: 52
            width: 159
            height: 30
            leftPadding: 3
            font.italic: false
            font.pointSize: 10

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: text3
            x: 79
            y: 106
            width: 159
            height: 30
            leftPadding: 3
            font.italic: false
            font.pointSize: 10

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: text4
            x: 84
            y: 160
            width: 154
            height: 30
            leftPadding: 3
            font.italic: false
            font.pointSize: 10

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Button {
            id: button
            x: 144
            y: 358
            width: 75
            height: 27
            text:text1.text===""? "Add Client":"Change Clinet"


            onClicked:{


                add_change_client_Dialog.visible=true


            }
        }

        Button {
            id: button4
            x: 10
            y: 358
            width: 75
            height: 27
            text:"Log OUT"



            onClicked: {

                log_out_clinet_Dialog.visible=true
            }
        }

        Text {
            id: text5
            x: 61
            y: 213
            width: 120
            height: 30
            leftPadding: 3
            font.italic: false
            font.pointSize: 10
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: label_dateIN
            x: 4
            y: 220
            text: qsTr("Date IN:")
            font.pointSize: 10
            font.family: "Arial"
        }

        Text {
            id: text6
            x: 50
            y: 273
            width: 100
            height: 30
            leftPadding: 3
            font.italic: false
            font.pointSize: 10
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }



    }


    Label {
        id: label6
        x: 1588
        y: 142
        text: qsTr("Floor:")
        font.pointSize: 10
    }



}
