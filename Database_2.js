function dbInit()
{

    var db = LocalStorage.openDatabaseSync("DataBase", "1.0", "Base", 1000000)

    try {
        db.transaction(function (tx) {


            tx.executeSql('CREATE TABLE IF NOT EXISTS Company (Name text, IdContact int,Description text)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Type (TypeName text, IdCategory text)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Category(Name text)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Contact (Name text, Email text,Phone text)');

           tx.executeSql('CREATE TABLE IF NOT EXISTS ObjectUser (IdObject int, IdCompany int,ShownName text,IdType int,DateIN text,DateOUT text)');


            tx.executeSql('CREATE TABLE IF NOT EXISTS Floors(Name text,Map text)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Points (Name text,X int, Y int,IdFloor int)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Distance (Name text, d float, IdFloor int)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Objects (Name text,IdFloor int,IdPointDoor text,IdObjectPosition int,Size text)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS ObjectPosition (Name text,X int, Y int)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS Elevator (Name text,IdPoint text, IdFloor int)');




          // var results =tx.executeSql('INSERT INTO User (Name) SELECT "EMPTY" WHERE NOT EXISTS (SELECT 1 FROM User WHERE Name="EMPTY")');



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

function dbReadObjectUser()
{
    var db = dbGetHandle()

    listObjectUser.clear()

    listModel.clear()
    filterModel.clear()







    db.transaction(function (tx) {

           var result=tx.executeSql('SELECT ShownName as Name,Type.IdCategory as Type FROM ObjectUser INNER JOIN Type ON ObjectUser.IdType=Type.rowid WHERE DateOUT IS NULL');



        for (var i=0;i<result.rows.length;i++)
          {
            console.log(result.rows.item(i).Name)

            if( result.rows.item(i).Name!==null)
               {
                listObjectUser.append({

                                  Name: result.rows.item(i).Name

                                     } )

                listModel.addData(result.rows.item(i).Name,result.rows.item(i).Type)





            }
        }


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

           listAllFloors.append({

             Name: result.rows.item(i).Name,

                                } )
        }


})
}
function dbReadObject(name)
{
     var db = dbGetHandle()

    db.transaction(function (tx) {

        var objectID=tx.executeSql('SELECT rowid FROM Objects WHERE Name=?',name);
/*
 var result = tx.executeSql(
   'SELECT DateIN,Company.Name as Name,ShownName,Type.TypeName as Type, Type.IdCategory as Category FROM ObjectUser INNER JOIN Type ON ObjectUser.IdType=Type.rowid INNER JOIN Company ON ObjectUser.IdCompany=Company.rowid INNER JOIN Object ON ObjectUser.IdObject=Object.rowid WHERE ObjectUser.IdObject=? ORDER BY ObjectUser.rowid DESC LIMIT 1',objectID)

*/
        if(name==="")
            return
        else
            {

             var count=tx.executeSql('SELECT rowid FROM ObjectUser WHERE IdObject=?',objectID.rows[0].rowid);

            if(count.rows.length===0)
           {

            text1.text=""
            text2.text=""
            text3.text=""
            text4.text=""
            text5.text=""
            text6.text=""
        }
        else
            {

             var result = tx.executeSql( 'SELECT ObjectUser.DateIN,Company.Name as Name,ObjectUser.ShownName,Objects.IdFloor as Floor,Type.TypeName as TypeName,Type.IdCategory as Category FROM ObjectUser INNER JOIN Objects ON ObjectUser.IdObject=Objects.rowid LEFT JOIN Company ON ObjectUser.IdCompany=Company.rowid LEFT JOIN Type ON ObjectUser.IdType=Type.rowid  WHERE Objects.Name=? ORDER BY ObjectUser.rowid DESC LIMIT 1',name)


                    var userName = result.rows[0].Name;
                    var showName=result.rows[0].ShownName;
                   var type=result.rows[0].TypeName;
                    var category=result.rows[0].Category;
                    var dateIN=result.rows[0].DateIN;
                    var floor = result.rows[0].Floor;

                    text1.text=String([userName])
                    text2.text=String([showName])
                    text3.text=String([type])
                    text4.text=String([category])
                    text5.text=String([dateIN])
                    text6.text=String([floor])
           }
       }

   })
}


function dbReadAllObjects()
{
    var db = dbGetHandle()
     listAllObjects.clear();
    db.transaction(function (tx) {
        var results = tx.executeSql('SELECT Name FROM Object')
        for (var i = 0; i < results.rows.length; i++) {

            listAllObjects.append({
                                // id: results.rows.item(i).rowid,
                                 //checked: " ",
                                 Name: results.rows.item(i).Name
                                 //Naziv: results.rows.item(i).Name,
                                 //Sprat: results.rows.item(i).Sprat,
                                 //Tekst: results.rows.item(i).Kategorija
                             })

        }


    })}

function dbInsertCompany(name,contact,description)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {

        var idContact = tx.executeSql('SELECT rowid FROM Contact WHERE Name=?',contact)
        tx.executeSql('INSERT INTO Company VALUES(?,?,?)',
                      [name,idContact.rows[0].rowid,description])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    //return rowid;
}

function dbInsertContact(name,email,phone)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO Contact VALUES(?,?,?)',
                      [name,email,phone])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    //return rowid;
}

function dbInsertType(type,category)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO Type VALUES(?,?)',
                      [type,category])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    //return rowid;
}


function dbEditCompany(name,contact,description)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        var idContact = tx.executeSql('SELECT rowid FROM Contact WHERE Name=?',contact)
        tx.executeSql('UPDATE Company SET Name=?,IdContact=?,Description=? WHERE Name=?' ,
                      [name,idContact.rows[0].rowid,description,name])
        /*var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId*/
    })
    //return rowid;
}

function dbDeleteCompany(name)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('DELETE FROM Company WHERE Name=?',name)
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    //return rowid;
}


function dbListCompany()
{
    var db = dbGetHandle()
    listCompany.clear();
    db.transaction(function (tx) {



        var results = tx.executeSql('SELECT Company.Name as Name, Contact.Name as Contact,Description FROM Company INNER JOIN Contact ON Company.IdContact=Contact.rowid')
        for (var i = 0; i < results.rows.length; i++) {

            listCompany.append({


                                 SN:String([i]),

                                 Name: results.rows.item(i).Name,
                                 Contact: results.rows.item(i).Contact,
                                 Description: results.rows.item(i).Description

                             })

        }

    })

}


function dbListContact(name)
{
    var db = dbGetHandle()
    listContacts.clear();
    var i=0
    db.transaction(function (tx) {

        if(name==="")
            {
                var results = tx.executeSql('SELECT * FROM Contact')
                 for ( i = 0; i < results.rows.length; i++) {

                   listContacts.append({


                                 SN:String([i]),

                                 Name: results.rows.item(i).Name,
                                 Email: results.rows.item(i).Email,
                                 Phone: results.rows.item(i).Phone

                             })

        }
      }
        else{


            var contact = tx.executeSql('SELECT * FROM Contact WHERE Name=?',name)


            var contactName=contact.rows[0].Name;
            var contactEmail=contact.rows[0].Email;
            var contactPhone=contact.rows[0].Phone;

             text_Contact_Name.text=contactName;

             text_Contact_Email.text=contactEmail;
             text_Contact_Phone.text=contactPhone;





        }

    })

}

function dbListType()
{
    var db = dbGetHandle()
    listType.clear();
    db.transaction(function (tx) {
        var results = tx.executeSql('SELECT * FROM Type')
        for (var i = 0; i < results.rows.length; i++) {

            listType.append({


              Type: results.rows.item(i).TypeName,
              Category: results.rows.item(i).Category,

               SN:String([i+1])


              })

        }

    })

}
function dbHistory()
{
    var db = dbGetHandle()
    listHistory.clear();
    db.transaction(function (tx) {
        var results = tx.executeSql('SELECT Objects.Name as ObjectName,Company.Name as CompanyName,Type.TypeName as Type,ShownName,DateIN,DateOUT FROM ObjectUser LEFT JOIN Company ON (ObjectUser.IdCompany=Company.rowid) LEFT JOIN Type ON (ObjectUser.IdType=Type.rowid ) INNER JOIN Objects ON ObjectUser.IdObject=Objects.rowid  ORDER BY ObjectUser.rowid DESC')


        for (var i = 0; i < results.rows.length; i++) {




            listHistory.append({

                                 SN:String([i+1]),
                                 ObjectName: results.rows.item(i).ObjectName,
                                 CompanyName: results.rows.item(i).CompanyName,
                                 ShownName: results.rows.item(i).ShownName,
                                 Type: results.rows.item(i).Type,

                                 DateIN: results.rows.item(i).DateIN,
                                 DateOUT:results.rows.item(i).DateOUT

                             })



        }

    })

}
function dbLogOutUserObject(objectName)
{

    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {



       var idObject= tx.executeSql('SELECT rowid FROM Objects WHERE Name=?',objectName);
       //var idUser= tx.executeSql('SELECT rowid FROM Company WHERE Name=?',userName);

       // console.log("ID: "+idObject+" "+idUser)
        //var rowid=tx.executeSql('SELECT rowid FROM ObjectUser WHERE rowid=(SELECT MIN(rowid) FROM ObjectUser)');

        tx.executeSql('INSERT INTO ObjectUser VALUES(?,?,?,?,?,?)',
                      [idObject.rows[0].rowid,'','','','',''])


    })

}

function dbInsertLogOUT(objectName,logout)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {



       var idObject= tx.executeSql('SELECT rowid FROM Objects WHERE Name=?',objectName);
        /*var dateOut=tx.executeSql('SELECT DateOUT FROM UsedObject WHERE UsedObject.IdObject=? AND UsedObject.rowid=(SELECT MAX(rowid) FROM UsedObject WHERE UsedObject.IdObject=?)',
                                  [idObject.rows[0].rowid,idObject.rows[0].rowid]);*/

        var count= tx.executeSql('SELECT rowid FROM ObjectUser WHERE IdObject=?',idObject.rows[0].rowid);
        if(count.rows.length===0)
        return
    else
        {
       var emptyObject=tx.executeSql('SELECT IdCompany FROM ObjectUser WHERE ObjectUser.IdObject=? AND ObjectUser.rowid=(SELECT MAX(rowid) FROM ObjectUser WHERE ObjectUser.IdObject=?)',[idObject.rows[0].rowid,idObject.rows[0].rowid])
       console.log("Company:"+emptyObject.rows[0].IdCompany)

        if(emptyObject.rows[0].IdCompany===null)
          {
            console.log("Praznooo")
            return
        }
        else
            {

          tx.executeSql('UPDATE ObjectUser SET DateOUT=? WHERE ObjectUser.IdObject=? AND ObjectUser.rowid=(SELECT MAX(rowid) FROM ObjectUser WHERE ObjectUser.IdObject=?)',
                        [logout,idObject.rows[0].rowid,idObject.rows[0].rowid])

        }
    }





    })

}

function dbObjectHistory(objectName)
{
    var db = dbGetHandle()
    listobjectHistory.clear();

      console.log("OB Name: "+objectName)
    db.transaction(function (tx) {

    var idObject= tx.executeSql('SELECT rowid FROM Object WHERE Object.Name=?',objectName);

    var results = tx.executeSql(
   'SELECT User.Name as UserName, DateIN, DateOUT FROM UsedObject INNER JOIN User ON UsedObject.IdUser=User.rowid WHERE(UsedObject.IdObject=?)  ORDER BY UsedObject.rowid DESC',idObject.rows[0].rowid);
        for (var i = 0; i < results.rows.length; i++) {

            listobjectHistory.append({

                                 SN:String([i+1]),

                                 UserName: results.rows.item(i).UserName,
                                 DateIN: results.rows.item(i).DateIN,
                                 DateOUT:results.rows.item(i).DateOUT

                             })

        }

    })


}


function dbObjectUserInsert(objectName,companyName,shownName,type,dateIN)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {



       var idObject= tx.executeSql('SELECT rowid FROM Objects WHERE Name=?',objectName);
       var idCompany= tx.executeSql('SELECT rowid FROM Company WHERE Name=?',companyName);
       var idType= tx.executeSql('SELECT rowid FROM Type WHERE TypeName=?',type);



        tx.executeSql('INSERT INTO ObjectUser VALUES(?,?,?,?,?,?)',
                      [idObject.rows[0].rowid,idCompany.rows[0].rowid,shownName,idType.rows[0].rowid,dateIN,""])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })

}
function dbReadLastRow()
{
    var db = dbGetHandle()
    var rowid = 0;
    var last


    db.transaction(function (tx) {

        var result = tx.executeSql('SELECT * FROM ObjectUsers WHERE rowid=(SELECT MAX(rowid) FROM ObjectUsers)')
        //rowid = result.insertId
         var value = result.rows[0].Name;
        //last=result.rows.item(0).Name;
        label5.text=value


    })

}
