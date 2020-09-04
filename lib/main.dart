import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final itemsList = List<String>.generate(100, (index) => "List item ${index}");

  ListView generateItemsList() {
    return ListView.builder(
      itemCount: itemsList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              final bool res = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(
                          "Are you sure you want to delete ${itemsList[index]}?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            // TODO: Delete the item from DB etc..
                            setState(() {
                              itemsList.removeAt(index);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
              return res;
            } else {
              // TODO: Navigate to edit page;
            }
          },
          background: slideRightBackground(),
          secondaryBackground: slideLeftBackground(),
          key: Key(itemsList[index]),
          child: InkWell(
              onTap: (){
                print("${itemsList[index]} clicked");
              },
              child: ListTile(title: Text('${itemsList[index]}'))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sulove Swipe Delete demo"),
      ),
      body: generateItemsList(),
    );
  }
}

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}
Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}


//-----------------------------------------------------------------
// Step 1: Create a List of Items
// Create a variable at the top of the state class as follows;
// class _MyHomePageState extends State<MyHomePage> {
//   final itemsList = List<String>.generate(10, (n) => "List item ${n}");
//   ...
// }
//
// Step 2: Generate the List
// We’ll use the 10 strings generated in Step 1 to populate a list view using ListView builder in Flutter. Add the following method to the state class.
// ListView generateItemsList() {
// return ListView.builder(
// itemCount: itemsList.length,
// itemBuilder: (context, index) {
// return ListTile(title: Text('${itemsList[index]}'));
// },
// );
// }
//Add this method as the body property in widget build method.
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(widget.title),
//     ),
//     body: generateItemsList(),
//   );
// }
//Step 3: Give the list item a click effect
// Now we have a list of items. I think it’s better we give them a clickable behavior; like a ripple effect when user clicks on it. Flutter provides a special widget called InkWell widget; once you wrap it around a widget like a ListTile, it’ll add a clickable behavior to it. (That means a ripple 🌊)
// We’ll change the itemBuilder property of generateItemsList() as follows;
// itemBuilder: (context, index) {
//   return InkWell(
//       onTap: () {
//         print("${itemsList[index]} clicked");
//       },
//       child: ListTile(title: Text('${itemsList[index]}')));
// },
// Render the view and see how it adds the ripple click behavior to each list item and the console will show you the message “List item n clicked” …
// Step 4: Wrap list items around Dismissible Widget
// itemBuilder: (context, index) {
//   return Dismissible(
//     child: InkWell(
//         onTap: () {
//           print("${itemsList[index]} clicked");
//         },
//         child: ListTile(title: Text('${itemsList[index]}'))),
//   );
// }
// Once we wrap it around a Dismissible widget, it’ll show us an error saying it needs a key. Flutter maintain keys to access widgets and children to help it rebuild the widget tree. Same goes for Dismissible items. For them to be separable, they need unique keys. In our case, each list item name is pretty much unique. So we can straightaway use item name as the key.
// return Dismissible(
//   key: Key(itemsList[index]),
//   child: InkWell(
//       onTap: () {
//         print("${itemsList[index]} clicked");
//       },
//       child: ListTile(title: Text('${itemsList[index]}'))),
// );
// Now let’s render our app and see. Try sliding items left and right to see they are getting removed from the list view. Pretty easy…
// Image for post
// Now comes the important parts. Dismissible widget has a few properties. Let me summarize the ones that are important for us to implement swipe both ways to get two actions done.
// background: It’s the widget that is visible when we slide the list item to right. There’s another property called secondaryBackground. If that property is not set, this will be the background for both sliding directions.
// secondaryBackground: It’s the widget that is visible when we slide the list item to left.
// confirmDismiss: This is where we can integrate a user input for confirmation such as a dialog box prompting user to delete or not.
// onDismissed: This method is called when the list item is gone from the view. We can put an action like “Undo Delete” here.
// Step 5: Add swipe backgrounds to list items
// Now we are going to use both the background and secondaryBackground properties to set custom widgets; one for delete and one for edit. Let’s create two methods for both the widgets.
// Right side sliding :: goes as “background”
// Widget slideRightBackground() {
//   return Container(
//     color: Colors.green,
//     child: Align(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(
//             width: 20,
//           ),
//           Icon(
//             Icons.edit,
//             color: Colors.white,
//           ),
//           Text(
//             " Edit",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//             ),
//             textAlign: TextAlign.left,
//           ),
//         ],
//       ),
//       alignment: Alignment.centerLeft,
//     ),
//   );
// }
// Left side sliding :: goes as “secondaryBackground”
// Widget slideLeftBackground() {
//   return Container(
//     color: Colors.red,
//     child: Align(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           Icon(
//             Icons.delete,
//             color: Colors.white,
//           ),
//           Text(
//             " Delete",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//             ),
//             textAlign: TextAlign.right,
//           ),
//           SizedBox(
//             width: 20,
//           ),
//         ],
//       ),
//       alignment: Alignment.centerRight,
//     ),
//   );
// }
// Now set these two widgets as properties for backgrounds as follows;
// background: slideRightBackground(),
// secondaryBackground: slideLeftBackground(),
// Let’s see how it looks;
// Image for post
// Image for post
// Step 6: Add actions to swipes
// Before doing something like a deletion, it’s wise to ask for user confirmation. Let’s add the feature using confirmDismiss property of Dismissible widget.
// confirmDismiss: (direction) async {
//   if (direction == DismissDirection.endToStart) {
//     final bool res = await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Text(
//                 "Are you sure you want to delete ${itemsList[index]}?"),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text(
//                   "Cancel",
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               FlatButton(
//                 child: Text(
//                   "Delete",
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 onPressed: () {
//                   // TODO: Delete the item from DB etc..
//                   setState(() {
//                     itemsList.removeAt(index);
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//     return res;
//   } else {
//     // TODO: Navigate to edit page;
//   }
// },
// Since we are waiting for a user input, an asynchronous method is used to handle this property. The result is something like this.
