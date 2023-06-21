import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routine_tracker_app/components/habit_tile.dart';
import 'package:routine_tracker_app/components/month_summary.dart';
import 'package:routine_tracker_app/components/my_alert_box.dart';
import 'package:routine_tracker_app/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    // if there is no current habit list, then it is the 1st time ever opening the app
    // then create default data
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }

    // there already exists data, this is not the first time
    else {
      db.loadData();
    }

    // update the database
    db.updateDatabase();

    super.initState();
  }

  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  // create a new habit
  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    // show alert dialog for user to enter the new habit details
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Enter habit name',
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save new habit
  void saveNewHabit() {
    // add new habit to todays habit list
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });

    // clear textfield
    _newHabitNameController.clear();
    // pop dialog box
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  // cancel new habit
  void cancelDialogBox() {
    // clear textfield
    _newHabitNameController.clear();

    // pop dialog box
    Navigator.of(context).pop();
  }

  // open habit settings to edit
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: db.todaysHabitList[index][0],
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(
      () {
        db.todaysHabitList[index][0] = _newHabitNameController.text;
      },
    );
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  // delete habit
  void deleteHabit(int index) {
    setState(
      () {
        db.todaysHabitList.removeAt(index);
      },
    );
    db.updateDatabase();
  }

  bool _showFab = true;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  // fit: BoxFit.fill,
                  image: AssetImage("assets/logo.png"),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Made by Darshan',
                      style: GoogleFonts.syne(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                'Routine',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: AnimatedSlide(
        duration: duration,
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: duration,
          opacity: _showFab ? 1 : 0,
          child: FloatingActionButton(
            onPressed: createNewHabit,
            child: const Icon(Icons.add),
          ),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final ScrollDirection direction = notification.direction;
          setState(() {
            if (direction == ScrollDirection.reverse) {
              _showFab = false;
            } else if (direction == ScrollDirection.forward) {
              _showFab = true;
            }
          });
          return true;
        },
        child: ListView(
          children: [
            // monthly summary heat map
            MonthlySummary(
              datasets: db.heatMapDataSet,
              startDate: _myBox.get("START_DATE"),
            ),

            // list of habits
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.todaysHabitList.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  habitName: db.todaysHabitList[index][0],
                  habitCompleted: db.todaysHabitList[index][1],
                  onChanged: (value) => checkBoxTapped(value, index),
                  settingsTapped: (context) => openHabitSettings(index),
                  deleteTapped: (context) => deleteHabit(index),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
