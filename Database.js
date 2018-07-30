

function dbInit()
{

    var db = LocalStorage.openDatabaseSync("DataBase", "1.0", "Base", 1000000)

    try {
        db.transaction(function (tx) {

            tx.executeSql('CREATE TABLE IF NOT EXISTS Floors(Name text,Map text)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Points (Name text,X int, Y int,IdFloor int)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Distance (Name text, d float, IdFloor int)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Objects (Name text,IdFloor int,idPointDoor text,IdObjectPosition int,Size text)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS ObjectPosition (Name text,X int, Y int)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Elevator (Name text,IdPoint text, IdFloor int)');

            tx.executeSql('CREATE TABLE IF NOT EXISTS Company (Name text, IdContact int,Description text)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Type (TypeName text, IdCategory text)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Category(Name text)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Contact (Name text, Email text,Phone text)');

           tx.executeSql('CREATE TABLE IF NOT EXISTS ObjectUser (IdObject int, IdCompany int,ShownName text,IdType int,DateIN text,DateOUT text)');

        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };

}

function dbGetHandle()
{
    try {
        var db = LocalStorage.openDatabaseSync("DataBase", "1.0", "Base", 1000000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}



function dbAddFloor(name,mapUrl)
{
    var db = dbGetHandle()

    db.transaction(function (tx) {



              tx.executeSql('INSERT INTO Floors VALUES(?,?)',[name,mapUrl]);

})
}

function dbEditFloor(name,mapUrl)
{
    var db = dbGetHandle()

    db.transaction(function (tx) {



              tx.executeSql('UPDATE Floors SET Map=? WHERE Name=?',[mapUrl,name]);

})
}

function dbReadFloors()
{
    var db = dbGetHandle()

    listAllFloors.clear()



    db.transaction(function (tx) {

           var result=tx.executeSql('SELECT Name FROM Floors');

        for (var i=0;i<result.rows.length;i++)
          {
             console.log("FLOOOR:"+result.rows.item(i).Name)

           listAllFloors.append({

             Name: result.rows.item(i).Name


                                } )
        }


})
}

function dbIDFloor(floor)
{
    var db = dbGetHandle()



    var floorID

    db.transaction(function (tx) {

         floorID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',floor);




})

    return floorID.rows[0].rowid;
}

function dbReadFrontMap(name)
{
    var db1 = dbGetHandle()




    db1.transaction(function (tx) {

           var result1=tx.executeSql('SELECT * FROM Floors WHERE Name=?',name);



         var floorMap=String([result1.rows[0].Map]);

        image_front.source=floorMap




})
}///ODABRATI JEDNU OD OVE DVIJE FUNKCIJE ZA ISCITAVANJE MAPE

function dbReadFloorMap(name)
{
    var db = dbGetHandle()



if(name!=="")
{
    db.transaction(function (tx) {
        //console.log(name)

        var result=tx.executeSql('SELECT * FROM Floors WHERE Name=?',name);

         var floorMap=String([result.rows[0].Map]);

        image.source=floorMap;
        //image_front.source=floorMap


    })
}



}

function dbAddObject(floor,x,y)
{
    var db = dbGetHandle()

    db.transaction(function (tx) {


                var numberFloor=floor.split("_")

        var count=tx.executeSql('SELECT rowid FROM Objects WHERE IdFloor=?',Number([numberFloor[1]]));


        if (count.rows.length>0)
            {


            var numObject=tx.executeSql('SELECT rowid FROM Objects WHERE IdFloor=?',Number([numberFloor[1]]));

           var number=Number([numObject.rows.length])+1;

            var nameObject="object_"+numberFloor[1]+"_"+number;
            var namePosition="P_"+numberFloor[1]+"_"+number
            tx.executeSql('INSERT INTO ObjectPosition VALUES(?,?,?)',[namePosition,x,y]);

            var positionID=tx.executeSql('SELECT rowid FROM ObjectPosition WHERE Name=?',namePosition);


          tx.executeSql('INSERT INTO Objects VALUES(?,?,?,?,?)',[nameObject,numberFloor[1],"null",positionID.rows[0].rowid,"null"]);



            }
        else
           {

             nameObject="object_"+numberFloor[1]+"_"+1;

             namePosition="P_"+numberFloor[1]+"_"+1
            tx.executeSql('INSERT INTO ObjectPosition VALUES(?,?,?)',[namePosition,x,y]);
            positionID=tx.executeSql('SELECT rowid FROM ObjectPosition WHERE Name=?',namePosition);

             tx.executeSql('INSERT INTO Objects VALUES(?,?,?,?,?)',[nameObject,numberFloor[1],"null",positionID.rows[0].rowid,"null"]);



            }







})
}

function dbReadFloorObjects(name)
{
    var db = dbGetHandle()



    listFloorObjects.clear()
    db.transaction(function (tx) {


    if(name==="")
        return;

    else{
        var floorRowID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',name);
        var result=tx.executeSql('SELECT Objects.Name as Name FROM Objects INNER JOIN Floors ON Objects.IdFloor=Floors.rowid WHERE Objects.IdFloor=?',floorRowID.rows[0].rowid);

        for (var i=0;i<result.rows.length;i++)
          {

           listFloorObjects.append({

             Name: result.rows.item(i).Name

                                } )
          }

         positionObject.clear()


        for (i=0;i<listFloorObjects.count;i++)

        {


        var positionID=tx.executeSql('SELECT IdObjectPosition as ID FROM Objects WHERE Objects.Name=?',[listFloorObjects.get(i).Name])


            var objectPosition=tx.executeSql('SELECT X,Y FROM ObjectPosition WHERE rowid=?',positionID.rows[0].ID)
            positionObject.append({


                        X:objectPosition.rows[0].X,
                        Y:objectPosition.rows[0].Y




                        })
        }
    }




})
}
function dbDeleteFloorObject(floor,object)
{
    var db = dbGetHandle()


    db.transaction(function (tx) {
        var floorRowID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',floor);

        console.log("F:"+floorRowID.rows[0].rowid+"  O: "+object)

     tx.executeSql('DELETE FROM Objects WHERE (Objects.IdFloor=? AND Name=?)',[floorRowID.rows[0].rowid,object]);



})
}
function dbInsertObjectPoint(object,point)
{
    var db = dbGetHandle()

    db.transaction(function (tx) {

        var result=tx.executeSql('SELECT rowid FROM Points WHERE Name=?',point);


        tx.executeSql('UPDATE Objects SET IdPointDoor=? WHERE Name=?',[point,object])


        comboBox_elevatorPoint.currentIndex=result.rows[0].rowid-1
    })



}
function dbReadObjectsPosition(floor)
{
    var db = dbGetHandle()

    objectsPosition.clear()


    db.transaction(function (tx) {


       var floorID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',floor);


        var objects=tx.executeSql('SELECT rowid,Name FROM Objects WHERE IdFloor=?',floorID.rows[0].rowid);



        for(var i=0; i<objects.rows.length;i++)

        {
            console.log("OB ID:" +objects.rows.item(i).rowid)

            var position=tx.executeSql('SELECT ObjectPosition.X AS Xc,ObjectPosition.Y AS Yc FROM Objects INNER JOIN ObjectPosition ON Objects.IdObjectPosition=ObjectPosition.rowid WHERE Objects.Name=?',objects.rows.item(i).Name);
            var name=tx.executeSql('SELECT ShownName FROM ObjectUser WHERE IdObject=? AND DateOUT IS NULL AND DateIN IS NOT NULL',objects.rows.item(i).rowid);

            objectsPosition.append({

                                       Name:name.rows[0].ShownName,
                                       X:position.rows[0].Xc,
                                       Y:position.rows[0].Yc




                                      } )
            }

 })



}

function dbReadObjectPoint(object)
{
    var db = dbGetHandle()

    db.transaction(function (tx) {

         var result=tx.executeSql('SELECT IdPointDoor FROM Objects WHERE Name=?',object);



        //comboBox_objectPoint.currentIndex=Number([result.rows[0].IdPointDoor])-1
    })



}

function dbInsert(name)
{
    var db = dbGetHandle()

    db.transaction(function (tx) {

        var floorRowID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',name);

         var result=tx.executeSql('DELETE FROM Points WHERE Points.IdFloor=?',floorRowID.rows[0].rowid);

        for (var i=0;i<pointCoordintes.count;i++)
            {

              tx.executeSql('INSERT INTO Points VALUES(?,?,?,?)',[pointCoordintes.get(i).Name,pointCoordintes.get(i).X,pointCoordintes.get(i).Y,floorRowID.rows[0].rowid]);
          }

     //   pointCoordintes.clear()


})
}

function dbAddElevator(floor)
{
    var db = dbGetHandle()

    db.transaction(function (tx) {

        var floorRowID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',floor);
        var numberFloor=floor.split("_")

        var count=tx.executeSql('SELECT rowid FROM Elevator WHERE IdFloor=?',floorRowID.rows[0].rowid);

        if(count.rows.length===0)
        {

            var elevatorName="elevator_"+numberFloor[1]+"_1"
            tx.executeSql('INSERT INTO Elevator VALUES(?,?,?)',[elevatorName,"",floorRowID.rows[0].rowid]);

        }
        else
         {
            var ele=tx.executeSql('SELECT Name FROM Elevator ORDER BY Name DESC')

            var maxElevatorNUm=ele.rows[0].Name;

            var readNum=maxElevatorNUm.split("_")

            var elevatorNUM=Number([readNum[2]])+1

            elevatorName="elevator_"+numberFloor[1]+"_"+elevatorNUM
            tx.executeSql('INSERT INTO Elevator VALUES(?,?,?)',[elevatorName,"",floorRowID.rows[0].rowid]);

         }

})
}

function dbReadElevator(floor)
{
    var db = dbGetHandle()


    listElevator.clear()

    db.transaction(function (tx) {

        var floorRowID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',floor);

           var result=tx.executeSql('SELECT Name FROM Elevator WHERE IdFloor=?',floorRowID.rows[0].rowid);

        for (var i=0;i<result.rows.length;i++)
          {

           listElevator.append({

                             Name: result.rows.item(i).Name

                                } )
          }

})
}

function dbReadElevatorPosition(floor)
{
    var db = dbGetHandle()



    var position
    db.transaction(function (tx) {

        var floorRowID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',floor);

           position=tx.executeSql('SELECT IdPoint FROM Elevator WHERE IdFloor=?',floorRowID.rows[0].rowid);

        console.log("F ID: "+floorRowID.rows[0].rowid)
                console.log("ELEVATOR: "+position.rows[0].IdPoint)
})
    return position.rows[0].IdPoint;
}

function dbInsertElevatorPoint(elevator,point)
{
    var db = dbGetHandle()

    db.transaction(function (tx) {

        var result=tx.executeSql('SELECT rowid FROM Points WHERE Name=?',point);
        var count=tx.executeSql('SELECT rowid FROM Elevator');





        tx.executeSql('UPDATE Elevator SET IdPoint=? WHERE Name=?',[point,elevator])




        comboBox_elevatorPoint.currentIndex=result.rows[0].rowid-1
    })



}
function dbReadElevatorPoint(elevator)
{
    var db = dbGetHandle()

    db.transaction(function (tx) {

         var result=tx.executeSql('SELECT rowid FROM Elevator WHERE Name=?',elevator);




        comboBox_elevatorPoint.currentIndex=Number([result.rows[0].rowid])-1
    })



}


function dbInsertDistance(point1,point2,floor)
{
    var db = dbGetHandle()

    db.transaction(function (tx) {

        var floorRowID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',floor);

        var p1=tx.executeSql('SELECT * FROM Points WHERE (Name=? AND IdFloor=?)',[point1,floorRowID.rows[0].rowid]);
        var p2=tx.executeSql('SELECT * FROM Points WHERE (Name=? AND IdFloor=?)',[point2,floorRowID.rows[0].rowid]);

        var distanceName=p1.rows[0].Name + p2.rows[0].Name;
        var distanceName2=p2.rows[0].Name + p1.rows[0].Name;

        var x1 = p1.rows[0].X;
        var y1 = p1.rows[0].Y;


        var x2 = p2.rows[0].X;
        var y2 = p2.rows[0].Y;

        var X=(x1-x2);
        var Y=(y1-y2);

        var d=Math.sqrt((X*X) + (Y*Y)).toFixed(1)

        console.log("Floor: "+floorRowID.rows[0].rowid+"; X1="+x1+" Y1="+y1+" ;   X2="+x2+" Y2="+y2+"   D="+d)

         tx.executeSql('INSERT INTO Distance VALUES(?,?,?)',[distanceName,d,floorRowID.rows[0].rowid]);
        tx.executeSql('INSERT INTO Distance VALUES(?,?,?)',[distanceName2,d,floorRowID.rows[0].rowid]);


     //   pointCoordintes.clear()


})
}

function dbGetCoordinates(name)
{
    var db = dbGetHandle()
    //listCoordinates.clear()
    pointCoordintes.clear()

    db.transaction(function (tx) {
        var floorRowID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',name);

      var result=tx.executeSql('SELECT Points.Name as Name,Points.X as X,Points.Y as Y FROM Points INNER JOIN Floors ON Points.IdFloor=Floors.rowid WHERE Points.IdFloor=?',floorRowID.rows[0].rowid);

       for (var i=0;i<result.rows.length;i++)
         {

         // listCoordinates.append({
            pointCoordintes.append({

            Name: result.rows.item(i).Name,
            X: result.rows.item(i).X,
            Y: result.rows.item(i).Y


                                } )

          }

})
}

function dbDeleteFloorPoints(name)
{
    var db = dbGetHandle()


    db.transaction(function (tx) {
        var floorRowID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',name);

     var result=tx.executeSql('DELETE FROM Points WHERE Points.IdFloor=?',floorRowID.rows[0].rowid);



})
}

function dbFilterObjects(category)
{
    var db = dbGetHandle()


    db.transaction(function (tx) {
        var result=tx.executeSql('SELECT Type.IdCategory as Category FROM ObjectUser INNER JOIN Type ON ObjectUser.IdType=Type.rowid WHERE ObjectUser.ShownName=?',category);


        console.log("Category: "+result.rows[0].Category)



})
}


function createList(path,floor)
{
    var pa=path.length;


     pathCoordinates.clear();

      var db = dbGetHandle()
       db.transaction(function (tx) {

           var floorRowID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',floor);


           for(var i=0;i<pa;i++)

           {

           var result = tx.executeSql('SELECT X, Y FROM Points WHERE (Name=? AND IdFloor=?)',["P"+path[i],floorRowID.rows[0].rowid])
           //rowid = result.insertId
           var x = result.rows[0].X;
           var y = result.rows[0].Y;


           pathCoordinates.append({X:x,Y:y});
       }


    })

}

var matrix = [];
var number2=0;

function readDestination(destination)
{

     var pointDoor
     var floor

    var db = dbGetHandle()

    db.transaction(function (tx) {
         var idObject=tx.executeSql('SELECT IdObject FROM ObjectUser WHERE ObjectUser.ShownName=? AND DateOUT IS NULL',destination);
        console.log("ttt: "+idObject.rows[0].IdObject)

      var object=tx.executeSql('SELECT IdPointDoor as Door, IdFloor FROM Objects WHERE rowid=?',idObject.rows[0].IdObject);

        console.log("IdFloor: "+object.rows[0].IdFloor)
        console.log("Door: "+object.rows[0].Door)


        //var pointID=object.rows[0].Door;


        floor=tx.executeSql('SELECT Name FROM Floors WHERE rowid=?',object.rows[0].IdFloor);

      //var pDoor=tx.executeSql('SELECT Name FROM Points WHERE rowid=?',object.rows[0].Door);

         //console.log("Point: "+pDoor.rows[0].Name)

        pointDoor=object.rows[0].Door


})

    return [pointDoor,floor.rows[0].Name];
}




function createMatrix(floor)
{


    matrix=[]

    var db = dbGetHandle()
    listCoordinates.clear()




    db.transaction(function (tx) {

        var floorID=tx.executeSql('SELECT rowid FROM Floors WHERE Name=?',floor);

   var  numberP=tx.executeSql('SELECT rowid FROM Points WHERE IdFloor=?',floorID.rows[0].rowid);





        for(var k=0; k<numberP.rows.length; k++) {
            matrix[k] = [];
            for(var j=0; j<numberP.rows.length; j++) {
                matrix[k][j] =Infinity;
            }
        }

         var result=tx.executeSql('SELECT * FROM Distance WHERE IdFloor=?',floorID.rows[0].rowid);

       for (var i=0;i<result.rows.length;i++)
         {

          var Name=result.rows.item(i).Name
          var d=result.rows.item(i).d

          var matrixPositions=Name.split("P")

           var Xm=matrixPositions[1]
           var Ym=matrixPositions[2]




           matrix[Xm][Ym]=d
           number2=numberP.rows.length


          }

      /* for (i=0;i<numberP.rows.length;i++)
         {

         for (j=0;j<numberP.rows.length;j++)
             {

              console.log("M["+i+"]["+j+"]: "+matrix[i][j])

         }

     }*/
})

  // return [matrix,number2];
}





function calculatePath(start,end)
{
    var source
    var destination
    var reverseFlag=false
   if(start>end)
   {
       source = end;
       destination =start;
       reverseFlag=true;
   }
   else
   {
       source = start;
       destination =end;
       reverseFlag=false
   }



console.log("Start:"+start+"  End: "+end)

// param for executing dijkstra
var unsettled = [];
var dijkstra = [];
var current_node = source;
var phi = 0;

// params for trackback
var change_val_log = [];
var settled_log = [];
var iteration = 0;

// init dijsktra
for(var key1 in matrix) {
   unsettled.push(key1);
   dijkstra[key1] = Infinity;


}




dijkstra[current_node] = 0;
unsettled.splice(unsettled.indexOf(current_node), 1);
settled_log.push(current_node);
iteration++;


// start dijkstra
while(unsettled.length > 0 && current_node !== destination) {

   var queue = [];
   var adjNodes = matrix[current_node];

   for(var key in adjNodes) {

       // process only unsettled node
       if(unsettled.indexOf(key) > -1) {



           var tmpVal = dijkstra[key];
           dijkstra[key] = Math.min(dijkstra[key], phi + adjNodes[key]);

           // log if value changed
           if(tmpVal !== dijkstra[key]) {
               change_val_log[key] = iteration;
           }
       }
   }

   var keyMin = unsettled[0];
   for(var i = 0; i < unsettled.length; i++) {

       if(dijkstra[keyMin] > dijkstra[unsettled[i]]) {
           keyMin = unsettled[i];
       }
   }

   current_node = keyMin;
   phi = dijkstra[current_node];


   unsettled.splice(unsettled.indexOf(current_node), 1); // remove current node from unsettled
   settled_log[iteration] = current_node;
   iteration++; // increase iteration
}

// do trackback
var path = [];
if(dijkstra[destination]) {

   current_node = destination;
   path.push(current_node);

   do {

       current_node = settled_log[change_val_log[current_node]-1 ];
       path.push(current_node);


   } while(current_node !== source);
}




//console.log(dijkstra);
console.log("optimum length from " + source + " to " + destination + ": " + dijkstra[destination]);
console.log("optimum path: " + path.reverse());   //path.reverse().join(' -> ')

if(reverseFlag===true)
{
  path.reverse()
}


return path;

}

