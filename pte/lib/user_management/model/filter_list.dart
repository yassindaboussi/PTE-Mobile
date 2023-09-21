class FilterListData {
  FilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<FilterListData> departmentFList = <FilterListData>[
    FilterListData(
      titleTxt: 'network',
    ),
    FilterListData(
      titleTxt: 'system',
    ),
    FilterListData(
      titleTxt: 'Assistante Technique',
    ),
  ];

  static List<FilterListData> titleList = <FilterListData>[
    FilterListData(
      titleTxt: 'Architect',
    ),
    FilterListData(
      titleTxt: 'Senior',
    ),
  ];
}
