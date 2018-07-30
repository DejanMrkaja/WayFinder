import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.LocalStorage 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "Database.js" as DB1
import "Database_2.js" as DB2

Item {
    id: item1
    width: 1920
    height: 1080



    property var current_floor:1
    property var floor
    property var objects_number
    property  var textObject:[]
    property var imageObject:[]
    property var areaObject:[]
    property var ob:[]

    property var numberfloor
    property var destObject

    property bool findPress:false






    Component.onCompleted:{

        listView_Floor.currentIndex="0"

        DB1.dbReadFrontMap("Floor_1")
        //readObjectsPosition()



    }

    function drawRoute(end)
    {
        canvasRoute.clear()

        findPress=true

        // timer_Home2.interval=13000;


        timer_Home2.stop()
        // timer_Home2.start()

        var destination=DB1.readDestination(end)


        var p=destination[0].split("P")


        destObject=p[1]

        var floorName=destination[1]

        console.log("DDD: "+destination)

        console.log("FFFF:"+floorName)

        if(floorName!=="Floor_1")
        {
            var str=floorName

            text3_Floor.text=str.replace('_','  ');


            listView_Floor.currentIndex=Number([DB1.dbIDFloor("Floor_1")])-1

            var el=DB1.dbReadElevatorPosition("Floor_1")
            var el2=el.split("P")

            DB1.dbReadFrontMap("Floor_1")
            DB1.createMatrix("Floor_1")

            var path1=DB1.calculatePath("0",el2[1])

            DB1.createList(path1,"Floor_1")

            numberfloor=Number([DB1.dbIDFloor(floorName)])-1
            floor=floorName;
            canvasRoute.requestPaint()



            timer_elevatorAnimation.start()






        }

        else{


            /*DB1.dbReadFrontMap(floorName)
            DB1.createMatrix(floorName)*/
            listView_Floor.currentIndex=Number([DB1.dbIDFloor(floorName)])-1
            DB1.dbReadFrontMap("Floor_1")
            DB1.createMatrix("Floor_1")

            var path=DB1.calculatePath("0",p[1])
            DB1.createList(path,floorName)

            canvasRoute.requestPaint()

            timer_Home.start()

        }




        //listView_Floor.currentIndex=Number([DB1.dbIDFloor(floorName)])-1







        //DB.dbGetCoordinates()



    }

    function showObject(name)
    {
        text_search.text=name
    }

    function readObjectsPosition()
    {



        var floorName=listAllFloors.get(listView_Floor.currentIndex).Name


        console.log("F_NAME:"+floorName)

        DB1.dbReadObjectsPosition(floorName)
        for(var i=0;i<objectsPosition.count;i++)
        {

            createObject(objectsPosition.get(i).Name,objectsPosition.get(i).X, objectsPosition.get(i).Y,i)
        }


        objects_number=objectsPosition.count


    }






    function createObject(name,x,y,num)
    {
        var X=Number([x])-45
        var Y=Number([y])-31

        var Xtext=X-20
        var Ytext=Y+35
        var Name=name
        var source="/images/loc.png"
        var imgID="img_"+Name
        var maID="ma_"+Name
        var color="#00000000"




        areaObject[num] = Qt.createQmlObject("import QtQuick 2.0;
    Rectangle {
        id: rect_Object;
        x:"+X+";
        y:"+Y+";
        width: 90;
        height: 63;
        z:2;
        color:'"+color+"';




        Image {
            id: imgID;
            x: 18;
            y: 2;
            width: 32;
            height: 32;
            anchors.horizontalCenter: parent.horizontalCenter;
            source: '"+source+"'
        }

        Text {

            x: 0;
            y: 41;
            width: 80;
            height: 22;
            text: '"+Name+"';
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: Text.AlignHCenter;
            anchors.horizontalCenterOffset: -1;
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: 17
        }
        MouseArea {
            id: maID;
            anchors.fill: parent;
          onPressed:{console.log('"+Name+"');imgID.scale=1.4}
          onReleased:{
                    setInfoDialog('"+(x+25)+"','"+(y-45)+"','"+Name+"');
                   showObject('"+Name+"');imgID.scale=1}
        }

    }",
                                             rectangle,
                                             "dynamicSnippet1");

    }



    function deleteObjects()
    {

        if(areaObject.length==0)
            return
        else
        {
            for(var i=0;i<objects_number;i++)
            {
                if(!areaObject[i])
                    return
                else
                {

                    areaObject[i].destroy();
                }

            }
        }
    }

    function setInfoDialog(x,y,text)
    {
        var X=10;
        var Y=20;

        infoDialog.x=x;
        infoDialog.y=y;
        info_Text.text=text
        infoDialog.visible=true
    }






    MouseArea {
        id: mouseArea_Settings

        x: 1834
        y: 17
        width: 61
        height: 50
        onClicked: {

            homeSettings.visible=true
            // homeSettings.visibility="FullScreen"
            //deleteObjects()

            console.log("Pritisno")

        }




    }

    Rectangle {
        id: rectangle
        x: 6
        y: 93
        width: 1490
        height: 925

        color: "#00000000"
        z: 1
        border.color: "#676779"
















        AnimatedImage {
            id: image_Arrow
            x: 718
            y: 542
            width: 27
            height: 30

            z: 2
            source: "images/arrow.gif"
            playing: listAllFloors.get(listView_Floor.currentIndex).Name==="Floor_1"? true:false
            visible: (listAllFloors.get(listView_Floor.currentIndex).Name==="Floor_1")? true:false
        }


        Rectangle{
            id:infoDialog
            x: 69
            y: 129
            width: 146
            height: 76
            visible: false
            color: "#00000000"
            radius: 8
            border.color: "#00000000"
            opacity: 1
            clip: true
            z: 1

            Text{
                id:info_Text
                x: 17
                y: 5

                width: 123
                height: 67
                color: "#141414"
                text:"ASDASFDSADASd tgte"
                font.bold: true
                renderType: Text.NativeRendering
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignTop
                elide: Text.ElideLeft
                horizontalAlignment: Text.AlignLeft
                z: 2
                fontSizeMode: Text.FixedSize
                clip: true
                font.letterSpacing: 0
                font.wordSpacing: 6
                font.pointSize: 9
                visible: true
            }

            Rectangle {
                id: rectangle1
                color: "#ffffff"
                radius: 8
                z: 1
                opacity: 0.5
                anchors.fill: parent
            }

            Image {
                id: image
                x: 0
                y: -16
                width: 14
                height: 22
                z: 1
                anchors.verticalCenterOffset: 1
                anchors.verticalCenter: parent.verticalCenter
                source: "images/arrow-left-01-128.png"
            }



        }


        AnimatedImage {
            id: image_front
            anchors.rightMargin: 2
            anchors.leftMargin: 2
            anchors.bottomMargin: 2
            anchors.topMargin: 2
            anchors.fill: parent

            //source: "qrc:/qtquickplugin/images/template_image.png"
        }



        Canvas {
            id: canvasRoute
            objectName: "canvasRoute"

            z: 3

            // property var koord:[a,b,e,f]


            function clear() {

                pathCoordinates.clear();

                var ctx = getContext("2d");
                ctx.reset();
                canvasRoute.requestPaint();

            }
            function arrow(fromx,fromy, tox, toy){

                var ctx2=getContext("2d");
                var headlen = 9;   // length of head in pixels
                var angle = Math.atan2(toy-fromy,tox-fromx);
                ctx2.moveTo(tox,toy);
                ctx2.lineTo(tox, toy);
                ctx2.lineTo(tox-headlen*Math.cos(angle-Math.PI/5),toy-headlen*Math.sin(angle-Math.PI/5));
                ctx2.moveTo(tox, toy);
                ctx2.lineTo(tox-headlen*Math.cos(angle+Math.PI/5),toy-headlen*Math.sin(angle+Math.PI/5));
            }



            property real start_x: 0
            property real start_y: 0
            property real end_x
            property real end_y
            property bool dashed: true
            property real dash_length: 11
            property real dash_space: 13
            property real line_width: 2.3
            property real stipple_length: (dash_length + dash_space) > 0 ? (dash_length + dash_space) : 20
            property color draw_color: "red"
            anchors.fill: parent



            onPaint: {

                /*  var context = getContext("2d");

                context.beginPath();
                context.lineWidth = 3;
                context.lineJoin="round";
                //context.miterLimit=5
                context.lineCap="square";
                context.strokeStyle = "red";
                //context.setLineDash([10]);


                //var start = koord[0]

                if(pathCoordinates.count>0)
                {

                    context.moveTo(pathCoordinates.get(0).X,pathCoordinates.get(0).Y)



                    for(var j=0; j<pathCoordinates.count+1;j++ ){

                        var end=pathCoordinates.get(j)

                        context.lineTo(end["X"], end["Y"]);
                        context.moveTo(end["X"], end["Y"]);

                    }
                    context.stroke();
                }

            }*/

                // Get the drawing context



                var ctx = canvasRoute.getContext('2d')
                // set line color
                ctx.strokeStyle = draw_color;
                ctx.lineWidth = line_width;
                ctx.beginPath();

                if(pathCoordinates.count>0)
                {

                    for(var j=0; j<pathCoordinates.count-1;j++ ){

                        var k=j+1;
                        var start=pathCoordinates.get(j)
                        var end=pathCoordinates.get(k)



                        start_x=start["X"];
                        start_y=start["Y"];
                        end_x=end["X"];
                        end_y=end["Y"];

                        //canvasRoute.arrow(start_x,start_y,end_x,end_y)



                        if (!dashed)
                        {
                            ctx.moveTo(start_x,start_y);
                            ctx.lineTo(end_x,end_y);
                        }
                        else
                        {
                            var dashLen = stipple_length;
                            var dX = end_x - start_x;
                            var dY = end_y - start_y;
                            var dashes = Math.floor(Math.sqrt(dX * dX + dY * dY) / dashLen);
                            if (dashes == 0)
                            {
                                dashes = 1;
                            }
                            var dash_to_length = dash_length/dashLen
                            var space_to_length = 1 - dash_to_length
                            var dashX = dX / dashes;
                            var dashY = dY / dashes;
                            var x1 = start_x;
                            var y1 = start_y;




                            ctx.moveTo(x1,y1);



                            var q = 0;
                            while (q++ < dashes) {
                                x1 += dashX*dash_to_length;
                                y1 += dashY*dash_to_length;



                                ctx.lineTo(x1, y1);

                                var x11=x1
                                var y11=y1




                                x1 += dashX*space_to_length;
                                y1 += dashY*space_to_length;


                                canvasRoute.arrow(start_x,start_y,x11,y11)

                                ctx.moveTo(x1, y1);





                                //arrow.lineTo(x1 / 2, y1 * 0.1)


                            }

                        }
                    }

                    ctx.stroke();
                }
            }

        }

        Rectangle {
            id: rectangle_Floor
            x: -145
            y: 748
            width: 320
            height: 135
            color: "#00000000"
            anchors.horizontalCenterOffset: -21
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: text2_goto
                x: 219
                y: 27
                width: 188
                height: 54
                color: "#0d8de9"
                text: qsTr("GO TO")
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font.pixelSize: 35
            }

            Text {
                id: text3_Floor
                x: 219
                y: 73
                width: 188
                height: 54
                color: "#0d8de9"
                text: qsTr("")
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 45
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }


    Timer{
        id:timer_elevatorAnimation
        interval: 7000;
        running: false;
        repeat: false;
        onTriggered: {

            image_Arrow.visible=false

            image_front.source="/images/elevator_2.gif"
            rectangle_Floor.visible=true

            image_front.playing=true
            deleteObjects()
            canvasRoute.clear()

            timer_loadFloor.start()
        }

    }


    Timer {
        id:timer_loadFloor
        objectName: "timer_lift"
        interval: 6200;
        running: false;
        repeat: false

        onTriggered: {



            // animationElevator.visible=false
            loadFloor(floor,numberfloor,destObject)
            rectangle_Floor.visible=false

            timer_Home.start()
            timer_Home2.restart()







        }
    }
    Timer{
        id:timer_Home
        interval: 12000;
        running: false;
        repeat: false;
        onTriggered: {



            canvasRoute.clear()
            listView_Floor.currentIndex=Number([DB1.dbIDFloor("Floor_1")])-1
            //DB1.dbReadFrontMap("Floor_1")
            // DB1.createMatrix("Floor_1")


            image_Arrow.visible=true
            text_search.text=""
            filterModel.setFilterCategory("")



        }

    }
    Timer{
        id:timer_Home2
        interval: 7000
        running: false;
        repeat: false;
        onTriggered: {

            //listView_Floor.currentIndex=Number([DB1.dbIDFloor("Floor_1")])-1

            text_search.text=""
            findPress=false
            infoDialog.visible=false
            filterModel.setFilterCategory("")


        }

    }

    function loadFloor(nameFloor,numFloor,destination)


    {

        canvasRoute.clear()

        listView_Floor.currentIndex=numFloor
        readObjectsPosition()

        var el=DB1.dbReadElevatorPosition(nameFloor)
        var el2=el.split("P")

        DB1.dbReadFrontMap(nameFloor)
        DB1.createMatrix(nameFloor)
        var path1=DB1.calculatePath(el2[1],destination)

        DB1.createList(path1,nameFloor)
        canvasRoute.requestPaint()


    }




    Image {
        id: rectangle_3_copy_2
        source: "images/FronScreen_3.jpg"
        x: 0
        y: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: -1
        anchors.leftMargin: 0
        anchors.topMargin: 1
        opacity: 1
        anchors.fill: parent

        MouseArea {
            id: mouseArea_Find
            x: 1509
            y: 632
            //949
            width: 388
            height: 65//520
            //312
            //67
            onClicked:{

                infoDialog.visible=false

                timer_Home2.restart()


                drawRoute(text_search.text)
            }



        }


        MouseArea {
            id: mouseArea3
            x: 1443
            y: 1199
            width: 69
            height: 67
            onClicked:{



            }
        }


        Text {
            id: text1
            x: 772
            y: 1354
            width: 125
            height: 43
            color: "#1761be"
            // text: current_floor==="L"? "Lift":"Sprat "+current_floor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 21
        }


        MouseArea {
            id: mouseArea5
            x: 1346
            y: 1199
            width: 69
            height: 67
            onClicked:{



            }
        }


        MouseArea {
            id: mouseArea4
            x: 1541
            y: 1199
            width: 69
            height: 67
            onClicked:{



            }
        }


        TextField {
            id:text_search
            x: 1519
            y: 98
            width: 372
            height: 56
            //954
            //104
            //301
            //54
            placeholderText: "Type to Search"
            Layout.fillWidth: true
            font.pointSize: 18


            style:  TextFieldStyle {
                textColor: "black"
                background: Rectangle {
                    color: "#00000000"
                    radius: 5
                    implicitWidth: 100
                    implicitHeight: 30
                    border.color: "#00000000"
                    border.width: 1
                }
            }

            onTextChanged: {
                filterModel.setFilterString(text);

                timer_Home2.stop()
                timer_Home2.interval=7000
                timer_Home2.start()
            }






        }

        MouseArea {
            id: mouseArea_Right
            x: 906
            y: 1019
            width: 53
            height: 53
            onPressed: {

                canvasRoute.clear()

                listView_Floor.incrementCurrentIndex()
                text_search.text=""


                var floorName=listAllFloors.get(listView_Floor.currentIndex).Name
                deleteObjects()
                readObjectsPosition()


                DB1.dbReadFrontMap(floorName)
                DB1.createMatrix(floorName)
                infoDialog.visible=false



            }
        }

        MouseArea {
            id: mouseArea_Left
            x: 514
            y: 1019
            width: 52
            height: 53
            onPressed: {


                canvasRoute.clear()
                listView_Floor.decrementCurrentIndex()
                text_search.text=""


                var floorName=listAllFloors.get(listView_Floor.currentIndex).Name

                deleteObjects()
                readObjectsPosition()


                DB1.dbReadFrontMap(floorName)
                DB1.createMatrix(floorName)

                infoDialog.visible=false






            }



        }




        ListView {
            id: view
            x: 1518
            y: 185
            width: 372
            height: 415
            snapMode: ListView.SnapToItem
            // 957
            //185
            //295
            //310
            preferredHighlightBegin: 0
            highlightResizeDuration: 1
            clip: true
            highlightRangeMode: ListView.NoHighlightRange
            model: filterModel
            Layout.minimumHeight: 25
            Layout.fillHeight: true
            Layout.fillWidth: true
            cacheBuffer: 100
            spacing: 7



            delegate: Rectangle{
                id:rect
                width: parent.width
                radius: 5
                anchors.horizontalCenter: parent.horizontalCenter
                height:45
                color:Qt.lighter("#4889d1", 1.2)


                MouseArea{
                    id:mouse_list
                    anchors.fill:parent
                    onClicked: {

                        console.log("DEST:"+name)
                        text_search.text=name




                    }


                    onPressed: {

                        rect.opacity=0.8
                        rect.scale=1.03

                    }
                    onReleased: {

                        rect.opacity=1
                        rect.scale=1

                    }

                }

                Text {
                    id: nameTxt
                    text:name
                    font.pointSize: 18
                    color: "#FFFFFF"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            onContentYChanged: timer_Home2.restart()



        }

        ListView {
            id: listView_Floor
            x: 596
            y: 1020
            width: 296
            height: 53
            spacing: 2
            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            // Component.onCompleted: readObjectsPosition()
            delegate: Item {
                id: item2
                x: 5
                width: 290
                height:50
                Row {
                    id: row1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20
                    Text {
                        color: "#0a47a7"

                        text: Name
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize:30
                        font.bold: false
                        anchors.verticalCenter: parent.verticalCenter
                    }


                }
            }
            model: listAllFloors
            onCurrentIndexChanged: {
                deleteObjects()
                readObjectsPosition()
                var floorName=listAllFloors.get(listView_Floor.currentIndex).Name
                DB1.dbReadFrontMap(floorName)
                DB1.createMatrix(floorName)
                if(floorName==="Floor_1")
                {
                    image_Arrow.visible=true
                }
                else
                {
                    image_Arrow.visible=false
                }

            }


        }

        MouseArea {
            id: mouseArea
            x: 1503
            y: 728
            width: 112
            height: 78
            onClicked: {

                filterModel.setFilterCategory("Shopping")


             timer_Home2.restart()
            }
        }

        MouseArea {
            id: mouseArea1
            x: 1647
            y: 728
            width: 111
            height: 78
            onClicked: {

                filterModel.setFilterCategory("Gastro")
                timer_Home2.restart()
               }
        }

        MouseArea {
            id: mouseArea2
            x: 1794
            y: 728
            width: 111
            height: 78
            onClicked: {

                filterModel.setFilterCategory("Entertainment")
                timer_Home2.restart()
               }
        }

        MouseArea {
            id: mouseArea6
            x: 1504
            y: 822
            width: 111
            height: 78
            onClicked: filterModel.setFilterCategory("Services")
        }

        MouseArea {
            id: mouseArea7
            x: 1650
            y: 822
            width: 111
            height: 78
            onClicked: {

                filterModel.setFilterCategory("Offices")
                timer_Home2.restart()
               }
        }

        MouseArea {
            id: mouseArea8
            x: 1794
            y: 822
            width: 111
            height: 78
        }


    }




}

