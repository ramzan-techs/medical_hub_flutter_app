import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medical_hub/constants.dart';
import 'package:medical_hub/data/category_image_paths.dart';
import 'package:medical_hub/data/doctor_types.dart';
import 'package:medical_hub/main.dart';
import 'package:medical_hub/screens/user/category/category_item_card.dart';

class CategoryScreen extends StatefulWidget {
  final String? categoryName;
  const CategoryScreen({super.key, this.categoryName});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  bool _isTapped = false;
  List<String> _searchList = [];

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = _textEditingController.text.isNotEmpty;
    });
  }

  void _onFocusChanged() {
    setState(() {
      _isTapped = _focusNode.hasFocus;
    });
  }

  void _clearTextFieldAndUnfocus() {
    _textEditingController.clear();
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    height: mq.height * 0.15,
                    decoration: BoxDecoration(
                      color: Constants().secondaryColor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.chevron_left,
                                  size: 40,
                                  color: Constants().onPrimary,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Categories",
                                style: TextStyle(
                                    color: Constants().onPrimary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: mq.width * 0.1,
                  child: Container(
                    width: mq.width * 0.8,
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 43, 54, 45),
                        blurRadius: 40,
                        spreadRadius: 1,
                      )
                    ]),

                    //    Search Field ///////

                    child: TextField(
                      focusNode: _focusNode,
                      controller: _textEditingController,
                      onChanged: (value) {
                        _searchList.clear();
                        List<String> _currentList = widget.categoryName == null
                            ? doctorTypes.keys.toList()
                            : doctorTypes[widget.categoryName]!.toList();
                        for (String catName in _currentList) {
                          if (catName
                              .toLowerCase()
                              .contains(value.trim().toLowerCase())) {
                            _searchList.add(catName);
                            log(catName);
                          }

                          setState(() {
                            _searchList;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                        ),
                        suffixIcon: _isTapped
                            ? IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _clearTextFieldAndUnfocus();
                                },
                              )
                            : null,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Search category...",
                        hintStyle: const TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),
                )
              ],
            ),

            // body /////////////////

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.categoryName == null
                          ? "All Categories"
                          : widget.categoryName!,
                      style: TextStyle(
                        fontSize: 24,
                        color: Constants().secondaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: GridView.builder(
                          padding: const EdgeInsets.only(top: 5),
                          itemCount: widget.categoryName == null
                              ? _isTyping
                                  ? _searchList.length
                                  : doctorTypes.keys.toList().length
                              : _isTyping
                                  ? _searchList.length
                                  : doctorTypes[widget.categoryName]!
                                      .toList()
                                      .length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widget.categoryName == null ? 2 : 1,
                            crossAxisSpacing: 10.0, // Spacing between columns
                            mainAxisSpacing: 10.0, // Spacing between rows
                          ),
                          itemBuilder: ((context, index) {
                            return CategoryItemCard(
                              isSubCatgeries:
                                  widget.categoryName == null ? false : true,
                              imageUrl: categoryImagePaths[
                                      widget.categoryName == null
                                          ? _isTyping
                                              ? _searchList[index]
                                              : doctorTypes.keys.toList()[index]
                                          : _isTyping
                                              ? _searchList[index]
                                              : doctorTypes[widget
                                                  .categoryName]![index]] ??
                                  "",
                              categoryName: widget.categoryName == null
                                  ? _isTyping
                                      ? _searchList[index]
                                      : doctorTypes.keys.toList()[index]
                                  : _isTyping
                                      ? _searchList[index]
                                      : doctorTypes[widget.categoryName]![
                                          index],
                              height: widget.categoryName == null
                                  ? mq.width * 0.6
                                  : mq.width * 1,
                              width: widget.categoryName == null
                                  ? mq.width * 0.4
                                  : mq.width * 1,
                            );
                          })),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
