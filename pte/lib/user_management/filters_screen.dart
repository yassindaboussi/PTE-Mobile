import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pte/user_management/pte_app_theme.dart';
import 'model/filter_list.dart';

class FiltersScreen extends StatefulWidget {
  final Function(String, String) onApplyFilters;
  const FiltersScreen({Key? key, required this.onApplyFilters}) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {

  List<FilterListData> departementListData = FilterListData.departmentFList;
  List<FilterListData> titleListData =  FilterListData.titleList;


  @override
  Widget build(BuildContext context) {
    return Material(
      color: PteAppTheme.buildLightTheme().colorScheme.background,
      child: Column(
        children: <Widget>[
          getAppBarUI(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
              //  priceBarFilter(),
                  const Divider(
                    height: 1,
                  ),
                  departementFilter(),
                  const Divider(
                    height: 1,
                  ),
                 //  distanceViewUI(),
                  const Divider(
                    height: 1,
                  ),
                  allTitleUI()
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: PteAppTheme.buildLightTheme().primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 8,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  highlightColor: Colors.transparent,
                  onTap: () {
                    // Call the callback function with selected filters
                    widget.onApplyFilters(
                      getSelectedDepartment(), // Implement this function to get the selected department
                      getSelectedTitle(),      // Implement this function to get the selected title
                    );
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget allTitleUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Title',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getTitleListUI(),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  List<Widget> getTitleListUI() {
    final List<Widget> noList = <Widget>[];
    for (int i = 0; i < titleListData.length; i++) {
      final FilterListData date = titleListData[i];
      noList.add(
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          onTap: () {
            if (mounted) {
              setState(() {
                checkTitlePosition(i);
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    date.titleTxt,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                CupertinoSwitch(
                  activeColor: date.isSelected
                      ? PteAppTheme.buildLightTheme().primaryColor
                      : Colors.grey.withOpacity(0.6),
                  onChanged: (bool value) {
                    if (mounted) {
                      setState(() {
                        checkTitlePosition(i);
                      });
                    }
                  },
                  value: date.isSelected,
                ),
              ],
            ),
          ),
        ),
      );
      if (i == 0) {
        noList.add(const Divider(
          height: 1,
        ));
      }
    }
    return noList;
  }


  void checkTitlePosition(int selectedIndex) {
    final selectedSwitch = titleListData[selectedIndex];
    selectedSwitch.isSelected = !selectedSwitch.isSelected; // Toggle the selection state

    if (selectedSwitch.isSelected) {
      // Deselect other switches
      for (int i = 0; i < titleListData.length; i++) {
        if (i != selectedIndex) {
          titleListData[i].isSelected = false;
        }
      }
    }
    print("Title Selected ===>>> "+selectedIndex.toString());
  }

  void checkDepartPosition(int selectedIndex) {
    final selectedSwitch = departementListData[selectedIndex];
    selectedSwitch.isSelected = !selectedSwitch.isSelected; // Toggle the selection state

    if (selectedSwitch.isSelected) {
      // Deselect other switches
      for (int i = 0; i < departementListData.length; i++) {
        if (i != selectedIndex) {
          departementListData[i].isSelected = false;
        }
      }
    }
    print("Departement Selected ===>>> "+selectedIndex.toString());
  }

  String getSelectedDepartment() {
    for (var departmentData in departementListData) {
      if (departmentData.isSelected) {
        return departmentData.titleTxt;
      }
    }
    return '';
  }

  String getSelectedTitle() {
    for (var titleData in titleListData) {
      if (titleData.isSelected) {
        return titleData.titleTxt;
      }
    }
    return '';
  }


  Widget departementFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Departement',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getDList(),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }


  List<Widget> getDList() {
    final List<Widget> noList = <Widget>[];
    for (int i = 0; i < departementListData.length; i++) {
      final FilterListData date = departementListData[i];
      noList.add(
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          onTap: () {
            if (mounted) {
              setState(() {
                checkDepartPosition(i);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    date.titleTxt,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                CupertinoSwitch(
                  activeColor: date.isSelected
                      ? PteAppTheme.buildLightTheme().primaryColor
                      : Colors.grey.withOpacity(0.6),
                  onChanged: (bool value) {
                    if (mounted) {
                      setState(() {
                        checkDepartPosition(i);
                      });
                    }
                  },
                  value: date.isSelected,
                ),
              ],
            ),
          ),
        ),
      );
      if (i == 0) {
        noList.add(const Divider(
          height: 1,
        ));
      }
    }
    return noList;
  }


  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: PteAppTheme.buildLightTheme().colorScheme.background,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
