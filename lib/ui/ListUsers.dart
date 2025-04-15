// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sygeq/ui/BackgroundImage.dart';
import 'package:sygeq/Models/User.dart';
import 'package:sygeq/Pages/DetailUpdate/MarketerUpdate/Detail/DetailUser.dart';
import 'package:sygeq/Pages/Maketers/HomeMarketer.dart';
import 'package:sygeq/Services/MarketerRemoteService.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/AddNewAllUsers.dart';
import 'package:sygeq/ui/EmptyList.dart';
import 'package:sygeq/ui/EmptyMessage.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';
import 'package:sygeq/ui/UserCard.dart';

class CreateNewUser extends StatefulWidget {
  const CreateNewUser({super.key});

  @override
  State<CreateNewUser> createState() => _CreateNewUserState();
}

class _CreateNewUserState extends State<CreateNewUser> {
  final formKey = GlobalKey<FormState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final searchController = TextEditingController();
  bool _firstSearch = false;
  String _query = "";
  _CreateNewUserState() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          _firstSearch = false;
          _query = '';
        });
      } else {
        setState(() {
          _firstSearch = true;
          _query = searchController.text;
        });
      }
    });
  }
  List<User> listUser = [];
  List<User> filterListUser = [];
  bool _animate = true;
  getUser() async {
    var data = await MarketerRemoteService.allGetListeUser();
    if (!mounted) return null;
    setState(() {
      listUser = data;
    });
    Future.delayed(Duration(seconds: 2));
    setState(() {
      _animate = false;
    });
    return data;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration(seconds: 2), getUser);
  }

  actionOnTheUser(var data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          // scrollable: true,
          insetPadding: EdgeInsets.all(10),
          child: Container(child: DetailUser(data: data)),
        );
      },
    ).then((value) {
      setState(() async {
        await getUser();
      });
    });
  }

  @override
  void initState() {
    listUser = [];
    listMarkStation.removeWhere((element) => element.id == 0);
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        iconTheme: IconThemeData(color: gryClaie),
        title: Text(
          "Mes Agents",
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: styleAppBar,
        ),
      ),
      backgroundColor: gryClaie,
      body: Container(
        decoration: logoDecoration(),
        child:
            _animate == true
                ? animationLoadingData()
                : listUser.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmptyList(),
                      EmptyMessage(),
                      TextButton.icon(
                        style: TextButton.styleFrom(backgroundColor: blue),
                        onPressed: () {
                          setState(() {
                            getUser();
                          });
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 30,
                        ),
                        label: Text(
                          'Réessayer',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : RefreshIndicator(
                  key: refreshKey,
                  onRefresh: refresh,
                  child: SafeArea(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 10,
                            right: 10,
                          ),
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              suffixIcon: Icon(Icons.search),
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(9),
                              //     borderSide: BorderSide(width: 0)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 5, right: 5, left: 5),
                            child:
                                !_firstSearch
                                    ? ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      // shrinkWrap: true,
                                      itemCount: listUser.length,
                                      itemBuilder: (context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            User userL = listUser[index];
                                            var data = {
                                              'id': listUser[index].id,
                                              'name': listUser[index].name,
                                              'email': listUser[index].email,
                                              'role': listUser[index].role,
                                              'type': listUser[index].type,
                                            };
                                            actionOnTheUser(data);
                                          },
                                          child: UserCardList(
                                            user: listUser[index],
                                          ),
                                        );
                                      },
                                    )
                                    : filterUserList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
      floatingActionButton:
          prefUserInfo['role'] != 'User'
              ? FloatingActionButton(
                backgroundColor: blue,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        // scrollable: true,
                        insetPadding: EdgeInsets.all(10),
                        child: Container(child: AddNewAllUsers()),
                      );
                    },
                  ).then((value) {
                    setState(() async {
                      await getUser();
                    });
                    // setState(() async {
                    //   await getUser();
                    // });
                  });
                },
                child: Icon(Icons.add, color: Colors.white),
              )
              : filterUserList(),
    );
  }

  Widget filterUserList() {
    Size _size = MediaQuery.of(context).size;
    filterListUser.clear();
    for (var element in listUser) {
      if (element.email.toLowerCase().contains(_query.toLowerCase()) ||
          element.name.toLowerCase().contains(_query.toLowerCase()) ||
          element.username.toLowerCase().contains(_query.toLowerCase())) {
        filterListUser.add(element);
      }
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      itemCount: filterListUser.length,
      itemBuilder: (context, int index) {
        return GestureDetector(
          onTap: () {
            User userL = filterListUser[index];
            var data = {
              'id': filterListUser[index].id,
              'name': filterListUser[index].name,
              'email': filterListUser[index].email,
              'role': filterListUser[index].role,
              'type': filterListUser[index].type,
            };
            actionOnTheUser(data);
          },
          child: UserCardList(user: filterListUser[index]),
        );
      },
    );
  }
}
