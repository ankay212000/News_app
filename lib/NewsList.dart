import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutterandpython/Newsclass.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {

  String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=ff94394ddcf74eb2be08755e5cd942e9";
  List<News> news = List();
  bool isLoaded = false;
  int currentPage = 0;
  PageController _pageController;
  @override
  void initState() {
    _fetchData();
    _pageController = PageController(
      initialPage: currentPage,
      keepPage: true,
      viewportFraction: 0.8
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(this.url);
      if(response.statusCode==200){
        final data = json.decode(response.body);
        news = (data["articles"] as List).map((data){
          
          return News.fromJSON(data);
        }).toList();
        setState(() {
        this.isLoaded = true;
      });
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(child: Text("Latest News"),),
      ),
      body: isLoaded == true
      ?
      PageView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context,int index){
          return Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Align(
              alignment: Alignment.topCenter,
                child: Container(
                  height: 900,
                  width: 1000,
                  margin: EdgeInsets.only(right:30,left:30,bottom:10),
                  child: Material(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0), 
                        bottomRight: Radius.circular(10.0))
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 8.0),
                          child: Text(
                            news[index].title,
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold
                              ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(news[index].image),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            news[index].description+"\n\n"+news[index].content,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300
                            ),
                            ),  
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Text("View more..",style: TextStyle(color: Colors.blue),),
                              onTap: (){
                                _launchUrl(index);
                              },
                          ),
                        ),   
                      ],
                    ),
                  ),
                )
            ),
          );
        },
        controller: _pageController,
        pageSnapping: true,
        onPageChanged: _onPageChanged,
      ): Center(
        child: CircularProgressIndicator()
      ),
    );
  }

  _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

   _launchUrl(int index) async{
    final String url = news[index].url;
    print(url);
    if(await canLaunch(url)){
      await launch (url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
