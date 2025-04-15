// ignore_for_file: must_be_immutable, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sygeq/Models/User.dart';
import 'package:sygeq/main.dart';

class UserCardList extends StatefulWidget {
  User user;
  UserCardList({super.key, required this.user});

  @override
  State<UserCardList> createState() => _UserCardListState();
}

class _UserCardListState extends State<UserCardList> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child:
                widget.user.image.isNotEmpty
                    ? Container(
                      decoration: BoxDecoration(
                        color: gryClaie,
                        border: Border.all(
                          color: blue,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          // alignment: Alignment.center,
                          image: NetworkImage(uRl + widget.user.image),
                          fit: BoxFit.contain,
                        ),
                      ),
                      width: _size.width / 3,
                      height: _size.height / 6,
                    )
                    : Container(
                      child: Image.asset(
                        'assets/icons/account.png',
                        width:
                            _size.width < _size.height
                                ? _size.width / 8
                                : _size.width / 10,
                        height:
                            _size.width < _size.height
                                ? _size.height / 8
                                : _size.height / 10,
                      ),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      width:
                          _size.width < _size.height
                              ? _size.width / 3
                              : _size.width / 6,
                      height:
                          _size.width < _size.height
                              ? _size.height / 10
                              : _size.height / 6,
                    ),
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
