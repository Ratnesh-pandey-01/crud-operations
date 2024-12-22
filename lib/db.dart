import 'package:flutter/material.dart';
import 'package:flutter_application_2/helper.dart';

class DbPage extends StatefulWidget {
  const DbPage({super.key});
  @override
  State<DbPage> createState() => _DbPageState();
}

class _DbPageState extends State<DbPage> {
  //const DbPage({super.key});
  // Dbhelper db = Dbhelper.getInstance;
  DBHelper? mainDb;
  List<Map<String, dynamic>> allNotes = [];
  TextEditingController descController = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    mainDb = DBHelper.getInstance;
    getInitialNotes();
  }

  getInitialNotes() async {
    allNotes = await mainDb!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Notes Page"),
        centerTitle: true,
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text("${allNotes[index][DBHelper.columnNoteSNo]}"),
                  title: Text(allNotes[index][DBHelper.columnNoteTitle]),
                  subtitle: Text(allNotes[index][DBHelper.columnNoteDesc]),
                  trailing: SizedBox(
                    width: 50,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            mainDb!.updateNote(
                                title: "updated notes",
                                desc: "this is updated",
                                sno: allNotes[index][DBHelper.columnNoteSNo]);
                            getInitialNotes();
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.lightGreen,
                            size: 25,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            mainDb!.deleteNote(
                                sno: allNotes[index][DBHelper.columnNoteSNo]);
                            getInitialNotes();
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.black87,
                            size: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("No Notes yet!!"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //mainDb!.addNote(title: "Note title", desc: "write anything");
          showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (_) {
                return Container(
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        "Add Note",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: titlecontroller,
                        decoration: InputDecoration(
                            hintText: "Enter title here",
                            labelText: "Title",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                            hintText: "Enter desc here",
                            labelText: "Desc",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                addNoteInDb();
                                titlecontroller.clear();
                                descController.clear();
                              },
                              child: Text("Add")),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("cancel"))
                        ],
                      )
                    ],
                  ),
                );
              });
          getInitialNotes();
        },
        child: Icon(
          Icons.add,
          color: Colors.black54,
        ),
      ),
    );
  }

  void addNoteInDb() async {
    var mtitle = titlecontroller.text.toString();
    var mdesc = descController.text.toString();
    bool check = await mainDb!.addNote(title: mtitle, desc: mdesc);
    String msg = "Notes adding failed";
    if (check) {
      msg = "Notes added successfull!";
      getInitialNotes();
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
