import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poetic_app/core/routes/routes.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/features/resources/firestore_methods.dart';
import 'package:poetic_app/features/screens/widgets/follow_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AcoountsChartPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AcoountsChartPage({Key? key}) : super(key: key);

  @override
  _AcoountsChartPageState createState() => _AcoountsChartPageState();
}

class _AcoountsChartPageState extends State<AcoountsChartPage> {
  final List<ChartData> chartData = [];
  bool isFollowing = false;
  var userData = {};
  int totalLen = 0;
  double writerP = 0,
      playbackP = 0,
      generalP = 0,
      composerP = 0,
      marketingP = 0;
  @override
  void initState() {
    getData();
    // getFollowerData();
    super.initState();
  }

  getData() async {
    var writerSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'Writer/poet')
        .get();
    var writerLen = writerSnap.docs.length;
    var writer = ChartData(
        'Writer/poet', writerLen, writerLen.toString(), 'Writer/poet');
    if (writerLen > 0) {
      if (mounted) {
        setState(() => chartData.add(writer));
      }
    }

    //
    var playbackSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'Playback singer/audio recorder')
        .get();
    var playbackLen = playbackSnap.docs.length;
    var playback = ChartData('Playback singer/\naudio recorder', playbackLen,
        playbackLen.toString(), 'Playback singer/audio recorder');
    if (playbackLen > 0) {
      if (mounted) {
        setState(() => chartData.add(playback));
      }
    }

    //
    var composerSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'Composer/publisher')
        .get();
    var composerLen = composerSnap.docs.length;
    var composer = ChartData('Composer/\npublisher', composerLen,
        composerLen.toString(), 'Composer/publisher');
    if (composerLen > 0) {
      if (mounted) {
        setState(() => chartData.add(composer));
      }
    }

    //
    var marketingSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'Marketing promoter/advertiser')
        .get();
    var marketingLen = marketingSnap.docs.length;
    var marketing = ChartData('Marketing promoter/\nadvertiser', marketingLen,
        marketingLen.toString(), 'Marketing promoter/advertiser');
    if (marketingLen > 0) {
      if (mounted) {
        setState(() => chartData.add(marketing));
      }
    }

    //
    var generalSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'General user')
        .get();
    var generalLen = generalSnap.docs.length;
    var general = ChartData(
        'General user', generalLen, generalLen.toString(), 'General user');
    if (generalLen > 0) {
      if (mounted) {
        setState(() => chartData.add(general));
      }
    }
    if (mounted) {
      setState(() {
        totalLen =
            (writerLen + playbackLen + generalLen + composerLen + marketingLen);

        writerP = (writerLen / totalLen) * 100;
        playbackP = (playbackLen / totalLen) * 100;
        generalP = (generalLen / totalLen) * 100;
        composerP = (composerLen / totalLen) * 100;
        marketingP = (marketingLen / totalLen) * 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SfCircularChart(
                // Chart title
                title: ChartTitle(text: 'percentage of users'),
                // Enable legend
                legend: Legend(isVisible: true, position: LegendPosition.right),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                //

                //
                palette: const [
                  Color(0XFF161853),
                  Color(0XffA9333A),
                  Color(0XffFDD2BF),
                  Color(0XffCE49BF),
                  Color(0Xff6EBF8B),
                ],
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: chartData,
                    onPointTap: (val) {
                      showUsersList(context, chartData[val.pointIndex!].name);
                    },
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    groupMode: CircularChartGroupMode.point,
                    dataLabelMapper: (ChartData data, _) => data.size,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    radius: '100%',
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildPerentage(theme, 'Writer/poet', writerP),
                  buildPerentage(
                      theme, 'Playback singer/audio recorder', playbackP),
                  buildPerentage(theme, 'Composer/publisher', composerP),
                  buildPerentage(
                      theme, 'Marketing promoter/advertiser', marketingP),
                  buildPerentage(theme, 'General user', generalP),
                ],
              ),
            ),
            // Flexible(child: Container(), flex: 1)
          ],
        ),
      ),
    );
  }

  showUsersList(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (builder) {
          return Dialog(
            child: ShowUsersList(text: text),
          );
        });
  }

  Text buildPerentage(ThemeData theme, String name, double value) {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: '$name  ',
          style: theme.textTheme.subtitle1,
        ),
        TextSpan(
          text: '${value.toStringAsFixed(0)}%',
          style: theme.textTheme.subtitle2,
        ),
      ]),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.size, this.name);
  final String x;
  final int y;
  final String name;
  final String size;
}

class ShowUsersList extends StatefulWidget {
  final String text;
  const ShowUsersList({Key? key, required this.text}) : super(key: key);

  @override
  State<ShowUsersList> createState() => _ShowUsersListState();
}

class _ShowUsersListState extends State<ShowUsersList> {
  bool isFollowing = false;
  var userData = {};
  // int totalLen = 0;

  @override
  void initState() {
    getFollowerData();
    super.initState();
  }

  getFollowerData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (mounted) {
        setState(() {
          userData = userSnap.data()!;
        });
      }
    } catch (e) {
      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('accountType', isEqualTo: widget.text)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Something wrong.!',
                textAlign: TextAlign.center,
              ),
            );
          }

          return RemoveOverlay(
            child: ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                isFollowing = userData['following']
                    .contains((snapshot.data! as dynamic).docs[index]['uid']);
                return InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                    '/ProfileScreen',
                    arguments: (snapshot.data! as dynamic).docs[index]['uid'],
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 0.1),
                      ),
                    ),
                    child: ListTile(
                      isThreeLine: true,
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ['photoUrl'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        (snapshot.data! as dynamic).docs[index]['username'],
                        // style: theme.textTheme.subtitle1,
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            (snapshot.data! as dynamic).docs[index]
                                ['accountType'],
                            // style: theme.textTheme.subtitle1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isFollowing
                                  ? InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color(0XFFFF0099)
                                              .withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Unfollow',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                              fontSize: 2.1 * SizeOF.text!,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        await FireStoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          (snapshot.data! as dynamic)
                                              .docs[index]['uid'],
                                        );

                                        setState(() {
                                          isFollowing = false;
                                        });
                                        getFollowerData();
                                      },
                                    )
                                  : InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0XFF493240),
                                              Color(0XFFFF0099),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Follow',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              fontSize: 2.1 * SizeOF.text!,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        await FireStoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          (snapshot.data! as dynamic)
                                              .docs[index]['uid'],
                                        );
                                        await FireStoreMethods().chatUser(
                                          uid: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          followId: (snapshot.data! as dynamic)
                                              .docs[index]['uid'],
                                        );
                                        setState(() {
                                          isFollowing = true;
                                        });
                                        getFollowerData();
                                      },
                                    ),
                              FollowIButton(
                                function: () async {
                                  await FireStoreMethods().chatUser(
                                    uid: FirebaseAuth.instance.currentUser!.uid,
                                    followId: (snapshot.data! as dynamic)
                                        .docs[index]['uid'],
                                  );

                                  final chat = MessageArguments(
                                      friendName: (snapshot.data! as dynamic)
                                          .docs[index]['username'],
                                      friendUid: (snapshot.data! as dynamic)
                                          .docs[index]['uid']);

                                  Navigator.of(context).pushNamed('/ChatDetail',
                                      arguments: chat);
                                },
                                text: 'message',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
