import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasks/models/intro.dart';
import 'package:tasks/providers/intro.dart';
import 'package:tasks/ui/home.dart';
import 'package:tasks/ui/partials/paginator.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final StreamController<int> _paginationStream = StreamController<int>();
  final IntroProvider _provider = IntroProvider();

  @override
  void dispose() {
    _paginationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<IntroModel>>(
        initialData: [],
        future: this._provider.getIntros(),
        builder: (BuildContext context, AsyncSnapshot<List<IntroModel>> pagesSnap) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  onPageChanged: this._paginationStream.sink.add,
                  physics: BouncingScrollPhysics(),
                  itemCount: pagesSnap.data.length,
                  itemBuilder: (_, int index) => _SingleItem(pagesSnap.data[index]),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: StreamBuilder<int>(
                  initialData: 0,
                  stream: this._paginationStream.stream,
                  builder: (_, AsyncSnapshot<int> pageSnap) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Paginator(
                          totalPages: pagesSnap.data.length,
                          activePage: pageSnap.data,
                        ),
                        AnimatedOpacity(
                          opacity: pagesSnap.data.length == pageSnap.data + 1 ? 1 : 0,
                          duration: Duration(milliseconds: 200),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Home(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              child: Icon(
                                Icons.arrow_forward,
                                size: 15,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.white10,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

class _SingleItem extends StatelessWidget {
  final IntroModel page;

  _SingleItem(this.page);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            child: SvgPicture.asset(
              'assets/images/intro/intro-${this.page.id}.svg',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fitWidth,
              color: Theme.of(context).primaryColor,
              colorBlendMode: BlendMode.color,
              placeholderBuilder: (_) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          SizedBox(height: 40),
          Text(
            this.page.title,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              height: 0.8,
              fontFamily: 'Lora',
            ),
          ),
          SizedBox(height: 10),
          Text(
            this.page.subTitle,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
