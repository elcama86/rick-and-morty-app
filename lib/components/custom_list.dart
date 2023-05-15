import 'package:flutter/material.dart';
import 'package:rickandmorty_app/components/loading.dart';

class CustomList extends StatelessWidget {
  final List<dynamic> list;
  final Function? onNotificationScroller;
  final ScrollController? scrollController;
  final bool? isPageLoading;
  final IconData firstIcon;
  final IconData secondIcon;
  final String origin;
  final bool? isFinalPage;

  const CustomList({
    Key? key,
    required this.list,
    this.onNotificationScroller,
    this.scrollController,
    this.isPageLoading,
    required this.firstIcon,
    required this.secondIcon,
    required this.origin,
    this.isFinalPage,
  }) : super(key: key);

  Widget _elementList(dynamic element) {
    final backgroundImage = origin == "characters"
        ? NetworkImage("${element.image}")
        : const AssetImage("assets/images/episodes.jpg") as ImageProvider;
    return Card(
      elevation: 6.0,
      margin: const EdgeInsets.all(4.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: backgroundImage,
          backgroundColor: Colors.transparent,
          child: origin == "characters"
              ? null
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    "${element.id}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
        ),
        title: Text(element.name),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              firstIcon,
              size: 10.0,
            ),
            const SizedBox(
              width: 4.0,
            ),
            Text(origin == "characters"
                ? "${element.gender}"
                : "${element.airDate}"),
            const SizedBox(
              width: 8.0,
            ),
            Icon(
              secondIcon,
              size: 10.0,
            ),
            const SizedBox(
              width: 4.0,
            ),
            Text(origin == "characters"
                ? "${element.species}"
                : "${element.episode}"),
          ],
        ),
        trailing: origin == "characters"
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Text("${element.status}"),
                ],
              )
            : null,
      ),
    );
  }

  Widget _body() {
    return ListView(
      controller: scrollController,
      shrinkWrap: true,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            return _elementList(list[index]);
          },
        ),
        if (isFinalPage != null && isPageLoading != null)
          SizedBox(
            height: isFinalPage! ? 0.0 : 40.0,
            child: isPageLoading! ? const Loading() : Container(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotificationScroller != null
          ? (ScrollNotification scrollInfo) =>
              onNotificationScroller!(scrollInfo)
          : null,
      child: _body(),
    );
  }
}
