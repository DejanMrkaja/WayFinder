
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.1

import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
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






    ListModel {
        id:listFloorObjects
        //Component.onCompleted: DB.dbReadObjects()
    }
    ListModel {
        id:listElevator
        Component.onCompleted: DB1.dbReadElevator(comboBox_CurrentFloor.currentText)
    }

  ListModel{
       id:listAllFloors
       Component.onCompleted: {

        refresh()

       }

   }



   /* ListModel{
        id:listFloors
        Component.onCompleted: {




            DB.dbReadFloorMap(comboBox_CurrentFloor.currentText)

            comboBox_CurrentFloor.currentIndex="0"
            comboBox1.currentIndex="0"
            comboBox4.currentIndex="0"
            comboBox5.currentIndex="0"

        }

    }*/


    ListModel{
        id:pointCoordintes
        Component.onCompleted: readCoordinates()

    }

    ListModel{
        id:positionObject
        Component.onCompleted: readObjects()


    }
  //Component.onCompleted: refresh()


    function refresh()
    {

        DB1.dbReadFloors()


                    comboBox_CurrentFloor.currentIndex="0"
                    comboBox1.currentIndex="0"
                    comboBox4.currentIndex="0"
                    comboBox5.currentIndex="0"
                    DB1.dbReadFloorMap(comboBox_CurrentFloor.currentText)
                    readCoordinates()
                    readObjects()



    }

    function readCoordinates()
    {



        if(comboBox_CurrentFloor.currentText==="")
            return
        else{
            DB1.dbGetCoordinates(comboBox_CurrentFloor.currentText)
            for(var i=0;i<pointCoordintes.count;i++)
            {
                mycanvas.arrpoints.push({"x": pointCoordintes.get(i).X, "y": pointCoordintes.get(i).Y})
                createText(pointCoordintes.get(i).Name,pointCoordintes.get(i).X,pointCoordintes.get(i).Y,i)


            }


            numPoints=pointCoordintes.count;
        }


    }

    function readObjects()
    {
        if(comboBox_CurrentFloor.currentText==="")
            return
        else{
            DB1.dbReadFloorObjects(comboBox_CurrentFloor.currentText)
            for(var i=0;i<listFloorObjects.count;i++)
            {
                canvasObject.arrpoints.push({"x": positionObject.get(i).X, "y": positionObject.get(i).Y})
                createObjectName(listFloorObjects.get(i).Name,positionObject.get(i).X, positionObject.get(i).Y,i)

            }

            numObjects=listFloorObjects.count
        }

    }




    Rectangle {
        id: rectangle
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
            x: 8
            y: 60
            anchors.rightMargin: 2
            anchors.leftMargin: 2
            anchors.bottomMargin: 2
            anchors.topMargin: 2
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

        MouseArea {
            id: mymouse
            anchors.fill: parent
            enabled:switch1.checked? true:false
            onClicked: {



                if(points_Tab.checked)
                {
                    mycanvas.arrpoints.push({"x": mouseX, "y": mouseY})

                    createText("P"+numPoints,Number([mouseX]),Number([mouseY]),numPoints);

                    pointCoordintes.append({Name:"P"+numPoints,X:mouseX,Y:mouseY});
                    numPoints++;

                    mycanvas.requestPaint()


                }
                else if(objects_Tab.checked)
                {


                    canvasObject.arrpoints.push({"x": mouseX, "y": mouseY})
                    //var name=FloorFunction.addNewObject(comboBox_CurrentFloor.currentText)

                    DB1.dbAddObject(comboBox_CurrentFloor.currentText,Number([mouseX]),Number([mouseY]))
                    DB1.dbReadFloorObjects(comboBox_CurrentFloor.currentText)
                    comboBox1.currentIndex=listFloorObjects.count-1;







                    createObjectName(comboBox1.currentText,Number([mouseX]),Number([mouseY]),numObjects);


                    numObjects++;

                    canvasObject.requestPaint()

                }

            }


        }

        Canvas {
            id: mycanvas
            function clear() {
                var ctx = getContext("2d");
                ctx.reset();
                mycanvas.arrpoints=[]
                mycanvas.requestPaint();
            }
            function deletLast()
            {
                var ctx = getContext("2d");
                ctx.reset();
                mycanvas.arrpoints.pop()
                mycanvas.requestPaint();
            }


            property real radius: 2
            property var arrpoints : []
            z: 2
            anchors.fill: parent

            onPaint: {
                var context = getContext("2d");
                context.strokeStyle = "red"//Qt.rgba(0, 1, 1, 0)

                context.fill()
                context.fillStyle="red"
                context.save()
                if(arrpoints.length > 0){
                    for(var i=0; i < arrpoints.length; i++){
                        var point= arrpoints[i]
                        context.ellipse(point["x"]-radius, point["y"]-radius, 2*radius, 2*radius)


                    }

                    context.stroke()

                }

            }




        }



    }

    function createObjectName(name,x,y,num)
    {
        var X=Number([x])
        var Y=Number([y])
        var Name=name.split("_")
        var object=Name[1]+"_"+Name[2]


        objectTextName[num]=Qt.createQmlObject("import QtQuick 2.3;Text {text:'"+object+"'; x:"+X+";y:"+Y+";}", rectangle, "")

    }
    function deleteObjects()
    {
        //  var num=listFloorObjects.count





            if(objectTextName.length==0)
                return
            else
            {
                for(var i=0;i<numObjects;i++)
                {
                    if(!objectTextName[i])
                        return
                    else
                    {
                        objectTextName[i].destroy();

                    }

                }

        }


    }



    function createText(name,x,y,num)
    {
        var X=Number([x])
        var Y=Number([y])


        textPoint[num]=Qt.createQmlObject("import QtQuick 2.3;Text {text:'"+name+"'; x:"+X+";y:"+Y+";color:'black';font {pixelSize: 10;}}", rectangle, "")

    }


    function deleteText()
    {


        for(var i=0;i<numPoints;i++)
        {

            textPoint[Number([i])].destroy()
        }


    }

    function deleteLastPoint()
    {


        textPoint[numPoints-1].destroy()
        mycanvas.deletLast()
        var n=pointCoordintes.count;
        pointCoordintes.remove(n-1)

        //numPoints=pointCoordintes.count

        numPoints--;
    }
    function deleteCurrentObject()
    {


        objectTextName[numObjects-1].destroy()
        canvasObject.deletLast()



        numPoints--;
    }


    ComboBox {
        id: comboBox_CurrentFloor
        x: 1596
        y: 121
        width: 306
        height: 53
        currentIndex: 0

        font.pointSize: 12
        visible: true


        textRole: "Name"
        model:listAllFloors


        onPressedChanged:{

            var index=comboBox_CurrentFloor.currentIndex
            DB1.dbReadFloors()

            comboBox_CurrentFloor.currentIndex=index


        }

        onCurrentTextChanged: {



            //DB.dbReadCurrentFloor(comboBox_CurrentFloor.currentText)

            deleteObjects();
            deleteText();

            //deleteObjectText();
            // comboBox1.currentIndex="0"


            mycanvas.clear()
            canvasObject.clear()
            // pointCoordintes.clear()

            numPoints=0;

            numObjects=0;

            readCoordinates();
            readObjects();


            comboBox4.currentIndex="0"
            comboBox5.currentIndex="0"

            currentFloorFloor=comboBox_CurrentFloor.currentText

            DB1.dbReadFloorMap(comboBox_CurrentFloor.currentText)

            DB1.dbReadElevator(comboBox_CurrentFloor.currentText)
            //DB.dbReadFloorObjects(comboBox_CurrentFloor.currentText)

            comboBox_Elevator.currentIndex="0"


        }

    }

    Label {
        id: label5
        x: 1522
        y: 133
        text: qsTr("Floor:")
        font.pointSize: 18
    }





    Button {
        id: button3
        x: 1565
        y: 971
        width: 90
        height: 33
        text: qsTr("Save All")

    }




    Rectangle{
        id: rectangle3
        x: 1522
        y: 220

        width:384
        height:732
        color: "#ffffff"
        border.color: "#666f74"

        TabBar {
            id: barFloor
            x: 0
            y: 0

            width: parent.width-2



            height: 25
            currentIndex: 0
            anchors.horizontalCenter: parent.horizontalCenter

            TabButton {
                height: 25
                id:points_Tab

                Rectangle{
                    id: rectangle1
                    color: parent.checked? "#afafb0":"#d2d2d6"
                    anchors.fill: parent
                    Text {
                        id: texPoints
                        text: qsTr("Points")
                        font.pointSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

            }
            TabButton {
                height: 25
                id:objects_Tab


                Rectangle{
                    id: rectangle2

                    color: parent.checked? "#afafb0":"#d2d2d6"
                    anchors.fill: parent
                    Text {
                        id: textObjects
                        text: qsTr("Objects")
                        font.pointSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }
                onClicked:{
                    DB1.dbReadFloorObjects(comboBox_CurrentFloor.currentText)
                    comboBox1.currentIndex="0"

                }

            }
            TabButton {
                height: 25
                id:elevator_Tab


                Rectangle{
                    id: elevator_rectangle

                    color: parent.checked? "#afafb0":"#d2d2d6"
                    anchors.fill: parent
                    Text {
                        id: textElevator
                        text: qsTr("Elevators")
                        font.pointSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }
                onClicked:{
                    DB1.dbReadFloorObjects(comboBox_CurrentFloor.currentText)
                    comboBox1.currentIndex="0"

                }

            }

        }

        StackLayout {
            width: parent.width

            currentIndex: barFloor.currentIndex

            //currentIndex: 2

            Item {
                id: homeTab
                visible: false

                Switch {
                    id: switch1
                    x: 33
                    y: 46
                    width: 180
                    height: 34
                    text: qsTr("Enable Create Point")
                    font.pointSize: 9

                }

                Button {
                    id: button
                    x: 61
                    y: 115
                    width: 81
                    height: 30
                    text: qsTr("Delete Last")
                    font.pointSize: 10
                    anchors.horizontalCenterOffset: -61
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: deleteLastPoint()
                }

                Button {
                    id: button1
                    x: 62
                    y: 116
                    width: 81
                    height: 30
                    text: qsTr("Clear All")
                    font.pointSize: 10
                    anchors.horizontalCenterOffset: 56
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        mycanvas.clear()
                        pointCoordintes.clear()

                        deleteText()
                        numPoints=0;
                    }

                }

                Button {
                    id: button2
                    x: 68
                    y: 187
                    width: 81
                    height: 30
                    text: qsTr("Save Points")
                    font.pointSize: 10
                    anchors.horizontalCenterOffset: -7
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {

                        // DB.dbDeleteFloorPoints(comboBox_CurrentFloor.currentText)



                        DB1.dbInsert(comboBox_CurrentFloor.currentText)

                        DB1.dbGetCoordinates(comboBox_CurrentFloor.currentText)
                    }
                }



                ComboBox {
                    id: comboBox4
                    x: 107
                    y: 284
                    width: 100
                    height: 30
                    currentIndex: 0
                    model: pointCoordintes
                    textRole: "Name"
                }

                ComboBox {
                    id: comboBox5
                    x: 107
                    y: 340
                    width: 100
                    height: 30
                    currentIndex: 0
                    model: pointCoordintes
                    textRole: "Name"
                }

                Button {
                    id: button8
                    x: 69
                    y: 395
                    width: 85
                    height: 30
                    text: qsTr("Connect")
                    font.pointSize: 10
                    anchors.horizontalCenterOffset: -9
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: DB1.dbInsertDistance(comboBox4.currentText,comboBox5.currentText,comboBox_CurrentFloor.currentText)
                }

                Label {
                    id: label4
                    x: 49
                    y: 346
                    text: qsTr("Point:")
                    font.pointSize: 12
                }

                Label {
                    id: label7
                    x: 16
                    y: 246
                    text: qsTr("Connect Points")
                    anchors.horizontalCenterOffset: -9
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 11
                }

                ToolSeparator {
                    id: toolSeparator
                    x: 101
                    y: 137
                    width: 13
                    height: 190
                    anchors.horizontalCenterOffset: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    rotation: 90
                }

                Label {
                    id: label6
                    x: 46
                    y: 290
                    text: qsTr("Point:")
                    font.pointSize: 12
                }



            }



            Item {
                id: discoverTab
                width: 0

                ComboBox {
                    id: comboBox1
                    x: 75
                    y: 69
                    width: 150
                    height: 26
                    visible: true
                    currentIndex: 0
                    textRole: "Name"
                    model:listFloorObjects

                    Component.onCompleted: {

                        DB1.dbReadFloorObjects(comboBox_CurrentFloor.currentText)
                        currentIndex="0"




                    }
                    onCurrentTextChanged:  DB1.dbReadObjectPoint(comboBox1.currentText)





                }

                ComboBox {
                    id: comboBox_objectPoint
                    x: 119
                    y: 245
                    width: 100
                    height: 26
                    visible: true
                    textRole: "Name"
                    model:pointCoordintes
                    currentIndex: 0


                }

                Button {
                    id: button7
                    x: 73
                    y: 391
                    height: 28
                    text: qsTr("Save")
                    onClicked: DB1.dbInsertObjectPoint(comboBox1.currentText,comboBox_objectPoint.currentText)
                }

                Label {
                    id: label1
                    x: 18
                    y: 73
                    text: qsTr("Object:")
                    font.pointSize: 12
                }

                Label {
                    id: label2
                    x: 32
                    y: 245
                    text: qsTr("Door Point:")
                    font.pointSize: 11
                }

                Button {
                    id: button10
                    x: 110
                    y: 124
                    width: 80
                    height: 28
                    text: qsTr("Delete")
                    onClicked: {



                        DB1.dbDeleteFloorObject(comboBox_CurrentFloor.currentText,comboBox1.currentText);


                        canvasObject.clear()
                        deleteObjects()
                        readObjects()
                        comboBox1.currentIndex="0"






                    }
                }



            }

            Item{



                ComboBox {
                    id: comboBox_Elevator
                    x: 99
                    y: 47
                    height: 28
                    model:listElevator
                    textRole: "Name"
                    visible: true
                    currentIndex:0
                    onCurrentTextChanged: {
                        DB1.dbReadElevatorPoint(comboBox_Elevator.currentText)
                    }
                }

                Label {
                    id: label3
                    x: 34
                    y: 54
                    text: qsTr("Elevator:")
                    font.pointSize: 10
                }

                ComboBox {
                    id: comboBox_elevatorPoint
                    x: 107
                    y: 142
                    width: 109
                    height: 28
                    model: pointCoordintes
                    textRole: "Name"
                }

                Label {
                    id: label8
                    x: 47
                    y: 148
                    text: qsTr("Point:")
                    font.pointSize: 10
                }

                ComboBox {
                    id: comboBox6
                    x: 99
                    y: 257
                    height: 28
                }

                ComboBox {
                    id: comboBox7
                    x: 99
                    y: 332
                    height: 28
                }

                Button {
                    id: button11
                    x: 28
                    y: 380
                    width: 75
                    height: 29
                    text: qsTr("Add New")
                    onClicked: {


                    }
                }

                Button {
                    id: button9
                    x: 144
                    y: 380
                    width: 75
                    height: 29
                    text: qsTr("Delete")
                }

                Label {
                    id: label9
                    x: 30
                    y: 262
                    text: qsTr("Escalator:")
                    font.pointSize: 10
                }

                ToolSeparator {
                    id: toolSeparator1
                    x: 117
                    y: 132
                    height: 200
                    rotation: 90
                }

                Button {
                    id: button6
                    x: 149
                    y: 93
                    width: 70
                    height: 25
                    text: qsTr("Delete")
                }

                Button {
                    id: button5
                    x: 36
                    y: 93
                    width: 70
                    height: 25
                    text: qsTr("Add New")
                    onClicked: {
                        DB1.dbAddElevator(comboBox_CurrentFloor.currentText)

                        DB1.dbReadElevator(comboBox_CurrentFloor.currentText)
                        comboBox_Elevator.currentIndex="0"
                    }
                }

                Label {
                    id: label10
                    x: 50
                    y: 318
                    text: qsTr("Point:")
                    font.pointSize: 10
                }

                Button {
                    id: button12
                    x: 87
                    y: 192
                    width: 75
                    height: 29
                    text: qsTr("Save")
                    onClicked: {

                        DB1.dbInsertElevatorPoint(comboBox_Elevator.currentText,comboBox_elevatorPoint.currentText)
                    }
                }

            }

        }
    }



    Button {
        id: button4
        x: 1724
        y: 971
        width: 90
        height: 33
        text: qsTr("Cancel")
    }

    Label {
        id: label
        x: 1522
        y: 185
        width: 27
        text: qsTr("Edit:")
        font.pointSize: 18
    }








}
