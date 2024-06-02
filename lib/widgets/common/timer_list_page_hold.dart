import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_minder/pages/view_list_timer_page.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:time_minder/widgets/common/providers.dart';

typedef ModalCloseCallback = void Function(int? id);

class ListTimerPageHold extends StatefulWidget {
  final List<Map<String, dynamic>> allData;

  const ListTimerPageHold({super.key, required this.allData});

  @override
  State<ListTimerPageHold> createState() => _ListTimerPageHoldState();
}

class _ListTimerPageHoldState extends State<ListTimerPageHold> {
  @override
  void dispose() {
    super.dispose();
  }

  void updateSelectedItems(List<int> newSelectedItems) {
    final selectedItemsProvider =
        Provider.of<SelectedItemsProvider>(context, listen: false);
    selectedItemsProvider.updateSelectedItems(newSelectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedItemsProvider>(
      builder: (context, selectedItemsProvider, _) {
        final selectedItemsProvider =
            Provider.of<SelectedItemsProvider>(context);
        final selectedItems = selectedItemsProvider.selectedItems;
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.allData.length,
          itemBuilder: (context, int index) {
            return GestureDetector(
              onTap: () {
                if (selectedItems.isNotEmpty) {
                  setState(() {
                    if (selectedItems.contains(index)) {
                      selectedItemsProvider.removeFromSelectedItems(index);
                    } else {
                      selectedItemsProvider.addToSelectedItems(index);
                    }
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CombinedTimerPage(
                        id: widget.allData[index]['id'],
                      ),
                    ),
                  );
                }
              },
              onLongPress: () {
                setState(() {
                  if (selectedItems.contains(index)) {
                    selectedItemsProvider.removeFromSelectedItems(index);
                  } else {
                    selectedItemsProvider.addToSelectedItems(index);
                  }
                });
              },
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 14.0).h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0).w,
                      color: offOrange,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 19.0)
                          .w,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5).w,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10).w,
                          color: heliotrope,
                          child: SvgPicture.asset(
                            'assets/images/cat1.svg',
                            height: 30.h,
                          ),
                        ),
                      ),
                      title: Text(
                        widget.allData[index]['title'],
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontWeight: FontWeight.w900,
                          fontSize: 14.sp,
                        ),
                      ),
                      subtitle: Text(
                        widget.allData[index]['description'],
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(widget.allData[index]['timer']),
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 9.sp,
                              color: darkGrey,
                            ),
                          ),
                          SizedBox(
                            height: 5.0.h,
                          ),
                          GestureDetector(
                            onTap: selectedItems.isNotEmpty
                                ? null
                                : () {
                                    Container();
                                  },
                            child: IgnorePointer(
                              ignoring: selectedItems.isNotEmpty,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 7)
                                    .w,
                                decoration: BoxDecoration(
                                  color: ripeMango,
                                  borderRadius: BorderRadius.circular(5).w,
                                ),
                                child: selectedItems.isNotEmpty
                                    ? Text(
                                        "Pilih",
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 9.sp,
                                          color: pureWhite,
                                        ),
                                      )
                                    : Text(
                                        "Mulai",
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 9.sp,
                                          color: pureWhite,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 52.w,
                    top: 50.h,
                    child: Container(
                      width: 21.w,
                      height: 21.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedItems.contains(index)
                            ? ripeMango
                            : Colors.transparent,
                      ),
                      child: selectedItems.contains(index)
                          ? SvgPicture.asset("assets/images/selected_item.svg")
                          : null,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(int time) {
    int hours = time ~/ 60;
    int minutes = time % 60;
    int seconds = 0;

    String padLeft(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${padLeft(hours)}:${padLeft(minutes)}:${padLeft(seconds)}';
  }
}
